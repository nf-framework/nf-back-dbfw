CREATE TRIGGER tr4unit_files8after AFTER DELETE ON nfc.unit_files FOR EACH ROW EXECUTE PROCEDURE nfc.f4unit_files8tr();
