import { RequestContext } from '@slq/serv';
import { dbapi, SessionAPI, ExecContext, NFProvider } from '@nfjs/back';

/**
 * @typedef {Object} env
 * @property {RequestContext|ExecContext} context - контекст выполнения
 * @property {string} providerName - наименование провайдера
 * @property {NFProvider} provider - экземпляр провайдера данных
 * @property {Connect} connect - подключение к базе данных, через провайдер provider
 */
class Env {
    /**
     * @param {RequestContext|ExecContext} context - контекст выполнения
     * @param {string} [providerName] - наименование провайдера
     * @param {NFProvider} [provider] - экземпляр провайдера данных
     * @param {Connect} [connect] - подключение к базе данных, через провайдер provider
     */
    constructor(context, providerName = 'default', provider, connect) {
        this.context = context;
        this.providerName = providerName;
        this.provider = provider;
        this.connect = connect;
    }

    /**
     * Инициализация соединения с провайдером данных
     * @param {Object} options - дополнительные настройки для соединения
     * @param {boolean} [options.forceCredentials] - признак, что нужно получить соединение с бд под указанным пользователем, невзирая на настройки провайдера
     * @param {string} [options.connectPlace] - шаблон для формирования строки, определяющей место в коде приложения вызова соединения. Например '{applicationName} : importReg'
     * @returns {Promise<void>}
     */
    async doConnect(options) {
        if (!this.connect) {
            if (!this.provider) this.provider = dbapi.getProvider(this.providerName);
            this.connect = await dbapi.getConnect(this.context, { ...options, provider: this.provider });
        }
    }


    /**
     * Создание контекста
     * @param {RequestContext|ExecContext|Object} contextSrc - сессионные данные пользователя
     * @returns {RequestContext}
     */
    static prepareContext(contextSrc) {
        let context;
        if (contextSrc instanceof RequestContext || contextSrc instanceof ExecContext) {
            context = contextSrc;
        } else {
            const { user, password, org, appuser } = contextSrc;
            if (!user || !org) {
                throw new Error('Ошибка инициализации окружения. Не указан один из параметров подключения.');
            }
            const session = new SessionAPI({});
            const dbContext = [
                { ctx: 'org', name: 'nf.org', prvType: 'db-postgres' },
                { ctx: 'user', name: 'nf.appuser', prvType: 'db-postgres' }
            ];
            const clientContext = { user, password, org, appuser };
            session.assign('context', clientContext);
            session.assign('context.prv', dbContext);
            context = new ExecContext({ session });
        }
        return context;
    }

    /**
     * Создание нового объекта окружения и первоначальные инициализации для работы с ним
     * @param {RequestContext|ExecContext|Object} contextSrc - сессионные данные пользователя
     * @param {Object} [options] - опции инициализации окружения
     * @param {string} [options.providerName] - наименование провайдера
     * @param {boolean} [options.forceCredentials] - признак передачи данных для соединения в обход настроек провайдера в конфиге
     * @param {string} [options.connectPlace] - шаблон для формирования строки, определяющей место в коде приложения вызова соединения. Например '{applicationName} : importReg'
     * @returns {Promise<Env>}
     */
    static async prepare(contextSrc, options = {}) {
        const context = Env.prepareContext(contextSrc);
        const { providerName = 'default', ...connectOptions } = options;
        const e = new Env(context, providerName);
        await e.doConnect(connectOptions);
        return e;
    }
}

export {
    Env
};
