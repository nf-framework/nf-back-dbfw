create or replace view nfc.v4ui_customization as 
 SELECT main.id,
    main.scope,
    main.key,
    main.value
   FROM nfc.ui_customization main;