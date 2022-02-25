create or replace view nfc.v4options_values as 
 SELECT main.option,
    main.id,
    main.val,
    main.org_id,
    ref_org_id.caption AS org_id_caption,
    ref_org_id.code AS org_id_code,
    main.user_id,
    ref_user_id.username AS user_id_username,
    main.date_begin,
    main.date_end
   FROM nfc.options_values main
     LEFT JOIN nfc.org ref_org_id ON ref_org_id.id = main.org_id
     LEFT JOIN nfc.users ref_user_id ON ref_user_id.id = main.user_id
  WHERE nfc.f4role_unitprivs8check('nfc.options_values'::character varying);