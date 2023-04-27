import { api, common, config } from '@nfjs/core';
import modulePg from 'pg';

const { Client } = modulePg;
const unitCache = new Map();
const unitBpCache = new Map();
const funcCache = new Map();

/**
 * @typedef NfcUnitOpt
 * @property {string} [table] - имя таблицы базы данных для раздела
 * @property {'ext'|'self'|'main'} [idGenMethod='main'] - метод генерации значения первичного ключа.
 * 'ext' - не генерируется, а подается явно
 * 'self' - должна быть собственная последовательность
 * 'main' - генерируется из основной последовательности пакета s_main
 * @property {'sys'|'org'|'grp'} [divideType='sys'] - способ деления данных в разделе
 * @property {string} [primaryKey='id::bigint'] - имя и тип первичного ключа раздела в формате имя::тип (id::bigint)
 */

/**
 * @typedef NfcUnit
 * @property {string} code - код раздела
 * @property {NfcUnitOpt} opt - настройки раздела
 * @property {string} tableSchema - схема таблицы базы данных для раздела
 * @property {string} tableName - имя таблицы
 * @property {Array<{name: string, datatype: string}>} columns - колонки таблицы из базы данных
 * @property {string} pkField - имя поля - первичного ключа таблицы
 * @property {string} pkType - тип данных поля pkField
 */

/**
 * @typedef NfcUnitBp
 * @property {string} code - код действия в разделе
 * @property {string} [func] - выполняемая функция
 * @property {boolean} [usePrivs=true] - признак проверять или нет права при выполнении действия
 */

/**
 * Получение информации о разделе
 * @param {Client} connect - соединение с базой данных
 * @param {string} unitCode - код раздела (nfc.unitlist.code)
 * @returns {Promise<NfcUnit>}
 */
async function getUnit(connect, unitCode) {
    if (unitCache.has(unitCode)) {
        return unitCache.get(unitCode);
    }
    /** @type Object */
    const queryRes = await connect.query(
        `select u.code, u.opt
               from nfc.v4unitlist u
              where u.code = $1`,
        [unitCode]
    );
        /** @type NfcUnit */
    const unit = queryRes?.rows?.[0];
    if (!unit) throw new Error(`Раздел ${unitCode} не найден в системе.`);
    [unit.tableSchema, unit.tableName] = (unit.opt && unit.opt.table) || unit.code.split('.');
    // колонки таблицы
    const colQueryRes = await connect.query(
        `select t3.attname as name,
                t4.typname as datatype
                from pg_catalog.pg_namespace   t1,
                    pg_catalog.pg_class       t2,
                    pg_catalog.pg_attribute   t3,
                    pg_catalog.pg_type        t4
                where t1.nspname    = $1
                and t2.relnamespace = t1.oid
                and t2.relname      = $2
                and t3.attrelid     = t2.oid
                and t3.attnum       > 0
                and not t3.attisdropped
                and t3.atttypid     = t4.oid
                order by t3.attnum`,
        [unit.tableSchema, unit.tableName]
    );
    unit.columns = colQueryRes?.rows;
    // первичный ключ
    let pkField = unit.opt.primaryKey;
    if (!pkField) {
        const pkQueryRes = await connect.query(
            'select nfc.f_db8get_primaryfield($1, $2, true) as pk',
            [unit.tableSchema, unit.tableName]
        );
        pkField = pkQueryRes?.rows?.[0]?.pk ?? 'id::int8';
    }
    [unit.pkField, unit.pkType] = pkField.split('::');
    if (!unit.pkType) unit.pkType = 'int8';
    unitCache.set(unitCode, unit);
    return unit;
}

/**
 * Получение информации о действии над разделом
 * @param {Client} connect - соединение с базой данных
 * @param {string} unitBp - код действия над разделом (nfc.unitbp.code)
 * @returns {Promise<NfcUnitBp>}
 */
async function getUnitBp(connect, unitBp) {
    if (unitBpCache.has(unitBp)) {
        return unitBpCache.get(unitBp);
    }
    const queryRes = await connect.query(
        `select u.code, u.exec_function as func, use_privs as "usePrivs"
               from nfc.v4unitbps u
              where u.code = $1`,
        [unitBp]
    );
    const queryRow = queryRes?.rows?.[0];
    unitBpCache.set(unitBp, queryRow);
    return queryRow;
}

/**
 * @typedef BrokerFuncArg
 * @property {string} name - имя аргумента
 * @property {string} datatype - тип данных
 * @property {string} mode - режим использования (входной, выходной)
 * @property {boolean} required - признак обязательности
 */

/**
 * Получение информации о функции базы данных
 * @param {Client} connect - соединение с базой данных
 * @param {string} func - полное имя функции
 * @returns {Promise<{args: Array<BrokerFuncArg>}>}
 */
async function getFunc(connect, func) {
    if (funcCache.has(func)) {
        return funcCache.get(func);
    }
    const queryRes = await connect.query(
        `select t.parameter_name as name,
                      t.udt_name as datatype,
                      t.parameter_mode as mode,
                      case when t.parameter_default is null and t.parameter_mode in ('IN','INOUT')  then true 
                          else false end as required  
                 from information_schema.parameters t 
                      join pg_namespace tpn on tpn.nspname = t.udt_schema 
                      join pg_type tp on (tp.typnamespace = tpn.oid and tp.typname = t.udt_name) 
                where t.specific_schema = $1 and t.specific_name ~ $2`,
        [func.split('.')[0], `^${func.split('.')[1]}_[0-9]+$`],
    );
    const res = { args: queryRes?.rows };
    funcCache.set(func, res);
    return res;
}

/**
 * Подготовка текста запроса, изменяющего данные
 * @param {NfcUnit} unit - настройки раздела
 * @param {'add'|'upd'|'del'|'get'|'find'} act - псевдо-действие над таблицей
 * @param {Object} params - параметры выполнения
 * @returns {{sql: string, params: Object}}
 */
function prepareSql(unit, act, params) {
    const _params = {};
    let sql = '', warn;
    if (act === 'add' || act === 'upd') {
        let sql_b = '',
            sql_a = '';
        Object.keys(params).forEach((key) => {
            const col = unit.columns.find((_col) => _col.name === key);
            if (col) {
                _params[key] = params[key];
                if (act === 'add') {
                    if (key !== 'org' && key !== 'grp' && (key !== unit.pkField || (key === unit.pkField && unit.opt.idGenMethod === 'ext'))) {
                        sql_b += `,"${key}"`;
                        sql_a += `,($1->>'${key}')::${col.datatype}`;
                    }
                } else if ([unit.pkField, 'org', 'grp'].indexOf(key) === -1) {
                    sql_b += `,"${key}" = ($1->>'${key}')::${col.datatype}`;
                }
            }
        });
        if (act === 'add') {
            if (unit.opt.divideType === 'org') {
                sql_b += ',org';
                sql_a += ',$2';
            } else if (unit.opt.divideType === 'grp') {
                sql_b += ',grp';
                sql_a += ',$2';
            }
            sql_b = sql_b.substring(1);
            sql_a = sql_a.substring(1);
            sql = `insert into "${unit.tableSchema}"."${unit.tableName}" (${sql_b}) values (${sql_a}) returning "${unit.pkField}"::text`;
            if (sql_b === '') warn = 'Нет ни одного подходящего параметра для добавления';
        } else {
            sql = `update only "${unit.tableSchema}"."${unit.tableName}" set ${sql_b.substring(1)} where "${unit.pkField}" = `;
            sql += (Array.isArray(params[unit.pkField])) ? `any($2::${unit.pkType}[])` : `$2::${unit.pkType}`;
            if (unit.opt.divideType === 'org') sql += ' and org = $3';
            if (unit.opt.divideType === 'grp') sql += ' and grp = $3';
        }
    } else if (act === 'del') {
        _params[unit.pkField] = params[unit.pkField];
        sql = `delete from only "${unit.tableSchema}"."${unit.tableName}" where "${unit.pkField}" = `;
        sql += (Array.isArray(params[unit.pkField])) ? `any($2::${unit.pkType}[])` : `$2::${unit.pkType}`;
        if (unit.opt.divideType === 'org') sql += ' and org = $3';
        if (unit.opt.divideType === 'grp') sql += ' and grp = $3';
    } else if (act === 'get') {
        _params[unit.pkField] = params[unit.pkField];
        sql += `select * from "${unit.tableSchema}"."v4${unit.tableName}" where "${unit.pkField}" = $1::${unit.pkType}`;
        if (unit.opt.divideType === 'org') sql += ' and org = nullif(pg_catalog.current_setting(\'nf.org\'),\'\')::bigint';
        if (unit.opt.divideType === 'grp') sql += ' and grp = (select grp from nfc.v4org where id = nullif(pg_catalog.current_setting(\'nf.org\'),\'\')::bigint)';
    } else if (act === 'find') {
        sql += `select * from "${unit.tableSchema}"."v4${unit.tableName}" where `;
        const where = [];
        Object.keys(params).forEach(key => {
            const col = unit.columns.find(f => f.name === key);
            if (col) {
                _params[key] = params[key];
                where.push(`"${col.name}" = ${Array.isArray(params[col.name]) ? `any((($1::json)->>'${col.name}')::${col.datatype}[])` : `(($1::json)->>'${col.name}')::${col.datatype}`}`);
            }
        });
        sql += where.join(' and ');
        if (unit.opt.divideType === 'org') sql += ' and org = nullif(pg_catalog.current_setting(\'nf.org\'),\'\')::bigint';
        if (unit.opt.divideType === 'grp') sql += ' and grp = (select grp from nfc.v4org where id = nullif(pg_catalog.current_setting(\'nf.org\'),\'\')::bigint)';
    } else {
        throw new Error('Not implemented.');
    }
    sql += ';';
    return { sql, params: _params, warn };
}

/**
 *
 * @param {Client} connect - соединение с базой данных
 * @param {string} action - выполняемое действие (или код nfc.unitbps.code или функция в бд)
 * @param {Object} params - параметры для действия
 * @returns {Promise<void|Object>}
 */
async function broker(connect, action, params = {}) {
    const _act = action.split('.');
    let func, /** @type NfcUnit */ unit, /** @type NfcUnitBp */ unitBp, unitBpCode, act, res;
    if (_act.length === 3) {
        unit = await getUnit(connect, `${_act[0]}.${_act[1]}`);
        unitBpCode = action;
        act = _act[2];
        if (act !== 'get' && act !== 'find') {
            // попытка выяснить какое действие на самом деле, если указано было псевдодействие mod
            if (act === 'mod') {
                const pkValue = params[unit.pkField];
                if (pkValue && Array.isArray(pkValue)) throw new Error('Действие [mod] не применимо для набора записей.');
                if (unit.opt.idGenMethod === 'ext') {
                    const checkPkRes = await connect.query({
                        text: 'select nfc.f_table_check_pk_value($1,$2,$3,$4) as fnd',
                        values: [unit.tableSchema, unit.tableName, `${unit.pkField}::${unit.pkType}`, params[unit.pkField]]
                    });
                    const fnd = checkPkRes?.rows?.[0].fnd;
                    act = (fnd) ? 'upd' : 'add';
                } else {
                    act = (common.isEmpty(params[unit.pkField])) ? 'add' : 'upd';
                }
                unitBpCode = `${_act[0]}.${_act[1]}.${act}`;
            }
            unitBp = await getUnitBp(connect, unitBpCode);
            if (!unitBp) throw new Error(`Действие ${unitBpCode} не найдено в системе.`);
            func = unitBp.func;
        }
    } else {
        func = action;
    }
    if (func) {
        const { args: funcRealParams } = await getFunc(connect, func);

        let i = 1;
        const frmParams = [];
        const sqlParams = [];
        const missedParams = [];
        funcRealParams.forEach(((v) => {
            let funcParam;
            let keyFromParams;
            if (v.name in params) {
                funcParam = v.name;
                keyFromParams = v.name;
            } else {
                keyFromParams = Object.keys(params).find((curParam) => (v.name === `p_${curParam}`));
                if (keyFromParams) {
                    funcParam = v.name;
                }
            }
            if (funcParam) {
                sqlParams.push(`${funcParam}:=$${i++}::${v.datatype}`);
                frmParams.push(params[keyFromParams]);
            } else if (v.required) missedParams.push(v.name);
        }));
        // проверка что не все параметры были переданы
        // if (missedParams.length > 0) {
        //     throw new Error(`Не были переданы параметры: ${missedParams.join(',')}`);
        // }
        const [schema, name] = func.split('.');
        const sql = `select * from "${schema}"."${name}"(${sqlParams.join(',')} ) result;`;
        const execRes = await connect.query({
            text: sql,
            values: frmParams
        });
        res = {
            data: execRes?.rows,
            query: sql,
            queryParams: frmParams
        };
    } else {
        const { sql, params: _params, warn } = prepareSql(unit, act, params);
        if (warn) throw new Error(`Действие ${unitBpCode} не может быть выполнено: ${warn}`);
        // Проверяем все входные параметры, если встречаем массив то приводим его к строке в формате postgresql
        Object.keys(_params).forEach((p) => {
            if (Array.isArray(_params[p])) {
                _params[p] = `{${_params[p].map((e) => (isNaN(e) && e.replace ? `"${e.replace(/"/g, '\\"')}"` : e)).join(',')}}`;
            }
        });
        if (act === 'get') {
            const execRes = await connect.query({
                text: sql,
                values: [_params[unit.pkField]]
            });
            res = execRes?.rows?.[0];
            res = {
                data: res,
                query: sql,
                queryParams: _params
            };
        } else if (act === 'find') {
            const execRes = await connect.query({
                text: sql,
                values: [_params]
            });
            res = {
                data: execRes?.rows,
                query: sql,
                queryParams: _params
            };
        } else {
            const options = {
                unitbp: unitBpCode,
                act,
                divideType: unit.opt.divideType,
                pkField: unit.pkField,
                usePrivs: unitBp?.usePrivs ?? true
            };
            const execRes = await connect.query({
                text: 'select nfc.f_broker8exec($1,$2,$3) as result',
                values: [sql, _params, options]
            });
            res = execRes?.rows?.[0]?.result;
            if (['int2', 'int4', 'int8', 'numeric'].indexOf(unit.pkType) !== -1 && !isNaN(res)) res = +res;

            res = {
                data: (common.isEmpty(res)) ? undefined : {[unit.pkField]: res},
                query: sql,
                queryParams: _params
            };
        }
    }
    return res;
}

/**
 * Метод broker для провайдера данных
 * @param {Client} connect - соединение с базой данных
 * @param {string} action - выполняемое действие (или код nfc.unitbps.code или функция в бд)
 * @param {Object} params - параметры для действия
 * @returns {Promise<{data: (void|Object)}>}
 */
async function providerBroker(connect, action, params) {
    function processTimeToString(time) {
        return (time) ? `${((time[0] * 1e9) + time[1]) / 1000000}ms` : '';
    }
    function _getDebug(frmQuery, frmParams, timeExecute) {
        if (common.getPath(config, 'debug.need')) {
            return {
                execQuery: frmQuery,
                execParams: frmParams || {},
                initQuery: action,
                initParams: params || {},
                timeExecute: processTimeToString(timeExecute),
            };
        }
    }
    let query, queryParams;
    try {
        let timeExecute = process.hrtime();
        const resBroker = await broker(connect, action, params);
        ({ query, queryParams } = resBroker);
        timeExecute = process.hrtime(timeExecute);
        const response = { data: resBroker.data };
        const debug = _getDebug(query, queryParams, timeExecute);
        if (debug) response.debug = debug;
        return response;
    } catch (e) {
        const debug = _getDebug(query, queryParams);
        const msg = await this.formatError(e);
        throw api.nfError(e, msg, { debug });
    }
}
export { getUnit, getUnitBp, prepareSql, broker, providerBroker };
