export default {
    "@main": {
        action: `select u.id,
                        u.username,
                        u.fullname,
                        u.extra, 
                        coalesce((select array_agg(json_build_object(
                           'id', ur.id,
                           'org_id', ur.org_id,
                           'role_id', ur.role_id
                        )) from nfc.v4userroles ur where ur.user_id = u.id),'{}'::json[]) as userroles
                   from nfc.v4users u
                  where u.id = :id`,
        "type": "query",
        "provider": "default"
    }
};
