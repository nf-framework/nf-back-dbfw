create or replace view nfc.v4unit_file_types as 
 SELECT main.id,
    main.unit,
    ref_unit.caption AS unit_caption,
    main.code,
    main.caption
   FROM nfc.unit_file_types main
     JOIN nfc.unitlist ref_unit ON ref_unit.code::text = main.unit::text
  WHERE nfc.f4role_unitprivs8check('nfc.unit_file_types'::character varying);