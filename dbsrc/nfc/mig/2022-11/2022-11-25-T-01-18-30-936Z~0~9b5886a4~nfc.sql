--[block]{"event":"run","when":"after","initial":"yes"}
create aggregate nfc.array_merge_agg(anyarray) (
    sfunc = nfc.f_tool4array8merge,
    stype = anyarray
);