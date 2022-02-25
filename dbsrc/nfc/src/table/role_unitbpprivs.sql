{
    "schema": "nfc",
    "tablename": "role_unitbpprivs",
    "comment": "Права ролей на действия в разделах",
    "cols": [
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
            "name": "pid",
            "datatype": "int8",
            "datatype_length": null,
            "datatype_full": "bigint",
            "required": true,
            "default_value": null,
            "comment": "Право на видимость",
            "fk_tablename": "nfc.role_unitprivs",
            "column_id": 2
        },
        {
            "name": "unitbp",
            "datatype": "varchar",
            "datatype_length": "90",
            "datatype_full": "character varying(90)",
            "required": true,
            "default_value": null,
            "comment": "Действие в разделе",
            "fk_tablename": "nfc.unitbps",
            "column_id": 3
        }
    ],
    "cons": [
        {
            "name": "fk4role_unitbpprivs8pid",
            "schema": "nfc",
            "type": "f",
            "update_rule": "a",
            "delete_rule": "c",
            "condition": null,
            "definition": "FOREIGN KEY (pid) REFERENCES nfc.role_unitprivs(id) ON DELETE CASCADE",
            "r_schema": "nfc",
            "r_tablename": "role_unitprivs",
            "r_columnname": "id",
            "columns": "pid",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "fk4role_unitbpprivs8unitbp",
            "schema": "nfc",
            "type": "f",
            "update_rule": "a",
            "delete_rule": "c",
            "condition": null,
            "definition": "FOREIGN KEY (unitbp) REFERENCES nfc.unitbps(code) ON DELETE CASCADE",
            "r_schema": "nfc",
            "r_tablename": "unitbps",
            "r_columnname": "code",
            "columns": "unitbp",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "pk4role_unitbpprivs",
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
            "name": "uk4role_unitbpprivs",
            "schema": "nfc",
            "type": "u",
            "update_rule": null,
            "delete_rule": null,
            "condition": null,
            "definition": "UNIQUE (pid, unitbp)",
            "r_schema": null,
            "r_tablename": null,
            "r_columnname": null,
            "columns": "pid,unitbp",
            "comment": null,
            "deferrable": null
        }
    ],
    "indx": [
        {
            "name": "i4role_unitbpprivs8unitbp",
            "schema": "nfc",
            "columns": [
                {
                    "name": "unitbp",
                    "nulls": "last",
                    "order": "asc",
                    "collate": "pg_catalog.\"default\""
                }
            ],
            "is_unique": false,
            "method": "btree",
            "tablespace": null,
            "definition": "CREATE INDEX i4role_unitbpprivs8unitbp ON nfc.role_unitbpprivs USING btree (unitbp)"
        }
    ]
}