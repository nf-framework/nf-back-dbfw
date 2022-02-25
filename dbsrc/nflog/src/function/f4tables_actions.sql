CREATE OR REPLACE FUNCTION nflog.f4tables_actions()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
declare
    r_ta nflog.tables_actions;
    r record;
    v_action char(1);
    v_action_opt text;
    v_excluded_cols text[] = ARRAY[]::text[];
    v_row_data jsonb;
    v_pk text;
begin
    if TG_OP = 'UPDATE' then 
        v_action = 'u';
        v_action_opt = TG_ARGV[1]::text;
    elsif TG_OP = 'INSERT' then 
        v_action = 'a';
        v_action_opt = TG_ARGV[0]::text;
    elsif TG_OP = 'DELETE' then 
        v_action = 'd';
        v_action_opt = TG_ARGV[2]::text;
    end if;
    if v_action_opt = 'n' then return null; end if;
    r_ta = row(
        nextval('nflog.s4tables_actions'),            -- id
        TG_TABLE_SCHEMA::text,                        -- schemaname
        TG_TABLE_NAME::text,                          -- tablename
        nfc.f_session_user()||'['||session_user||']', -- session_user_name
        current_timestamp,                            -- ts_transact_started
        clock_timestamp(),                            -- ts_log
        current_setting('application_name'),          -- application_name
        inet_client_addr(),                           -- client_addr
        inet_client_port(),                           -- client_port
        null,                                         -- client_query
        v_action,                                     -- action
        null,                                         -- row_data,
        null,                                         -- row_changed_data,
        null                                          -- row_id
    );
    /*
    v_a = TG_ARGV[0]::text;
    v_u = TG_ARGV[1]::text;
    v_d = TG_ARGV[2]::text;
    */
    if TG_ARGV[3]::boolean then 
        r_ta.client_query = current_query();
    end if;
    if TG_ARGV[4] != '' then
        v_excluded_cols = TG_ARGV[4]::text[];
    end if;
    if v_action = 'u' then
        v_row_data = row_to_json(OLD.*);
    	if v_action_opt = 'f' then
            r_ta.row_data = v_row_data;
            r_ta.row_changed_data = row_to_json(NEW.*);
            for r in select * from jsonb_each(r_ta.row_changed_data) 
            loop
                if r_ta.row_data @> jsonb_build_object(r.key, r.value) then
                    r_ta.row_changed_data = r_ta.row_changed_data - r.key;
                end if;
            end loop;
        end if;  
    elsif v_action = 'd' then
        v_row_data = row_to_json(OLD.*); 
    	if v_action_opt = 'f' then
            r_ta.row_data = v_row_data;
        end if;  
    elsif v_action = 'a' then
        v_row_data = row_to_json(NEW.*);
    	if v_action_opt = 'f' then
            r_ta.row_data = v_row_data;
        end if;
    else
        return null;
    end if;
    select a.attname into v_pk
      from pg_catalog.pg_index i
           join pg_attribute a on (a.attrelid = i.indrelid and a.attnum = i.indkey[0])
     where i.indrelid = (TG_TABLE_SCHEMA||'.'||TG_TABLE_NAME)::regclass
       and i.indisprimary;
    if v_pk is not null then 
    	r_ta.row_id = (v_row_data->>v_pk)::text;
    end if;
    if array_length(v_excluded_cols,1) > 0 then
        if r_ta.row_data is not null then
            for r in select * from unnest(v_excluded_cols) as k
            loop 
                r_ta.row_data = r_ta.row_data - r.k;
            end loop;
        end if;
        if r_ta.row_changed_data is not null then
            for r in select * from unnest(v_excluded_cols) as k
            loop 
                r_ta.row_changed_data = r_ta.row_changed_data - r.k;
            end loop;
        end if;
    end if;    
    insert into nflog.tables_actions values (r_ta.*);
    return null;
end;
$function$
;