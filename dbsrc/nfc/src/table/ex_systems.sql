{
    "schema": "nfc",
    "tablename": "ex_systems",
    "comment": "Внешние системы",
    "cols": [
        {
            "name": "any_options",
            "datatype": "jsonb",
            "datatype_length": null,
            "datatype_full": "jsonb",
            "required": false,
            "default_value": null,
            "comment": "Опции внешней системы",
            "fk_tablename": null,
            "column_id": 5
        },
        {
            "name": "caption",
            "datatype": "varchar",
            "datatype_length": "300",
            "datatype_full": "character varying(300)",
            "required": true,
            "default_value": null,
            "comment": "Наименование",
            "fk_tablename": null,
            "column_id": 3
        },
        {
            "name": "code",
            "datatype": "varchar",
            "datatype_length": "30",
            "datatype_full": "character varying(30)",
            "required": true,
            "default_value": null,
            "comment": "Код",
            "fk_tablename": null,
            "column_id": 2
        },
        {
            "name": "endpoint",
            "datatype": "text",
            "datatype_length": null,
            "datatype_full": "text",
            "required": false,
            "default_value": null,
            "comment": null,
            "fk_tablename": null,
            "column_id": 6
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
            "name": "is_stopped",
            "datatype": "bool",
            "datatype_length": null,
            "datatype_full": "boolean",
            "required": true,
            "default_value": null,
            "comment": "Внешняя система приостановлена",
            "fk_tablename": null,
            "column_id": 4
        }
    ],
    "cons": [
        {
            "name": "ch4ex_systems8caption",
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
            "name": "ch4ex_systems8code",
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
            "name": "pk4ex_systems",
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
            "name": "uk4ex_systems8code",
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
    "indx": null
}