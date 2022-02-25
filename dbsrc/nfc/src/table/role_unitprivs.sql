{
    "schema": "nfc",
    "tablename": "role_unitprivs",
    "comment": "Права ролей на видимость разделов",
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
            "name": "role_id",
            "datatype": "int8",
            "datatype_length": null,
            "datatype_full": "bigint",
            "required": false,
            "default_value": null,
            "comment": "Роль",
            "fk_tablename": "nfc.roles",
            "column_id": 2
        },
        {
            "name": "unit",
            "datatype": "varchar",
            "datatype_length": "60",
            "datatype_full": "character varying(60)",
            "required": false,
            "default_value": null,
            "comment": "Раздел",
            "fk_tablename": "nfc.unitlist",
            "column_id": 3
        }
    ],
    "cons": [
        {
            "name": "fk4role_unitprivs8role_id",
            "schema": "nfc",
            "type": "f",
            "update_rule": "a",
            "delete_rule": "c",
            "condition": null,
            "definition": "FOREIGN KEY (role_id) REFERENCES nfc.roles(id) ON DELETE CASCADE",
            "r_schema": "nfc",
            "r_tablename": "roles",
            "r_columnname": "id",
            "columns": "role_id",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "fk4role_unitprivs8unit",
            "schema": "nfc",
            "type": "f",
            "update_rule": "c",
            "delete_rule": "c",
            "condition": null,
            "definition": "FOREIGN KEY (unit) REFERENCES nfc.unitlist(code) ON UPDATE CASCADE ON DELETE CASCADE",
            "r_schema": "nfc",
            "r_tablename": "unitlist",
            "r_columnname": "code",
            "columns": "unit",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "pk4role_unitprivs",
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
            "name": "uk4role_unitprivs",
            "schema": "nfc",
            "type": "u",
            "update_rule": null,
            "delete_rule": null,
            "condition": null,
            "definition": "UNIQUE (unit, role_id)",
            "r_schema": null,
            "r_tablename": null,
            "r_columnname": null,
            "columns": "unit,role_id",
            "comment": null,
            "deferrable": null
        }
    ],
    "indx": [
        {
            "name": "i4role_unitprivs8role_id",
            "schema": "nfc",
            "columns": [
                {
                    "name": "role_id",
                    "nulls": "last",
                    "order": "asc",
                    "collate": null
                }
            ],
            "is_unique": false,
            "method": "btree",
            "tablespace": null,
            "definition": "CREATE INDEX i4role_unitprivs8role_id ON nfc.role_unitprivs USING btree (role_id)"
        }
    ]
}