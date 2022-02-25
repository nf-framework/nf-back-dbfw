CREATE OR REPLACE FUNCTION nfc.f4role_unitprivs8check(p_unit character varying)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
AS $function$
select true
 where exists (select null
  from nfc.users u,
       nfc.userroles ur,
       nfc.role_unitprivs rup
 where u.username = coalesce(nullif(pg_catalog.current_setting('nf.appuser',true),''),session_user)
   and ur.user_id = u.id 
   and ur.org_id = nullif(pg_catalog.current_setting('nf.org'),'')::bigint
   and rup.role_id = ur.role_id
   and rup.unit = p_unit)
$function$
;