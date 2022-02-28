create or replace view nfc.v4unitbps as 
 SELECT main.code,
    main.unit,
    ref1.caption AS unit_caption,
    main.caption,
    main.exec_function,
    main.use_privs
   FROM nfc.unitbps main
     JOIN nfc.unitlist ref1 ON ref1.code::text = main.unit::text;