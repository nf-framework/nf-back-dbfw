create or replace view nfc.v4role_unitbpprivs as 
 SELECT main.id,
    main.pid,
    ref1.unit AS pid_unit,
    main.unitbp,
    ref2.unit AS unitbp_unit
   FROM nfc.role_unitbpprivs main
     JOIN nfc.role_unitprivs ref1 ON ref1.id = main.pid
     JOIN nfc.unitbps ref2 ON ref2.code::text = main.unitbp::text
  WHERE nfc.f4role_unitprivs8check('nfc.role_unitbpprivs'::character varying);