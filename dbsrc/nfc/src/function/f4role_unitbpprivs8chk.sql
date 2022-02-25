CREATE OR REPLACE FUNCTION nfc.f4role_unitbpprivs8chk(p_unitbp character varying, p_org bigint)
 RETURNS void
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER
AS $function$
declare 
    v_has boolean;
begin
    select true
      into v_has
     where exists (select null 
      from nfc.users u,
           nfc.userroles ur,
           nfc.role_unitprivs rup,
           nfc.role_unitbpprivs rubp
     where u.username = nfc.f_session_user()
       and ur.user_id = u.id 
       and ur.org_id = p_org
       and rup.role_id = ur.role_id
       and rubp.pid = rup.id 
       and rubp.unitbp = p_unitbp);
    if v_has is distinct from true then 
        perform nfc.f_raise(
            'Пользователь [$1] не имеет прав на действие [$2: $3] в организации [$4: $5]',
            nfc.f_session_user(),
            p_unitbp,
            coalesce(nfc.f4unitbps8get_caption(p_unitbp),'действия не существует'),
            p_org::text,
            coalesce((select j.caption from nfc.org j where j.id = p_org),'организации не существует')
        );
    end if;   
end;
$function$
;