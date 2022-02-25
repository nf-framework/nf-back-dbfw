--[block]{"event":"run","when":"before"}
DROP FUNCTION IF EXISTS nfc.f4users8check(p_action varchar, p_org bigint, p_username varchar, p_fullname varchar, p_password varchar);