CREATE OR REPLACE FUNCTION nfc.f_tool4date8btw(p_date_to timestamp with time zone, p_date_from timestamp with time zone, p_unit character varying DEFAULT 'year'::character varying)
 RETURNS integer
 LANGUAGE sql
AS $function$
select 
  (case lower($3) 
    when 'year' then extract (year from age($1,$2))
    when 'month' then extract (year from age($1,$2))*12 + extract (month from age($1,$2))
    when 'week' then trunc(extract(day from $1 - $2)/7)
    when 'day' then extract(day from $1 - $2)
    when 'hour' then extract(day from $1 - $2)*24 + extract(hour from $1 - $2)
    when 'minute' then trunc(extract(epoch from $1 - $2)/60)
    else null
  end)::integer
$function$
;