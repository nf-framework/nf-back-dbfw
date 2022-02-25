CREATE OR REPLACE FUNCTION nfc.f4unitlist8del(p_code character varying)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
begin
    delete from nfc.unitlist where code = p_code;            
end;
$function$
;