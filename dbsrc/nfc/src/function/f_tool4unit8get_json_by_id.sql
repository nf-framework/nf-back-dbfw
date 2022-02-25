CREATE OR REPLACE FUNCTION nfc.f_tool4unit8get_json_by_id(p_unit text, p_unit_id text)
 RETURNS json
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$declare
    v_sql text;
    v_t text;
    v_alias text;
    v_palias text;
    v_subalias text;
    v_malias text;
    v_unit text = p_unit;
    r record;
    v_pk text;
    v_res json;
begin
v_malias = replace(v_unit,'.','_0_');
v_sql = format('select %s.*#%s# from %s %s', v_malias, v_malias, v_unit, v_malias); 
for r in 
with recursive un as (
    select code, pcode, 1 as lv from nfc.unitlist where pcode = v_unit
    union 
    select u.code, u.pcode, un.lv + 1
      from un,
           nfc.unitlist u
     where u.pcode = un.code
)
select * from un
loop
    v_alias = replace(r.code,'.','_'||r.lv::text||'_');
    v_palias = replace(r.pcode,'.','_'||(r.lv-1)::text||'_');
    v_subalias = replace(r.code,'.','__');
    v_t = 'coalesce((select array_agg(row_to_json('||v_alias||'_out.*)) from (select '||v_alias||'.*#'||v_alias||'# from '||r.code||' '||v_alias;
    v_t = v_t||' where '||v_alias||'.pid = '||v_palias||'.id) '||v_alias||'_out),  ''{}''::json[]) as '||v_subalias;
    v_sql = replace(v_sql,'#'||v_palias||'#',','||v_t||'#'||v_palias||'#');
end loop;
v_sql = regexp_replace(v_sql,'#.*?#','','g');

v_pk = nfc.f_db8get_primaryfield(split_part(v_unit,'.',1), split_part(v_unit,'.',2), true);
v_sql = v_sql||' where '||v_malias||'.'||split_part(v_pk,'::',1)||' = $1::'||split_part(v_pk,'::',2);
v_sql = 'select row_to_json(t) from ('||v_sql||') t';
-- raise notice '%', v_sql;
execute v_sql into v_res using p_unit_id;
return v_res;
end;
$function$
;