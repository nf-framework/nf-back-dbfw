import Ajv from 'ajv';
import ajvLocalize from 'ajv-i18n';
import addFormats from 'ajv-formats';

import { common } from '@nfjs/core';

const ajv = new Ajv({ allErrors: true });
addFormats(ajv);

/**
 * @typedef {Object} ModelHasDefinitionType - Описание для связанной с текущей моделью моделями (пока отношение один(основная) ко многим(зависимая))
 * @property {Model} model - класс связываемой модели
 * @property {string} as - имя свойства основной модели в которой будут связанные
 * @property {string} prop - имя свойства в пришедших данных при инициализации в котором связанные. По-умолчанию как as
 * @property {string} fk - имя поля в связанной сущности, которое указывает на первичный ключ основной
 * @property {string} cmpFields - имена полей связанной которые вкупе с fk определяют запись (уникальный ключ)
 *      для поиска и сопоставления для поиска исправляемых связанных записей. Задаётся в виде 'exam_type;exam_date'
 * @property {function} [cmpFn] - функция сравнения 2х экземпляров связанной(первый и второй аргумент), как замена cmpFields.
 *      Возвращает true\false
 * @property {Object} assignMethod - настройки при сравнения 2х наборов экземпляров связанных данных
 *      для определения что изменилось от первого ко второму
 * @property {boolean} assignMethod.add - добавлять ли ненайденные в первом наборе из второго
 * @property {boolean} assignMethod.upd - исправлять ли найденные в первом наборе из второго данными второго
 * @property {boolean} assignMethod.del - удалять ли из первого набора те, что не было во втором
 */

/**
 * @typedef {Object} ModelQueryOptionsType
 * @property {Array<Array|string>} attributes - выбираемые атрибуты модели. Когда массив, то 1ый элемент сам атрибут, 2ой - алиас
 * @property {(string|Array<ModelHasDefinitionType>)} [include] - указание какие данные связанных сущностей использовать и как
 * @property {Object} where - настройки условия WHERE запроса в виде {field1: 'value', field2: {[Op.gt]: 10, [Op.lt]: 100}}
 * @property {Object} whereSubQuery - дополнительные условия фильтрации. Используется на данный момент для построения subQuery для ModelHasDefinitionType
 * @property {number} limit - количество данных
 * @property {boolean} [allowOtherProperties] - подмешивать ли в итоговый экземпляр из данных свойства, которых нет в таблице, но есть в представлении
 */

/**
 * @typedef {Object} ModelValidationErrorType
 * @property {string} property - свойство(а) на котром не прошла проверка
 * @property {string} message - человекочитаемое сообщение
 */

/**
 * Проверка значения, что является объектом
 * @param {*} obj - проверяемое значение
 * @return {boolean}
 */
function isObject(obj) {
    const type = typeof obj;
    return type === 'function' || (type === 'object' && !!obj);
}

/**
 * Получение свойств объекта
 * @param {Object} obj - объект
 * @return {symbol[]}
 */
function objectKeys(obj) {
    return Object.getOwnPropertySymbols(obj).concat(Object.getOwnPropertyNames(obj));
}

/**
 * Операторы sql
 * @type {{in: symbol, lt: symbol, gte: symbol, isndf: symbol, lte: symbol, isdf: symbol, gt: symbol}}
 */
const Op = {
    in: Symbol.for('in'),
    isdf: Symbol.for('isdf'),
    isndf: Symbol.for('isndf'),
    gt: Symbol.for('gt'),
    gte: Symbol.for('gte'),
    lt: Symbol.for('lt'),
    lte: Symbol.for('lte'),
};

/**
 * Сравнение на равенство всех значений указанного перечня свойств в двух объектах
 * @param {string} fields - перечень свойст, разделенных через ";"
 * @return {(function(Object, Object): (boolean))}
 */
function compareFn(fields) {
    const fa = fields.split(';');
    return function (obj1, obj2) {
        for (let i = 0; i < fa.length; i++) if (obj1[fa[i]] !== obj2[fa[i]]) return false;
        return true;
    };
}

class Model {
    static _validator = ajv;

    /**
     * Инициализация по данным
     * @param {Object} values - данные
     * @param {Object} [options] - настройки
     * @param {(string|Array<ModelHasDefinitionType>)} [options.include] - указание какие данные связанных сущностей использовать и как
     * @param {boolean} [options.allowOtherProperties] - подмешивать ли в итоговый экземпляр из данных свойства, которых
     * нет в таблице модели
     * @returns {void}
     */
    _constructor(values, options) {
        const iV = common.cloneDeep(values);
        const allowOtherProperties = options?.allowOtherProperties ?? false;
        let include = options?.include ?? [];
        objectKeys(iV).forEach((key) => {
            if (allowOtherProperties || key in this.constructor._schema.properties) {
                if (key in Model) throw new Error(`Свойство [${key}] не может быть инициализировано - совпадает с именем метода класса.`);
                // TODO вставить приведение к типу
                this[key] = iV[key];
            }
        });
        const iniInclude = include;
        if (include === 'all') include = Object.values(this.constructor._hasdef || {});
        for (const _inc of include) {
            const inc = Model.incResolve.call(this, _inc);
            if (iV[inc.prop] && Array.isArray(iV[inc.prop])) {
                this[inc.as] = [];
                for (const im of iV[inc.prop]) {
                    im[inc.fk] = (this[this.constructor._def.pk]) ? this[this.constructor._def.pk] : this.defer(this.constructor._def.pk);
                    if (!_inc.include && iniInclude === 'all') _inc.include = 'all';
                    // eslint-disable-next-line new-cap
                    this[inc.as].push(new inc.model(im, _inc));
                }
            }
        }
    }

    /**
     * Заполнение приватного свойства _saveOnlyAttr со списком свойств экземпляра, которые будут участвовать при сохранении в бд
     * @param {Array<string>} attr - список свойств
     */
    _assignSaveOnlyAttr(attr = []) {
        if (attr.length > 0) {
            if (this._saveOnlyAttr) {
                this._saveOnlyAttr = [...new Set([...this._saveOnlyAttr, ...attr])]; // только уникальные
            } else {
                this._saveOnlyAttr = attr;
            }
        }
    }

    /**
     * Копирование в экземляр свойств из объекта данных вместе со связанными данными, разбираясь как обрабатывать наборы
     * связанных данных
     * @param {Object} values - сам объект данных вместе со связанными
     * @param {Object} options - настройки копирования
     * @param {(string|Array<ModelHasDefinitionType>)} [options.include] - указание какие данные связанных сущностей использовать и как
     * @param {boolean} [options.allowOtherProperties] - подмешивать ли в итоговый экземпляр из данных свойства, которых нет в таблице модели
     * @param {boolean} [options.assignSaveOnlyAttr] - заполнять ли _saveOnlyAttr свойствами из переданного на копирование объекта
     * @returns {void}
     */
    assign(values = {}, options = {}) {
        const iV = common.cloneDeep(values);
        const allowOtherProperties = options?.allowOtherProperties ?? false;
        const assignSaveOnlyAttr = options?.assignSaveOnlyAttr ?? false;
        let include = options?.include ?? [];
        objectKeys(iV).forEach((key) => {
            if (allowOtherProperties || key in this.constructor._schema.properties) {
                if (key in Model) throw new Error(`Свойство [${key}] не может быть инициализировано - совпадает с именем метода класса.`);
                // TODO вставить приведение к типу
                this[key] = iV[key];
            }
        });
        if (assignSaveOnlyAttr) this._assignSaveOnlyAttr(Object.keys(iV));
        const iniInclude = include;
        if (include === 'all') include = Object.values(this.constructor._hasdef || {});
        for (const _inc of include) {
            const inc = Model.incResolve.call(this, _inc);
            if (!('include' in _inc) && iniInclude === 'all') _inc.include = 'all';
            if (!('assignSaveOnlyAttr' in _inc) && iniInclude === 'all') _inc.assignSaveOnlyAttr = assignSaveOnlyAttr;
            if (!('allowOtherProperties' in _inc) && iniInclude === 'all') _inc.allowOtherProperties = allowOtherProperties;
            const cmpFn = (inc.cmpFn) ?
                inc.cmpFn :
                compareFn(inc.cmpFields);
            if (!(inc.as in this)) this[inc.as] = [];
            this[inc.as]._mutations = { add: [], upd: [], del: [] };
            if (iV[inc.prop] && Array.isArray(iV[inc.prop])) {
                // новые или существующие данные
                for (const newI of iV[inc.prop]) {
                    // найти в существующих
                    const exists = this[inc.as].find((oldI) => cmpFn(oldI, newI));
                    if (exists) {
                        if (inc.assignMethod.upd) {
                            exists.assign(newI, _inc);
                            this[inc.as]._mutations.upd.push(exists);
                        }
                    } else if (inc.assignMethod.add) {
                        newI[inc.fk] = this.defer(this.constructor._def.pk);
                        // eslint-disable-next-line new-cap
                        const newItem = new inc.model(newI, _inc);
                        this[inc.as].push(newItem);
                        this[inc.as]._mutations.add.push(newItem);
                    }
                }
                if (inc.assignMethod.del) {
                    // найти более не существующие
                    for (const oldI of this[inc.as]) {
                        // найти в новых
                        const existsIndex = iV[inc.prop].findIndex((newI) => cmpFn(oldI, newI));
                        if (existsIndex === -1) {
                            this[inc.as]._mutations.del.push(oldI);
                        }
                    }
                }
            } else {
                // нет данных. Нужно решить что делать с существующими
                if (inc.assignMethod.del) {
                    for (const oldI of this[inc.as]) {
                        this[inc.as]._mutations.del.push(oldI);
                    }
                }
            }
        }
    }

    /**
     * Заполнение описания использования связанной сущности значениями по-умолчанию и проверки
     * @param {ModelHasDefinitionType} inc
     * @returns {ModelHasDefinitionType}
     */
    static incResolve(inc) {
        let { model, prop, as, has, cmpFn, cmpFields, assignMethod } = inc;
        let hasDef;
        if (has) {
            hasDef = this.constructor._hasdef[has];
            if (!hasDef) throw new Error(`${this.constructor.name} has no association for prop ${has}`);
        } else {
            hasDef = Object.values(this.constructor._hasdef).find((i) => i.model === model);
            if (!hasDef) throw new Error(`${this.constructor.name} has no association with model ${model.constructor.name}`);
        }
        if (!model) model = hasDef.model;
        if (!as) as = hasDef.as;
        if (!prop) prop = hasDef.as;
        if (!cmpFn) cmpFn = hasDef.cmpFn;
        if (!cmpFields) cmpFields = hasDef.cmpFields;
        if (!assignMethod) assignMethod = hasDef.assignMethod || { add: true, upd: true, del: true };
        return { model, as, prop, fk: hasDef.fk, cmpFn, cmpFields, assignMethod };
    }

    /**
     * Формирование параметров для сохранения экземпляра в бд, основываясь на _saveOnlyAttr
     * @returns {Object}
     */
    getParams() {
        const params = {};
        const pk = this.constructor._def.pk;
        Object.keys(this.constructor._schema.properties)
            // eslint-disable-next-line max-len
            .filter((name) => (name === pk || (!this._saveOnlyAttr || (this._saveOnlyAttr && this._saveOnlyAttr.length > 0 && this._saveOnlyAttr.indexOf(name) !== -1))))
            .forEach((key) => {
                if (this[key] instanceof Function) {
                    params[key] = this[key]();
                } else {
                    params[key] = this[key];
                }
            });
        return params;
    }

    /**
     * Создание
     * @param {Connect} connect - соединение с источником данных
     * @returns {Promise<void>}
     */
    async create(connect) {
        const action = `${this.constructor._def.schema}.${this.constructor._def.table}.add`;
        const res = await connect.broker(action, this.getParams());
        this[this.constructor._def.pk] = res && res.data && res.data[this.constructor._def.pk];
    }

    /**
     * Исправление
     * @param {Connect} connect - соединение с источником данных
     * @returns {Promise<void>}
     */
    async update(connect) {
        const action = `${this.constructor._def.schema}.${this.constructor._def.table}.upd`;
        await connect.broker(action, this.getParams());
    }

    /**
     * Удаление
     * @param {Connect} connect - соединение с источником данных
     * @returns {Promise<void>}
     */
    async destroy(connect) {
        const action = `${this.constructor._def.schema}.${this.constructor._def.table}.del`;
        await connect.broker(action, this.getParams());
    }

    /**
     * Построение запроса за данными экземпляров в бд
     * @param {ModelQueryOptionsType} queryOptions - настройки для запроса
     * @param {Object} params - значения переменных в запросе
     * @param {string} [as] - алиас для подзапроса
     * @returns {string}
     */
    static buildSelect(queryOptions, params = {}, { as } = {}) {
        // TODO QueryBuilder
        // where: {title: 'aProject'},
        // attributes: ['id', ['name', 'title']]
        let attributes = '*';
        const alias = (as) || `${this._def.schema}__${this._def.table}`;
        if (queryOptions.attributes) {
            attributes = queryOptions.attributes.map((att) => {
                if (Array.isArray(att)) return `${alias}.${att[0]} as ${att[1]}`;
                return att;
            }).join();
        }
        let sql = `select ${attributes} `;
        let include = queryOptions.include || [];
        const iniInclude = include;
        if (include === 'all') include = Object.values(this._hasdef || {});
        for (const _inc of include) {
            const inc = Model.incResolve.call(this, _inc);
            const qOptions = { ..._inc.queryOptions, whereSubQuery: { [inc.fk]: `${alias}.${this._def.pk || 'id'}` } };
            if (!qOptions.include && iniInclude === 'all') qOptions.include = 'all';
            const incSql = inc.model.buildSelect(qOptions, params, { as: `${alias}_${inc.as}` });
            const sorts = (inc.cmpFields) ? ` order by ${inc.cmpFields.split(';').map((f) => `${`_${inc.as}`}.${f} asc nulls last`).join(',')}` : '';
            // Важно. Даты row_to_json конвертяться всегда в YYYY-MM-DD,
            // таймстампы без зоны в 2020-09-14T21:38:51.580355 или 2020-08-29T09:00:00
            // c зоной конвертятся к зоне веб сервера и вида 2020-09-25T11:00:25.959113+03:00
            sql += `,coalesce((select array_agg(row_to_json(${`_${inc.as}`}.*) ${sorts}) from (${incSql}) ${`_${inc.as}`}),'{}'::json[]) as ${inc.as}`;
            /*
            select r.*,
                   coalesce((select array_agg(row_to_json(s1.*))
                 from (select s.*,
                       coalesce((select array_agg(row_to_json(vsr.*)) from vcc.v4stage_reaction vsr where vsr.pid = s.id),'{}'::json[]) as sub_reactions
                       from vcc.v4stage s where s.pid = r.id) s1),  '{}'::json[]) as sub_stages
              from vcc.v4reg r
             where r.uin = '230000000000007'
            */
        }

        sql += ` from ${this._def.schema}.${this._def.view} as ${alias}`;
        if (queryOptions.where) {
            sql += ' where';
            Object.keys(queryOptions.where).forEach((col, ind) => {
                const colV = queryOptions.where[col];
                sql += `${(ind === 0 ? ' ' : ' and ')}`;
                if (isObject(colV)) {
                    sql += '(';
                    objectKeys(colV).forEach((op, i) => {
                        sql += `${(i === 0 ? ' ' : ' and ')}`;
                        const prm = `${alias}__${col}${i}`;
                        switch (op) {
                            case Op.in:
                                sql += `${alias}.${col} = any(:${prm})`;
                                params[prm] = colV[op];
                                break;
                            case Op.isdf:
                                sql += `${alias}.${col} is distinct from :${prm}`;
                                params[prm] = colV[op];
                                break;
                            case Op.isndf:
                                sql += `${alias}.${col} is not distinct from :${prm}`;
                                params[prm] = colV[op];
                                break;
                            case Op.gt:
                                sql += `${alias}.${col} > :${col}${i}`;
                                params[col + i] = colV[op];
                                break;
                            case Op.gte:
                                sql += `${alias}.${col} >= :${col}${i}`;
                                params[col + i] = colV[op];
                                break;
                            case Op.lt:
                                sql += `${alias}.${col} < :${col}${i}`;
                                params[col + i] = colV[op];
                                break;
                            case Op.lte:
                                sql += `${alias}.${col} <= :${col}${i}`;
                                params[col + i] = colV[op];
                                break;
                        }
                    });
                    sql += ')';
                } else {
                    const prm = `${alias}__${col}`;
                    sql += `${alias}.${col} =:${prm}`;
                    params[prm] = colV;
                }
            });
        }
        if (queryOptions.whereSubQuery) {
            if (!queryOptions.where) sql += ' where';
            Object.keys(queryOptions.whereSubQuery).forEach((col, ind) => {
                const colQ = queryOptions.whereSubQuery[col];
                sql += `${((!queryOptions.where && ind === 0) ? ' ' : ' and ')}`;
                sql += `${alias}.${col} = ${colQ}`;
            });
        }
        if (queryOptions.limit) {
            sql += ' limit :__limit';
            params.__limit = queryOptions.limit;
        }
        return sql;
    }

    /**
     * Поиск записей таблицы модели с наложением условий отбора
     * @param {Connect} connect - соединение с источником данных
     * @param {ModelQueryOptionsType} queryOptions - настройки для запроса
     * @returns {Promise<Object[]>}
     */
    static async select(connect, queryOptions) {
        const params = {};
        const sql = this.buildSelect(queryOptions, params, { as: 't' });
        const res = await connect.query(sql, params);
        if (res && res.data) return res.data;
        return [];
    }

    /**
     * Поиск всех экземпляров модели подходящих под условия
     * @param {Connect} connect - соединение с источником данных
     * @param {ModelQueryOptionsType} queryOptions - настройки для запроса
     * @returns {Promise<Model[]>}
     */
    static async findAll(connect, queryOptions) {
        const all = await this.select(connect, queryOptions);
        const res = [];
        for (const one of all) {
            const _one = new this(one, queryOptions);
            res.push(_one);
        }
        return res;
    }

    /**
     * Поиск первого экземпляра модели подходящего под условия
     * @param {Connect} connect - соединение с источником данных
     * @param {ModelQueryOptionsType} queryOptions - настройки для запроса
     * @returns {Promise<Model>}
     */
    static async findOne(connect, queryOptions) {
        // eslint-disable-next-line no-param-reassign
        queryOptions.limit = 1;
        const _r = await this.findAll(connect, queryOptions);
        return (_r && _r[0]);
    }

    /**
     * Поиск первого экземпляра модели подходящего под условия. Если не найден, то формирование нового
     * @param {Connect} connect - соединение с источником данных
     * @param {ModelQueryOptionsType} queryOptions - настройки для запроса
     * @param {Object} initValues - данные для нового экземпляра
     * @param {Object} initOptions - настройки
     * @param {(string|Array<ModelHasDefinitionType>)} [initOptions.include] - указание какие данные связанных сущностей использовать и как
     * @param {boolean} [initOptions.allowOtherProperties] - подмешивать ли в итоговый экземпляр из данных свойства, которых
     * @returns {Promise<Model>}
     */
    static async findOneOrNew(connect, queryOptions, initValues, initOptions) {
        let _r = await this.findOne(connect, queryOptions);
        if (!(_r && _r[this.constructor._def.pk])) {
            _r = new this(initValues, initOptions);
        } else if (initValues) _r.assign(initValues, initOptions);
        return _r;
    }

    /**
     * Поиск экземпляра модели по первичному ключу и дополнение объекта по настройкам queryOptions (hasdef)
     * @param {Connect} connect - соединение с источником данных
     * @param {*} pkValue - значение первичного ключа
     * @param {ModelQueryOptionsType} queryOptions - настройки для запроса
     * @returns {Promise<Model>}
     */
    static async findByPk(connect, pkValue, queryOptions = {}) {
        return this.findOne(connect, { ...queryOptions, where: { [this.constructor._def.pk || 'id']: pkValue } });
    }

    /**
     * Сохранение
     * @param {Connect} connect - соединение с источником данных
     * @returns {Promise<void>}
     */
    async save(connect) {
        const pk = this.constructor._def.pk || 'id';
        // TODO в некоторых разделах id на вход явно может подаваться. Для таких видимо пока использовать create или update явно
        if (this[pk]) {
            await this.update(connect);
        } else {
            await this.create(connect);
        }
    }

    /**
     * Сохранение текущего экземпляра со связанными путем сохранения в порядке зависимости. Сначала текущую,
     * потом исправления\добавления вглубь по уровням вложенности. Затем удаления зависимых в обратном глубине порядке
     * @param {Connect} connect - соединение с источником данных
     * @param {Object} options - настройки
     * @param {(string|Array<ModelHasDefinitionType>)} options.include - указание какие данные связанных сущностей использовать и как
     * @returns {Promise<void>}
     */
    async saveFull(connect, options) {
        await this.save(connect);
        const aSave = [],
            aDel = [];
        this._prepareSaveHas({ lvl: 0, aSave, aDel }, options);
        for (let lvl = 0; lvl < aSave.length; lvl++) await Promise.all((aSave[lvl] || []).map((i) => i.save(connect)));
        for (let lvl = aDel.length - 1; lvl >= 0; lvl--) await Promise.all((aDel[lvl] || []).map((i) => i.destroy(connect)));
    }

    /**
     * Подготовка сохранения всех связянных с текущей сущностью. Выстраивание порядка сохранения
     * @param {Object} agg - куда складывать подготовленные
     * @param {number} agg.lvl - уровень вложенности связанных данных
     * @param {Array<Array<Model>>} agg.aSave - массив экземпляров сущностей к сохранению, распределенных по уровням вложенности
     * @param {Array<Array<Model>>} agg.aDel - массив экземпляров сущностей к удалению, распределенных по уровням вложенности
     * @param {Object} options - настройки
     * @param {(string|Array<ModelHasDefinitionType>)} options.include - указание какие данные связанных сущностей использовать и как
     */
    _prepareSaveHas(agg, options) {
        const { lvl, aSave, aDel } = agg;
        if (!aSave[lvl]) aSave[lvl] = [];
        if (!aDel[lvl]) aDel[lvl] = [];
        let { include = [] } = options;
        const iniInclude = include;
        if (include === 'all') include = Object.values(this.constructor._hasdef || {});
        for (const _inc of include) {
            const inc = Model.incResolve.call(this, _inc);
            if (!('include' in _inc) && iniInclude === 'all') _inc.include = 'all';
            if (this[inc.as]) {
                if ('_mutations' in this[inc.as]) {
                    [...(this[inc.as]._mutations.add || []), ...(this[inc.as]._mutations.upd || [])].forEach((i) => {
                        aSave[lvl].push(i);
                        i._prepareSaveHas({ lvl: lvl + 1, aSave, aDel }, _inc);
                    });
                    aDel[lvl].push(...(this[inc.as]._mutations.del || []));
                } else if (this[inc.as] && Array.isArray(this[inc.as])) {
                    this[inc.as].forEach((i) => {
                        aSave[lvl].push(i);
                        i._prepareSaveHas({ lvl: lvl + 1, aSave, aDel }, _inc);
                    });
                }
            }
        }
    }

    /**
     * Возвращает значение указанного свойства. Используется при сохранении когда например на момент инициализации свойства
     * другой сущности нужно id текущей, но оно заполнится только при сохранении текущей, что обычно делается в конце всех манипуляций
     * @param {string} prop - имя свойства, которое нужно будет вернуть
     * @returns {*}
     */
    defer(prop) {
        return () => this[prop];
    }

    /**
     * Валидация экземпляра по описанной схеме и кастомным проверкам
     * @return {Promise<{valid: boolean, message: string, errors: ModelValidationErrorType[]}>}
     */
    async validate() {
        let errors = [];
        const schemaValidator = this.constructor._validationSchema;
        if (schemaValidator) {
            const valid = schemaValidator(this);
            if (!valid) {
                const schemaErrors = schemaValidator.errors;
                ajvLocalize.ru(schemaErrors);
                errors = schemaErrors.map((e) => {
                    const message = ajv.errorsText([e], { dataVar: this.constructor.name });
                    let property;
                    switch (e.keyword) {
                        case 'required':
                            property = e.params.missingProperty;
                            break;
                        default:
                            property = e.instancePath.substr(1);
                            break;
                    }
                    return {
                        ...e,
                        message,
                        property
                    }
                });
            }
        }
        if (this.constructor._validations) {
            let vErrors = await Promise.all(this.constructor._validations.map((vFunc) => vFunc.call(this)));
            vErrors = vErrors.filter((vRes) => !!vRes.message);
            errors.push(...vErrors);
        }
        return {
            valid: errors.length === 0,
            message: errors.map((e) => e.message).join(','),
            errors
        };
    }
}

export { Model, Op };
