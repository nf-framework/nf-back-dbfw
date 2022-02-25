CREATE OR REPLACE FUNCTION nfc.f_broker(p_action text, p_params json)
 RETURNS json
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
declare
  x                record;
  sql              text        = '';
  osql             text;
  a_par            text[];
  a_ipar           text[];
  a_type           text[];
  a_pn             pg_catalog.pg_proc.proargnames%type;
  a_pm             pg_catalog.pg_proc.proargmodes%type;
  rettype          text;
  a_ret_par        text[];
  a_ret_val        text[];
  a_ret            text[][];
  a_pt             text[];
  n_multipar       integer;
  a_multipar       text[];
  fnd              integer;
  notfnd_p         text = '';
  n_ident          bigint;
  
  unit_id          text;
  org              bigint;
  grp              bigint;
  cid              bigint;
  divide_type      text;
  sql_b            text;
  sql_a            text;
  unit             varchar(60);
  unitbp           varchar(90);
  exec_function    varchar(60);
  unit_pcode       nfc.unitlist.pcode%type;
  unit_opt         jsonb;
  unit_table       text;
  pk_field         text;
  pk_type          text; 
  act              varchar(60);
  res              jsonb;
  v_params         jsonb = p_params::jsonb;
  v_found_par      text;
begin
  act = split_part(p_action,'.',3); 
  if act = '' then -- выполняется функция напрямую
      exec_function = p_action;
  else   
      select k.code, k.unit, k.exec_function, u.opt, u.pcode
        into unitbp, unit, exec_function, unit_opt, unit_pcode
        from nfc.unitbps k
             join nfc.unitlist u on u.code = k.unit
       where k.code = p_action;
      if unit is null then 
        select u.code, u.opt, u.pcode
          into unit, unit_opt, unit_pcode
          from nfc.unitlist u 
         where u.code = split_part(p_action,'.',1)||'.'||split_part(p_action,'.',2);
      end if;   
      if exec_function is null then
          unit_table = coalesce(unit_opt->>'table',unit);
          pk_field = unit_opt->>'primaryKey';
          if pk_field is null then 
              pk_field = nfc.f_db8get_primaryfield(split_part(unit_table,'.',1), split_part(unit_table,'.',2), true);
          end if;
          if pk_field is null then 
              pk_field = 'id::bigint';
          end if;    
          pk_type = split_part(pk_field,'::',2);
          if pk_type = '' then pk_type = 'bigint'; end if;
          pk_field = split_part(pk_field,'::',1);
          unit_id = coalesce((p_params->>pk_field),(p_params->>'p_'||pk_field)); 
          if act = 'mod' then 
              if unit_opt->>'idGenMethod' = 'ext' then -- первичный ключ вводится вручную, а не генерится 
                  execute 'select 1 from '||unit_table||' where '||pk_field||' = $1::'||pk_type into fnd using unit_id;
                  if fnd = 1 then 
                      act = 'upd';  
                  else 
                      act = 'add';
                  end if;
              else 
                if unit_id is null then 
                    act = 'add';
                else 
                    act = 'upd';
                end if;
              end if;  
              unitbp = unit||'.'||act;
              select k.exec_function 
                into exec_function 
                from nfc.unitbps k
               where k.code = unitbp;  
          end if;
      end if;      
  end if;     
  if exec_function is null then -- выполняться будет стандартное действие, без объявленной функции выполнения
      sql_b = '';
      sql_a = '';
      org = p_params->>'org';
      if org is null then org = nfc.f_cfg8get('org'); end if;
      divide_type = unit_opt->>'divideType';
      if divide_type = 'grp' then 
          select l.grp_id into grp from nfc.org l where l.id = org;
      end if;
      if (unit_opt->>'useCatalog')::boolean then 
          if unit_pcode is null then 
              cid = p_params->>'cid';
          else 
              -- реализовать для дочерних разделов
          end if;  
      end if;
      -- подготовка оператора действия
      for x in (select t3.attname,
                       t4.typname,
                       t3.atthasdef,
                       'p'||lower(t4.typcategory)||'_' as var_start
                  from pg_catalog.pg_namespace   t1,
                       pg_catalog.pg_class       t2,
                       pg_catalog.pg_attribute   t3,
                       pg_catalog.pg_type        t4
                 where t1.nspname      = split_part(unit_table,'.',1)
                   and t2.relnamespace = t1.oid
                   and t2.relname      = split_part(unit_table,'.',2)
                   and t3.attrelid     = t2.oid
                   and t3.attnum       > 0
                   and not t3.attisdropped
                   and t3.atttypid     = t4.oid
                 order by t3.attnum)
      loop
          if p_params::jsonb ? x.attname::text then 
              if act = 'add' then 
                  if not (x.attname in ('org','grp') or (x.attname = pk_field and coalesce(unit_opt->>'idGenMethod','self') != 'ext')) then
                      sql_b = sql_b||','||x.attname;
                      sql_a = sql_a||',($1->>'''||x.attname||''')::'||x.typname;
                  end if;  
              else 
                  if x.attname not in ('id',pk_field,'org','grp','cid') then
                      sql_b = sql_b||','||x.attname||' = ($1->>'''||x.attname||''')::'||x.typname; 
                  end if;  
              end if;  
          end if;
      end loop;  
      if act = 'add' then 
          if divide_type = 'org' then 
              sql_b = ',org'||sql_b;
              sql_a = ',$2'||sql_a;
          elsif divide_type = 'grp' then 
              sql_b = ',grp'||sql_b;
              sql_a = ',$2'||sql_a;
          end if;
          if unit_opt->>'idGenMethod' = 'main' then 
              sql_b = pk_field||sql_b;
              sql_a = 'nfc.f_id()::'||pk_type||sql_a;
          else
              sql_b = substring(sql_b,2);
              sql_a = substring(sql_a,2);
          end if;
          sql = 'insert into '||unit_table||'('||sql_b||') values ('||sql_a||') returning '||pk_field||'::text;';
      elsif act = 'upd' then 
          sql = 'update only '||unit_table||' set '||substring(sql_b,2)||' where '||pk_field||' = $2::'||pk_type;
          if divide_type = 'org' then 
              sql = sql||' and org = $3;';
          elsif divide_type = 'grp' then 
              sql = sql||' and grp = $3;';
          else 
              sql = sql||';';
          end if;
      elsif act = 'del' then 
          sql = 'delete from only '||unit_table||' where '||pk_field||' = $2::'||pk_type;
          if divide_type = 'org' then 
              sql = sql||' and org = $3;';
          elsif divide_type = 'grp' then 
              sql = sql||' and grp = $3;';
          else 
              sql = sql||';';
          end if;
      end if; 
      -- выполнение
      perform nfc.f_bp8before(unitbp, unit_id, org, grp, cid);
      if act = 'add' then
          execute sql into unit_id using p_params,(case when divide_type = 'org' then org when divide_type = 'grp' then grp else null end);
          res = json_build_object(pk_field,unit_id); 
      else 
          execute sql using p_params,unit_id,(case when divide_type = 'org' then org when divide_type = 'grp' then grp else null end);
      end if;
      perform nfc.f_bp8after(unitbp, unit_id, org, grp, cid);
      return res;
  else 
      begin
          select (select array_agg(r.typname)
                    from (select g rn, 
                                 k.typname::text typname
                            from generate_subscripts(coalesce(p.proallargtypes,p.proargtypes::oid[]),1) AS g,
                                 pg_catalog.pg_type k
                           where k.oid = coalesce(p.proallargtypes[g],p.proargtypes[g]) 
                           order by rn) r),
                 p.proargnames,
                 p.proargmodes,
                 case when t.typname in ('void','record') then null else t.typname::text end
            into strict a_pt, a_pn, a_pm, rettype    
            from pg_catalog.pg_namespace l,
                 pg_catalog.pg_proc      p
                 left outer join pg_catalog.pg_type t on (p.prorettype = t.oid)
           where l.nspname = split_part(exec_function,'.',1) 
             and p.pronamespace = l.oid 
             and p.proname      = split_part(exec_function,'.',2);
      exception when no_data_found then perform nfc.f_raise('2.1. Не найдено функции для действия [$1]',p_action);
                when too_many_rows then perform nfc.f_raise('2.2. Определено более одной фукции для действия [$1]',p_action);
      end; 
      -- параметры процедуры переводим в массив, который должен соотвествовать массиву значений
      -- a_par = string_to_array(trim(both ';' from ps_params::text),';'::text);
      -- составляем массив параметров и их типов, скореллированный со входными параметрами
      if not (v_params?'org' or v_params?'p_org') then 
          v_params = v_params||jsonb_build_object('p_org', nfc.f_cfg8get('org'));
      end if;
      if array_length(a_pn,1) > 0 then
          fnd = 0;
          for m in array_lower(a_pn,1)..array_upper(a_pn,1)
          loop
              v_found_par = null;
              --raise notice '%',(v_params?a_pn[m])::text;
              --raise notice '%',(v_params?regexp_replace(a_pn[m],'^p_',''))::text;
              if v_params?a_pn[m] then 
                  v_found_par = a_pn[m];
              elsif (v_params?regexp_replace(a_pn[m],'^p_','')) then 
                  v_found_par = regexp_replace(a_pn[m],'^p_','');
              elsif v_params?('~'||a_pn[m]) then 
                  v_found_par = a_pn[m];
                  n_multipar = fnd;
              elsif v_params?('~'||regexp_replace(a_pn[m],'^p_','')) then
                  v_found_par = regexp_replace(a_pn[m],'^p_','');
                  n_multipar = fnd;
              end if;
              if v_found_par is not null then     
                  a_par[fnd] = a_pn[m];
                  a_ipar[fnd] = v_found_par;
                  a_type[fnd] = a_pt[m];
                  fnd = fnd + 1;
              else 
                  notfnd_p = notfnd_p||a_pn[m]||';';
              end if;
          end loop;
      end if;  
      -- соединение всех параметров со значениями для последующего выполнения
      begin
        if n_multipar is null then
          if array_length(a_par,1) > 0 then
            for i in array_lower(a_par,1)..array_upper(a_par,1) loop 
              if substr(a_par[i],1,1) = '#' then --дополнительные свойства 
                if unitbp is NOT null then 
                  if n_ident is null then 
                    select nfc.f_id() into n_ident;
                    perform nfc.f_cfg8set('broker_ident',n_ident::text);
                  end if;
                  --INSERT into core.broker_unitprops(ident,unitbp,unitprop,unitprop_value) values (n_ident,unitbp,substring(a_par[i] from 2),ps_params->>a_par[i]);
                end if;
              else
                --TODO binded 
                sql = sql||','||quote_ident(a_par[i])||':='||coalesce(quote_literal(v_params->>a_ipar[i]),'null')||'::'||a_type[i];
              end if;   
            end loop;
          else 
            sql = ',';  
          end if;
          sql = exec_function||'('||substr(sql,2)||')';
          -- формирование выходных данных
          if rettype is NOT null then 
            execute 'select '||sql||'::text;' into rettype;
            res = json_build_object('result',rettype);
          elsif a_pm is NOT null then 
            --TODO упростить
            if array_length(a_pn,1) > 0 then
              for i in array_lower(a_pn,1)..array_upper(a_pn,1)
              loop 
                if a_pm[i] in ('o','b') then 
                  if osql is NOT null then osql = osql||','; else osql = ''; end if;
                  osql = osql||a_pn[i]||'::text';
                  a_ret_par = a_ret_par||a_pn[i];
                end if;  
              end loop;
            end if;  
            execute 'select array['||osql||']::text[] from '||sql into a_ret_val;
            res = json_object(a_ret_par,a_ret_val);
            /*
            if array_length(a_ret_par,1) > 0 then
              for i in array_lower(a_ret_par,1)..array_upper(a_ret_par,1)
              loop 
                a_ret = a_ret||array[[a_ret_par[i],a_ret_val[i]]];
              end loop;
            end if; 
            */ 
          else  
            execute 'select '||sql||';';
          end if;
          -- очистка данных для дополнительных свойств
          if n_ident is NOT null then 
            --delete from core.broker_unitprops k where k.ident = n_ident;
          end if;
          return res;
        else 
          a_multipar = string_to_array(trim(both ';' from v_params->>a_par[n_multipar]::text),';'::text);
          if array_length(a_multipar,1) > 0 then
            for j in array_lower(a_multipar,1)..array_upper(a_multipar,1)
            loop 
              sql = '';
              for i in array_lower(a_par,1)..array_upper(a_par,1)
              loop 
                if i = n_multipar then 
                  sql = sql||','||quote_ident(substr(a_par[i],2))||':='||quote_nullable(a_multipar[j])||'::'||a_type[i];
                else
                  sql = sql||','||quote_ident(a_par[i])||':='||quote_nullable(v_params->>a_ipar[i])||'::'||a_type[i];
                end if;  
              end loop;
              sql = 'select '||exec_function||'('||substr(sql,2)||');';
              execute sql; 
            end loop;
          end if;  
        end if;  
      exception 
        when undefined_function then 
          --raise '%,%,%',p_params::text,a_par::text,a_type::text;
          if coalesce(nfc.f_cfg8get('debug')::integer,0) > 0 then 
            raise '%. Не были переданы параметры:%',sqlerrm||chr(10),notfnd_p;
          else 
            raise;
          end if;
      end; 
  end if;   
  return null::json;
end;
$function$
;