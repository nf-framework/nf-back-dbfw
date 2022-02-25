CREATE OR REPLACE FUNCTION nfc.f_msg8prepare(p_msgcode text, p_namespace text DEFAULT NULL::text, VARIADIC p_replaces text[] DEFAULT '{text[]}'::text[])
 RETURNS text
 LANGUAGE sql
 STABLE SECURITY DEFINER COST 10
AS $function$
select json_build_object('msgcode',p_msgcode,'namespace',p_namespace,'replaces',p_replaces)::text
$function$
;