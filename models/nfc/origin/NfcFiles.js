import { Model } from '../../../lib/model.js';

export class NfcFilesOrigin extends Model {
    constructor(values, options) {
        super();
        this._constructor(values, options);
    }

    static _def = {
        schema: 'nfc',
        table: 'files',
        view: 'v4files',
        pk: 'id'
    }

    /**
     * null
     * @type {number}
     */
    id;

    /**
     * Организация, загрузившая файл
     * @type {number}
     */
    org_id;

    /**
     * Name of the file on the users computer
     * @type {string}
     */
    originalname;

    /**
     * Encoding type of the file
     * @type {string}
     */
    encoding;

    /**
     * Mime type of the file
     * @type {string}
     */
    mimetype;

    /**
     * Size of the file in bytes
     * @type {number}
     */
    filesize;

    /**
     * The folder to which the file has been saved
     * @type {string}
     */
    destination;

    /**
     * The name of the file within the destination
     * @type {string}
     */
    filename;

    /**
     * Дата и время загрузки файла
     * @type {Date}
     */
    upload_date;

    /**
     * Пользователь, загрузивший файл
     * @type {number}
     */
    user_id;

    static _schema = {
        type: 'object',
        properties: {
            id: { type: 'integer' },
            org_id: { type: 'integer' },
            originalname: { type: 'string', maxLength: 255 },
            encoding: { type: ['string', 'null'], maxLength: 32 },
            mimetype: { type: ['string', 'null'], maxLength: 255 },
            filesize: { type: ['integer', 'null'] },
            destination: { type: ['string', 'null'] },
            filename: { type: ['string', 'null'], maxLength: 255 },
            upload_date: { type: 'string', format: 'date-time' },
            user_id: { type: ['integer', 'null'] }
        },
        required: ['org_id', 'originalname', 'upload_date'],
    }

    static _validationSchema = Model._validator.compile(NfcFilesOrigin._schema);
}
