{
    "schema": "nflog",
    "tablename": "int_log",
    "comment": "Интеграционные логи",
    "cols": [
        {
            "name": "context",
            "datatype": "text",
            "datatype_length": null,
            "datatype_full": "text",
            "required": true,
            "default_value": null,
            "comment": null,
            "fk_tablename": null,
            "column_id": 2
        },
        {
            "name": "err_msg",
            "datatype": "text",
            "datatype_length": null,
            "datatype_full": "text",
            "required": false,
            "default_value": null,
            "comment": "Текст ошибки, для случая, когда отвалились при формировании запроса или ответа",
            "fk_tablename": null,
            "column_id": 15
        },
        {
            "name": "ex_service",
            "datatype": "int8",
            "datatype_length": null,
            "datatype_full": "bigint",
            "required": true,
            "default_value": null,
            "comment": "Сервис внешней системы",
            "fk_tablename": "nfc.ex_system_services",
            "column_id": 5
        },
        {
            "name": "ex_system",
            "datatype": "int8",
            "datatype_length": null,
            "datatype_full": "bigint",
            "required": true,
            "default_value": null,
            "comment": null,
            "fk_tablename": "nfc.ex_systems",
            "column_id": 4
        },
        {
            "name": "id",
            "datatype": "int8",
            "datatype_length": null,
            "datatype_full": "bigint",
            "required": true,
            "default_value": "nextval('nflog.int_log_id_seq'::regclass)",
            "comment": null,
            "fk_tablename": null,
            "column_id": 1
        },
        {
            "name": "ok",
            "datatype": "bool",
            "datatype_length": null,
            "datatype_full": "boolean",
            "required": false,
            "default_value": null,
            "comment": "Статус сообщения: удачно \\ не удачно",
            "fk_tablename": null,
            "column_id": 14
        },
        {
            "name": "req_body",
            "datatype": "text",
            "datatype_length": null,
            "datatype_full": "text",
            "required": false,
            "default_value": null,
            "comment": "Текст запроса",
            "fk_tablename": null,
            "column_id": 9
        },
        {
            "name": "req_date",
            "datatype": "timestamptz",
            "datatype_length": null,
            "datatype_full": "timestamp with time zone",
            "required": false,
            "default_value": null,
            "comment": "Дата и время запроса",
            "fk_tablename": null,
            "column_id": 7
        },
        {
            "name": "req_head",
            "datatype": "text",
            "datatype_length": null,
            "datatype_full": "text",
            "required": false,
            "default_value": null,
            "comment": null,
            "fk_tablename": null,
            "column_id": 8
        },
        {
            "name": "res_body",
            "datatype": "text",
            "datatype_length": null,
            "datatype_full": "text",
            "required": false,
            "default_value": null,
            "comment": "Текст ответа",
            "fk_tablename": null,
            "column_id": 12
        },
        {
            "name": "res_date",
            "datatype": "timestamptz",
            "datatype_length": null,
            "datatype_full": "timestamp with time zone",
            "required": false,
            "default_value": null,
            "comment": "Дата и время ответа",
            "fk_tablename": null,
            "column_id": 10
        },
        {
            "name": "res_head",
            "datatype": "text",
            "datatype_length": null,
            "datatype_full": "text",
            "required": false,
            "default_value": null,
            "comment": null,
            "fk_tablename": null,
            "column_id": 11
        },
        {
            "name": "uri",
            "datatype": "text",
            "datatype_length": null,
            "datatype_full": "text",
            "required": false,
            "default_value": null,
            "comment": null,
            "fk_tablename": null,
            "column_id": 6
        },
        {
            "name": "username",
            "datatype": "text",
            "datatype_length": null,
            "datatype_full": "text",
            "required": false,
            "default_value": null,
            "comment": "Пользователь, который инициировал отправку запроса",
            "fk_tablename": null,
            "column_id": 13
        },
        {
            "name": "uuid",
            "datatype": "bpchar",
            "datatype_length": "40",
            "datatype_full": "character(40)",
            "required": false,
            "default_value": null,
            "comment": "Идентификатор",
            "fk_tablename": null,
            "column_id": 3
        }
    ],
    "cons": [
        {
            "name": "fk4int_log8service",
            "schema": "nflog",
            "type": "f",
            "update_rule": "a",
            "delete_rule": "a",
            "condition": null,
            "definition": "FOREIGN KEY (ex_service) REFERENCES nfc.ex_system_services(id)",
            "r_schema": "nfc",
            "r_tablename": "ex_system_services",
            "r_columnname": "id",
            "columns": "ex_service",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "fk4int_log8system",
            "schema": "nflog",
            "type": "f",
            "update_rule": "a",
            "delete_rule": "a",
            "condition": null,
            "definition": "FOREIGN KEY (ex_system) REFERENCES nfc.ex_systems(id)",
            "r_schema": "nfc",
            "r_tablename": "ex_systems",
            "r_columnname": "id",
            "columns": "ex_system",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "pk4int_log",
            "schema": "nflog",
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
            "name": "i4int_log8service",
            "schema": "nflog",
            "columns": [
                {
                    "name": "ex_service",
                    "nulls": "last",
                    "order": "asc",
                    "collate": null
                }
            ],
            "is_unique": false,
            "method": "btree",
            "tablespace": null,
            "definition": "CREATE INDEX i4int_log8service ON nflog.int_log USING btree (ex_service)"
        },
        {
            "name": "i4int_log8system",
            "schema": "nflog",
            "columns": [
                {
                    "name": "ex_system",
                    "nulls": "last",
                    "order": "asc",
                    "collate": null
                }
            ],
            "is_unique": false,
            "method": "btree",
            "tablespace": null,
            "definition": "CREATE INDEX i4int_log8system ON nflog.int_log USING btree (ex_system)"
        }
    ]
}