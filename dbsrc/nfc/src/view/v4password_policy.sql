create or replace view nfc.v4password_policy as 
 SELECT main.id,
    main.code,
    main.caption,
    main.attempts_to_lock,
    main.pwd_locktime,
    main.pwd_lifetime,
    main.pwd_minlength,
    main.pwd_use_specs,
    main.pwd_use_digit,
    main.pwd_use_shift,
    main.pwd_chk_block,
    main.pwd_chk_block_remark
   FROM nfc.password_policy main
  WHERE nfc.f4role_unitprivs8check('nfc.password_policy'::character varying);