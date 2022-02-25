create or replace view nfc.v4options as 
 SELECT main.code,
    main.caption,
    main.note,
    main.datatype,
    ref_datatype.caption AS datatype_caption,
    ref_datatype.code AS datatype_code,
    main.val,
    main.val_limits,
    main.mdl,
    ref_mdl.caption AS mdl_caption,
    main.multi_val
   FROM nfc.options main
     JOIN nfc.datatypes ref_datatype ON ref_datatype.id = main.datatype
     JOIN nfc.modulelist ref_mdl ON ref_mdl.code::text = main.mdl::text
  WHERE nfc.f4role_unitprivs8check('nfc.options'::character varying);