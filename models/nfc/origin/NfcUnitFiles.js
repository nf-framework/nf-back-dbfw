import { Model } from '../../../lib/model.js';

export class NfcUnitFilesOrigin extends Model {
    constructor(values, options) {
        super();
        this._constructor(values, options);
    }

    static _def = {
        schema: 'nfc',
        table: 'unit_files',
        view: 'v4unit_files',
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
     * Идентификатор записи в разделе
     * @type {number}
     */
    unit_id;

    /**
     * Тип документа
     * @type {number}
     */
    uf_type;

    /**
     * Файл
     * @type {number}
     */
    file_id;

    static _schema = {
        type: 'object',
        properties: {
            id: { type: 'integer' },
            unit: { type: 'string' },
            unit_id: { type: 'integer' },
            uf_type: { type: ['integer', 'null'] },
            file_id: { type: 'integer' }
        },
        required: ['unit', 'unit_id', 'file_id'],
    }

    static _validationSchema = Model._validator.compile(NfcUnitFilesOrigin._schema);
}
