{
    "schema": "nfc",
    "tablename": "unitlist",
    "comment": "Разделы системы",
    "cols": [
        {
            "name": "caption",
            "datatype": "varchar",
            "datatype_length": "200",
            "datatype_full": "character varying(200)",
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
            "comment": "Уникальный код сущности",
            "fk_tablename": null,
            "column_id": 1
        },
        {
            "name": "mdl",
            "datatype": "varchar",
            "datatype_length": "30",
            "datatype_full": "character varying(30)",
            "required": true,
            "default_value": null,
            "comment": "Модуль системы",
            "fk_tablename": "nfc.modulelist",
            "column_id": 4
        },
        {
            "name": "opt",
            "datatype": "jsonb",
            "datatype_length": null,
            "datatype_full": "jsonb",
            "required": false,
            "default_value": null,
            "comment": "Настройки",
            "fk_tablename": null,
            "column_id": 5
        },
        {
            "name": "pcode",
            "datatype": "varchar",
            "datatype_length": "60",
            "datatype_full": "character varying(60)",
            "required": false,
            "default_value": null,
            "comment": "Код родительской сущности",
            "fk_tablename": "nfc.unitlist",
            "column_id": 3
        }
    ],
    "cons": [
        {
            "name": "ch4unitlist8code",
            "schema": "nfc",
            "type": "c",
            "update_rule": null,
            "delete_rule": null,
            "condition": "(NOT ((code)::text ~ '[^a-z_.0-9]'::text))",
            "definition": "CHECK (NOT code::text ~ '[^a-z_.0-9]'::text)",
            "r_schema": null,
            "r_tablename": null,
            "r_columnname": null,
            "columns": "code",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "ch4unitlist8trim",
            "schema": "nfc",
            "type": "c",
            "update_rule": null,
            "delete_rule": null,
            "condition": "(((code)::text = btrim(lower((code)::text))) AND ((caption)::text = btrim((caption)::text)))",
            "definition": "CHECK (code::text = btrim(lower(code::text)) AND caption::text = btrim(caption::text))",
            "r_schema": null,
            "r_tablename": null,
            "r_columnname": null,
            "columns": "code,caption",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "fk4unitlist8mdl",
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
            "name": "fk4unitlist8pcode",
            "schema": "nfc",
            "type": "f",
            "update_rule": "c",
            "delete_rule": "a",
            "condition": null,
            "definition": "FOREIGN KEY (pcode) REFERENCES nfc.unitlist(code) ON UPDATE CASCADE DEFERRABLE INITIALLY DEFERRED",
            "r_schema": "nfc",
            "r_tablename": "unitlist",
            "r_columnname": "code",
            "columns": "pcode",
            "comment": null,
            "deferrable": "deferred"
        },
        {
            "name": "pk4unitlist",
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
            "name": "uk4unitlist8caption",
            "schema": "nfc",
            "type": "u",
            "update_rule": null,
            "delete_rule": null,
            "condition": null,
            "definition": "UNIQUE (mdl, caption)",
            "r_schema": null,
            "r_tablename": null,
            "r_columnname": null,
            "columns": "mdl,caption",
            "comment": null,
            "deferrable": null
        }
    ],
    "indx": [
        {
            "name": "i4unitlist8pcode",
            "schema": "nfc",
            "columns": [
                {
                    "name": "pcode",
                    "nulls": "last",
                    "order": "asc",
                    "collate": "pg_catalog.\"default\""
                }
            ],
            "is_unique": false,
            "method": "btree",
            "tablespace": null,
            "definition": "CREATE INDEX i4unitlist8pcode ON nfc.unitlist USING btree (pcode)"
        }
    ]
}