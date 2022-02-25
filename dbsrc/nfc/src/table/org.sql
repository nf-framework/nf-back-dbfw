{
    "schema": "nfc",
    "tablename": "org",
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
            "name": "grp_id",
            "datatype": "int8",
            "datatype_length": null,
            "datatype_full": "bigint",
            "required": true,
            "default_value": null,
            "comment": "Группа организаций",
            "fk_tablename": "nfc.grp",
            "column_id": 4
        },
        {
            "name": "id",
            "datatype": "int8",
            "datatype_length": null,
            "datatype_full": "bigint",
            "required": true,
            "default_value": "nextval('nfc.s4org'::text::regclass)",
            "comment": "Id",
            "fk_tablename": null,
            "column_id": 1
        },
        {
            "name": "userforms",
            "datatype": "varchar",
            "datatype_length": "60",
            "datatype_full": "character varying(60)",
            "required": false,
            "default_value": null,
            "comment": "Каталог пользовательских форм",
            "fk_tablename": null,
            "column_id": 5
        }
    ],
    "cons": [
        {
            "name": "ch4org8trim",
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
            "name": "fk4org8grp_id",
            "schema": "nfc",
            "type": "f",
            "update_rule": "a",
            "delete_rule": "a",
            "condition": null,
            "definition": "FOREIGN KEY (grp_id) REFERENCES nfc.grp(id)",
            "r_schema": "nfc",
            "r_tablename": "grp",
            "r_columnname": "id",
            "columns": "grp_id",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "pk4org",
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
            "name": "uk4org8caption",
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
            "name": "uk4org8code",
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
            "name": "i4org8grp_id",
            "schema": "nfc",
            "columns": [
                {
                    "name": "grp_id",
                    "nulls": "last",
                    "order": "asc",
                    "collate": null
                }
            ],
            "is_unique": false,
            "method": "btree",
            "tablespace": null,
            "definition": "CREATE INDEX i4org8grp_id ON nfc.org USING btree (grp_id)"
        }
    ]
}