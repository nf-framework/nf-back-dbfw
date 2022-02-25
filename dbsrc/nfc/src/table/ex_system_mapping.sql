{
    "schema": "nfc",
    "tablename": "ex_system_mapping",
    "comment": "Внешние системы : маппинг",
    "cols": [
        {
            "name": "ex_id",
            "datatype": "text",
            "datatype_length": null,
            "datatype_full": "text",
            "required": true,
            "default_value": null,
            "comment": "Идентификатор во внешней системе",
            "fk_tablename": null,
            "column_id": 6
        },
        {
            "name": "ex_namespace",
            "datatype": "text",
            "datatype_length": null,
            "datatype_full": "text",
            "required": true,
            "default_value": null,
            "comment": "Пространство имен из внешней системы",
            "fk_tablename": null,
            "column_id": 5
        },
        {
            "name": "id",
            "datatype": "int8",
            "datatype_length": null,
            "datatype_full": "bigint",
            "required": true,
            "default_value": "nextval('nfc.s4ex_system_mapping'::text::regclass)",
            "comment": null,
            "fk_tablename": null,
            "column_id": 2
        },
        {
            "name": "in_id",
            "datatype": "text",
            "datatype_length": null,
            "datatype_full": "text",
            "required": true,
            "default_value": null,
            "comment": "Идентификатор внутри системы",
            "fk_tablename": null,
            "column_id": 4
        },
        {
            "name": "in_namespace",
            "datatype": "text",
            "datatype_length": null,
            "datatype_full": "text",
            "required": true,
            "default_value": null,
            "comment": "Пространство имен внутри системы",
            "fk_tablename": null,
            "column_id": 3
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
            "column_id": 1
        }
    ],
    "cons": [
        {
            "name": "fk4ex_system_mapping8pid",
            "schema": "nfc",
            "type": "f",
            "update_rule": "a",
            "delete_rule": "a",
            "condition": null,
            "definition": "FOREIGN KEY (pid) REFERENCES nfc.ex_systems(id)",
            "r_schema": "nfc",
            "r_tablename": "ex_systems",
            "r_columnname": "id",
            "columns": "pid",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "pk4ex_system_mapping",
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
            "name": "i4ex_system_mapping8in",
            "schema": "nfc",
            "columns": [
                {
                    "name": "in_namespace",
                    "nulls": "last",
                    "order": "asc",
                    "collate": "pg_catalog.\"default\""
                },
                {
                    "name": "in_id",
                    "nulls": "last",
                    "order": "asc",
                    "collate": "pg_catalog.\"default\""
                }
            ],
            "is_unique": false,
            "method": "btree",
            "tablespace": null,
            "definition": "CREATE INDEX i4ex_system_mapping8in ON nfc.ex_system_mapping USING btree (in_namespace, in_id)"
        },
        {
            "name": "i4ex_system_mapping8pid",
            "schema": "nfc",
            "columns": [
                {
                    "name": "pid",
                    "nulls": "last",
                    "order": "asc",
                    "collate": null
                },
                {
                    "name": "ex_namespace",
                    "nulls": "last",
                    "order": "asc",
                    "collate": "pg_catalog.\"default\""
                },
                {
                    "name": "ex_id",
                    "nulls": "last",
                    "order": "asc",
                    "collate": "pg_catalog.\"default\""
                },
                {
                    "name": "in_namespace",
                    "nulls": "last",
                    "order": "asc",
                    "collate": "pg_catalog.\"default\""
                },
                {
                    "name": "in_id",
                    "nulls": "last",
                    "order": "asc",
                    "collate": "pg_catalog.\"default\""
                }
            ],
            "is_unique": true,
            "method": "btree",
            "tablespace": null,
            "definition": "CREATE UNIQUE INDEX i4ex_system_mapping8pid ON nfc.ex_system_mapping USING btree (pid, ex_namespace, ex_id, in_namespace, in_id)"
        }
    ]
}