CREATE OR REPLACE FUNCTION nfc.f_db8get_primaryfield(p_schema text, p_tablename text, p_withtype boolean DEFAULT false)
 RETURNS text
 LANGUAGE sql
 SECURITY DEFINER
AS $function$
select case when p_withtype then 
         t5.attname::text||'::'||(select t4.typname::text from pg_catalog.pg_type t4 where t4.oid = t5.atttypid)
       else t5.attname::text end
  from pg_catalog.pg_namespace   t1,
       pg_catalog.pg_class       t2,
       pg_catalog.pg_constraint  t3,
       pg_catalog.pg_attribute   t5
 where t1.nspname      = p_schema
   and t2.relnamespace = t1.oid 
   and t2.relname      = p_tablename
   and t3.conrelid     = t2.oid
   and t3.contype      = 'p'
   and t5.attrelid     = t2.oid
   and t5.attnum       = any(t3.conkey)
   and not t5.attisdropped
   and t5.attnum       > 0
 limit 1;
$function$
;