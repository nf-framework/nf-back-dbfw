CREATE OR REPLACE FUNCTION nfc.f4unitbps8del(p_code character varying)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
begin
    delete from nfc.unitbps where code = p_code;            
end;
$function$
;