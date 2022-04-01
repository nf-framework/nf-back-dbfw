{
    "schema": "nfc",
    "tablename": "unit_files",
    "comment": "Прикрепленные документы",
    "cols": [
        {
            "name": "file_id",
            "datatype": "int8",
            "datatype_length": null,
            "datatype_full": "bigint",
            "required": true,
            "default_value": null,
            "comment": "Файл",
            "fk_tablename": "nfc.files",
            "column_id": 5
        },
        {
            "name": "id",
            "datatype": "int8",
            "datatype_length": null,
            "datatype_full": "bigint",
            "required": true,
            "default_value": "nextval('nfc.s4unit_files'::text::regclass)",
            "comment": null,
            "fk_tablename": null,
            "column_id": 1
        },
        {
            "name": "uf_type",
            "datatype": "int8",
            "datatype_length": null,
            "datatype_full": "bigint",
            "required": false,
            "default_value": null,
            "comment": "Тип документа",
            "fk_tablename": "nfc.unit_file_types",
            "column_id": 4
        },
        {
            "name": "unit",
            "datatype": "varchar",
            "datatype_length": null,
            "datatype_full": "character varying",
            "required": true,
            "default_value": null,
            "comment": "Раздел",
            "fk_tablename": "nfc.unitlist",
            "column_id": 2
        },
        {
            "name": "unit_id",
            "datatype": "int8",
            "datatype_length": null,
            "datatype_full": "bigint",
            "required": true,
            "default_value": null,
            "comment": "Идентификатор записи в разделе",
            "fk_tablename": null,
            "column_id": 3
        }
    ],
    "cons": [
        {
            "name": "fk4unit_files8file_id",
            "schema": "nfc",
            "type": "f",
            "update_rule": "a",
            "delete_rule": "a",
            "condition": null,
            "definition": "FOREIGN KEY (file_id) REFERENCES nfc.files(id)",
            "r_schema": "nfc",
            "r_tablename": "files",
            "r_columnname": "id",
            "columns": "file_id",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "fk4unit_files8uf_type",
            "schema": "nfc",
            "type": "f",
            "update_rule": "a",
            "delete_rule": "a",
            "condition": null,
            "definition": "FOREIGN KEY (uf_type) REFERENCES nfc.unit_file_types(id)",
            "r_schema": "nfc",
            "r_tablename": "unit_file_types",
            "r_columnname": "id",
            "columns": "uf_type",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "fk4unit_files8unit",
            "schema": "nfc",
            "type": "f",
            "update_rule": "a",
            "delete_rule": "a",
            "condition": null,
            "definition": "FOREIGN KEY (unit) REFERENCES nfc.unitlist(code)",
            "r_schema": "nfc",
            "r_tablename": "unitlist",
            "r_columnname": "code",
            "columns": "unit",
            "comment": null,
            "deferrable": null
        },
        {
            "name": "pk4unit_files",
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
            "name": "i4unit_files8file_id",
            "schema": "nfc",
            "columns": [
                {
                    "name": "file_id",
                    "nulls": "last",
                    "order": "asc",
                    "collate": null
                }
            ],
            "is_unique": false,
            "method": "btree",
            "tablespace": null,
            "definition": "CREATE INDEX i4unit_files8file_id ON nfc.unit_files USING btree (file_id)"
        },
        {
            "name": "i4unit_files8uf_type",
            "schema": "nfc",
            "columns": [
                {
                    "name": "uf_type",
                    "nulls": "last",
                    "order": "asc",
                    "collate": null
                }
            ],
            "is_unique": false,
            "method": "btree",
            "tablespace": null,
            "definition": "CREATE INDEX i4unit_files8uf_type ON nfc.unit_files USING btree (uf_type)"
        },
        {
            "name": "i4unit_files8unit",
            "schema": "nfc",
            "columns": [
                {
                    "name": "unit",
                    "nulls": "last",
                    "order": "asc",
                    "collate": "pg_catalog.\"default\""
                },
                {
                    "name": "unit_id",
                    "nulls": "last",
                    "order": "asc",
                    "collate": null
                },
                {
                    "name": "uf_type",
                    "nulls": "last",
                    "order": "asc",
                    "collate": null
                },
                {
                    "name": "file_id",
                    "nulls": "last",
                    "order": "asc",
                    "collate": null
                }
            ],
            "is_unique": true,
            "method": "btree",
            "tablespace": null,
            "definition": "CREATE UNIQUE INDEX i4unit_files8unit ON nfc.unit_files USING btree (unit, unit_id, uf_type, file_id)"
        }
    ]
}