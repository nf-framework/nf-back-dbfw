CREATE OR REPLACE FUNCTION nfc.f4unitlist8get_genobj(p_code character varying)
 RETURNS jsonb
 LANGUAGE sql
 STABLE SECURITY DEFINER COST 10
AS $function$
select 
    row_to_json(u)::jsonb ||
    json_build_object('bps',(select array_to_json(array_agg(row_to_json(bps)))
          from (select replace(b.code,b.unit||'.','') as code,
                       b.caption,
                       b.exec_function,
                       b.use_privs
                  from nfc.unitbps b 
                 where b.unit = u.code
                 order by 1) bps))::jsonb|| 
    coalesce(nfc.f_db8get_tableobj(split_part(u.code,'.',1),split_part(u.code,'.',2)),'{}')::jsonb
  from nfc.unitlist u where code = p_code
$function$
;