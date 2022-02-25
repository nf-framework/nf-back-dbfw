{
    "schema": "nfc",
    "tablename": "ui_customization",
    "comment": "Настройки и персонализация интерфейсных элементов",
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
            "name": "key",
            "datatype": "text",
            "datatype_length": null,
            "datatype_full": "text",
            "required": true,
            "default_value": null,
            "comment": "Ключ настроек. Обычно путь к форме",
            "fk_tablename": null,
            "column_id": 3
        },
        {
            "name": "scope",
            "datatype": "text",
            "datatype_length": null,
            "datatype_full": "text",
            "required": true,
            "default_value": null,
            "comment": "Область распространения настроек. Обычно u:имя_пользователя",
            "fk_tablename": null,
            "column_id": 2
        },
        {
            "name": "value",
            "datatype": "jsonb",
            "datatype_length": null,
            "datatype_full": "jsonb",
            "required": false,
            "default_value": null,
            "comment": "Настройки",
            "fk_tablename": null,
            "column_id": 4
        }
    ],
    "cons": [
        {
            "name": "pk4ui_customization",
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
            "name": "uk4ui_customization",
            "schema": "nfc",
            "type": "u",
            "update_rule": null,
            "delete_rule": null,
            "condition": null,
            "definition": "UNIQUE (scope, key)",
            "r_schema": null,
            "r_tablename": null,
            "r_columnname": null,
            "columns": "scope,key",
            "comment": null,
            "deferrable": null
        }
    ],
    "indx": null
}