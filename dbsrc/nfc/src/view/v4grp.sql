create or replace view nfc.v4grp as 
 SELECT main.id,
    main.code,
    main.caption
   FROM nfc.grp main
  WHERE nfc.f4role_unitprivs8check('nfc.grp'::character varying);