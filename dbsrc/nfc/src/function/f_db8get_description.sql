CREATE OR REPLACE FUNCTION nfc.f_db8get_description(p_object_type text, p_schema text, p_object_name text, p_subobject_name text DEFAULT NULL::text)
 RETURNS text
 LANGUAGE sql
 STABLE SECURITY DEFINER
AS $function$
select case when p_object_name = 'column' then (select t4.description
                                                  from pg_catalog.pg_namespace   t1,
                                                       pg_catalog.pg_class       t2,
                                                       pg_catalog.pg_attribute   t3,
                                                       pg_catalog.pg_description t4
                                                 where (t1.nspname     = p_schema or p_schema is null)
                                                   and t2.relnamespace = t1.oid 
                                                   and t2.relname      = p_object_name
                                                   and t3.attrelid     = t2.oid
                                                   and t3.attname      = p_subobject_name
                                                   and t4.objoid       = t2.oid
                                                   and t4.objsubid     = t3.attnum)
       else (select d.description                                   
               from (select nfc.f_db8obj_exist(p_object_type,p_schema,p_object_name) as o_id) g
                    join pg_catalog.pg_description d on d.objoid = g.o_id and d.objsubid = 0)
       end
$function$
;