CREATE OR REPLACE FUNCTION nfc.f4users8save(p_org bigint, p_username character varying, p_fullname character varying, p_password character varying DEFAULT NULL::character varying, p_extra jsonb DEFAULT NULL::jsonb)
 RETURNS bigint
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
declare
    v_id bigint;
    v_password text;
begin
	perform nfc.f_bp8before('nfc.users.add', null::text, p_org, null, null);
    if p_password is not null then 
        perform nfc.f4users8check(p_org, p_password);
        if p_extra->>'logonKind' = 'pool' then
            v_password = crypt(p_password, gen_salt('bf', 10));
        end if;
    end if;    
    insert into nfc.users (
        username,
        fullname,
        password,
        extra
    ) values (
        p_username,
        p_fullname,
        v_password,
        p_extra
    ) returning id into v_id;
    --
    if p_extra->>'logonKind' = 'user' then
        perform nfc.f4users8mod_user(p_username, p_password);
    end if;
    perform nfc.f_bp8after('nfc.users.add', v_id::text, p_org, null, null);
    return v_id;
end;
$function$
;