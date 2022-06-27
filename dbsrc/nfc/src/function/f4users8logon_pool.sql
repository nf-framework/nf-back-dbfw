CREATE OR REPLACE FUNCTION nfc.f4users8logon_pool(p_user character varying, p_password character varying)
 RETURNS json
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
declare
    v_org int8;
    v_user_id int8;
    v_grp int8;
    v_userforms text;
begin
    -- Если пользователю доступно только одна учетная единица, сразу вернем её
    select case when min(ur.org_id) = max(ur.org_id) then min(ur.org_id) else null end,
    	   min(u.id)
      into v_org,
      	   v_user_id
      from nfc.users u
           left join nfc.userroles ur on ur.user_id = u.id
     where u.username = p_user
       and u.password = crypt(p_password, u.password);  
    if v_org is not null then 
        select grp_id, userforms
          into v_grp, v_userforms 
          from nfc.org 
         where id = v_org;
    end if;
    
    return json_build_object(
        'org', v_org,
        'user_id', v_user_id,
        'grp', v_grp,
        'userforms', v_userforms
    );
end;
$function$
;