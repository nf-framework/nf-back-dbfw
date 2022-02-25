CREATE OR REPLACE FUNCTION nfc.f_id()
 RETURNS bigint
 LANGUAGE sql
 SECURITY DEFINER COST 1
AS $function$
select nextval('nfc.s_main')::bigint;
$function$
;