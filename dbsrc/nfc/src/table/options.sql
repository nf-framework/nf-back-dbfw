{
    "schema": "nfc",
    "tablename": "options",
    "comment": "Системные опции",
    "cols": [
        {
            "name": "caption",
            "datatype": "varchar",
            "datatype_length": "300",
            "datatype_full": "character varying(300)",
            "required": true,
            "default_value": null,
            "comment": "Наименование",
            "fk_tablename": null,
            "column_id": 2
        },
        {
            "name": "code",
            "datatype": "varchar",
            "datatype_length": "60",
            "datatype_full": "character varying(60)",
            "required": true,
            "default_value": null,
            "comment": "Код",
            "fk_tablename": null,
            "column_id": 1
        },
        {
            "name": "datatype",
            "datatype": "int8",
            "datatype_length": null,
            "datatype_full": "bigint",
            "required": true,
            "default_value": null,
            "comment": "Тип данных",
            "fk_tablename": "nfc.datatypes",
            "column_id": 4
        },
        {
            "name": "mdl",
            "datatype": "varchar",
            "datatype_length": "30",
            "datatype_full": "character varying(30)",
            "required": true,
            "default_value": null,
            "comment": "Модуль",
            "fk_tablename": "nfc.modulelist",
            "column_id": 7
        },
        {
            "name": "multi_val",
            "datatype": "bool",
            "datatype_length": null,
            "datatype_full": "boolean",
            "required": true,
            "default_value": null,
            "comment": "Возможность указания множества значений. В таком случае сохраняться будет в виде массива",
            "fk_tablename": null,
            "column_id": 8
        },
        {
            "name": "note",
            "datatype": "text",
            "datatype_length": null,
            "datatype_full": "text",
            "required": false,
            "default_value": null,
            "comment": "Примечание",
            "fk_tablename": null,
            "column_id": 3
        },
        {
            "name": "val",
            "datatype": "text",
            "datatype_length": null,
            "datatype_full": "text",
            "required": false,
            "default_value": null,
            "comment": "Значение",
            "fk_tablename": null,
            "column_id": 5
        },
        {
            "name": "val_limits",
            "datatype": "jsonb",
            "datatype_length": null,
            "datatype_full": "jsonb",
            "required": false,
            "default_value": null,
            "comment": "Ограничения для значения",
            "fk_tablename": null,
            "column_id": 6
        }
    ],
    "cons": [
        {
            "name": "ch4options8caption",
            "schema": "nfc",
            "type": "c",
            "update_rule": null,
            "delete_rule": null,
            "condition": "((caption)::text = btrim((caption)::text))",
            "definition": "CHECK (caption::text = btrim(caption::text))",
            "r_schema": null,
            "r_tablename": null,
            "r_columnname": null,
            "columns": "caption",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "ch4options8code",
            "schema": "nfc",
            "type": "c",
            "update_rule": null,
            "delete_rule": null,
            "condition": "(((code)::text = btrim((code)::text)) AND ((code)::text ~ '^[0-9a-zA-Z._]+$'::text))",
            "definition": "CHECK (code::text = btrim(code::text) AND code::text ~ '^[0-9a-zA-Z._]+$'::text)",
            "r_schema": null,
            "r_tablename": null,
            "r_columnname": null,
            "columns": "code",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "fk4options8datatype",
            "schema": "nfc",
            "type": "f",
            "update_rule": "a",
            "delete_rule": "a",
            "condition": null,
            "definition": "FOREIGN KEY (datatype) REFERENCES nfc.datatypes(id)",
            "r_schema": "nfc",
            "r_tablename": "datatypes",
            "r_columnname": "id",
            "columns": "datatype",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "fk4options8mdl",
            "schema": "nfc",
            "type": "f",
            "update_rule": "a",
            "delete_rule": "a",
            "condition": null,
            "definition": "FOREIGN KEY (mdl) REFERENCES nfc.modulelist(code)",
            "r_schema": "nfc",
            "r_tablename": "modulelist",
            "r_columnname": "code",
            "columns": "mdl",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "pk4options",
            "schema": "nfc",
            "type": "p",
            "update_rule": null,
            "delete_rule": null,
            "condition": null,
            "definition": "PRIMARY KEY (code)",
            "r_schema": null,
            "r_tablename": null,
            "r_columnname": null,
            "columns": "code",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "uk4options8code",
            "schema": "nfc",
            "type": "u",
            "update_rule": null,
            "delete_rule": null,
            "condition": null,
            "definition": "UNIQUE (code)",
            "r_schema": null,
            "r_tablename": null,
            "r_columnname": null,
            "columns": "code",
            "comment": null,
            "deferrable": null
        }
    ],
    "indx": [
        {
            "name": "i4options8datatype",
            "schema": "nfc",
            "columns": [
                {
                    "name": "datatype",
                    "nulls": "last",
                    "order": "asc",
                    "collate": null
                }
            ],
            "is_unique": false,
            "method": "btree",
            "tablespace": null,
            "definition": "CREATE INDEX i4options8datatype ON nfc.options USING btree (datatype)"
        },
        {
            "name": "i4options8mdl",
            "schema": "nfc",
            "columns": [
                {
                    "name": "mdl",
                    "nulls": "last",
                    "order": "asc",
                    "collate": "pg_catalog.\"default\""
                }
            ],
            "is_unique": false,
            "method": "btree",
            "tablespace": null,
            "definition": "CREATE INDEX i4options8mdl ON nfc.options USING btree (mdl)"
        }
    ]
}