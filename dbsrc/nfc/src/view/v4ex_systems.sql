create or replace view nfc.v4ex_systems as 
 SELECT main.id,
    main.code,
    main.caption,
    main.is_stopped,
    main.endpoint,
    main.any_options
   FROM nfc.ex_systems main
  WHERE nfc.f4role_unitprivs8check('nfc.ex_systems'::character varying);