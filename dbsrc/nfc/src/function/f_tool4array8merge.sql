CREATE OR REPLACE FUNCTION nfc.f_tool4array8merge(arr1 anyarray, arr2 anyarray)
 RETURNS anyarray
 LANGUAGE sql
 IMMUTABLE
AS $function$
    select array_agg(distinct elem order by elem)
    from (
        select unnest(arr1) elem 
        union
        select unnest(arr2)
    ) s
$function$
;