--[block]{"event":"main","when":"after"}
do
$$
begin
    update nfc.ex_systems set is_stopped = false where is_stopped is null;
    update nfc.ex_system_services set is_stopped = false where is_stopped is null;
end;
$$