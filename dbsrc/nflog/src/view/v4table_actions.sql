create or replace view nflog.v4table_actions as 
 SELECT tables_actions.id,
    tables_actions.schemaname,
    tables_actions.tablename,
    tables_actions.session_user_name,
    tables_actions.ts_transact_started,
    tables_actions.ts_log,
    tables_actions.application_name,
    tables_actions.client_addr,
    tables_actions.client_port,
    tables_actions.client_query,
    tables_actions.action,
    tables_actions.row_data,
    tables_actions.row_changed_data,
    tables_actions.row_id
   FROM nflog.tables_actions;