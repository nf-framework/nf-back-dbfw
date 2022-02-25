create or replace view nfc.v4unitlist as 
 SELECT main.code,
    main.caption,
    main.pcode,
    main.mdl,
    main.opt
   FROM nfc.unitlist main;