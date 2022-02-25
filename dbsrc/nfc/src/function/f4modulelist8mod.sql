CREATE OR REPLACE FUNCTION nfc.f4modulelist8mod(p_code character varying, p_caption character varying)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
declare 
    v_code varchar(60);
    v_caption varchar(600);
begin
    select code, caption into v_code, v_caption from nfc.modulelist where code = p_code;
    if v_code is null then 
        insert into nfc.modulelist (
            code,
            caption
        ) values (
            p_code,
            p_caption
        );
        execute format('create schema if not exists %I authorization nfadm;comment on schema %I is %L;',p_code,p_code,p_caption);
    else 
        if p_caption is distinct from v_caption then 
            update nfc.modulelist set
                caption = p_caption
             where code = p_code; 
        end if;       
        execute format('comment on schema %I is %L;',p_code,p_caption);
    end if;            
end;
$function$
;