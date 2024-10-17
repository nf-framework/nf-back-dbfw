import { getUnit, prepareSql } from "./broker.js";
import { dbapi } from "@nfjs/back";
import { debug } from "@nfjs/core";

export async function valuesHandler(context) {
    try {
        const { args } = context.req.body;
        const controller = new AbortController();
        const signal = controller.signal;
        context.res.on('close', () => {
            const { destroyed, writableEnded } = context.res;
            // weird aborted status clarification
            if (destroyed && !writableEnded) {
                controller.abort();
            }
        });
        const { code, fields, actualDate, control } = args;

        //this.dictionaryValues.control.sorts	= this.fields.filter(row=> row.sort).map(row=> ({field: row.field, sort: row.sort}));
        //this.dictionaryValues.control.filters = this.dictionaryValues.control.filters.concat(this.filters);

        const connect = await dbapi.getConnect(context);
        const unit = await getUnit(connect._connect, code);
        const sql = prepareSql(unit, 'find', {});
        const options = { signal };        
        const resp = await connect.query(sql.sql, sql._params, options, control);
        if (resp?.debug?.timing) {
            const tmng = debug.timingToHttpHeader(resp.debug.timing);
            context.headers({'Server-Timing': tmng });
        }
        context.send(resp, true);
    } catch(e) {
        console.error(e);
        context.code(500).end();
    }
}