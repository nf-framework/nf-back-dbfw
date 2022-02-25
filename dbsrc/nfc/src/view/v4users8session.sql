create or replace view nfc.v4users8session as 
 SELECT main.id,
    main.username,
    main.fullname,
    main.extra
   FROM nfc.users main
  WHERE main.username::text = nfc.f_session_user();