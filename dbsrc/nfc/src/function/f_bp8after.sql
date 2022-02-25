CREATE OR REPLACE FUNCTION nfc.f_bp8after(p_unitbp character varying, p_unit_id text, p_org bigint, p_grp bigint DEFAULT NULL::bigint, p_cid bigint DEFAULT NULL::bigint)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
begin
  -- выполнение событийных процедур После действия
  --perform nfc.f4eventprocs8auto_execute(p_unitbp,p_unit_id,0,p_org,p_grp,p_cid);
  -- выполнение пользовательских процедур ПОСЛЕ действия
  --perform nfc.f4userprocs8auto_execute(p_unitbp,p_unit_id,0,p_org,p_grp,p_cid);
  -- завершение логгирования бизнесс-процесса
  --perform core.f_bplog8set_log_end_date(ps_unitbp,pn_unit_id);
  -- заполнение доп.свойств при необходимости
  --perform core.f_unitprop_values8broker_load(pn_lpu,ps_unitbp,pn_unit_id);
end;
$function$
;
comment on function nfc.f_bp8after(p_unitbp character varying, p_unit_id text, p_org bigint, p_grp bigint, p_cid bigint) is 'Эпилог бизнес-действия';