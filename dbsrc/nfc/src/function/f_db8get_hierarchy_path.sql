CREATE OR REPLACE FUNCTION nfc.f_db8get_hierarchy_path(p_schema text, p_tablename text, p_field text, p_delimiter text, p_key text, p_pkey text, p_key_value text)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
declare 
  v_sql text;
  v_key_type text;
  v_res text;
begin
  select t4.typname::text
    into v_key_type
    from pg_catalog.pg_namespace   t1,
         pg_catalog.pg_class       t2,
         pg_catalog.pg_attribute   t5,
         pg_catalog.pg_type        t4
   where t1.nspname      = p_schema
     and t2.relnamespace = t1.oid 
     and t2.relname      = p_tablename
     and t5.attrelid     = t2.oid
     and t5.attname      = p_key
     and t4.oid = t5.atttypid;
  if v_key_type is null then 
    raise 'Не найден тип для поля [%] таблицы [%]', p_key, p_schema||'.'||p_tablename;
  end if;
  v_sql = format(
  'with recursive r as  (
        select %I, %I, %I, array[%I] as visited from %I.%I d where d.%I = $1::%s
        union all 
        select t.%I, t.%I, t.%I||''%s''||r.%I, r.visited||t.%I from r, %I.%I t where t.%I = r.%I and t.%I <> ALL (r.visited)
   ) 
   select r.%I::text 
     from r 
    where r.%I is null;', 
  p_key, p_pkey, p_field, p_key, p_schema, p_tablename, p_key, v_key_type,
  p_key, p_pkey, p_field, p_delimiter, p_field, p_key, p_schema, p_tablename, p_key, p_pkey, p_key,
  p_field,
  p_pkey
  );
  --raise notice '%', v_sql;
  execute v_sql into v_res using p_key_value;
  return v_res;
end 
$function$
;