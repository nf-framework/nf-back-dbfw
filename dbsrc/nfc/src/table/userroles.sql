{
    "schema": "nfc",
    "tablename": "userroles",
    "comment": "Назначенные роли пользователям",
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
            "name": "org_id",
            "datatype": "int8",
            "datatype_length": null,
            "datatype_full": "bigint",
            "required": true,
            "default_value": null,
            "comment": "Организация",
            "fk_tablename": "nfc.org",
            "column_id": 2
        },
        {
            "name": "role_id",
            "datatype": "int8",
            "datatype_length": null,
            "datatype_full": "bigint",
            "required": true,
            "default_value": null,
            "comment": "Роль",
            "fk_tablename": "nfc.roles",
            "column_id": 4
        },
        {
            "name": "user_id",
            "datatype": "int8",
            "datatype_length": null,
            "datatype_full": "bigint",
            "required": true,
            "default_value": null,
            "comment": "Пользователь",
            "fk_tablename": "nfc.users",
            "column_id": 3
        }
    ],
    "cons": [
        {
            "name": "fk4userroles8org_id",
            "schema": "nfc",
            "type": "f",
            "update_rule": "a",
            "delete_rule": "a",
            "condition": null,
            "definition": "FOREIGN KEY (org_id) REFERENCES nfc.org(id)",
            "r_schema": "nfc",
            "r_tablename": "org",
            "r_columnname": "id",
            "columns": "org_id",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "fk4userroles8role_id",
            "schema": "nfc",
            "type": "f",
            "update_rule": "a",
            "delete_rule": "a",
            "condition": null,
            "definition": "FOREIGN KEY (role_id) REFERENCES nfc.roles(id)",
            "r_schema": "nfc",
            "r_tablename": "roles",
            "r_columnname": "id",
            "columns": "role_id",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "fk4userroles8user_id",
            "schema": "nfc",
            "type": "f",
            "update_rule": "a",
            "delete_rule": "c",
            "condition": null,
            "definition": "FOREIGN KEY (user_id) REFERENCES nfc.users(id) ON DELETE CASCADE",
            "r_schema": "nfc",
            "r_tablename": "users",
            "r_columnname": "id",
            "columns": "user_id",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "pk4userroles",
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
            "name": "uk4userroles",
            "schema": "nfc",
            "type": "u",
            "update_rule": null,
            "delete_rule": null,
            "condition": null,
            "definition": "UNIQUE (org_id, user_id, role_id)",
            "r_schema": null,
            "r_tablename": null,
            "r_columnname": null,
            "columns": "org_id,user_id,role_id",
            "comment": null,
            "deferrable": null
        }
    ],
    "indx": [
        {
            "name": "i4userroles8role_id",
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
            "definition": "CREATE INDEX i4userroles8role_id ON nfc.userroles USING btree (role_id)"
        },
        {
            "name": "i4userroles8user_id",
            "schema": "nfc",
            "columns": [
                {
                    "name": "user_id",
                    "nulls": "last",
                    "order": "asc",
                    "collate": null
                }
            ],
            "is_unique": false,
            "method": "btree",
            "tablespace": null,
            "definition": "CREATE INDEX i4userroles8user_id ON nfc.userroles USING btree (user_id)"
        }
    ]
}