CREATE OR REPLACE FUNCTION nfc.f_msg8nofound(p_id bigint, p_unit character varying)
 RETURNS void
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER COST 1
AS $function$
begin
    raise '%', nfc.f_msg8prepare('', '', coalesce(nfc.f4unitlist8get_caption(p_unit),coalesce(p_unit,'<NULL>')),coalesce(p_id::text,'<NULL>'));
end;
$function$
;