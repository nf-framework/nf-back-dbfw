create or replace view nfc.v4ex_systems_chains as 
 SELECT main.pid,
    main.id,
    main.any_data,
    main.uid,
    main.status,
    main.call,
    main.wait,
    main.result,
    main.nextargs
   FROM nfc.ex_systems_chains main
  WHERE nfc.f4role_unitprivs8check('nfc.ex_systems_chains'::character varying);