import path from 'path';
import { api } from "@nfjs/core";
import { dataProviders, web } from "@nfjs/back";
import { authProviders } from "@nfjs/auth";

import { AuthProvider, loginOpenId } from "./lib/auth-provider.js";
import * as rolesEi from "./lib/roles/ei.js";
import { providerBroker } from './lib/broker.js';
import { getMenu, getFullMenu } from "./lib/menu.js";
import * as customizations from "./lib/customizations.js";
import { download, upload } from './lib/file-storage.js';

const meta = {
    require: {
        after: '@nfjs/db-postgres',
    }
};

const __dirname = path.join(path.dirname(decodeURI(new URL(import.meta.url).pathname))).replace(/^\\([A-Z]:\\)/, "$1");
let msgs = await api.loadJSON(__dirname + '/msgs.json');

async function init() {
    // Регистрация метода broker в провайдеры данных типа db-postgres
    Object.keys(dataProviders).forEach((providerName) => {
        const provider = dataProviders[providerName];
        if (provider.config.type === 'db-postgres') {
            provider.broker = providerBroker;
        }
    });
    // экспорт, импорт настроек ролей
    web.on('GET', '/@nfjs/back-dbfw/api/roles/exportRoleUnitPrivs', { middleware: ['session', 'query'] }, rolesEi.exportRoleUnitPrivs);
    web.on('POST', '/@nfjs/back-dbfw/api/roles/importRoleUnitPrivs/upload', { middleware: ['files', 'session'] }, rolesEi.importRoleUnitPrivs)

    authProviders['fw'] = new AuthProvider();

    // Регистрация обновления информации о пользователе при режиме подключения через openId
    api.addHook('authOpenId', loginOpenId);

    web.on('GET', '/nf-customizations/get', { middleware: ['session', 'query'], override: true }, customizations.get);
    web.on('POST', '/nf-customizations/set', { middleware: ['session', 'json'], override: true }, customizations.set);

    web.on('POST', '/front/action/getMenu', { middleware: ['session'], override: true }, getMenu);
    web.on('POST', '/front/action/getFullMenu', { middleware: ['session'], override: true }, getFullMenu);

    web.on('POST', '/@nfjs/upload', { middleware: ['session', 'auth', 'files'] }, upload);
    web.on('GET', '/@nfjs/download/:fileName', { middleware: ['session', 'auth'] }, download);
}

export {
    meta,
    init,
    msgs,
};
