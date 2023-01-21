{
    "schema": "nfc",
    "tablename": "users",
    "comment": "Пользователи системы",
    "cols": [
        {
            "name": "extra",
            "datatype": "jsonb",
            "datatype_length": null,
            "datatype_full": "jsonb",
            "required": false,
            "default_value": null,
            "comment": "Дополнительная информация",
            "fk_tablename": null,
            "column_id": 4
        },
        {
            "name": "fullname",
            "datatype": "varchar",
            "datatype_length": "300",
            "datatype_full": "character varying(300)",
            "required": true,
            "default_value": null,
            "comment": "Полное имя пользователя",
            "fk_tablename": null,
            "column_id": 3
        },
        {
            "name": "id",
            "datatype": "int8",
            "datatype_length": null,
            "datatype_full": "bigint",
            "required": true,
            "default_value": "nextval('nfc.s4users'::text::regclass)",
            "comment": "Идентификатор",
            "fk_tablename": null,
            "column_id": 1
        },
        {
            "name": "password",
            "datatype": "text",
            "datatype_length": null,
            "datatype_full": "text",
            "required": false,
            "default_value": null,
            "comment": "Пароль",
            "fk_tablename": null,
            "column_id": 5
        },
        {
            "name": "username",
            "datatype": "varchar",
            "datatype_length": "60",
            "datatype_full": "character varying(60)",
            "required": true,
            "default_value": null,
            "comment": "Имя пользователя",
            "fk_tablename": null,
            "column_id": 2
        }
    ],
    "cons": [
        {
            "name": "ch4users8username",
            "schema": "nfc",
            "type": "c",
            "update_rule": null,
            "delete_rule": null,
            "condition": "((username)::text = btrim((username)::text))",
            "definition": "CHECK (username::text = btrim(username::text))",
            "r_schema": null,
            "r_tablename": null,
            "r_columnname": null,
            "columns": "username",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "pk4users",
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
            "name": "uk4users8username",
            "schema": "nfc",
            "type": "u",
            "update_rule": null,
            "delete_rule": null,
            "condition": null,
            "definition": "UNIQUE (username)",
            "r_schema": null,
            "r_tablename": null,
            "r_columnname": null,
            "columns": "username",
            "comment": null,
            "deferrable": null
        }
    ],
    "indx": null
}