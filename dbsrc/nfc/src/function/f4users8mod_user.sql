CREATE OR REPLACE FUNCTION nfc.f4users8mod_user(p_username character varying, p_password character varying DEFAULT NULL::character varying)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
begin
    --
    if nfc.f_db8obj_exist('role',p_username) is null then 
        execute format('create role %I login in role nfusr',p_username);
    end if;
    if p_password is not null then 
        execute format('alter role %I password %s',p_username,quote_literal(p_password));
    end if;
end;
$function$
;
comment on function nfc.f4users8mod_user(p_username character varying, p_password character varying) is 'Работа с ролью postgresql при модификации пользователя';