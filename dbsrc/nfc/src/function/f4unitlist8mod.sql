CREATE OR REPLACE FUNCTION nfc.f4unitlist8mod(p_code character varying, p_caption character varying, p_pcode character varying, p_mdl character varying, p_opt json)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
declare 
    v_code varchar(60);
    v_opt json := p_opt::jsonb - '__old';
begin
    select code into v_code from nfc.unitlist where code = p_code;
    if v_code is null then 
        insert into nfc.unitlist (
            code,
            caption,
            pcode,
            mdl,
            opt 
        ) values (
            p_code,
            p_caption,
            nullif(p_pcode,''),
            p_mdl,
            v_opt 
        );
    else 
        update nfc.unitlist set
            caption = p_caption,
            pcode = nullif(p_pcode,''),
            mdl = p_mdl,
            opt = v_opt
         where code = p_code;   
    end if;            
end;
$function$
;