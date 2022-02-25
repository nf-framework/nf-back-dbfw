CREATE OR REPLACE FUNCTION nfc.f4users8del(p_org bigint, p_id bigint)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
declare
    v_username varchar(60);
begin
    perform nfc.f_bp8before('nfc.users.del', p_id::text, p_org, null, null);
    delete from nfc.users
     where id = p_id returning username into v_username;
    if not found then perform nfc.f_msg8nofound(p_id,'nfc.users'); end if;
    if nfc.f_db8obj_exist('role',v_username) is not null then 
        execute format('drop role %I;',v_username);
    end if;
    perform nfc.f_bp8after('nfc.users.del', p_id::text, p_org, null, null);
end;
$function$
;