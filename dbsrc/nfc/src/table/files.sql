{
    "schema": "nfc",
    "tablename": "files",
    "comment": "Файлы системы",
    "cols": [
        {
            "name": "destination",
            "datatype": "text",
            "datatype_length": null,
            "datatype_full": "text",
            "required": false,
            "default_value": null,
            "comment": "The folder to which the file has been saved",
            "fk_tablename": null,
            "column_id": 7
        },
        {
            "name": "encoding",
            "datatype": "varchar",
            "datatype_length": "32",
            "datatype_full": "character varying(32)",
            "required": false,
            "default_value": null,
            "comment": "Encoding type of the file",
            "fk_tablename": null,
            "column_id": 4
        },
        {
            "name": "filename",
            "datatype": "varchar",
            "datatype_length": "255",
            "datatype_full": "character varying(255)",
            "required": false,
            "default_value": null,
            "comment": "The name of the file within the destination",
            "fk_tablename": null,
            "column_id": 8
        },
        {
            "name": "filesize",
            "datatype": "int8",
            "datatype_length": null,
            "datatype_full": "bigint",
            "required": false,
            "default_value": null,
            "comment": "Size of the file in bytes",
            "fk_tablename": null,
            "column_id": 6
        },
        {
            "name": "id",
            "datatype": "int8",
            "datatype_length": null,
            "datatype_full": "bigint",
            "required": true,
            "default_value": "nextval('nfc.s4files'::text::regclass)",
            "comment": null,
            "fk_tablename": null,
            "column_id": 1
        },
        {
            "name": "mimetype",
            "datatype": "varchar",
            "datatype_length": "255",
            "datatype_full": "character varying(255)",
            "required": false,
            "default_value": null,
            "comment": "Mime type of the file",
            "fk_tablename": null,
            "column_id": 5
        },
        {
            "name": "org_id",
            "datatype": "int8",
            "datatype_length": null,
            "datatype_full": "bigint",
            "required": true,
            "default_value": null,
            "comment": "Организация, загрузившая файл",
            "fk_tablename": "nfc.org",
            "column_id": 2
        },
        {
            "name": "originalname",
            "datatype": "varchar",
            "datatype_length": "255",
            "datatype_full": "character varying(255)",
            "required": true,
            "default_value": null,
            "comment": "Name of the file on the users computer",
            "fk_tablename": null,
            "column_id": 3
        },
        {
            "name": "upload_date",
            "datatype": "timestamp",
            "datatype_length": null,
            "datatype_full": "timestamp without time zone",
            "required": true,
            "default_value": "now()",
            "comment": "Дата и время загрузки файла",
            "fk_tablename": null,
            "column_id": 9
        },
        {
            "name": "user_id",
            "datatype": "int8",
            "datatype_length": null,
            "datatype_full": "bigint",
            "required": false,
            "default_value": null,
            "comment": "Пользователь, загрузивший файл",
            "fk_tablename": "nfc.users",
            "column_id": 10
        }
    ],
    "cons": [
        {
            "name": "fk4files8org_id",
            "schema": "nfc",
            "type": "f",
            "update_rule": "a",
            "delete_rule": "a",
            "condition": null,
            "definition": "FOREIGN KEY (org_id) REFERENCES nfc.org(id)",
            "r_schema": "nfc",
            "r_tablename": "org",
            "r_columnname": "id",
            "columns": "org_id",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "fk4files8user_id",
            "schema": "nfc",
            "type": "f",
            "update_rule": "a",
            "delete_rule": "a",
            "condition": null,
            "definition": "FOREIGN KEY (user_id) REFERENCES nfc.users(id)",
            "r_schema": "nfc",
            "r_tablename": "users",
            "r_columnname": "id",
            "columns": "user_id",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "pk4files",
            "schema": "nfc",
            "type": "p",
            "update_rule": null,
            "delete_rule": null,
            "condition": null,
            "definition": "PRIMARY KEY (id)",
            "r_schema": null,
            "r_tablename": null,
            "r_columnname": null,
            "columns": "id",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "uk4files8filename",
            "schema": "nfc",
            "type": "u",
            "update_rule": null,
            "delete_rule": null,
            "condition": null,
            "definition": "UNIQUE (filename)",
            "r_schema": null,
            "r_tablename": null,
            "r_columnname": null,
            "columns": "filename",
            "comment": null,
            "deferrable": null
        }
    ],
    "indx": [
        {
            "name": "i4files8org_id",
            "schema": "nfc",
            "columns": [
                {
                    "name": "org_id",
                    "nulls": "last",
                    "order": "asc",
                    "collate": null
                }
            ],
            "is_unique": false,
            "method": "btree",
            "tablespace": null,
            "definition": "CREATE INDEX i4files8org_id ON nfc.files USING btree (org_id)"
        },
        {
            "name": "i4files8user_id",
            "schema": "nfc",
            "columns": [
                {
                    "name": "user_id",
                    "nulls": "last",
                    "order": "asc",
                    "collate": null
                }
            ],
            "is_unique": false,
            "method": "btree",
            "tablespace": null,
            "definition": "CREATE INDEX i4files8user_id ON nfc.files USING btree (user_id)"
        }
    ]
}