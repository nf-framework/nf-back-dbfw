CREATE OR REPLACE FUNCTION nfc.f_db8get_tableobj(p_schema text, p_tablename text)
 RETURNS json
 LANGUAGE sql
 STABLE SECURITY DEFINER
AS $function$
select public.nf_get_objsrc('table', p_schema, p_tablename)
$function$
;