CREATE OR REPLACE FUNCTION nfc.f_db8get_foreigntable(p_schema text, p_tablename text, p_refcolumn text, p_withshemaname boolean DEFAULT false)
 RETURNS text
 LANGUAGE sql
 SECURITY DEFINER
AS $function$
select case when p_withshemaname then (t6.nspname||'.'||t4.relname)::text
            else t4.relname::text
       end     
  from pg_catalog.pg_namespace   t1,
       pg_catalog.pg_class       t2,
       pg_catalog.pg_constraint  t3,
       pg_catalog.pg_class       t4,
       pg_catalog.pg_namespace   t6,
       pg_catalog.pg_attribute   t5
 where t1.nspname      = p_schema
   and t2.relnamespace = t1.oid 
   and t2.relname      = p_tablename
   and t3.conrelid     = t2.oid
   and t4.oid          = t3.confrelid
   and t6.oid          = t4.relnamespace
   and t5.attrelid     = t2.oid
   and t5.attnum       = any(t3.conkey)
   and t5.attname      = p_refcolumn::name;
$function$
;
comment on function nfc.f_db8get_foreigntable(p_schema text, p_tablename text, p_refcolumn text, p_withshemaname boolean) is 'Поиск имени таблицы-внешнего ключа ';