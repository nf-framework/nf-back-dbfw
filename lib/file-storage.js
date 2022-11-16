import { dbapi } from "@nfjs/back";
import { api } from "@nfjs/core";
import crypto from "crypto";
import fs from 'fs';
import path from "path";

export async function upload(context) {
    try {
        const raw = crypto.pseudoRandomBytes(16);
        const hex = raw.toString('hex');
        const destination = `uploads/${hex.substr(0, 2)}/${hex.substr(2, 2)}/`;
        const saveTo = path.join(process.cwd(), `${destination}/${context.fileInfo.fileName}`);

        await fs.promises.mkdir(destination, { recursive: true });

        context.fileInfo.fileStream.pipe(fs.createWriteStream(saveTo));

        let { data } = await dbapi.broker('nfc.files.add',
            {
                org_id: context.session.get('context.org'),
                originalname: context.fileInfo.fileName,
                encoding: context.fileInfo.encoding,
                mimetype: context.fileInfo.mimetype,
                filesize: context.req.headers['content-length'],
                destination: saveTo,
                filename: hex,
                user_id: context.session.get('context.user_id'),
            }, { context: context }
        );

        context.send(JSON.stringify({
            id: data.id,
            filename: hex
        }));
    }
    catch (error) {
        const err = api.nfError(error, error.message);
        context.send(err.json());
    }
}

export async function download(context) {
    try {
        let { data } = await dbapi.query(
            'select * from nfc.v4files t where t.filename = :filename',
            { filename: context.params.fileName },
            { context: context, returnFirst: true }
        );

        if (data) {
            if (data.mimetype) {
                context.type('Content-Type', data.mimetype);
            }
            const headers = {
                'Content-Disposition': `attachment; filename=${encodeURIComponent(data.originalname)}`,
                'Content-Transfer-Encoding': 'binary'
            }

            await fs.promises.stat(data.destination);
            const rs = fs.createReadStream(data.destination);
            context.headers(headers);
            context.send(rs);        
        }
    } catch (error) {
        context.code(404);
        const err = api.nfError(error, error.message);
        context.send(err.json());
    }
}