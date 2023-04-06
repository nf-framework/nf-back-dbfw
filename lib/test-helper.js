import { provider } from '@nfjs/db-postgres';
import { SessionAPI, ExecContext } from '@nfjs/back';
import { common, config } from '@nfjs/core';

import { Env } from './env.js';
import * as broker from './broker.js';

/**
 * Подготовка экземпляра провайдера
 * @param name {string} имя провайдера из конфига
 * @returns {NFPostgresProvider}
 */
function prepareProvider(name) {
    // eslint-disable-next-line new-cap
    const _provider = new provider(common.getPath(config, `data_providers.${name}`));
    _provider.broker = broker.providerBroker;
    return _provider;
}

/**
 * Подготовка эмуляции сессионного контекста пользователя
 * @param cfg {string|Object} полный путь в конфиге до настроек тестового пользователя или сами настройки
 * @returns {ExecContext}
 */
function prepareContext(cfg) {
    let _config = cfg;
    if (typeof cfg === 'string') _config = common.getPath(config, cfg);
    const { user, password, org = 1, grp = 1, appuser } = _config;
    const session = new SessionAPI({});
    const _context = new ExecContext({ session });
    const dbContext = [
        { ctx: 'org', name: 'nf.org', prvType: 'db-postgres' },
        { ctx: 'appuser', name: 'nf.appuser', prvType: 'db-postgres' }
    ];
    const clientContext = { user, password, org, grp, appuser };
    _context.session.assign('context', clientContext);
    _context.session.assign('context.prv', dbContext);
    return _context;
}

/**
 * @param params {Object} параметры выполнения
 * @param {string} [params.configPath] - полный путь в конфиге до настроек тестового пользователя
 * @param {Object} [params.config] - настройки тестового пользователя
 * @param {string} [params.providerName] - имя провайдера из конфига
 * @param {boolean} [params.forceCredentials] - производить коннект к базе минуя настройки провайдера
 * @param {string} [params.connectPlace] - шаблон для формирования строки, определяющей место в коде приложения вызова соединения. Например '{applicationName} : importReg'
 * @returns {Promise<Env>}
 */
async function prepareEnv(params) {
    const _params = {
        configPath: 'test',
        providerName: 'default',
        ...params
    };
    const _provider = prepareProvider(_params.providerName);
    const _context = prepareContext(_params.config || _params.configPath);
    const env = new Env(_context, _params.providerName, _provider);
    await env.doConnect(_params);
    return env;
}

/**
 * Выполнение переданной функции в транзакции бд и откат этой транзакции по завершении выполнения
 * @param {Function} fn - функция, принимающая один параметр Env
 * @param {Object} params - параметры формирования тестового контекста выполнения
 * @return {Promise<void>}
 */
async function execFnEnv(fn, params) {
    const env = await prepareEnv(params);
    try {
        await env.connect.begin();
        await fn(env);
        await env.connect.rollback();
    } catch (e) {
        await env.connect.rollback();
        console.log(e);
        throw e;
    } finally {
        if (env.connect) env.connect.release();
    }
}

export {
    prepareProvider,
    prepareContext,
    prepareEnv,
    execFnEnv
};
