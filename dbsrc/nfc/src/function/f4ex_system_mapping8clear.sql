CREATE OR REPLACE FUNCTION nfc.f4ex_system_mapping8clear()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$declare
    v_in_namespace text;
    v_in_id text;
begin
    -- вешать только после действия удаления
    if not(TG_WHEN = 'AFTER' and TG_OP = 'DELETE') then 
        raise 'Триггер на очистку маппинга должен быть только на ПОСЛЕ УДАЛЕНИЯ.';
    end if;
    v_in_namespace = lower(TG_TABLE_SCHEMA::text)||'.'||lower(TG_TABLE_NAME::text);
    v_in_id = OLD.id::text;
    delete from nfc.ex_system_mapping w where w.in_namespace = v_in_namespace and w.in_id = v_in_id;
    return null;
end;$function$
;