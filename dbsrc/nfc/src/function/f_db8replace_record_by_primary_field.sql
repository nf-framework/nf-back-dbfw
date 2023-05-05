CREATE OR REPLACE FUNCTION nfc.f_db8replace_record_by_primary_field(p_tablename text, p_old text, p_new text, p_exclude text[], p_notice boolean DEFAULT false)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare
  x record;
  v_cnt int8;
  v_sql text;
begin
  for x in 
  select fk_sch.nspname as schema, 
         fk_tbl.relname as tablename, 
         fk_attr.attname as attr_name, 
         fk_attr_type.typname::text as attr_type
    from pg_catalog.pg_namespace   sch,
         pg_catalog.pg_class       tbl,
         pg_catalog.pg_constraint  fk,
         pg_catalog.pg_class       fk_tbl,
         pg_catalog.pg_namespace   fk_sch,
         pg_catalog.pg_attribute   fk_attr,
         pg_catalog.pg_type        fk_attr_type
   where sch.nspname      = split_part(p_tablename, '.', 1) 
     and tbl.relnamespace = sch.oid 
     and tbl.relname      = split_part(p_tablename, '.', 2) 
     and fk.confrelid     = tbl.oid
     and fk_tbl.oid       = fk.conrelid
     and fk_sch.oid       = fk_tbl.relnamespace
     and fk_attr.attrelid = fk_tbl.oid
     and fk_attr.attnum   = any(fk.conkey)
     and fk_sch.nspname||'.'||fk_tbl.relname||'.'||fk_attr.attname != all(p_exclude)
     and fk_attr_type.oid = fk_attr.atttypid
   order by 1, 2, 3  
  loop 
    v_sql = format('update %I.%I set %I = $2::%s where %I = $1::%s;', x.schema, x.tablename, x.attr_name, x.attr_type, x.attr_name, x.attr_type);
    --raise notice '%', v_sql;
    execute v_sql using p_old, p_new;
    get diagnostics v_cnt = row_count;
    if p_notice and v_cnt > 0 then 
      raise notice 'table[%]:id[%]to[%]:updated[%]rows in[%]', p_tablename, p_old::text, p_new::text, v_cnt::text, x.schema||'.'||x.tablename; 
    end if;
  end loop;
end
$function$
;