import { dbapi } from '@nfjs/back';
import { config  } from '@nfjs/core';

const logonKind = config?.data_providers?.default?.connectType ?? 'user';
class AuthProvider {
    /**
     * Попытка аутентификации пользователя средствами провайдера данных 'default'
     * @param {string} user
     * @param {string} password
     * @param {SessionAPI} session
     * @returns {Promise<{result: boolean, detail?: string}>}
     */
    async login(user, password, session) {
        let ret, connect;
        try {
            const credentials = { user, password };
            const func = (logonKind === 'user') ? 'nfc.f4users8logon' : 'nfc.f4users8logon_pool';
            let funcParams = {};
            if (logonKind === 'pool') {
                funcParams = { user, password };
            }
            connect = await dbapi.getConnect(credentials);
            const logonResult = await connect.func(func, funcParams);
            const logonData = logonResult?.data?.[0]?.result;
            const serverContext = {
                ...credentials,
                ...logonData
            };
            if (serverContext.user_id) {
                const dbContext = [
                    {ctx: 'org', name: 'nf.org', prvType: 'db-postgres'},
                    // { ctx: 'client_ip', name: 'all.remote_ip', prvType: 'db-postgres' },
                    // { ctx: 'client_host', name: 'all.hostname', prvType: 'db-postgres' },
                    // { ctx: 'language', name: 'all.language', prvType: 'db-postgres' },
                    // { ctx: 'debug', name: 'all.debug', prvType: 'db-postgres' },
                ];
                if (logonKind === 'pool')
                    dbContext.push({ ctx: 'user', name: 'nf.appuser', prvType: 'db-postgres' });
                session.assign('context', serverContext);
                session.assign('context.prv', dbContext);
                ret = { result: true };
            } else {
                ret = { result: false, detail: 'Пользователь с указанным паролем не существует' };
            }
        } catch (err) {
            ret = { result: false, detail: err.message };
        } finally {
            if (connect) connect.release();
        }
        return ret;
    }

    /**
     * Выход пользователя
     * @param {SessionAPI} session
     * @return {Promise<void>}
     */
    async logout(session) {
        session.destroy();
    }
}

/**
 * Обновление информации о пользователе во время логин через openId и запись обновленной информации в контекст сессии
 * @param {RequestContext} context - контекст выполнения запроса
 * @param {Connect} connect - соединение с базой данных дефолтного провайдера
 * @return {Promise<void>}
 */
async function loginOpenId(context, connect) {
    const userInfo = context.session.get('openid-userinfo');
    const { _username: username, _fullname: fullname } = userInfo;
    const res = await connect.func(
        'nfc.f4users8logon_openid',
        { username, fullname, extra: userInfo },
        null,
        'object',
    );
    const clientContext = {
        user: username,
        ...res.data[0].result
    };
    const dbContext = [
        { ctx: 'org', name: 'nf.org', prvType: 'db-postgres' },
        { ctx: 'user', name: 'nf.appuser', prvType: 'db-postgres' },
    ];
    context.session.assign('context', clientContext);
    context.session.assign('context.prv', dbContext);
}

export { AuthProvider, loginOpenId }
