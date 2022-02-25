import { Model } from '../../../lib/model.js';

export class NfcRoleUnitbpprivsOrigin extends Model {
    constructor(values, options) {
        super();
        this._constructor(values, options);
    }

    static _def = {
        schema: 'nfc',
        table: 'role_unitbpprivs',
        view: 'v4role_unitbpprivs',
        pk: 'id'
    }

    /**
     * null
     * @type {number}
     */
    id;

    /**
     * Право на видимость
     * @type {number}
     */
    pid;

    /**
     * Действие в разделе
     * @type {string}
     */
    unitbp;

    static _schema = {
        type: 'object',
        properties: {
            id: { type: 'integer' },
            pid: { type: 'integer' },
            unitbp: { type: 'string', maxLength: 90 }
        },
        required: ['pid', 'unitbp'],
    }

    static _validationSchema = Model._validator.compile(NfcRoleUnitbpprivsOrigin._schema);
}
