CREATE OR REPLACE FUNCTION nfc.f_db8obj_exist(p_object_type text, p_schema text, p_object_name text DEFAULT NULL::text, p_subobject_name text DEFAULT NULL::text)
 RETURNS oid
 LANGUAGE sql
 STABLE SECURITY DEFINER
AS $function$
select case p_object_type when 'function' then (select t2.oid
                                                   from pg_catalog.pg_namespace   t1,
                                                        pg_catalog.pg_proc        t2
                                                  where t1.nspname      = p_schema
                                                    and t2.pronamespace = t1.oid 
                                                    and t2.proname      = p_object_name)
                           when 'view' then (select t2.oid
                                               from pg_catalog.pg_namespace   t1,
                                                    pg_catalog.pg_class       t2
                                              where t1.nspname      = p_schema
                                                and t2.relnamespace = t1.oid 
                                                and t2.relkind     = 'v'
                                                and t2.relname      = p_object_name)
                           when 'table' then  (select t2.oid
                                                 from pg_catalog.pg_namespace   t1,
                                                      pg_catalog.pg_class       t2
                                                where t1.nspname      = p_schema
                                                  and t2.relnamespace = t1.oid 
                                                  and t2.relkind     = 'r'
                                                  and t2.relname      = p_object_name)
                           when 'column' then (select q.oid
                                                 from (select t2.oid
                                                         from pg_catalog.pg_namespace   t1,
                                                              pg_catalog.pg_class       t2,
                                                              pg_catalog.pg_attribute   t3
                                                        where t1.nspname      = p_schema
                                                          and t2.relnamespace = t1.oid 
                                                          and t2.relname      = p_object_name
                                                          and t3.attrelid     = t2.oid
                                                          and t3.attname      = p_subobject_name
                                                        limit 1) q)
                           when 'trigger' then (select t2.oid
                                                  from pg_catalog.pg_namespace   t1,
                                                       pg_catalog.pg_class       t3,
                                                       pg_catalog.pg_trigger     t2
                                                 where t1.nspname      = p_schema
                                                   and t3.relnamespace = t1.oid
                                                   and t2.tgrelid      = t3.oid
                                                   and t2.tgname       = p_object_name)
                           when 'constraint' then (select t3.oid  
                                                     from pg_catalog.pg_namespace   t1,
                                                          pg_catalog.pg_constraint  t3
                                                    where (t1.nspname     = p_schema or p_schema is null)
                                                      and t3.connamespace = t1.oid
                                                      and t3.conname      = p_object_name)                         
                           when 'role' then (select t.oid from pg_catalog.pg_roles t where t.rolname = p_schema)
                           when 'sequence' then (select t2.oid
                                                 from pg_catalog.pg_namespace   t1,
                                                      pg_catalog.pg_class       t2
                                                where t1.nspname      = p_schema
                                                  and t2.relnamespace = t1.oid 
                                                  and t2.relkind     = 'S'
                                                  and t2.relname      = p_object_name)
                           else null
                           end
$function$
;