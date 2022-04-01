create or replace view nfc.v4unitbps as 
 SELECT main.code,
    main.unit,
    main.caption,
    main.exec_function,
    main.use_privs
   FROM nfc.unitbps main;