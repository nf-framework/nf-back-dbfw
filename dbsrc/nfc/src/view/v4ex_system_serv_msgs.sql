create or replace view nfc.v4ex_system_serv_msgs as 
 SELECT main.id,
    main.pid,
    main.msg_id,
    main.msg_ts,
    main.msg_type,
    main.any_data,
    main.status
   FROM nfc.ex_system_serv_msgs main
  WHERE nfc.f4role_unitprivs8check('nfc.ex_system_serv_msgs'::character varying);