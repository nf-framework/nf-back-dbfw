create or replace view nfc.v4datatypes as 
 SELECT main.id,
    main.caption,
    main.code
   FROM nfc.datatypes main;