import { Model } from '../../../lib/model.js';

export class NfcRolesOrigin extends Model {
    constructor(values, options) {
        super();
        this._constructor(values, options);
    }

    static _def = {
        schema: 'nfc',
        table: 'roles',
        view: 'v4roles',
        pk: 'id'
    }

    /**
     * null
     * @type {number}
     */
    id;

    /**
     * Код
     * @type {string}
     */
    code;

    /**
     * Наименование
     * @type {string}
     */
    caption;

    static _schema = {
        type: 'object',
        properties: {
            id: { type: 'integer' },
            code: { type: 'string', maxLength: 60 },
            caption: { type: 'string', maxLength: 300 }
        },
        required: ['code', 'caption'],
    }

    static _validationSchema = Model._validator.compile(NfcRolesOrigin._schema);
}
