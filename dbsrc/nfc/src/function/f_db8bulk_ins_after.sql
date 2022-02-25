CREATE OR REPLACE FUNCTION nfc.f_db8bulk_ins_after()
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
declare
    r record;
begin
    for r in (select script from temp8bulk_ins_scripts)
    loop
        execute r.script;
    end loop;
end;
$function$
;