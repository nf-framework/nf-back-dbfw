import path, { join } from 'path';
import { writeFile, mkdir } from 'fs/promises';

import { dbsrc } from '@nfjs/back';

const capitalize = (s) => (s.split('_').map((w) => (w[0].toUpperCase() + w.slice(1))).join(''));
const dbTypesConvert = {
    int2: { jsonSchema: 'integer', jsDoc: 'number' },
    int4: { jsonSchema: 'integer', jsDoc: 'number' },
    int8: { jsonSchema: 'integer', jsDoc: 'number' },
    numeric: { jsonSchema: 'number', jsDoc: 'number' },
    float4: { jsonSchema: 'number', jsDoc: 'number' },
    float8: { jsonSchema: 'number', jsDoc: 'number' },
    bool: { jsonSchema: 'boolean', jsDoc: 'boolean' },
    date: { jsonSchema: 'date', jsDoc: 'Date' },
    timestamp: { jsonSchema: 'date-time', jsDoc: 'Date' },
    timestamptz: { jsonSchema: 'date-time', jsDoc: 'Date' },
    json: { jsonSchema: 'object', jsDoc: 'Object' },
    jsonb: { jsonSchema: 'object', jsDoc: 'Object' },
};

async function script(unit) {
    const [schema, tableName] = unit.split('.');
    const table = await dbsrc.getTable(schema, tableName);
    const pk = (table.cons.find((con) => con.type === 'p'))?.columns || 'id';
    const properties = table.cols
        .sort((a, b) => a.column_id - b.column_id)
        .map((col) => `
    /**
     * ${col.comment}
     * @type {${dbTypesConvert[col.datatype]?.jsDoc ?? 'string'}}
     */
    ${col.name};`).join('\n');
    const jsonSchema = {
        type: 'object',
        description: table.comment,
        properties: {},
        required: []
    };
    table.cols.forEach((col) => {
        const clm = {
            type: dbTypesConvert[col.datatype]?.jsonSchema ?? 'string',
        };
        if (clm.type === 'date' || clm.type === 'date-time') {
            clm.format = clm.type;
            clm.type = 'string';
        }
        if (col.datatype_length) clm.maxLength = Number(col.datatype_length);
        if (!col.required) {
            clm.type = [clm.type, 'null'];
        } else if (col.name !== pk) jsonSchema.required.push(col.name);
        jsonSchema.properties[col.name] = clm;
    });
    const jsSchProps = Object.entries(jsonSchema.properties).map((p) => {
        let pr = `${p[0]}: { `;
        if (Array.isArray(p[1].type)) {
            pr += `type: [${p[1].type.map((t) => `'${t}'`).join(', ')}]`;
        } else {
            pr += `type: '${p[1].type}'`;
        }
        if (p[1].format) pr += `, format: '${p[1].format}'`;
        if (p[1].maxLength) pr += `, maxLength: ${p[1].maxLength}`;
        pr += ' }';
        return pr;
    }).join(',\n            ');
    const jsSchText = `
        type: '${jsonSchema.type}',
        properties: {
            ${jsSchProps}
        },
        required: [${jsonSchema.required.map((e) => `'${e}'`).join(', ')}],
    `;
    const s = `import { Model } from '@nfjs/back-dbfw';

export class ${capitalize(schema)}${capitalize(tableName)}Origin extends Model {
    constructor(values, options) {
        super();
        this._constructor(values, options);
    }

    static _def = {
        schema: '${schema}',
        table: '${tableName}',
        view: 'v4${tableName}',
        pk: '${pk}'
    }
${properties}

    static _schema = {${jsSchText}}

    static _validationSchema = Model._validator.compile(${capitalize(schema)}${capitalize(tableName)}Origin._schema);
}
`;
    return s;
}

async function gen(unit) {
    const [schema, tableName] = unit.split('.');
    const content = await script(unit);
    const mdl = await dbsrc.getSchemaModule(schema);
    let pth = `${process.cwd().replace(/\\/g, '/')}/node_modules/`;
    pth = path.join(pth, mdl, 'models', schema, 'origin');
    try {
        await mkdir(pth, { recursive: true });
    } catch (e) {
        if (!(e.code === 'EEXIST')) throw (e);
    }
    await writeFile(join(pth, `${capitalize(schema)}${capitalize(tableName)}.js`), content);
}

export { script, gen };
