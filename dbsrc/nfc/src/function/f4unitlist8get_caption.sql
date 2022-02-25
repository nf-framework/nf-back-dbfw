CREATE OR REPLACE FUNCTION nfc.f4unitlist8get_caption(p_code character varying)
 RETURNS character varying
 LANGUAGE sql
 STABLE SECURITY DEFINER COST 10
AS $function$
select caption from nfc.unitlist where code = p_code
$function$
;