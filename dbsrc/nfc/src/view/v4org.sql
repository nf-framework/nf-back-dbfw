create or replace view nfc.v4org as 
 SELECT main.id,
    main.code,
    main.caption,
    main.grp_id,
    ref1.caption AS grp_id_caption,
    ref1.code AS grp_id_code,
    main.userforms
   FROM nfc.org main
     JOIN nfc.grp ref1 ON ref1.id = main.grp_id
  WHERE nfc.f4role_unitprivs8check('nfc.org'::character varying);