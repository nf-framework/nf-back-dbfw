CREATE OR REPLACE FUNCTION nfc.f4role_unitprivs8add(p_org bigint, p_role_id bigint, p_unit character varying, p_all boolean DEFAULT false)
 RETURNS bigint
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
declare
    v_id bigint;
    bps record;
begin
    perform nfc.f_bp8before('nfc.role_unitprivs.add', null::text, p_org, null, null);
        insert into nfc.role_unitprivs (
            role_id,
            unit
        ) values (
            p_role_id,
            p_unit
        ) returning id into v_id;
    if p_all then 
        for bps in (select code from nfc.unitbps where unit = p_unit)
        loop 
            insert into nfc.role_unitbpprivs (pid, unitbp)
            values (v_id, bps.code);
        end loop;
    end if;
    perform nfc.f_bp8after('nfc.role_unitprivs.add', v_id::text, p_org, null, null);
    return v_id;
end;
$function$
;