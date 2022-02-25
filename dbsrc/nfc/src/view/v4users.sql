create or replace view nfc.v4users as 
 SELECT main.id,
    main.username,
    main.fullname,
    main.extra
   FROM nfc.users main
  WHERE nfc.f4role_unitprivs8check('nfc.users'::character varying);