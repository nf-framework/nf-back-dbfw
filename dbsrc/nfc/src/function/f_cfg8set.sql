CREATE OR REPLACE FUNCTION nfc.f_cfg8set(p_config text, p_value text, p_namespace text DEFAULT 'nf'::text)
 RETURNS void
 LANGUAGE plpgsql
 STABLE SECURITY DEFINER COST 1
AS $function$
begin 
  perform pg_catalog.set_config(p_namespace||'.'||p_config,p_value,false);
end;
$function$
;
comment on function nfc.f_cfg8set(p_config text, p_value text, p_namespace text) is 'Установка значения параметра сессии';