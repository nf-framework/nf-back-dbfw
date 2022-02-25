create or replace view nfc.v4roles as 
 SELECT main.id,
    main.code,
    main.caption
   FROM nfc.roles main
  WHERE nfc.f4role_unitprivs8check('nfc.roles'::character varying);