CREATE OR REPLACE FUNCTION nfc.f_raise(p_msg text, VARIADIC p_params text[] DEFAULT NULL::text[])
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER COST 1
AS $function$
declare
  msg text;
begin
  --s_msg := core.f_txtmsg_l10n8translate(ps_msg::text);
  msg := p_msg;
  if array_lower(p_params, 1) is not null then
    for i in reverse array_upper(p_params, 1)..array_lower(p_params, 1) --чтобы $11 заменить раньше чем $1
    loop
      msg := replace(msg,'$'||i::text,coalesce(p_params[i],'NULL'));
    end loop;
  end if;
  raise '%', msg;
end;
$function$
;
comment on function nfc.f_raise(p_msg text, VARIADIC p_params text[]) is 'Вывод ошибки с подстановкой значений';