{
    "schema": "nflog",
    "tablename": "tables_actions",
    "comment": null,
    "cols": [
        {
            "name": "action",
            "datatype": "bpchar",
            "datatype_length": "1",
            "datatype_full": "character(1)",
            "required": false,
            "default_value": null,
            "comment": null,
            "fk_tablename": null,
            "column_id": 11
        },
        {
            "name": "application_name",
            "datatype": "text",
            "datatype_length": null,
            "datatype_full": "text",
            "required": false,
            "default_value": null,
            "comment": null,
            "fk_tablename": null,
            "column_id": 7
        },
        {
            "name": "client_addr",
            "datatype": "inet",
            "datatype_length": null,
            "datatype_full": "inet",
            "required": false,
            "default_value": null,
            "comment": null,
            "fk_tablename": null,
            "column_id": 8
        },
        {
            "name": "client_port",
            "datatype": "int4",
            "datatype_length": null,
            "datatype_full": "integer",
            "required": false,
            "default_value": null,
            "comment": null,
            "fk_tablename": null,
            "column_id": 9
        },
        {
            "name": "client_query",
            "datatype": "text",
            "datatype_length": null,
            "datatype_full": "text",
            "required": false,
            "default_value": null,
            "comment": null,
            "fk_tablename": null,
            "column_id": 10
        },
        {
            "name": "id",
            "datatype": "int8",
            "datatype_length": null,
            "datatype_full": "bigint",
            "required": true,
            "default_value": null,
            "comment": null,
            "fk_tablename": null,
            "column_id": 1
        },
        {
            "name": "row_changed_data",
            "datatype": "jsonb",
            "datatype_length": null,
            "datatype_full": "jsonb",
            "required": false,
            "default_value": null,
            "comment": null,
            "fk_tablename": null,
            "column_id": 13
        },
        {
            "name": "row_data",
            "datatype": "jsonb",
            "datatype_length": null,
            "datatype_full": "jsonb",
            "required": false,
            "default_value": null,
            "comment": null,
            "fk_tablename": null,
            "column_id": 12
        },
        {
            "name": "row_id",
            "datatype": "text",
            "datatype_length": null,
            "datatype_full": "text",
            "required": false,
            "default_value": null,
            "comment": null,
            "fk_tablename": null,
            "column_id": 14
        },
        {
            "name": "schemaname",
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
            "name": "session_user_name",
            "datatype": "text",
            "datatype_length": null,
            "datatype_full": "text",
            "required": false,
            "default_value": null,
            "comment": null,
            "fk_tablename": null,
            "column_id": 4
        },
        {
            "name": "tablename",
            "datatype": "text",
            "datatype_length": null,
            "datatype_full": "text",
            "required": true,
            "default_value": null,
            "comment": null,
            "fk_tablename": null,
            "column_id": 3
        },
        {
            "name": "ts_log",
            "datatype": "timestamptz",
            "datatype_length": null,
            "datatype_full": "timestamp with time zone",
            "required": false,
            "default_value": null,
            "comment": null,
            "fk_tablename": null,
            "column_id": 6
        },
        {
            "name": "ts_transact_started",
            "datatype": "timestamptz",
            "datatype_length": null,
            "datatype_full": "timestamp with time zone",
            "required": false,
            "default_value": null,
            "comment": null,
            "fk_tablename": null,
            "column_id": 5
        }
    ],
    "cons": [
        {
            "name": "ch4tables_actions8action",
            "schema": "nflog",
            "type": "c",
            "update_rule": null,
            "delete_rule": null,
            "condition": "((action)::text = ANY (ARRAY['a'::text, 'd'::text, 'u'::text]))",
            "definition": "CHECK (action::text = ANY (ARRAY['a'::text, 'd'::text, 'u'::text]))",
            "r_schema": null,
            "r_tablename": null,
            "r_columnname": null,
            "columns": "action",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "pk4tables_actions",
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
            "name": "i4tables_actions8row_id",
            "schema": "nflog",
            "columns": [
                {
                    "name": "row_id",
                    "nulls": "last",
                    "order": "asc",
                    "collate": "pg_catalog.\"default\""
                }
            ],
            "is_unique": false,
            "method": "btree",
            "tablespace": null,
            "definition": "CREATE INDEX i4tables_actions8row_id ON nflog.tables_actions USING btree (row_id)"
        },
        {
            "name": "i4tables_actions8ts_log",
            "schema": "nflog",
            "columns": [
                {
                    "name": "ts_log",
                    "nulls": "first",
                    "order": "desc",
                    "collate": null
                }
            ],
            "is_unique": false,
            "method": "btree",
            "tablespace": null,
            "definition": "CREATE INDEX i4tables_actions8ts_log ON nflog.tables_actions USING btree (ts_log DESC)"
        }
    ]
}