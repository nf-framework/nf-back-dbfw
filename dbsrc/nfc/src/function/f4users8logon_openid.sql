CREATE OR REPLACE FUNCTION nfc.f4users8logon_openid(p_username character varying, p_fullname character varying, p_extra json)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$declare
    v_user nfc.users%rowtype;
    v_grp int8;
    v_userforms text;
    v_roles text[];
    v_org int8 = (p_extra->>'_org')::int8;
    v_roles_scope text = p_extra->>'_roles_scope';
    v_ text;
begin
    select array_agg(p)
      into v_roles
      from json_array_elements_text(p_extra->'_roles') as p(p);
    select * into v_user from nfc.users where username = p_username;
    if v_user is null then
        insert into nfc.users (username, fullname, extra) 
            values (p_username, p_fullname, p_extra) 
            returning * into v_user;
        insert into nfc.userroles (user_id,role_id,org_id)
        (select v_user.id, r.id, v_org
           from nfc.roles r
          where r.code = any(v_roles));
    else 
        if (p_fullname is distinct from v_user.fullname or
            p_extra::jsonb is distinct from v_user.extra) then 
            update nfc.users set 
                fullname = p_fullname,
                extra = p_extra
             where id = v_user.id;
        end if;
        -- убрать роли, которые входят в scope ролей интеграции и не пришли на вход
        if v_roles_scope is not null then
            delete from nfc.userroles ur
             using nfc.roles r 
             where r.id = ur.role_id
               and ur.user_id = v_user.id
               and ur.org_id = v_org
               and r.code like v_roles_scope||'%'
               and (r.code != all(v_roles) or v_roles is null);
        end if;
        -- добавить пришедшие роли
        insert into nfc.userroles (user_id,role_id,org_id)
        (select v_user.id, r.id, v_org
           from nfc.roles r
          where r.code = any(v_roles)
            and not exists (select null from nfc.userroles uo where uo.user_id = v_user.id and uo.org_id = v_org and uo.role_id = r.id));
        --
        if v_org is not null then 
            select grp_id, userforms
              into v_grp, v_userforms 
              from nfc.org 
             where id = v_org;
        end if;
    end if;    
    return jsonb_build_object(
        'org', v_org,
        'grp', v_grp,
        'userforms', v_userforms,
        'user_id', v_user.id
    );
end;
$function$
;