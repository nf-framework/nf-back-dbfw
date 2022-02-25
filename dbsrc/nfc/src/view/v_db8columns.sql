create or replace view nfc.v_db8columns as 
 SELECT nc.nspname::text AS schema,
    c.relname::text AS tablename,
    a.attname::text AS column_name,
    a.attnum AS column_order,
    pg_get_expr(ad.adbin, ad.adrelid) AS column_default,
        CASE
            WHEN a.attnotnull OR t.typtype = 'd'::"char" AND t.typnotnull THEN true
            ELSE false
        END AS column_required,
    t.typname::text AS datatype,
    format_type(a.atttypid, a.atttypmod) AS datatype_full,
    COALESCE(( SELECT t4.description
           FROM pg_description t4
          WHERE t4.objoid = c.oid AND t4.objsubid = a.attnum),
        CASE
            WHEN c.relkind = 'v'::"char" THEN nfc.f_db8get_description('column'::text, nc.nspname::text, substr(c.relname::text, 3), a.attname::text)
            ELSE NULL::text
        END) AS description
   FROM pg_attribute a
     LEFT JOIN pg_attrdef ad ON a.attrelid = ad.adrelid AND a.attnum = ad.adnum,
    pg_class c,
    pg_namespace nc,
    pg_type t
  WHERE a.attrelid = c.oid AND a.atttypid = t.oid AND nc.oid = c.relnamespace AND a.attnum > 0 AND NOT a.attisdropped AND (c.relkind = ANY (ARRAY['r'::"char", 'v'::"char", 'f'::"char"]));