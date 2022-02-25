{
    "schema": "nfc",
    "tablename": "grp",
    "comment": null,
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
            "datatype_length": "60",
            "datatype_full": "character varying(60)",
            "required": true,
            "default_value": null,
            "comment": "Код",
            "fk_tablename": null,
            "column_id": 2
        },
        {
            "name": "id",
            "datatype": "int8",
            "datatype_length": null,
            "datatype_full": "bigint",
            "required": true,
            "default_value": "nextval('nfc.s4grp'::text::regclass)",
            "comment": "Id",
            "fk_tablename": null,
            "column_id": 1
        }
    ],
    "cons": [
        {
            "name": "ch4grp8trim",
            "schema": "nfc",
            "type": "c",
            "update_rule": null,
            "delete_rule": null,
            "condition": "(((code)::text = btrim((code)::text)) AND ((caption)::text = btrim((caption)::text)))",
            "definition": "CHECK (code::text = btrim(code::text) AND caption::text = btrim(caption::text))",
            "r_schema": null,
            "r_tablename": null,
            "r_columnname": null,
            "columns": "code,caption",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "pk4grp",
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
            "name": "uk4grp8caption",
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
            "name": "uk4grp8code",
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