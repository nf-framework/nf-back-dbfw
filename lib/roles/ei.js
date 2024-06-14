import { nfc as nfcModel } from '../../models/index.js';
import { Env } from '../env.js';
import { api } from '@nfjs/core';

/**
 * Получение из базы данных настроенных прав для перечня ролей
 * @param {Env} env - окружение выполнения
 * @param {Array<string>} roles - выбранные к экспорту коды ролей
 * @returns {Promise<Array<Object>>}
 */
async function getRoleUnitPrivs(env, roles, options = {}) {
    const { includeId = false } = options;
    const sql = (includeId) ?
        `select json_build_object(
            'id', r.id,
            'code', r.code,
            'caption', r.caption,
            'unitPrivs', coalesce((select array_agg(json_build_object(
                'id', ru.id,
                'unit', ru.unit,
                'unitBpprivs', coalesce((select array_agg(json_build_object(
                    'id', rub.id,
                    'unitbp', rub.unitbp
                    )) from nfc.v4role_unitbpprivs rub where rub.pid = ru.id),'{}'::json[])
                )) from nfc.v4role_unitprivs ru where ru.role_id = r.id),'{}'::json[]),
            'menuRoles', coalesce((select array_agg(json_build_object(
                'id', mr.id,
                'menuguid', mr.menuguid
                )) from nfc.v4menuroles mr where mr.role_id = r.id),'{}'::json[])
            ) as role
          from nfc.v4roles r where r.code = any(string_to_array(:roles,';'))` :
        `select json_build_object(
            'code', r.code,
            'caption', r.caption,
            'unitPrivs', coalesce((select array_agg(json_build_object(
                'unit', ru.unit,
                'unitBpprivs', coalesce((select array_agg(rub.unitbp) from nfc.v4role_unitbpprivs rub where rub.pid = ru.id),'{}'::text[])
                )) from nfc.v4role_unitprivs ru where ru.role_id = r.id),'{}'::json[]),
            'menuRoles', coalesce((select array_agg(json_build_object(
                'menuguid', mr.menuguid
                )) from nfc.v4menuroles mr where mr.role_id = r.id),'{}'::json[])
            ) as role
          from nfc.v4roles r where r.code = any(string_to_array(:roles,';'))`;
    const dataRes = await env.connect.query(sql, { roles });
    return dataRes.data;
}

/**
 * Отдача на клиент полученного json настроенных прав перечню ролей
 * @param {RequestContext} context - контекст выполнения запроса от пользователя
 * @return {Promise<void>}
 */
async function exportRoleUnitPrivs(context) {
    const { roles } = context.query;
    let env, res;
    try {
        env = await Env.prepare(context.session.get('context'));
        res = await getRoleUnitPrivs(env, roles);
    } finally {
        if (env.connect) env.connect.release();
    }
    const headers = {
        'Content-type': 'application/octet-stream',
        'Content-disposition': 'attachment; filename=roleUnitPrivs.json'
    };
    context.headers(headers);
    context.send(res);
}

/**
 * Синхронизация в базе данных настроек прав ролей с указанными
 *
 * @param {Env} env - окружение выполнения
 * @param {Array<Object>} data - настройки прав ролей. Сформированные getRoleUnitPrivs на базе источнике
 * @return {Promise<void>}
 */
async function putRoleUnitPrivs(env, data) {
    const roles = [],
        unitPrivs = [],
        unitPrivsDel = [],
        unitBpprivs = [],
        unitBpprivsDel = [],
        menuRoles = [],
        menuRolesDel = [];
    for (const _r of data) {
        const _role = _r.role;
        const eRoles = await getRoleUnitPrivs(env, _role.code, { includeId: true });
        const eRole = eRoles && eRoles[0] && eRoles[0].role;
        if (eRole) {
            const role = await nfcModel.NfcRoles.findOne(env.connect, { where: { code: _role.code } });
            if (role.caption !== _role.caption) {
                role.assign({ caption: _role.caption }, true);
                roles.push(role);
            }
            // по разделам которых не было или совпадающие
            for (const _unit of _role.unitPrivs) {
                const eUnit = eRole.unitPrivs.find((_eu) => _eu.unit === _unit.unit);
                if (eUnit) {
                    // по действиям, которых не было или совпадающие
                    for (const _unitbp of _unit.unitBpprivs) {
                        const eUnitbp = eUnit.unitBpprivs.find((_eub) => _eub.unitbp === _unitbp);
                        if (!eUnitbp) {
                            const ubp = new nfcModel.NfcRoleUnitbpprivs({
                                pid: eUnit.id,
                                unitbp: _unitbp
                            });
                            unitBpprivs.push(ubp);
                        }
                    }
                    // по действиям, которых не стало
                    for (const _eUnitbp of eUnit.unitBpprivs) {
                        if (_unit.unitBpprivs.findIndex((_ub) => _ub === _eUnitbp.unitbp) === -1) {
                            unitBpprivsDel.push(_eUnitbp.id);
                        }
                    }
                } else {
                    const u = new nfcModel.NfcRoleUnitprivs({
                        role_id: eRole.id,
                        unit: _unit.unit
                    });
                    unitPrivs.push(u);
                    for (const _unitbp of _unit.unitBpprivs) {
                        const ubp = new nfcModel.NfcRoleUnitbpprivs({
                            pid: u.defer('id'),
                            unitbp: _unitbp
                        });
                        unitBpprivs.push(ubp);
                    }
                }
            }
            // по разделам, которых не стало
            for (const _eUnit of eRole.unitPrivs) {
                if (_role.unitPrivs.findIndex((_u) => _u.unit === _eUnit.unit) === -1) {
                    unitPrivsDel.push(_eUnit.id);
                }
            }

            // разделы меню, которых не было или совпадающие
            for (const _menu of _role.menuRoles) {
                const eMenu = eRole.menuRoles.find((_em) => _em.menuguid === _menu.menuguid);
                if (!eMenu) {
                    const menuItem = new nfcModel.NfcMenuRoles({
                        role_id: eRole.id,
                        menuguid: _menu.menuguid
                    });
                    menuRoles.push(menuItem);
                }
            }

            // разделы меню, которых не стало
            for (const _eMenu of eRole.menuRoles) {
                const menu = _role.menuRoles.find(_m => _m.menuguid === _eMenu.menuguid);
                if (!menu) {
                    menuRolesDel.push(_eMenu.id);
                }
            }
        } else {
            const role = new nfcModel.NfcRoles({
                code: _role.code,
                caption: _role.caption
            });
            roles.push(role);
            for (const _unit of _role.unitPrivs) {
                const u = new nfcModel.NfcRoleUnitprivs({
                    role_id: role.defer('id'),
                    unit: _unit.unit
                });
                unitPrivs.push(u);
                for (const _unitbp of _unit.unitBpprivs) {
                    const ubp = new nfcModel.NfcRoleUnitbpprivs({
                        pid: u.defer('id'),
                        unitbp: _unitbp
                    });
                    unitBpprivs.push(ubp);
                }
            }

            for (const _menu of _role.menuRoles) {
                const menu = new nfcModel.NfcMenuRoles({
                    role_id: role.defer('id'),
                    menuguid: _menu.menuguid
                });
                menuRoles.push(menu);
            }
        }
    }
    // сохранение
    await Promise.all(roles.map((r) => r.save(env.connect)));
    await Promise.all(unitPrivs.map((r) => r.save(env.connect)));
    await Promise.all(unitBpprivs.map((r) => r.save(env.connect)));
    await Promise.all(menuRoles.map((r) => r.save(env.connect)));
    await Promise.all(unitPrivsDel.map((u) => env.connect.broker('nfc.role_unitprivs.del', { id: u })));
    await Promise.all(unitBpprivsDel.map((u) => env.connect.broker('nfc.role_unitbpprivs.del', { id: u })));
    await Promise.all(menuRolesDel.map((u) => env.connect.broker('nfc.menuroles.del', { id: u })));
}

/**
 * Импорт настроек прав ролей из переданного с клиента файла
 *
 * @param {RequestContext} context - контекст выполнения запроса от пользователя
 * @return {Promise<void>}
 */
async function importRoleUnitPrivs(context) {
    try {
        const chunks = [];
        const fileStream = context.fileInfo.fileStream;
        for await (const chunk of fileStream) {
            chunks.push(chunk);
        }

        const buffer = Buffer.concat(chunks);
        const str = buffer.toString('utf-8');

        const data = JSON.parse(str);
        const env = await Env.prepare(context.session.get('context'));
        try {
            await env.connect.begin();
            await putRoleUnitPrivs(env, data);
            await env.connect.commit();
        } catch (e) {
            await env.connect.rollback();
            throw e;
        } finally {
            if (env.connect) env.connect.release();
        }
        context.send({ id: 1, res: data.map((d) => d.role.code).join(',') });
    } catch (e) {
        const error = api.nfError(e, e.message);
        context.send(error.json());
    }
}

export {
    getRoleUnitPrivs,
    exportRoleUnitPrivs,
    putRoleUnitPrivs,
    importRoleUnitPrivs
};
