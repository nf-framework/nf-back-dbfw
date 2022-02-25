create or replace view nflog.v4int_log as 
 SELECT int_log.id,
    int_log.context,
    int_log.uuid,
    int_log.ex_system,
    int_log.ex_service,
    int_log.uri,
    int_log.req_date,
    int_log.req_head,
    int_log.req_body,
    int_log.res_date,
    int_log.res_head,
    int_log.res_body,
    int_log.username,
    int_log.ok,
    int_log.err_msg
   FROM nflog.int_log;