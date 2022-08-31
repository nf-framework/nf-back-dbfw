CREATE OR REPLACE FUNCTION nfc.f4users8change_password(p_org bigint, p_id bigint, p_password character varying)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$declare
    v_password text;
    v_extra json;
    v_username varchar;
begin
	perform nfc.f_bp8before('nfc.users.change_password', p_id::text, p_org, null, null);
    perform nfc.f4users8check(p_org, p_password);
    select extra, username into v_extra, v_username from nfc.users where id = p_id;
    if v_extra->>'logonKind' = 'pool' then
        v_password = crypt(p_password, gen_salt('bf', 10));
        update nfc.users set
            password = v_password
         where id = p_id;
    else
        perform nfc.f4users8mod_user(v_username, p_password);
    end if;
    perform nfc.f_bp8after('nfc.users.change_password', p_id::text, p_org, null, null);
end;$function$
;