CREATE OR REPLACE FUNCTION nfc.f4modulelist8del(p_code character varying)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
begin
    delete from nfc.modulelist where code = p_code;
    execute 'drop schema if exists '||p_code||';';            
end;
$function$
;