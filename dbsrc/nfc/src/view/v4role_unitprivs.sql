create or replace view nfc.v4role_unitprivs as 
 SELECT main.id,
    main.role_id,
    ref1.caption AS role_id_caption,
    ref1.code AS role_id_code,
    main.unit,
    ref2.caption AS unit_caption
   FROM nfc.role_unitprivs main
     LEFT JOIN nfc.roles ref1 ON ref1.id = main.role_id
     LEFT JOIN nfc.unitlist ref2 ON ref2.code::text = main.unit::text
  WHERE nfc.f4role_unitprivs8check('nfc.role_unitprivs'::character varying);