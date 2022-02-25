CREATE OR REPLACE FUNCTION nfc.f_db8bulk_ins_before(p_schema text, p_tablename text)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
declare
    r record;
    v_text text;
    v_hasright boolean;
begin
    create temp table if not exists temp8bulk_ins_scripts (script text) 
    on commit drop;
    for r in (select c2.relname as name,
                   n2.nspname as schema,
                   pg_catalog.pg_get_indexdef(i.indexrelid, 0, true) definition
              from pg_catalog.pg_index i
                   join pg_catalog.pg_class c2 on (c2.oid = i.indexrelid) 
                   join pg_catalog.pg_namespace n2 on (n2.oid = c2.relnamespace)
                   left join pg_catalog.pg_tablespace t2 on (t2.oid = c2.reltablespace)
             where i.indrelid = nfc.f_db8obj_exist('table', p_schema, p_tablename)
               and not exists (select null from pg_catalog.pg_constraint con where con.conrelid = i.indrelid and con.conindid = i.indexrelid and contype in ('p','u','x'))
             order by c2.relname)
    loop
        insert into temp8bulk_ins_scripts values (r.definition);
        v_text = format('drop index %I.%I cascade;',r.schema,r.name);
        execute v_text;
    end loop;
    -- проверить наличие права у nfusr на вставку записей и временно выдать, если нет
    select true
      into v_hasright
      from (select (aclexplode(coalesce(c.relacl, acldefault('r',c.relowner)))).grantor AS grantor,
                   (aclexplode(coalesce(c.relacl, acldefault('r',c.relowner)))).grantee AS grantee,
                   (aclexplode(coalesce(c.relacl, acldefault('r',c.relowner)))).privilege_type AS privilege_type
              from pg_catalog.pg_class c,
                   pg_catalog.pg_namespace nc
             where c.relnamespace = nc.oid 
               and c.relkind = 'r'
               and c.relname = p_tablename
               and nc.nspname = p_schema) acl
           join pg_catalog.pg_authid grantor on (grantor.oid = acl.grantor and grantor.rolname = 'nfadm')
           join pg_catalog.pg_authid grantee on (grantee.oid = acl.grantee and grantee.rolname = 'nfusr')
     where acl.privilege_type = 'SELECT';
    if v_hasright is null then 
        v_text = format('grant insert on %I.%I to nfusr', p_schema, p_tablename);
        execute v_text;
        v_text = format('revoke insert on %I.%I from nfusr', p_schema, p_tablename);
        insert into temp8bulk_ins_scripts values (v_text);
    end if; 
end;
$function$
;