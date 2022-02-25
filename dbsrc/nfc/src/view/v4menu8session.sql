create or replace view nfc.v4menu8session as 
 SELECT main.menuguid
   FROM nfc.menuroles main
     JOIN nfc.userroles ur ON ur.role_id = main.role_id
     JOIN nfc.users u ON u.id = ur.user_id
  WHERE ur.org_id = NULLIF(current_setting('nf.org'::text), ''::text)::bigint AND u.username::text = nfc.f_session_user();