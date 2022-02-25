CREATE OR REPLACE FUNCTION nfc.f4options8get(p_code character varying, p_date date DEFAULT (now())::date)
 RETURNS text
 LANGUAGE sql
 STABLE SECURITY DEFINER
AS $function$
select r.val
  from (select e.lv,e.val from (
select 0 as lv,
       t.val
  from nfc.options t 
 where t.code = p_code
 union all
 select case when tt.user_id is not null then 3
             else case when tt.org_id is not null then 2 
                  else 1 end end as lv,
        tt.val
   from nfc.options_values tt  
  where tt.option = p_code
    and tt.date_begin <= p_date
    and (tt.date_end >= p_date or tt.date_end is null)
    and (tt.org_id is null or tt.org_id = nullif(pg_catalog.current_setting('nf.org'),'')::bigint) 
    and (tt.user_id is null or (tt.user_id = (select id from nfc.users where username = nfc.f_session_user()) 
                                and tt.org_id = nullif(pg_catalog.current_setting('nf.org'),'')::bigint))) e
 order by e.lv desc) r limit 1
$function$
;