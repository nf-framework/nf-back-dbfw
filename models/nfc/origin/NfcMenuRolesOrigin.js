import { Model } from '../../../lib/model.js';

export class NfcMenuRolesOrigin extends Model {
    constructor(values, options) {
        super();
        this._constructor(values, options);
    }

    static _def = {
        schema: 'nfc',
        table: 'menuroles',
        view: 'v4menuroles',
        pk: 'id'
    }

    /**
     * null
     * @type {number}
     */
    id;

    /**
     * Роль
     * @type {number}
     */
    role_id;

    /**
     * Раздел меню
     * @type {string}
     */
    menuguid;

    static _schema = {
        type: 'object',
        properties: {
            id: { type: 'integer' },
            role_id: { type: 'integer' },
            menuguid: { type: 'string', maxLength: 60 }
        },
        required: [],
    }

    static _validationSchema = Model._validator.compile(NfcMenuRolesOrigin._schema);
}
