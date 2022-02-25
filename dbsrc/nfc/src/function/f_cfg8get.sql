CREATE OR REPLACE FUNCTION nfc.f_cfg8get(p_config text, p_namespace text DEFAULT 'nf'::text)
 RETURNS text
 LANGUAGE plpgsql
 STABLE STRICT SECURITY DEFINER COST 1
AS $function$
declare
  s_value                  text;
begin
  select nullif(pg_catalog.current_setting(p_namespace||'.'||p_config)::text,''::text) into s_value;
  if s_value = '' then return null; else return s_value; end if;
exception when others then return null;
end;
$function$
;
comment on function nfc.f_cfg8get(p_config text, p_namespace text) is 'Получение значения параметра сессии';