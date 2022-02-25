import { Model } from '../../../lib/model.js';

export class NfcExSystemServicesOrigin extends Model {
    constructor(values, options) {
        super();
        this._constructor(values, options);
    }

    static _def = {
        schema: 'nfc',
        table: 'ex_system_services',
        view: 'v4ex_system_services',
        pk: 'id'
    }

    /**
     * null
     * @type {number}
     */
    id;

    /**
     * null
     * @type {number}
     */
    pid;

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
     * Сервис приостановлен
     * @type {boolean}
     */
    is_stopped;

    /**
     * URL - адрес сервиса
     * @type {string}
     */
    url;

    /**
     * Опции сервиса
     * @type {Object}
     */
    any_options;

    static _schema = {
        type: 'object',
        properties: {
            id: { type: 'integer' },
            pid: { type: 'integer' },
            code: { type: 'string', maxLength: 60 },
            caption: { type: 'string', maxLength: 300 },
            is_stopped: { type: 'boolean' },
            url: { type: ['string', 'null'] },
            any_options: { type: ['object', 'null'] }
        },
        required: ['pid', 'code', 'caption', 'is_stopped'],
    }

    static _validationSchema = Model._validator.compile(NfcExSystemServicesOrigin._schema);
}
