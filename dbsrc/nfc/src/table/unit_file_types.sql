{
    "schema": "nfc",
    "tablename": "unit_file_types",
    "comment": "Типы прикрепляемых документов по разделам",
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
            "column_id": 4
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
            "column_id": 3
        },
        {
            "name": "id",
            "datatype": "int8",
            "datatype_length": null,
            "datatype_full": "bigint",
            "required": true,
            "default_value": "nextval('nfc.s_main'::text::regclass)",
            "comment": null,
            "fk_tablename": null,
            "column_id": 1
        },
        {
            "name": "unit",
            "datatype": "varchar",
            "datatype_length": null,
            "datatype_full": "character varying",
            "required": true,
            "default_value": null,
            "comment": "Раздел",
            "fk_tablename": "nfc.unitlist",
            "column_id": 2
        }
    ],
    "cons": [
        {
            "name": "ch4unit_file_types8caption",
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
            "name": "ch4unit_file_types8code",
            "schema": "nfc",
            "type": "c",
            "update_rule": null,
            "delete_rule": null,
            "condition": "((code)::text = btrim((code)::text))",
            "definition": "CHECK (code::text = btrim(code::text))",
            "r_schema": null,
            "r_tablename": null,
            "r_columnname": null,
            "columns": "code",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "fk4unit_file_types8unit",
            "schema": "nfc",
            "type": "f",
            "update_rule": "a",
            "delete_rule": "c",
            "condition": null,
            "definition": "FOREIGN KEY (unit) REFERENCES nfc.unitlist(code) ON DELETE CASCADE",
            "r_schema": "nfc",
            "r_tablename": "unitlist",
            "r_columnname": "code",
            "columns": "unit",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "pk4unit_file_types",
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
        }
    ],
    "indx": [
        {
            "name": "i4unit_file_types8unit",
            "schema": "nfc",
            "columns": [
                {
                    "name": "unit",
                    "nulls": "last",
                    "order": "asc",
                    "collate": "pg_catalog.\"default\""
                },
                {
                    "name": "code",
                    "nulls": "last",
                    "order": "asc",
                    "collate": "pg_catalog.\"default\""
                }
            ],
            "is_unique": true,
            "method": "btree",
            "tablespace": null,
            "definition": "CREATE UNIQUE INDEX i4unit_file_types8unit ON nfc.unit_file_types USING btree (unit, code)"
        }
    ]
}