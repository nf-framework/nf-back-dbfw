{
    "schema": "nfc",
    "tablename": "ex_system_services",
    "comment": "Внешние системы : сервисы",
    "cols": [
        {
            "name": "any_options",
            "datatype": "jsonb",
            "datatype_length": null,
            "datatype_full": "jsonb",
            "required": false,
            "default_value": null,
            "comment": "Опции сервиса",
            "fk_tablename": null,
            "column_id": 7
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
            "name": "is_stopped",
            "datatype": "bool",
            "datatype_length": null,
            "datatype_full": "boolean",
            "required": true,
            "default_value": null,
            "comment": "Сервис приостановлен",
            "fk_tablename": null,
            "column_id": 5
        },
        {
            "name": "pid",
            "datatype": "int8",
            "datatype_length": null,
            "datatype_full": "bigint",
            "required": true,
            "default_value": null,
            "comment": null,
            "fk_tablename": "nfc.ex_systems",
            "column_id": 2
        },
        {
            "name": "url",
            "datatype": "text",
            "datatype_length": null,
            "datatype_full": "text",
            "required": false,
            "default_value": null,
            "comment": "URL - адрес сервиса",
            "fk_tablename": null,
            "column_id": 6
        }
    ],
    "cons": [
        {
            "name": "ch4ex_system_services8caption",
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
            "name": "ch4ex_system_services8code",
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
            "name": "fk4ex_system_services8pid",
            "schema": "nfc",
            "type": "f",
            "update_rule": "a",
            "delete_rule": "c",
            "condition": null,
            "definition": "FOREIGN KEY (pid) REFERENCES nfc.ex_systems(id) ON DELETE CASCADE",
            "r_schema": "nfc",
            "r_tablename": "ex_systems",
            "r_columnname": "id",
            "columns": "pid",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "pk4ex_system_services",
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
            "name": "uk4ex_system_services8code",
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
            "name": "i4ex_system_services8pid",
            "schema": "nfc",
            "columns": [
                {
                    "name": "pid",
                    "nulls": "last",
                    "order": "asc",
                    "collate": null
                }
            ],
            "is_unique": false,
            "method": "btree",
            "tablespace": null,
            "definition": "CREATE INDEX i4ex_system_services8pid ON nfc.ex_system_services USING btree (pid)"
        }
    ]
}