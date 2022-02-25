import { extension } from '@nfjs/core';
import { dbapi } from '@nfjs/back';

/**
 * Отдача на клиент полного дерева главного меню
 *
 * @param {RequestContext} context - контекст выполнения запроса от пользователя
 * @return {Promise<void>}
 */
async function getFullMenu(context) {
    context.send({
        data: extension.menuInfo
    });
}

/**
 * Отдача на клиент полного дерева доступного пользователю главного меню
 *
 * @param {RequestContext} context - контекст выполнения запроса от пользователя
 * @return {Promise<void>}
 */
async function getMenu(context) {
    const menuForShow = [];
    const menu = extension.menuInfo;
    const permissionListRequest = await dbapi.query('select distinct(menuguid) from nfc.v4menu8session', {}, { context: context });
    const permissionList = permissionListRequest.data;
    if (permissionList.length > 0) {
        menu.filter((menuitem) => {
            permissionList.filter((menuPermItem) => {
                if (menuitem.guid === menuPermItem.menuguid) {
                    menuForShow.push(menuitem);
                }
            });
        });
    }

    const fillParents = function (allMenuList, currentMenuList, currentMenuItem) {
        const parent = allMenuList.find((item) => item.id === currentMenuItem.pid);

        if (!!parent && !currentMenuList.includes(parent)) {
            currentMenuList.push(parent);
            fillParents(allMenuList, currentMenuList, parent);
        }
    };

    menuForShow.forEach((item, index, arr) => {
        fillParents(menu, arr, item);
    });

    context.send({
        data: menuForShow.sort((a, b) => a.id - b.id)
    });
}

export {
    getMenu,
    getFullMenu
};
