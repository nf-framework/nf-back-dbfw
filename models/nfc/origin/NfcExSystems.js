import { Model } from '../../../lib/model.js';

export class NfcExSystemsOrigin extends Model {
    constructor(values, options) {
        super();
        this._constructor(values, options);
    }

    static _def = {
        schema: 'nfc',
        table: 'ex_systems',
        view: 'v4ex_systems',
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

    /**
     * Внешняя система приостановлена
     * @type {boolean}
     */
    is_stopped;

    /**
     * Опции внешней системы
     * @type {Object}
     */
    any_options;

    /**
     * null
     * @type {string}
     */
    endpoint;

    static _schema = {
        type: 'object',
        properties: {
            id: { type: 'integer' },
            code: { type: 'string', maxLength: 30 },
            caption: { type: 'string', maxLength: 300 },
            is_stopped: { type: 'boolean' },
            any_options: { type: ['object', 'null'] },
            endpoint: { type: ['string', 'null'] }
        },
        required: ['code', 'caption', 'is_stopped'],
    }

    static _validationSchema = Model._validator.compile(NfcExSystemsOrigin._schema);
}
