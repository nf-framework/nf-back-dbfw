CREATE OR REPLACE FUNCTION nfc.f4users8check(p_org bigint, p_password character varying DEFAULT NULL::character varying)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
declare
    s                 text;
    s_error           text := '';
    n_pwd_minlength	  numeric := 0;	
    b_pwd_use_specs		bool := false;
    b_pwd_use_digit		bool := false;
    b_pwd_use_shift		bool := false;
begin
    select pwd_minlength,
	  	     pwd_use_specs,
	  	     pwd_use_digit,
	  	     pwd_use_shift
	    into n_pwd_minlength, 
   		     b_pwd_use_specs, 
   		     b_pwd_use_digit,
   		     b_pwd_use_shift
	    from nfc.password_policy
	   where code = 'default';
  if n_pwd_minlength > 0 then 
   	  if char_length(p_password) < n_pwd_minlength then 
 		      s_error := s_error||'1. Длина пароля должна быть более '||n_pwd_minlength||' символов.';
 	    end if;
  end if;
  if b_pwd_use_specs then 
      s := regexp_matches(p_password, '\W');
  	  if s is null then 
  	 	    s_error := s_error||'2. Пароль должен содержать спецсимволы.';
  	  end if;
  end if;
  if b_pwd_use_specs then 
  	  s := regexp_matches(p_password, '\d+');
  	  if s is null then 
  	 	    s_error := s_error||'3. Пароль должен содержать цифры.';
  	  end if;
  end if;
  if b_pwd_use_specs then 
  	  s := regexp_matches(p_password, '[A-ZА-ЯЁ]+');
  	  if s is null then 
  	 	    s_error := s_error||'4. Пароль должен содержать символы верхнего регистра.';
  	  end if;
  	  s := regexp_matches(p_password, '[a-zа-яё]+');
  	  if s is null then 
  	 	    s_error := s_error||'5. Пароль должен содержать символы нижнего регистра.';
  	  end if;
  end if;
  if s_error is not null and s_error <> '' then
      perform nfc.f_raise(s_error);
  end if;
end;
$function$
;