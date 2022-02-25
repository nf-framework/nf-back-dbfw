CREATE OR REPLACE FUNCTION nfc.f4unit_files8tr()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$begin
if TG_OP = 'DELETE' and TG_WHEN = 'AFTER' then 
    begin
        delete from nfc.files k where k.id = old.file_id;
    exception when others then null;
    end;
end if;
-- корректный возврат
if TG_WHEN = 'BEFORE' then 
    if TG_OP in ('INSERT','UPDATE') then 
        return NEW;
    elsif TG_OP = 'DELETE' then 
        return OLD;
    end if;
else 
    return null;
end if;    
end;$function$
;