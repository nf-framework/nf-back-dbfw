create or replace view nfc.v4modulelist as 
 SELECT main.code,
    main.caption
   FROM nfc.modulelist main;