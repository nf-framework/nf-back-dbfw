{
    "schema": "nfc",
    "tablename": "menuroles",
    "comment": "Настройка ограничений для пунктов меню",
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
            "column_id": 3
        },
        {
            "name": "menuguid",
            "datatype": "uuid",
            "datatype_length": null,
            "datatype_full": "uuid",
            "required": true,
            "default_value": null,
            "comment": "Пунт меню",
            "fk_tablename": null,
            "column_id": 1
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
            "column_id": 2
        }
    ],
    "cons": [
        {
            "name": "fk4menuroles8role_id",
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
            "name": "pk4menuroles",
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
            "name": "uk4menuroles8menuguid",
            "schema": "nfc",
            "type": "u",
            "update_rule": null,
            "delete_rule": null,
            "condition": null,
            "definition": "UNIQUE (role_id, menuguid)",
            "r_schema": null,
            "r_tablename": null,
            "r_columnname": null,
            "columns": "role_id,menuguid",
            "comment": null,
            "deferrable": null
        }
    ],
    "indx": null
}