CREATE OR REPLACE FUNCTION nfc.f_session_user()
 RETURNS text
 LANGUAGE sql
 STABLE SECURITY DEFINER
AS $function$select coalesce(nullif(pg_catalog.current_setting('nf.appuser',true),''),session_user)$function$
;