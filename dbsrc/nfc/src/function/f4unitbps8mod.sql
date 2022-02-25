CREATE OR REPLACE FUNCTION nfc.f4unitbps8mod(p_code character varying, p_caption character varying, p_unit character varying, p_exec_function character varying DEFAULT NULL::character varying, p_use_privs boolean DEFAULT NULL::boolean)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
declare 
    v_code varchar(60);
begin
    select code into v_code from nfc.unitbps where code = p_code;
    if v_code is null then 
        insert into nfc.unitbps (
            code,
            caption,
            unit,
            exec_function,
            use_privs
        ) values (
            p_code,
            p_caption,
            p_unit,
            p_exec_function,
            p_use_privs
        );
    else 
        update nfc.unitbps set
            caption = p_caption,
            unit = p_unit,
            exec_function = p_exec_function,
            use_privs = p_use_privs
         where code = p_code;   
    end if;            
end;
$function$
;