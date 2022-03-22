import { dataProviders } from '@nfjs/back';
import { api } from '@nfjs/core';

class AuthProvider {
    /**
     * Попытка аутентификации пользователя средствами провайдера данных 'default'
     * @param {string} user
     * @param {string} password
     * @param {SessionAPI} session
     * @returns {Promise<{result: boolean, detail?: string}>}
     */
    async login(user, password, session) {
        const provider = this._getProvider();
        const credentials = { user, password };
        let ret, connect;
        try {
            connect = await provider.getConnect(credentials);
            const clientContext = await this._dbLogon(connect, credentials);
            if (clientContext.user_id) {
                const dbContext = [
                    {ctx: 'org', name: 'nf.org', prvType: 'db-postgres'},
                    // { ctx: 'client_ip', name: 'all.remote_ip', prvType: 'db-postgres' },
                    // { ctx: 'client_host', name: 'all.hostname', prvType: 'db-postgres' },
                    // { ctx: 'language', name: 'all.language', prvType: 'db-postgres' },
                    // { ctx: 'debug', name: 'all.debug', prvType: 'db-postgres' },
                ];
                session.assign('context', clientContext);
                session.assign('context.prv', dbContext);
                ret = {result: true};
            } else {
                ret = {result: false, detail: 'No such user'};
            }
        } catch (err) {
            ret = { result: false, detail: err.message };
        } finally {
            if (connect) provider.releaseConnect(connect);
        }
        return ret;
    }

    /**
     * Попытка аутентификации в источнике данных данными пользователя
     * @param {*} connect - коннект с источником данных
     * @param {Object} credentials - данные для аутентификации в источнике данных
     * @return {Promise<*&{grp: *, org: *, user_id: *, userforms: *}>}
     * @private
     */
    async _dbLogon(connect, credentials) {
        const provider = this._getProvider();
        let logonResult;
        try {
            logonResult = await provider.func(
                connect,
                'nfc.f4users8logon',
                {},
                null,
                'object',
            );
        } catch (e) {
            throw api.nfError(e, 'Запрос за параметрами пользователя из базы данных не удался.');
        }

        const logonData = logonResult.data[0];
        return {
            ...credentials,
            org: logonData.p_org,
            user_id: logonData.p_user_id,
            grp: logonData.p_grp,
            userforms: logonData.p_userforms,
        };
    }

    /**
     * Выход пользователя
     * @param {SessionAPI} session
     * @return {Promise<void>}
     */
    async logout(session) {
        session.destroy();
    }

    /** @private */
    _getProvider() {
        return dataProviders.default;
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
