create or replace view nfc.v4unit_files as 
 SELECT main.id,
    main.unit,
    ref_unit.caption AS unit_caption,
    main.unit_id,
    main.uf_type,
    ref_uf_type.code AS uf_type_code,
    ref_uf_type.caption AS uf_type_caption,
    main.file_id
   FROM nfc.unit_files main
     JOIN nfc.unitlist ref_unit ON ref_unit.code::text = main.unit::text
     LEFT JOIN nfc.unit_file_types ref_uf_type ON ref_uf_type.id = main.uf_type
     LEFT JOIN nfc.files ref_file_id ON ref_file_id.id = main.file_id
  WHERE nfc.f4role_unitprivs8check('nfc.unit_files'::character varying);