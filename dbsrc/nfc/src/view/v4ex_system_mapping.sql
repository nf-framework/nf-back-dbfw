create or replace view nfc.v4ex_system_mapping as 
 SELECT main.pid,
    main.id,
    main.in_namespace,
    main.in_id,
    main.ex_namespace,
    main.ex_id
   FROM nfc.ex_system_mapping main;