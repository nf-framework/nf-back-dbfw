CREATE OR REPLACE FUNCTION nfc.f_bp8before(p_unitbp character varying, p_unit_id text, p_org bigint, p_grp bigint DEFAULT NULL::bigint, p_cid bigint DEFAULT NULL::bigint)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
begin
  -- проверка прав
	perform nfc.f4role_unitbpprivs8chk(p_unitbp, p_org);
  -- выполнение событийных процедур ДО действия
  --perform nfc.f4eventprocs8auto_execute(p_unitbp,p_unit_id,0,p_org,p_grp,p_cid);
  -- выполнение пользовательских процедур ДО действия
  --perform nfc.f4userprocs8auto_execute(p_unitbp,p_unit_id,0,p_org,p_grp,p_cid);
  -- логгирование бизнес-процесса
  --perform core.f_bplog8add(ps_unitbp,pn_unit_id);
end;
$function$
;
comment on function nfc.f_bp8before(p_unitbp character varying, p_unit_id text, p_org bigint, p_grp bigint, p_cid bigint) is 'Пролог бизнес-действия';