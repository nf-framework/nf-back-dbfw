create or replace view nfc.v4userroles as 
 SELECT main.id,
    main.org_id,
    ref1.caption AS org_id_caption,
    ref1.code AS org_id_code,
    main.user_id,
    ref3.username AS user_id_username,
    main.role_id,
    ref2.code AS role_id_code,
    ref2.caption AS role_id_caption
   FROM nfc.userroles main
     JOIN nfc.org ref1 ON ref1.id = main.org_id
     JOIN nfc.users ref3 ON ref3.id = main.user_id
     JOIN nfc.roles ref2 ON ref2.id = main.role_id
  WHERE nfc.f4role_unitprivs8check('nfc.userroles'::character varying);