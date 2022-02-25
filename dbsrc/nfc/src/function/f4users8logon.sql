CREATE OR REPLACE FUNCTION nfc.f4users8logon(OUT p_org bigint, OUT p_grp bigint, OUT p_userforms character varying, OUT p_user_id bigint)
 RETURNS record
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
declare
begin
    -- Если пользователю доступно только одна учетная единица, сразу вернем её
    select case when min(ur.org_id) = max(ur.org_id) then min(ur.org_id) else null end,
    	   min(u.id)
      into p_org,
      	   p_user_id
      from nfc.users u,
           nfc.userroles ur 
     where u.username = session_user      
       and ur.user_id = u.id;
    -- session_user - важно. Именно так определяется изначальный пользователь, стартовавший сессию    
    if p_org is not null then 
        select grp_id, userforms
          into p_grp, p_userforms 
          from nfc.org 
         where id = p_org;
    end if;
end;
$function$
;