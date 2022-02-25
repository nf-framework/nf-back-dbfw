import { Model } from '../../../lib/model.js';

export class NfcUnitFileTypesOrigin extends Model {
    constructor(values, options) {
        super();
        this._constructor(values, options);
    }

    static _def = {
        schema: 'nfc',
        table: 'unit_file_types',
        view: 'v4unit_file_types',
        pk: 'id'
    }

    /**
     * null
     * @type {number}
     */
    id;

    /**
     * Раздел
     * @type {string}
     */
    unit;

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
            unit: { type: 'string' },
            code: { type: 'string', maxLength: 60 },
            caption: { type: 'string', maxLength: 300 }
        },
        required: ['unit', 'code', 'caption'],
    }

    static _validationSchema = Model._validator.compile(NfcUnitFileTypesOrigin._schema);
}
