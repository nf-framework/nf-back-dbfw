import { dbapi } from '@nfjs/back';

/**
 * Отдача на клиент настройки персонализации ui пользователя
 *
 * @param {RequestContext} context - контекст выполнения запроса от пользователя
 * @return {Promise<void>}
 */
async function get(context) {
    const res = await dbapi.query(
        'select value from nfc.v4ui_customization where scope=:scope and key=:key',
        { scope: `u:${context.session.get('context.user')}`, key: context.query.key },
        { context: context }
    );

    context.send((res && res.data[0] && res.data[0].value) || {});
}

/**
 * Сохранение в базу данных настройки персонализации ui пользователя
 *
 * @param {RequestContext} context - контекст выполнения запроса от пользователя
 * @return {Promise<void>}
 */
function set(context) {
    dbapi.func('nfc.f4ui_customization8user_save', { key: context.body.key, value: context.body.customizations }, { context: context });
    context.send(true);
}

export {
    get,
    set
};
