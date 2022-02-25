{
    "schema": "nfc",
    "tablename": "datatypes",
    "comment": "Типы данных для интерфейса",
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
            "column_id": 3
        },
        {
            "name": "id",
            "datatype": "int8",
            "datatype_length": null,
            "datatype_full": "bigint",
            "required": true,
            "default_value": null,
            "comment": "Id",
            "fk_tablename": null,
            "column_id": 1
        }
    ],
    "cons": [
        {
            "name": "ch4datatypes8caption",
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
            "name": "ch4datatypes8code",
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
            "name": "pk4datatypes",
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
            "name": "uk4datatypes8caption",
            "schema": "nfc",
            "type": "u",
            "update_rule": null,
            "delete_rule": null,
            "condition": null,
            "definition": "UNIQUE (caption)",
            "r_schema": null,
            "r_tablename": null,
            "r_columnname": null,
            "columns": "caption",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "uk4datatypes8code",
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