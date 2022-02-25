import { Model } from '../../../lib/model.js';

export class NfcExSystemMappingOrigin extends Model {
    constructor(values, options) {
        super();
        this._constructor(values, options);
    }

    static _def = {
        schema: 'nfc',
        table: 'ex_system_mapping',
        view: 'v4ex_system_mapping',
        pk: 'id'
    }

    /**
     * null
     * @type {number}
     */
    pid;

    /**
     * null
     * @type {number}
     */
    id;

    /**
     * Пространство имен внутри системы
     * @type {string}
     */
    in_namespace;

    /**
     * Идентификатор внутри системы
     * @type {string}
     */
    in_id;

    /**
     * Пространство имен из внешней системы
     * @type {string}
     */
    ex_namespace;

    /**
     * Идентификатор во внешней системе
     * @type {string}
     */
    ex_id;

    static _schema = {
        type: 'object',
        properties: {
            pid: { type: 'integer' },
            id: { type: 'integer' },
            in_namespace: { type: 'string' },
            in_id: { type: 'string' },
            ex_namespace: { type: 'string' },
            ex_id: { type: 'string' }
        },
        required: ['pid', 'in_namespace', 'in_id', 'ex_namespace', 'ex_id'],
    }

    static _validationSchema = Model._validator.compile(NfcExSystemMappingOrigin._schema);
}
