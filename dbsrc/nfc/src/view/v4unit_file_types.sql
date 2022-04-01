create or replace view nfc.v4unit_file_types as 
 SELECT main.id,
    main.unit,
    main.code,
    main.caption
   FROM nfc.unit_file_types main
  WHERE nfc.f4role_unitprivs8check('nfc.unit_file_types'::character varying);