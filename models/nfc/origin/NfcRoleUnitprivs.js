import { Model } from '../../../lib/model.js';

export class NfcRoleUnitprivsOrigin extends Model {
    constructor(values, options) {
        super();
        this._constructor(values, options);
    }

    static _def = {
        schema: 'nfc',
        table: 'role_unitprivs',
        view: 'v4role_unitprivs',
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
     * Раздел
     * @type {string}
     */
    unit;

    static _schema = {
        type: 'object',
        properties: {
            id: { type: 'integer' },
            role_id: { type: ['integer', 'null'] },
            unit: { type: ['string', 'null'], maxLength: 60 }
        },
        required: [],
    }

    static _validationSchema = Model._validator.compile(NfcRoleUnitprivsOrigin._schema);
}
