CREATE OR REPLACE FUNCTION nfc.f_init(p_username character varying, p_password character varying, p_rolename text DEFAULT NULL::text, p_options json DEFAULT NULL::json)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
declare
    v_rolename text;
    v_grp_id bigint;
    v_org_id bigint;
    v_user_id bigint;
    v_role_id bigint;
    v_rup bigint;
    v_logon_kind text;
    v_password text;
begin
    v_logon_kind = coalesce(p_options->>'logonKind', 'user');
    if v_logon_kind = 'user' then
        if nfc.f_db8obj_exist('role',p_username) is null then 
            execute format('create role %I login in role nfusr',p_username);
            if p_password is not null then 
                execute format('alter role %I password %s',p_username,quote_literal(p_password));
            end if;
        end if;
    else 
        v_password = crypt(p_password, gen_salt('bf', 10));
    end if;
    select id into v_user_id from nfc.users where username = p_username;
    if v_user_id is null then  
        insert into nfc.users (username, fullname, password, extra)
        values (p_username, p_username, v_password, p_options) returning id into v_user_id;
    end if;
    v_rolename = coalesce(p_rolename,p_username);
    select id into v_role_id from nfc.roles where code = v_rolename;    
    if v_role_id is null then
        insert into nfc.roles (code, caption)
        values (v_rolename, v_rolename) returning id into v_role_id;
    end if;    
    --
    select id into v_org_id from nfc.org limit 1;
    if v_org_id is null then 
        insert into nfc.grp (code, caption)
        values ('grp', 'grp') returning id into v_grp_id;
        insert into nfc.org (code, caption, grp_id)
        values ('org', 'org', v_grp_id) returning id into v_org_id;
    end if;    
    --
    if not exists (select null from nfc.userroles u where u.user_id = v_user_id and u.role_id = v_role_id) then 
        insert into nfc.userroles (org_id, user_id, role_id)
        values (v_org_id, v_user_id, v_role_id);
    end if;
    -- nfc.role_unitprivs
    select id into v_rup from nfc.role_unitprivs u where u.role_id = v_role_id and u.unit = 'nfc.role_unitprivs';
    if v_rup is null then
   		insert into nfc.role_unitprivs (role_id, unit)
        values (v_role_id, 'nfc.role_unitprivs') returning id into v_rup;
    end if;
    if not exists (select null from nfc.role_unitbpprivs where pid = v_rup and unitbp = 'nfc.role_unitprivs.add') then 
        insert into nfc.role_unitbpprivs (pid, unitbp)
        values (v_rup, 'nfc.role_unitprivs.add');
    end if;
    if not exists (select null from nfc.role_unitbpprivs where pid = v_rup and unitbp = 'nfc.role_unitprivs.del') then
        insert into nfc.role_unitbpprivs (pid, unitbp)
        values (v_rup, 'nfc.role_unitprivs.del');
    end if;  
    -- nfc.role_unitbpprivs
    select id into v_rup from nfc.role_unitprivs u where u.role_id = v_role_id and u.unit = 'nfc.role_unitbpprivs';
    if v_rup is null then
   		insert into nfc.role_unitprivs (role_id, unit)
        values (v_role_id, 'nfc.role_unitbpprivs') returning id into v_rup;
    end if;
    if not exists (select null from nfc.role_unitbpprivs where pid = v_rup and unitbp = 'nfc.role_unitbpprivs.add') then 
        insert into nfc.role_unitbpprivs (pid, unitbp)
        values (v_rup, 'nfc.role_unitbpprivs.add');
    end if;
    if not exists (select null from nfc.role_unitbpprivs where pid = v_rup and unitbp = 'nfc.role_unitbpprivs.del') then
        insert into nfc.role_unitbpprivs (pid, unitbp)
        values (v_rup, 'nfc.role_unitbpprivs.del');
    end if;
    -- nfc.roles
    select id into v_rup from nfc.role_unitprivs u where u.role_id = v_role_id and u.unit = 'nfc.roles';
    if v_rup is null then
   		insert into nfc.role_unitprivs (role_id, unit)
        values (v_role_id, 'nfc.roles') returning id into v_rup;
    end if;
    if not exists (select null from nfc.role_unitbpprivs where pid = v_rup and unitbp = 'nfc.roles.add') then 
        insert into nfc.role_unitbpprivs (pid, unitbp)
        values (v_rup, 'nfc.roles.add');
    end if;
    if not exists (select null from nfc.role_unitbpprivs where pid = v_rup and unitbp = 'nfc.roles.upd') then 
        insert into nfc.role_unitbpprivs (pid, unitbp)
        values (v_rup, 'nfc.roles.upd');
    end if;    
    if not exists (select null from nfc.role_unitbpprivs where pid = v_rup and unitbp = 'nfc.roles.del') then
        insert into nfc.role_unitbpprivs (pid, unitbp)
        values (v_rup, 'nfc.roles.del');
    end if;
    -- nfc.users
    select id into v_rup from nfc.role_unitprivs u where u.role_id = v_role_id and u.unit = 'nfc.users';
    if v_rup is null then
   		insert into nfc.role_unitprivs (role_id, unit)
        values (v_role_id, 'nfc.users') returning id into v_rup;
    end if;
    if not exists (select null from nfc.role_unitbpprivs where pid = v_rup and unitbp = 'nfc.users.add') then 
        insert into nfc.role_unitbpprivs (pid, unitbp)
        values (v_rup, 'nfc.users.add');
    end if;
    if not exists (select null from nfc.role_unitbpprivs where pid = v_rup and unitbp = 'nfc.users.upd') then 
        insert into nfc.role_unitbpprivs (pid, unitbp)
        values (v_rup, 'nfc.users.upd');
    end if;    
    if not exists (select null from nfc.role_unitbpprivs where pid = v_rup and unitbp = 'nfc.users.del') then
        insert into nfc.role_unitbpprivs (pid, unitbp)
        values (v_rup, 'nfc.users.del');
    end if;    
    -- nfc.userroles
    select id into v_rup from nfc.role_unitprivs u where u.role_id = v_role_id and u.unit = 'nfc.userroles';
    if v_rup is null then
   		insert into nfc.role_unitprivs (role_id, unit)
        values (v_role_id, 'nfc.userroles') returning id into v_rup;
    end if;
    if not exists (select null from nfc.role_unitbpprivs where pid = v_rup and unitbp = 'nfc.userroles.add') then 
        insert into nfc.role_unitbpprivs (pid, unitbp)
        values (v_rup, 'nfc.userroles.add');
    end if;
    if not exists (select null from nfc.role_unitbpprivs where pid = v_rup and unitbp = 'nfc.userroles.del') then
        insert into nfc.role_unitbpprivs (pid, unitbp)
        values (v_rup, 'nfc.userroles.del');
    end if; 
    -- nfc.menuroles
    select id into v_rup from nfc.role_unitprivs u where u.role_id = v_role_id and u.unit = 'nfc.menuroles';
    if v_rup is null then
   		insert into nfc.role_unitprivs (role_id, unit)
        values (v_role_id, 'nfc.menuroles') returning id into v_rup;
    end if;
    if not exists (select null from nfc.role_unitbpprivs where pid = v_rup and unitbp = 'nfc.menuroles.add') then 
        insert into nfc.role_unitbpprivs (pid, unitbp)
        values (v_rup, 'nfc.menuroles.add');
    end if;
    if not exists (select null from nfc.role_unitbpprivs where pid = v_rup and unitbp = 'nfc.menuroles.del') then
        insert into nfc.role_unitbpprivs (pid, unitbp)
        values (v_rup, 'nfc.menuroles.del');
    end if; 
    --nfc.ui_customization
    select id into v_rup from nfc.role_unitprivs u where u.role_id = v_role_id and u.unit = 'nfc.ui_customization';
    if v_rup is null then
   		insert into nfc.role_unitprivs (role_id, unit)
        values (v_role_id, 'nfc.ui_customization') returning id into v_rup;
    end if;
    if not exists (select null from nfc.role_unitbpprivs where pid = v_rup and unitbp = 'nfc.ui_customization.add') then 
        insert into nfc.role_unitbpprivs (pid, unitbp)
        values (v_rup, 'nfc.ui_customization.add');
    end if;
    if not exists (select null from nfc.role_unitbpprivs where pid = v_rup and unitbp = 'nfc.ui_customization.upd') then 
        insert into nfc.role_unitbpprivs (pid, unitbp)
        values (v_rup, 'nfc.ui_customization.upd');
    end if;    
    if not exists (select null from nfc.role_unitbpprivs where pid = v_rup and unitbp = 'nfc.ui_customization.del') then
        insert into nfc.role_unitbpprivs (pid, unitbp)
        values (v_rup, 'nfc.ui_customization.del');
    end if;    
    -- nfc.org
    if not exists (select null from nfc.role_unitprivs rup
                    where rup.role_id = v_role_id and
                    	  rup.unit = 'nfc.org') then
    	insert into nfc.role_unitprivs (role_id, unit)
        values (v_role_id, 'nfc.org');
    end if;
    if not exists (select null from nfc.role_unitprivs rup
                    where rup.role_id = v_role_id and
                    	  rup.unit = 'nfc.unitlist') then
    	insert into nfc.role_unitprivs (role_id, unit)
        values (v_role_id, 'nfc.unitlist');
    end if;
    if not exists (select null from nfc.role_unitprivs rup
                    where rup.role_id = v_role_id and
                    	  rup.unit = 'nfc.modulelist') then
    	insert into nfc.role_unitprivs (role_id, unit)
        values (v_role_id, 'nfc.modulelist');
    end if;
    if not exists (select null from nfc.role_unitprivs rup
                    where rup.role_id = v_role_id and
                    	  rup.unit = 'nfc.unitbps') then
    	insert into nfc.role_unitprivs (role_id, unit)
        values (v_role_id, 'nfc.unitbps');
    end if;
    -- права на пункты меню
    -- Пользователи
    if not exists (select null from nfc.menuroles mr where mr.role_id = v_role_id and mr.menuguid = '6a56c7c6-16b1-45d7-bbc2-0afebaf47e69') then
        insert into nfc.menuroles (role_id, menuguid)
        values (v_role_id, '6a56c7c6-16b1-45d7-bbc2-0afebaf47e69');
    end if;
    -- Роли
    if not exists (select null from nfc.menuroles mr where mr.role_id = v_role_id and mr.menuguid = 'b6afe25d-a22b-4092-891d-6e3d3a5ca985') then
        insert into nfc.menuroles (role_id, menuguid)
        values (v_role_id, 'b6afe25d-a22b-4092-891d-6e3d3a5ca985');
    end if;
    --  О системе
    if not exists (select null from nfc.menuroles mr where mr.role_id = v_role_id and mr.menuguid = 'a6a28f08-c30f-4375-8bfe-e91845b46dbe') then
        insert into nfc.menuroles (role_id, menuguid)
        values (v_role_id, 'a6a28f08-c30f-4375-8bfe-e91845b46dbe');
    end if;
end;
$function$
;