CREATE OR REPLACE FUNCTION nfc.f_broker8exec(p_action text, p_params json, p_options json DEFAULT '{}'::json)
 RETURNS text
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$declare
    v_unitbp text = p_options->>'unitbp';
    v_act text = p_options->>'act';
    v_pk_field text = p_options->>'pkField';
    v_divide_type text = p_options->>'divideType';
    v_use_privs boolean = p_options->>'usePrivs';
    v_org int8;
    v_grp int8;
    v_unit_id text;
begin
    v_org = p_params->>'org';
    if v_org is null then v_org = nfc.f_cfg8get('org'); end if;
    if v_divide_type = 'grp' then 
        select l.grp_id into v_grp from nfc.org l where l.id = v_org;
    end if;
    v_unit_id = p_params->>v_pk_field;
    -- выполнение
    perform nfc.f_bp8before(v_unitbp, v_unit_id, v_org, v_grp, null, v_use_privs);
    if v_act = 'add' then
        execute p_action into v_unit_id using p_params,(case when v_divide_type = 'org' then v_org when v_divide_type = 'grp' then v_grp else null end);
    else 
        execute p_action using p_params,v_unit_id,(case when v_divide_type = 'org' then v_org when v_divide_type = 'grp' then v_grp else null end);
    end if;
    perform nfc.f_bp8after(v_unitbp, v_unit_id, v_org, v_grp, null);
    return v_unit_id;
end;
$function$
;