{
    "schema": "nfc",
    "tablename": "modulelist",
    "comment": null,
    "cols": [
        {
            "name": "caption",
            "datatype": "varchar",
            "datatype_length": "200",
            "datatype_full": "character varying(200)",
            "required": true,
            "default_value": null,
            "comment": null,
            "fk_tablename": null,
            "column_id": 2
        },
        {
            "name": "code",
            "datatype": "varchar",
            "datatype_length": "30",
            "datatype_full": "character varying(30)",
            "required": true,
            "default_value": null,
            "comment": null,
            "fk_tablename": null,
            "column_id": 1
        }
    ],
    "cons": [
        {
            "name": "ch4modulelist8trim",
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
            "name": "pk4modulelist",
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
            "name": "uk4modulelist8caption",
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
        }
    ],
    "indx": null
}