CREATE OR REPLACE FUNCTION nflog.f4tables_actions8switch(p_schemaname text, p_tablename text, p_add_opt character varying DEFAULT 'n'::character varying, p_upd_opt character varying DEFAULT 'n'::character varying, p_del_opt character varying DEFAULT 'n'::character varying, p_store_query boolean DEFAULT false, p_excluded_cols text[] DEFAULT NULL::text[])
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
declare
    v_table_fullname text = p_schemaname||'.'||p_tablename;
    v_trg_txt text;
begin
    execute 'drop trigger if exists tr8tables_actions on ' || v_table_fullname::TEXT;
    if coalesce(p_add_opt,'n') in ('f','y')  
       or coalesce(p_upd_opt,'n') in ('f','y') 
       or coalesce(p_del_opt,'n') in ('f','y') then
        v_trg_txt = 'create trigger tr8tables_actions after insert or update or delete on ' || 
                     v_table_fullname::TEXT || 
                     ' for each row execute procedure nflog.f4tables_actions(' ||
                     quote_nullable(coalesce(p_add_opt,'n'))|| ',' ||
                     quote_nullable(coalesce(p_upd_opt,'n'))|| ',' ||
                     quote_nullable(coalesce(p_del_opt,'n'))|| ',' ||
                     quote_nullable(coalesce(p_store_query,false))|| ',' ||
                     quote_nullable(coalesce(p_excluded_cols::text,''))|| ');';
        execute v_trg_txt;
    end if;                 
end;
$function$
;