{
    "schema": "nfc",
    "tablename": "ex_system_serv_msgs",
    "comment": "Внешние системы: сервисы: сообщения",
    "cols": [
        {
            "name": "any_data",
            "datatype": "jsonb",
            "datatype_length": null,
            "datatype_full": "jsonb",
            "required": false,
            "default_value": null,
            "comment": "Любые данные",
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
            "column_id": 1
        },
        {
            "name": "msg_id",
            "datatype": "varchar",
            "datatype_length": "40",
            "datatype_full": "character varying(40)",
            "required": false,
            "default_value": null,
            "comment": "Идентификатор сообщения",
            "fk_tablename": null,
            "column_id": 3
        },
        {
            "name": "msg_ts",
            "datatype": "timestamp",
            "datatype_length": null,
            "datatype_full": "timestamp without time zone",
            "required": false,
            "default_value": "now()",
            "comment": "Дата сообщения",
            "fk_tablename": null,
            "column_id": 4
        },
        {
            "name": "msg_type",
            "datatype": "int2",
            "datatype_length": null,
            "datatype_full": "smallint",
            "required": true,
            "default_value": null,
            "comment": "Тип сообщения (0 - sent, 1 - received) ",
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
            "fk_tablename": "nfc.ex_system_services",
            "column_id": 2
        },
        {
            "name": "status",
            "datatype": "int2",
            "datatype_length": null,
            "datatype_full": "smallint",
            "required": true,
            "default_value": "0",
            "comment": "Статус сообщения ( 0 - не обработано, 1 - обработано)",
            "fk_tablename": null,
            "column_id": 7
        }
    ],
    "cons": [
        {
            "name": "fk4ex_system_serv_msgs8pid",
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
            "name": "pk4ex_system_serv_msgs",
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
            "name": "i4ex_system_serv_msgs8pid",
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
            "definition": "CREATE INDEX i4ex_system_serv_msgs8pid ON nfc.ex_system_serv_msgs USING btree (pid)"
        }
    ]
}