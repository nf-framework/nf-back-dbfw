CREATE OR REPLACE FUNCTION nfc.f4role_unitbpprivs8check(p_unitbp character varying)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
AS $function$
select true
 where exists (select null 
  from nfc.users u,
       nfc.userroles ur,
       nfc.role_unitprivs rup,
       nfc.role_unitbpprivs rubp
 where u.username = nfc.f_session_user()
   and ur.user_id = u.id 
   and ur.org_id = nullif(pg_catalog.current_setting('nf.org'),'')::bigint
   and rup.role_id = ur.role_id
   and rubp.pid = rup.id 
   and rubp.unitbp = p_unitbp)
$function$
;