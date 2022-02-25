CREATE OR REPLACE FUNCTION nfc.f4unitbps8get_caption(p_code character varying, p_full boolean DEFAULT true)
 RETURNS character varying
 LANGUAGE sql
 STABLE SECURITY DEFINER COST 10
AS $function$
select (case when p_full then 
(select u.caption||' * '||b.caption 
   from nfc.unitbps b 
        join nfc.unitlist u on u.code = b.unit
  where b.code = p_code)
else 
(select b.caption 
   from nfc.unitbps b 
  where b.code = p_code)
end)
$function$
;