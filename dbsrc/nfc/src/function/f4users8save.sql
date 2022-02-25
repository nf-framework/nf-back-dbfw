CREATE OR REPLACE FUNCTION nfc.f4users8save(p_org bigint, p_username character varying, p_fullname character varying, p_password character varying DEFAULT NULL::character varying, p_extra jsonb DEFAULT NULL::jsonb)
 RETURNS bigint
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
declare
    v_id bigint;
begin
	perform nfc.f_bp8before('nfc.users.add', null::text, p_org, null, null);
    if p_password is not null then 
        perform nfc.f4users8check(p_org, p_password);
    end if;    
    insert into nfc.users (
        username,
        fullname
    ) values (
        p_username,
        p_fullname
    ) returning id into v_id;
    --
    perform nfc.f4users8mod_user(p_username, p_password);
    perform nfc.f_bp8after('nfc.users.add', v_id::text, p_org, null, null);
    return v_id;
end;
$function$
;