{
    "schema": "nfc",
    "tablename": "ex_systems_chains",
    "comment": "Внешние системы: Цепочки вызовов",
    "cols": [
        {
            "name": "any_data",
            "datatype": "jsonb",
            "datatype_length": null,
            "datatype_full": "jsonb",
            "required": false,
            "default_value": null,
            "comment": null,
            "fk_tablename": null,
            "column_id": 3
        },
        {
            "name": "call",
            "datatype": "varchar",
            "datatype_length": "256",
            "datatype_full": "character varying(256)",
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
            "column_id": 2
        },
        {
            "name": "nextargs",
            "datatype": "jsonb",
            "datatype_length": null,
            "datatype_full": "jsonb",
            "required": false,
            "default_value": null,
            "comment": null,
            "fk_tablename": null,
            "column_id": 9
        },
        {
            "name": "pid",
            "datatype": "int8",
            "datatype_length": null,
            "datatype_full": "bigint",
            "required": true,
            "default_value": null,
            "comment": null,
            "fk_tablename": "nfc.ex_system_services",
            "column_id": 1
        },
        {
            "name": "result",
            "datatype": "jsonb",
            "datatype_length": null,
            "datatype_full": "jsonb",
            "required": false,
            "default_value": null,
            "comment": null,
            "fk_tablename": null,
            "column_id": 8
        },
        {
            "name": "status",
            "datatype": "int2",
            "datatype_length": null,
            "datatype_full": "smallint",
            "required": true,
            "default_value": "0",
            "comment": "0-pending, 1-resolved, 2-rejected",
            "fk_tablename": null,
            "column_id": 5
        },
        {
            "name": "uid",
            "datatype": "varchar",
            "datatype_length": "256",
            "datatype_full": "character varying(256)",
            "required": true,
            "default_value": null,
            "comment": null,
            "fk_tablename": null,
            "column_id": 4
        },
        {
            "name": "wait",
            "datatype": "_varchar",
            "datatype_length": null,
            "datatype_full": "character varying[]",
            "required": false,
            "default_value": null,
            "comment": null,
            "fk_tablename": null,
            "column_id": 7
        }
    ],
    "cons": [
        {
            "name": "ch4ex_systems_chains8status",
            "schema": "nfc",
            "type": "c",
            "update_rule": null,
            "delete_rule": null,
            "condition": "(status = ANY (ARRAY[0, 1, 2]))",
            "definition": "CHECK (status = ANY (ARRAY[0, 1, 2]))",
            "r_schema": null,
            "r_tablename": null,
            "r_columnname": null,
            "columns": "status",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "fk4ex_systems_chains8pid",
            "schema": "nfc",
            "type": "f",
            "update_rule": "a",
            "delete_rule": "a",
            "condition": null,
            "definition": "FOREIGN KEY (pid) REFERENCES nfc.ex_system_services(id)",
            "r_schema": "nfc",
            "r_tablename": "ex_system_services",
            "r_columnname": "id",
            "columns": "pid",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "pk4ex_systems_chains",
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
            "name": "i4ex_systems_chains8pid",
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
            "definition": "CREATE INDEX i4ex_systems_chains8pid ON nfc.ex_systems_chains USING btree (pid)"
        },
        {
            "name": "i4ex_systems_chains8uid",
            "schema": "nfc",
            "columns": [
                {
                    "name": "uid",
                    "nulls": "last",
                    "order": "asc",
                    "collate": "pg_catalog.\"default\""
                }
            ],
            "is_unique": false,
            "method": "btree",
            "tablespace": null,
            "definition": "CREATE INDEX i4ex_systems_chains8uid ON nfc.ex_systems_chains USING btree (uid)"
        }
    ]
}