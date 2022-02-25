{
    "schema": "nfc",
    "tablename": "options_values",
    "comment": "Системные опции : Переназначения",
    "cols": [
        {
            "name": "date_begin",
            "datatype": "date",
            "datatype_length": null,
            "datatype_full": "date",
            "required": true,
            "default_value": "now()::date",
            "comment": "Дата начала",
            "fk_tablename": null,
            "column_id": 6
        },
        {
            "name": "date_end",
            "datatype": "date",
            "datatype_length": null,
            "datatype_full": "date",
            "required": false,
            "default_value": null,
            "comment": "Дата окончания",
            "fk_tablename": null,
            "column_id": 7
        },
        {
            "name": "id",
            "datatype": "int8",
            "datatype_length": null,
            "datatype_full": "bigint",
            "required": true,
            "default_value": "nextval('nfc.s_main'::text::regclass)",
            "comment": "Id",
            "fk_tablename": null,
            "column_id": 2
        },
        {
            "name": "option",
            "datatype": "varchar",
            "datatype_length": null,
            "datatype_full": "character varying",
            "required": true,
            "default_value": null,
            "comment": "Системная опция",
            "fk_tablename": "nfc.options",
            "column_id": 1
        },
        {
            "name": "org_id",
            "datatype": "int8",
            "datatype_length": null,
            "datatype_full": "bigint",
            "required": false,
            "default_value": null,
            "comment": "Организация",
            "fk_tablename": "nfc.org",
            "column_id": 4
        },
        {
            "name": "user_id",
            "datatype": "int8",
            "datatype_length": null,
            "datatype_full": "bigint",
            "required": false,
            "default_value": null,
            "comment": "Пользователь",
            "fk_tablename": "nfc.users",
            "column_id": 5
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
            "column_id": 3
        }
    ],
    "cons": [
        {
            "name": "ch4options_values8begin_end",
            "schema": "nfc",
            "type": "c",
            "update_rule": null,
            "delete_rule": null,
            "condition": "((date_begin <= date_end) OR (date_end IS NULL))",
            "definition": "CHECK (date_begin <= date_end OR date_end IS NULL)",
            "r_schema": null,
            "r_tablename": null,
            "r_columnname": null,
            "columns": "date_begin,date_end",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "fk4options_values8org_id",
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
            "name": "fk4options_values8pid",
            "schema": "nfc",
            "type": "f",
            "update_rule": "a",
            "delete_rule": "a",
            "condition": null,
            "definition": "FOREIGN KEY (option) REFERENCES nfc.options(code)",
            "r_schema": "nfc",
            "r_tablename": "options",
            "r_columnname": "code",
            "columns": "option",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "fk4options_values8user_id",
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
            "name": "pk4options_values",
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
            "name": "uk4options_values8dates",
            "schema": "nfc",
            "type": "x",
            "update_rule": null,
            "delete_rule": null,
            "condition": null,
            "definition": "EXCLUDE USING gist (option WITH =, COALESCE(org_id, '-1'::integer::bigint) WITH =, COALESCE(user_id, '-1'::integer::bigint) WITH =, daterange(date_begin, date_end, '[]'::text) WITH &&)",
            "r_schema": null,
            "r_tablename": null,
            "r_columnname": null,
            "columns": "option",
            "comment": null,
            "deferrable": null
        }
    ],
    "indx": [
        {
            "name": "i4options_values8org_id",
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
            "definition": "CREATE INDEX i4options_values8org_id ON nfc.options_values USING btree (org_id)"
        },
        {
            "name": "i4options_values8pid",
            "schema": "nfc",
            "columns": [
                {
                    "name": "option",
                    "nulls": "last",
                    "order": "asc",
                    "collate": "pg_catalog.\"default\""
                }
            ],
            "is_unique": false,
            "method": "btree",
            "tablespace": null,
            "definition": "CREATE INDEX i4options_values8pid ON nfc.options_values USING btree (option)"
        },
        {
            "name": "i4options_values8user_id",
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
            "definition": "CREATE INDEX i4options_values8user_id ON nfc.options_values USING btree (user_id)"
        }
    ]
}