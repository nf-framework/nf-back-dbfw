{
    "schema": "nfc",
    "tablename": "unitbps",
    "comment": "Разделы системы : Действия",
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
            "column_id": 3
        },
        {
            "name": "code",
            "datatype": "varchar",
            "datatype_length": "90",
            "datatype_full": "character varying(90)",
            "required": true,
            "default_value": null,
            "comment": "Код",
            "fk_tablename": null,
            "column_id": 1
        },
        {
            "name": "exec_function",
            "datatype": "varchar",
            "datatype_length": "90",
            "datatype_full": "character varying(90)",
            "required": false,
            "default_value": null,
            "comment": "Выполняемая хранимая функция субд",
            "fk_tablename": null,
            "column_id": 4
        },
        {
            "name": "unit",
            "datatype": "varchar",
            "datatype_length": "60",
            "datatype_full": "character varying(60)",
            "required": true,
            "default_value": null,
            "comment": "Раздел системы",
            "fk_tablename": "nfc.unitlist",
            "column_id": 2
        },
        {
            "name": "use_privs",
            "datatype": "bool",
            "datatype_length": null,
            "datatype_full": "boolean",
            "required": false,
            "default_value": null,
            "comment": "Использовать права при выполнении",
            "fk_tablename": null,
            "column_id": 5
        }
    ],
    "cons": [
        {
            "name": "ch4unitbps8code",
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
            "name": "ch4unitbps8trim",
            "schema": "nfc",
            "type": "c",
            "update_rule": null,
            "delete_rule": null,
            "condition": "(((code)::text = btrim(lower((code)::text))) AND ((caption)::text = btrim((caption)::text)) AND ((exec_function)::text = btrim((exec_function)::text)))",
            "definition": "CHECK (code::text = btrim(lower(code::text)) AND caption::text = btrim(caption::text) AND exec_function::text = btrim(exec_function::text))",
            "r_schema": null,
            "r_tablename": null,
            "r_columnname": null,
            "columns": "code,caption,exec_function",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "fk4unitbps8unit",
            "schema": "nfc",
            "type": "f",
            "update_rule": "c",
            "delete_rule": "c",
            "condition": null,
            "definition": "FOREIGN KEY (unit) REFERENCES nfc.unitlist(code) ON UPDATE CASCADE ON DELETE CASCADE",
            "r_schema": "nfc",
            "r_tablename": "unitlist",
            "r_columnname": "code",
            "columns": "unit",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "pk4unitbps",
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
            "name": "uk4unitbps8caption",
            "schema": "nfc",
            "type": "u",
            "update_rule": null,
            "delete_rule": null,
            "condition": null,
            "definition": "UNIQUE (unit, caption)",
            "r_schema": null,
            "r_tablename": null,
            "r_columnname": null,
            "columns": "unit,caption",
            "comment": null,
            "deferrable": null
        }
    ],
    "indx": [
        {
            "name": "i4unitbps8unit",
            "schema": "nfc",
            "columns": [
                {
                    "name": "unit",
                    "nulls": "last",
                    "order": "asc",
                    "collate": "pg_catalog.\"default\""
                }
            ],
            "is_unique": false,
            "method": "btree",
            "tablespace": null,
            "definition": "CREATE INDEX i4unitbps8unit ON nfc.unitbps USING btree (unit)"
        }
    ]
}