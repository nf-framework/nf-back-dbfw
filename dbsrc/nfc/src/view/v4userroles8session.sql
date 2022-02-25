create or replace view nfc.v4userroles8session as 
 SELECT main.role_id,
    ref2.code AS role_id_code,
    ref2.caption AS role_id_caption
   FROM nfc.userroles main
     JOIN nfc.users ref3 ON ref3.id = main.user_id AND ref3.username::text = nfc.f_session_user()
     JOIN nfc.roles ref2 ON ref2.id = main.role_id
  WHERE main.org_id = NULLIF(current_setting('nf.org'::text), ''::text)::bigint;