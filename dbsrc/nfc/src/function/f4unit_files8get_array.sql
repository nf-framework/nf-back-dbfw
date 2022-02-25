CREATE OR REPLACE FUNCTION nfc.f4unit_files8get_array(p_unit text, p_unit_id bigint, p_uf_type_code text DEFAULT NULL::text, p_return_type text DEFAULT 'filename'::text)
 RETURNS text[]
 LANGUAGE sql
 STABLE SECURITY DEFINER
AS $function$select array_agg(case p_return_type when 'filename' then f.filename::text else uf.id::text end)
  from nfc.unit_files uf 
       left join nfc.unit_file_types uft on uft.id = uf.uf_type
       join nfc.files f on f.id = uf.file_id
 where uf.unit = p_unit
   and uf.unit_id = p_unit_id
   and (p_uf_type_code is null or uft.code = p_uf_type_code)$function$
;