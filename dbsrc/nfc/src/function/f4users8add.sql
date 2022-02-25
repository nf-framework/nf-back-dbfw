CREATE OR REPLACE FUNCTION nfc.f4users8add(p_org bigint, p_username character varying, p_fullname character varying, p_extra jsonb DEFAULT NULL::jsonb)
 RETURNS bigint
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
declare
    v_id bigint;
begin
	perform nfc.f_bp8before('nfc.users.add', null::text, p_org, null, null);
    insert into nfc.users (
        username,
        fullname,
        extra
    ) values (
        p_username,
        p_fullname,
        p_extra
    ) returning id into v_id;
    --
    perform nfc.f_bp8after('nfc.users.add', v_id::text, p_org, null, null);
    return v_id;
end;
$function$
;