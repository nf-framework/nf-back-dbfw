CREATE OR REPLACE FUNCTION nfc.f_tool4jsonb8diff(p_old jsonb, p_new jsonb)
 RETURNS jsonb
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$declare 
    v_diff jsonb = p_new;
    r record;
begin
    for r in select * from jsonb_each(p_new) 
    loop
        if p_old @> jsonb_build_object(r.key, r.value) then
            v_diff = v_diff - r.key;
        end if;
    end loop;
    return v_diff;
end;$function$
;