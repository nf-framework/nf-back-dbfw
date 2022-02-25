CREATE OR REPLACE FUNCTION nfc.f4ui_customization8user_save(p_key text, p_value jsonb)
 RETURNS void
 LANGUAGE sql
 SECURITY DEFINER
AS $function$insert into nfc.ui_customization (scope,key,value) values ('u:'||nfc.f_session_user(),p_key,p_value)  
on conflict on constraint uk4ui_customization do update set value = excluded.value
$function$
;