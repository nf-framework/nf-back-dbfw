CREATE OR REPLACE FUNCTION nfc.f_db8grant_all()
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
declare
    r record;
begin
-- nfusr (пользователь системы)
-- чтение представлений
for r in (select c.relname as tablename,
                 nc.nspname as schemaname
            from pg_catalog.pg_class c,
                 pg_catalog.pg_namespace nc,
                 nfc.modulelist u
           where c.relnamespace = nc.oid 
             and c.relkind = 'v'
             and u.code = nc.nspname
             and not pg_catalog.has_table_privilege('nfusr', format('%I.%I',nc.nspname,c.relname), 'select'))
loop 
    execute format('grant select on %I.%I to nfusr', r.schemaname, r.tablename);
end loop;  
-- выполнение функций
for r in (select c.oid
            from pg_catalog.pg_proc c,
                 pg_catalog.pg_namespace nc,
                 nfc.modulelist u
           where c.pronamespace = nc.oid 
             and u.code = nc.nspname
             and not pg_catalog.has_function_privilege('nfusr', c.oid::regprocedure , 'execute'))
loop 
    execute format('grant execute on function %s to nfusr', r.oid::regprocedure);
end loop;
-- доступ к схемам
for r in (select nc.nspname
            from pg_catalog.pg_namespace nc,
                 nfc.modulelist u
           where u.code = nc.nspname
             and not pg_catalog.has_schema_privilege('nfusr', format('%I',nc.nspname) , 'usage'))
loop  
    execute format('grant usage on schema %I to nfusr', r.nspname);  
end loop;
-- nftst (тестировщик данных)   
if nfc.f_db8obj_exist('role','nftst') is not null then 
	-- доступ к схемам
	for r in (select nc.nspname
	            from pg_catalog.pg_namespace nc,
	                 nfc.modulelist u
	           where u.code = nc.nspname
	             and not pg_catalog.has_schema_privilege('nftst', format('%I',nc.nspname) , 'usage'))
	loop  
	    execute format('grant usage on schema %I to nftst', r.nspname);  
	end loop;
	-- просмотр, редактирование данных
	for r in (select t.*
  				from (select c.relname as tablename,
						     nc.nspname as schemaname,
						     pg_catalog.has_table_privilege('nftst', format('%I.%I',nc.nspname,c.relname), 'select') as can_select,
						     pg_catalog.has_table_privilege('nftst', format('%I.%I',nc.nspname,c.relname), 'insert') as can_insert,
						     pg_catalog.has_table_privilege('nftst', format('%I.%I',nc.nspname,c.relname), 'update') as can_update,
						     pg_catalog.has_table_privilege('nftst', format('%I.%I',nc.nspname,c.relname), 'delete') as can_delete
						    from pg_catalog.pg_class c,
						         pg_catalog.pg_namespace nc,
						         nfc.modulelist u
						   where c.relnamespace = nc.oid 
						     and c.relkind = 'r'
						 	 and u.code = nc.nspname) t
			 where not (t.can_select and t.can_insert and t.can_update and t.can_delete))
	loop 
	    if not r.can_select then 
			execute format('grant select on %I.%I to nftst', r.schemaname, r.tablename);
		end if;
		if not r.can_insert then 
			execute format('grant insert on %I.%I to nftst', r.schemaname, r.tablename);
		end if;
		if not r.can_update then 
			execute format('grant update on %I.%I to nftst', r.schemaname, r.tablename);
		end if;
		if not r.can_delete then 
			execute format('grant delete on %I.%I to nftst', r.schemaname, r.tablename);
		end if;
	end loop; 
	-- использование(генерация следующего значения) последовательностей
	for r in (select c.relname as tablename,
	                 nc.nspname as schemaname
	            from pg_catalog.pg_class c,
	                 pg_catalog.pg_namespace nc,
	                 nfc.modulelist u
	           where c.relnamespace = nc.oid 
	             and c.relkind = 'S'
	             and u.code = nc.nspname
	             and not pg_catalog.has_sequence_privilege('nftst', format('%I.%I',nc.nspname,c.relname), 'usage'))
	loop 
	    execute format('grant usage on %I.%I to nftst', r.schemaname, r.tablename);
	end loop;
end if;
-- nfobs (только чтение данных)   
if nfc.f_db8obj_exist('role','nfobs') is not null then 
	-- доступ к схемам
	for r in (select nc.nspname
	            from pg_catalog.pg_namespace nc,
	                 nfc.modulelist u
	           where u.code = nc.nspname
	             and not pg_catalog.has_schema_privilege('nfobs', format('%I',nc.nspname) , 'usage'))
	loop  
	    execute format('grant usage on schema %I to nfobs', r.nspname);  
	end loop;
	-- просмотр данных
	for r in (select c.relname as tablename,
	                 nc.nspname as schemaname
	            from pg_catalog.pg_class c,
	                 pg_catalog.pg_namespace nc,
	                 nfc.modulelist u
	           where c.relnamespace = nc.oid 
	             and c.relkind = 'r'
	             and u.code = nc.nspname
	             and not pg_catalog.has_table_privilege('nfobs', format('%I.%I',nc.nspname,c.relname), 'select'))
	loop 
	    execute format('grant select on %I.%I to nfobs', r.schemaname, r.tablename);
	end loop;
end if;

-- запустить гранторы остальных схем
for r in (select nc.nspname as schemaname
            from pg_catalog.pg_namespace nc,
                 nfc.modulelist u
           where u.code = nc.nspname
             and u.code != 'nfc')
loop 
    if nfc.f_db8obj_exist('function', r.schemaname, 'f_db8grant_all') is not null then 
        execute format('select %I.f_db8grant_all()',r.schemaname);
    end if;
end loop;           
end;
$function$
;