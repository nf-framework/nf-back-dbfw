CREATE OR REPLACE FUNCTION nfc.f_tool4array8min(anyarray, anyelement)
 RETURNS anyelement
 LANGUAGE sql
 IMMUTABLE
AS $function$SELECT min(i) FROM unnest($1) i where ($2 is null or $2 < i)$function$
;