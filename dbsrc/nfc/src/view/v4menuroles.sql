create or replace view nfc.v4menuroles as 
 SELECT main.menuguid,
    main.role_id,
    ref_role_id.caption AS role_id_caption,
    ref_role_id.code AS role_id_code,
    main.id
   FROM nfc.menuroles main
     JOIN nfc.roles ref_role_id ON ref_role_id.id = main.role_id
  WHERE nfc.f4role_unitprivs8check('nfc.menuroles'::character varying);