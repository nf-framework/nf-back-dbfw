CREATE OR REPLACE FUNCTION nfc.f_table_check_pk_value(p_schema text, p_name text, p_pk text, p_pk_value text)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$declare
    v_sql text;
    v_fnd bool;
begin
    v_sql = format('select 1 from %I.%I where %I = $1::%s', p_schema, p_name, split_part(p_pk,'::',1), split_part(p_pk,'::',2));
    execute v_sql into v_fnd using p_pk_value;
    return v_fnd;
end;$function$
;