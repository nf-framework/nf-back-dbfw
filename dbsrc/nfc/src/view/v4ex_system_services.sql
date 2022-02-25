create or replace view nfc.v4ex_system_services as 
 SELECT main.id,
    main.pid,
    main.code,
    main.caption,
    main.is_stopped,
    main.url,
    main.any_options
   FROM nfc.ex_system_services main
  WHERE nfc.f4role_unitprivs8check('nfc.ex_system_services'::character varying);