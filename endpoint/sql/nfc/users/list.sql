--[options]{"provider":"default","session":[["current_user_id","user_id"],"username"]}
select role_id, role_id_code, role_id_caption
  from nfc.v4userroles u
 where u.user_id = :current_user_id
{{#if role}} and u.role_id_code = :role{{/if}}