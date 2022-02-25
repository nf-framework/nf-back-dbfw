CREATE OR REPLACE FUNCTION nfc.f_db8get_columntypes(p_schema text, p_tablename text)
 RETURNS json
 LANGUAGE sql
 STABLE SECURITY DEFINER
AS $function$
select json_object(h.names, h.types)
  from (select array_agg(col.attname) as names, array_agg(typ.typname) as types
          from pg_catalog.pg_class tabl
               join pg_catalog.pg_namespace sch on sch.oid = tabl.relnamespace
               join pg_catalog.pg_attribute col on (col.attrelid = tabl.oid and col.attnum > 0 and not col.attisdropped)
               join pg_catalog.pg_type typ on typ.oid = col.atttypid
         where sch.nspname = p_schema
           and tabl.relname = p_tablename) h
$function$
;