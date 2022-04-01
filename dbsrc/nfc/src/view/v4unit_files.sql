create or replace view nfc.v4unit_files as 
 SELECT main.id,
    main.unit,
    main.unit_id,
    main.uf_type,
    ref_uf_type.code AS uf_type_code,
    ref_uf_type.caption AS uf_type_caption,
    main.file_id
   FROM nfc.unit_files main
     LEFT JOIN nfc.unit_file_types ref_uf_type ON ref_uf_type.id = main.uf_type
  WHERE nfc.f4role_unitprivs8check('nfc.unit_files'::character varying);