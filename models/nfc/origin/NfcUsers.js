import { Model } from '../../../lib/model.js';

export class NfcUsersOrigin extends Model {
    constructor(values, options) {
        super();
        this._constructor(values, options);
    }

    static _def = {
        schema: 'nfc',
        table: 'users',
        view: 'v4users',
        pk: 'id'
    }

    /**
     * null
     * @type {number}
     */
    id;

    /**
     * Имя пользователя
     * @type {string}
     */
    username;

    /**
     * Полное имя пользователя
     * @type {string}
     */
    fullname;

    /**
     * Дополнительная информация
     * @type {Object}
     */
    extra;

    static _schema = {
        type: 'object',
        properties: {
            id: { type: 'integer' },
            username: { type: 'string', maxLength: 60 },
            fullname: { type: 'string', maxLength: 300 },
            extra: { type: ['object', 'null'] }
        },
        required: ['username', 'fullname'],
    }

    static _validationSchema = Model._validator.compile(NfcUsersOrigin._schema);
}
