PGDMP         !                x            TimPhongTro    12.3    12.2 d    6           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            7           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            8           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            9           1262    16388    TimPhongTro    DATABASE        CREATE DATABASE "TimPhongTro" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';
    DROP DATABASE "TimPhongTro";
                postgres    false                        2615    16518    timphongtro    SCHEMA        CREATE SCHEMA timphongtro;
    DROP SCHEMA timphongtro;
                postgres    false                       1255    33367    calculate_point()    FUNCTION       CREATE FUNCTION public.calculate_point() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin 
	update timphongtro."HOME" 
	set "POINT" = (select sum(r."POINT" )/count(*) from "RATING" r where r."IDHOME" = new."IDHOME")
	where "ID" = new."IDHOME";
	
	return new;
end;
$$;
 (   DROP FUNCTION public.calculate_point();
       public          postgres    false                       1255    41572    calculate_point_delete()    FUNCTION       CREATE FUNCTION timphongtro.calculate_point_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin 
	update "HOME" 
	set "POINT" = (select sum(r."POINT" )/count(*) from "RATING" r where r."IDHOME" = old."IDHOME")
	where "ID" = old."IDHOME";
	
	return new;
end;
$$;
 4   DROP FUNCTION timphongtro.calculate_point_delete();
       timphongtro          postgres    false    26                       1255    33370    calculate_point_insert()    FUNCTION       CREATE FUNCTION timphongtro.calculate_point_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin 
	update timphongtro."HOME" 
	set "POINT" = (select sum(r."POINT" )/count(*) from "RATING" r where r."IDHOME" = new."IDHOME")
	where "ID" = new."IDHOME";
	
	return new;
end;
$$;
 4   DROP FUNCTION timphongtro.calculate_point_insert();
       timphongtro          postgres    false    26                       1255    41627    calculate_price_area_delete()    FUNCTION     f  CREATE FUNCTION timphongtro.calculate_price_area_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin 
	update "HOME" 
	set "MIN_AREA" = (select min(r."AREA" ) from "ROOM" r where r."IDHOME"  = old."IDHOME" ),
		"MIN_PRICE" = (select min(r."PRICE" ) from "ROOM" r where r."IDHOME" = old."IDHOME")
	where "ID" = old."IDHOME";
	
	return old;
end;
$$;
 9   DROP FUNCTION timphongtro.calculate_price_area_delete();
       timphongtro          postgres    false    26                       1255    41626    calculate_price_area_insert()    FUNCTION     f  CREATE FUNCTION timphongtro.calculate_price_area_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin 
	update "HOME" 
	set "MIN_AREA" = (select min(r."AREA" ) from "ROOM" r where r."IDHOME"  = new."IDHOME" ),
		"MIN_PRICE" = (select min(r."PRICE" ) from "ROOM" r where r."IDHOME" = new."IDHOME")
	where "ID" = new."IDHOME";
	
	return new;
end;
$$;
 9   DROP FUNCTION timphongtro.calculate_price_area_insert();
       timphongtro          postgres    false    26                       1255    41632    calculate_price_area_update()    FUNCTION     f  CREATE FUNCTION timphongtro.calculate_price_area_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin 
	update "HOME" 
	set "MIN_AREA" = (select min(r."AREA" ) from "ROOM" r where r."IDHOME"  = new."IDHOME" ),
		"MIN_PRICE" = (select min(r."PRICE" ) from "ROOM" r where r."IDHOME" = new."IDHOME")
	where "ID" = new."IDHOME";
	
	return new;
end;
$$;
 9   DROP FUNCTION timphongtro.calculate_price_area_update();
       timphongtro          postgres    false    26                       1255    41983 0   func_change_password(numeric, character varying)    FUNCTION     �  CREATE FUNCTION timphongtro.func_change_password(p_id numeric, p_password character varying, OUT p_err_code character, OUT p_err_desc character) RETURNS record
    LANGUAGE plpgsql
    AS $$

begin
	p_err_code := '0';
	p_err_desc := 'OK';
		if not exists (select 1 from "USER" u where u."ID" = p_id) then
			p_err_code := '-1';
			p_err_desc := 'User đăng nhập không tồn tại!';
		else
			UPDATE "USER"
			SET "PASSWORD" = p_password
			WHERE "ID" = p_id;
		end if;
	EXCEPTION
  	WHEN others THEN
		p_err_code := '-1';
		p_err_desc := 'Error';
	RAISE LOG  'prc_insert_citran:%, context: %','ERROR:', 'sqlstate: ' || sqlstate || ',sqlerrm: ' || sqlerrm ;
end
$$;
 �   DROP FUNCTION timphongtro.func_change_password(p_id numeric, p_password character varying, OUT p_err_code character, OUT p_err_desc character);
       timphongtro          postgres    false    26                       1255    42013    func_get_password(numeric)    FUNCTION     �  CREATE FUNCTION timphongtro.func_get_password(p_id numeric, OUT p_password character varying, OUT p_err_code character, OUT p_err_desc character) RETURNS record
    LANGUAGE plpgsql
    AS $$
begin
	
	p_err_code := '0';
	p_err_desc := 'OK';
	
	if not exists(select 1 from "USER" u where u."ID" = p_id) then
		p_err_code := '-1';
		p_err_desc := 'Tài khoản không tồn tại!';
	else 
		select u."PASSWORD"
			into p_password
		from "USER" u
		where u."ID" = p_id;
	end if;
	EXCEPTION
	WHEN others THEN
		p_err_code := '-1';
		p_err_desc := 'Error';
	RAISE LOG  'prc_insert_citran:%, context: %','ERROR:', 'sqlstate: ' || sqlstate || ',sqlerrm: ' || sqlerrm ;
end
$$;
 �   DROP FUNCTION timphongtro.func_get_password(p_id numeric, OUT p_password character varying, OUT p_err_code character, OUT p_err_desc character);
       timphongtro          postgres    false    26                       1255    33380    func_login(character varying)    FUNCTION     �  CREATE FUNCTION timphongtro.func_login(INOUT p_email character varying, OUT p_id numeric, OUT p_password character varying, OUT p_name character varying, OUT p_phone character varying, OUT p_avatar character varying, OUT p_active numeric, OUT p_idrole numeric, OUT p_err_code character, OUT p_err_desc character) RETURNS record
    LANGUAGE plpgsql
    AS $$
begin
	
	p_err_code := '0';
	p_err_desc := 'OK';
	
	if exists(select 1 from "USER" u where u."EMAIL" = p_email and u."ACTIVE" = 0) then
		p_err_code := '-1';
		p_err_desc := 'Tài khoản của bạn đã bị khóa!';
	else if exists(select 1 from "USER" u where u."EMAIL" = p_email and u."ACTIVE" = 1) then 
		select u."EMAIL" , u."ID" , u."PASSWORD" , u."NAME" , u."PHONE" , u."AVATAR" , u."ACTIVE" , u."IDROLE" 
			into p_email, p_id, p_password, p_name, p_phone, p_avatar, p_active, p_idrole
		from "USER" u
		where u."EMAIL" = p_email;
	else 
		p_err_code := '-1';
		p_err_desc := 'Email không tồn tại!';
	end if;
	end if;
end
$$;
 8  DROP FUNCTION timphongtro.func_login(INOUT p_email character varying, OUT p_id numeric, OUT p_password character varying, OUT p_name character varying, OUT p_phone character varying, OUT p_avatar character varying, OUT p_active numeric, OUT p_idrole numeric, OUT p_err_code character, OUT p_err_desc character);
       timphongtro          postgres    false    26                       1255    42946 A   func_search(numeric, numeric, numeric, numeric, numeric, numeric)    FUNCTION       CREATE FUNCTION timphongtro.func_search(minprice numeric, maxprice numeric, minarea numeric, maxarea numeric, iddistrict numeric, idward numeric) RETURNS TABLE(h_id integer, h_title character varying, h_description character varying, h_address character varying, h_image character varying, h_verify integer, h_min_price integer, h_min_area real, h_point real, h_created_at timestamp with time zone, h_idward integer)
    LANGUAGE plpgsql
    AS $$
begin
	if(idward != 0) then
		return query
		(SELECT 
				cast (h."ID" as integer) ,
				h."TITLE" ,
				h."DESCRIPTION" ,
				h."ADDRESS" ,
				h."IMAGE" ,
				cast (h."VERIFY" as integer) ,
				cast (h."MIN_PRICE" as integer) ,
				h."MIN_AREA" ,
				h."POINT" ,
				h."CREATED_AT",
				cast (h."IDWARD" as integer)
	   	FROM "HOME" h
	  	WHERE h."MIN_PRICE" between minprice and maxprice and h."MIN_AREA" between minarea and maxarea and h."IDWARD" = idward order by h."ID" desc);
	 else
	 	if(iddistrict != 0) then
	 		drop table IF EXISTS  listIdWard;
	
			CREATE TEMP TABLE listIdWard AS
			SELECT w."ID" from "WARD" w where w."IDDISTRICT" = iddistrict;
	
	 		return query
			(SELECT 
				cast (h."ID" as integer) ,
				h."TITLE" ,
				h."DESCRIPTION" ,
				h."ADDRESS" ,
				h."IMAGE" ,
				cast (h."VERIFY" as integer) ,
				cast (h."MIN_PRICE" as integer) ,
				h."MIN_AREA" ,
				h."POINT" ,
				h."CREATED_AT",
				cast (h."IDWARD" as integer)
	   		FROM "HOME" h, listIdWard
	  		WHERE h."MIN_PRICE" between minprice and maxprice and h."MIN_AREA" between minarea and maxarea and h."IDWARD" = listIdWard."ID" order by h."ID" desc);
	  	else
	  		return query
			(SELECT 
				cast (h."ID" as integer) ,
				h."TITLE" ,
				h."DESCRIPTION" ,
				h."ADDRESS" ,
				h."IMAGE" ,
				cast (h."VERIFY" as integer) ,
				cast (h."MIN_PRICE" as integer) ,
				h."MIN_AREA" ,
				h."POINT" ,
				h."CREATED_AT",
				cast (h."IDWARD" as integer)
	   		FROM "HOME" h
	  		WHERE h."MIN_PRICE" between minprice and maxprice and h."MIN_AREA" between minarea and maxarea order by h."ID" desc);
	  	end if;
	 end if;
END;
$$;
 �   DROP FUNCTION timphongtro.func_search(minprice numeric, maxprice numeric, minarea numeric, maxarea numeric, iddistrict numeric, idward numeric);
       timphongtro          postgres    false    26                       1255    41996 )   func_update_room_status(numeric, numeric)    FUNCTION     �  CREATE FUNCTION timphongtro.func_update_room_status(p_id numeric, p_status numeric, OUT p_err_code character, OUT p_err_desc character) RETURNS record
    LANGUAGE plpgsql
    AS $$

begin
	p_err_code := '0';
	p_err_desc := 'OK';
		if not exists (select 1 from "ROOM" r where r."ID" = p_id) then
			p_err_code := '-1';
			p_err_desc := 'Mã phòng không tồn tại!';
		else
			UPDATE "ROOM" 
			SET "STATUS" = p_status
			WHERE "ID" = p_id;
		end if;
	EXCEPTION
  	WHEN others THEN
		p_err_code := '-1';
		p_err_desc := 'Error';
	RAISE LOG  'prc_insert_citran:%, context: %','ERROR:', 'sqlstate: ' || sqlstate || ',sqlerrm: ' || sqlerrm ;
end
$$;
 �   DROP FUNCTION timphongtro.func_update_room_status(p_id numeric, p_status numeric, OUT p_err_code character, OUT p_err_desc character);
       timphongtro          postgres    false    26                       1255    41588    func_verify_home(numeric)    FUNCTION     �  CREATE FUNCTION timphongtro.func_verify_home(p_id numeric, OUT p_err_code character, OUT p_err_desc character) RETURNS record
    LANGUAGE plpgsql
    AS $$
begin
	
	p_err_code := '0';
	p_err_desc := 'OK';
	
	if not exists(select 1 from "HOME" h where h."ID" = p_id) then
		p_err_code := '-1';
		p_err_desc := 'Mã bài viết không tồn tại!';
	else 
		update "HOME" set "VERIFY" = 1 where "ID" = p_id;
	end if;
end
$$;
 n   DROP FUNCTION timphongtro.func_verify_home(p_id numeric, OUT p_err_code character, OUT p_err_desc character);
       timphongtro          postgres    false    26                       1255    43588 !   function_get_home_detail(numeric)    FUNCTION     �  CREATE FUNCTION timphongtro.function_get_home_detail(idhome numeric) RETURNS TABLE(id integer, title character varying, description character varying, address character varying, image character varying, verify integer, host_name character varying, host_phone character varying, point real, created_at timestamp with time zone, id_ward integer)
    LANGUAGE plpgsql
    AS $$
begin
	return query 
		(SELECT cast (h."ID" as integer) ,
				h."TITLE" ,
				h."DESCRIPTION" ,
				h."ADDRESS" ,
				h."IMAGE" ,
				cast (h."VERIFY" as integer) ,
				u."NAME" ,
				u."PHONE" ,
				h."POINT" ,
				h."CREATED_AT",
				cast (h."IDWARD" as integer )
	   	FROM "HOME" h , "USER" u 
	  	WHERE h."ID"  = idhome and u."ID" = h."IDUSER" );	
END;
$$;
 D   DROP FUNCTION timphongtro.function_get_home_detail(idhome numeric);
       timphongtro          postgres    false    26            '           1255    43589 +   function_get_home_from_reservation(numeric)    FUNCTION     /  CREATE FUNCTION timphongtro.function_get_home_from_reservation(iduser numeric) RETURNS TABLE(id integer, title character varying, description character varying, address character varying, image character varying, verify integer, id_user integer, min_price integer, min_area real, point real, created_at timestamp with time zone, id_ward integer)
    LANGUAGE plpgsql
    AS $$
begin
	drop table IF EXISTS  myIdRoom, myIdHome;
	
	CREATE TEMP TABLE myIdRoom AS
	SELECT r."IDROOM" from "RESERVATION" r where r."IDUSER" = iduser;
	
	CREATE TEMP TABLE myIdHome AS
	SELECT distinct(r."IDHOME") from "ROOM" r, myIdRoom where r."ID" = myIdRoom."IDROOM";

	return query 
		(SELECT 
				cast (h."ID" as integer) ,
				h."TITLE" ,
				h."DESCRIPTION" ,
				h."ADDRESS" ,
				h."IMAGE" ,
				cast (h."VERIFY" as integer) ,
				cast (h."IDUSER" as integer) ,
				cast (h."MIN_PRICE" as integer) ,
				h."MIN_AREA" ,
				h."POINT" ,
				h."CREATED_AT",
				cast (h."IDWARD" as integer)
	   	FROM "HOME" h, myIdHome
	  	WHERE h."ID" = myIdHome."IDHOME" order by h."ID" desc);	
END;
$$;
 N   DROP FUNCTION timphongtro.function_get_home_from_reservation(iduser numeric);
       timphongtro          postgres    false    26                        1255    43590 !   function_get_home_rating(numeric)    FUNCTION     �  CREATE FUNCTION timphongtro.function_get_home_rating(idhome numeric) RETURNS TABLE(id integer, user_name character varying, user_avatar character varying, point real, user_comment character varying)
    LANGUAGE plpgsql
    AS $$
begin
	return query 
		(SELECT cast (r."IDUSER" as integer ),
				u."NAME" ,
				u."AVATAR" ,
				r."POINT" ,
				r."COMMENT" 
	   	FROM "RATING" r , "USER" u
	  	WHERE r."IDHOME" = idhome and u."ID" = r."IDUSER");	
END;
$$;
 D   DROP FUNCTION timphongtro.function_get_home_rating(idhome numeric);
       timphongtro          postgres    false    26            !           1255    43591    function_get_host_home(numeric)    FUNCTION     �  CREATE FUNCTION timphongtro.function_get_host_home(iduser numeric) RETURNS TABLE(id integer, title character varying, description character varying, address character varying, image character varying, verify integer, min_price integer, min_area real, point real, created_at timestamp with time zone, id_ward integer)
    LANGUAGE plpgsql
    AS $$
begin
	return query 
		(SELECT 
				cast (h."ID" as integer) ,
				h."TITLE" ,
				h."DESCRIPTION" ,
				h."ADDRESS" ,
				h."IMAGE" ,
				cast (h."VERIFY" as integer) ,
				cast (h."MIN_PRICE" as integer) ,
				h."MIN_AREA" ,
				h."POINT" ,
				h."CREATED_AT",
				cast (h."IDWARD" as integer)
	   	FROM "HOME" h
	  	WHERE h."IDUSER" = iduser order by h."ID" desc);	
END;
$$;
 B   DROP FUNCTION timphongtro.function_get_host_home(iduser numeric);
       timphongtro          postgres    false    26            "           1255    43592    function_get_list_room(numeric)    FUNCTION     G  CREATE FUNCTION timphongtro.function_get_list_room(idhome numeric) RETURNS TABLE(id integer, price integer, p_area real, description character varying, maximum integer, image character varying, status integer, id_home integer)
    LANGUAGE plpgsql
    AS $$
begin
	return query 
		(SELECT cast (r."ID" as integer),
				cast (r."PRICE" as integer),
				r."AREA",
				r."DESCRIPTION",
				cast (r."MAXIMUM" as integer),
				r."IMAGE",
				cast (r."STATUS" as integer),
				cast (r."IDHOME" as integer)
	   	FROM "ROOM" r 
	  	WHERE r."IDHOME" = idhome order by r."ID" desc);	
END;
$$;
 B   DROP FUNCTION timphongtro.function_get_list_room(idhome numeric);
       timphongtro          postgres    false    26            �            1255    44039 &   function_get_reservation_info(numeric)    FUNCTION     �  CREATE FUNCTION timphongtro.function_get_reservation_info(idroom numeric) RETURNS TABLE(user_id integer, user_name character varying, user_phone character varying, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
begin
	return query 
		(SELECT cast (u."ID" as integer ),
				u."NAME" ,
				u."PHONE" ,
				r."CREATED_AT" 
	   	FROM "RESERVATION" r, "USER" u
	  	WHERE r."IDROOM" = idroom and r."IDUSER" = u."ID" );	
END;
$$;
 I   DROP FUNCTION timphongtro.function_get_reservation_info(idroom numeric);
       timphongtro          postgres    false    26            #           1255    43593 !   function_get_room_detail(numeric)    FUNCTION     0  CREATE FUNCTION timphongtro.function_get_room_detail(idroom numeric) RETURNS TABLE(id integer, price integer, p_area real, description character varying, maximum integer, image character varying, status integer, id_home integer)
    LANGUAGE plpgsql
    AS $$
begin
	return query 
		(SELECT cast (r."ID" as integer),
				cast (r."PRICE" as integer),
				r."AREA",
				r."DESCRIPTION",
				cast (r."MAXIMUM" as integer),
				r."IMAGE",
				cast (r."STATUS" as integer),
				cast (r."IDHOME" as integer)
	   	FROM "ROOM" r 
	  	WHERE r."ID" = idroom);	
END;
$$;
 D   DROP FUNCTION timphongtro.function_get_room_detail(idroom numeric);
       timphongtro          postgres    false    26            $           1255    43594 4   function_get_room_from_reservation(numeric, numeric)    FUNCTION     C  CREATE FUNCTION timphongtro.function_get_room_from_reservation(iduser numeric, idhome numeric) RETURNS TABLE(id integer, price integer, p_area real, description character varying, maximum integer, image character varying, status integer, id_home integer)
    LANGUAGE plpgsql
    AS $$
begin
	drop table IF EXISTS  myIdRoomReservation;
	
	CREATE TEMP TABLE myIdRoomReservation AS
	SELECT r."IDROOM" from "RESERVATION" r where r."IDUSER" = iduser;

	return query 
		(SELECT cast (r."ID" as integer),
				cast (r."PRICE" as integer),
				r."AREA" ,
				r."DESCRIPTION" ,
				cast (r."MAXIMUM" as integer),
				r."IMAGE" ,
				cast (r."STATUS" as integer),
				cast (r."IDHOME"  as integer)
	   	FROM "ROOM" r , myIdRoomReservation
	  	WHERE r."ID" = myIdRoomReservation."IDROOM" and r."IDHOME"  = idhome order by r."ID" desc);	
END;
$$;
 ^   DROP FUNCTION timphongtro.function_get_room_from_reservation(iduser numeric, idhome numeric);
       timphongtro          postgres    false    26            %           1255    43595    function_get_user_info(numeric)    FUNCTION     �  CREATE FUNCTION timphongtro.function_get_user_info(iduser numeric) RETURNS TABLE(id integer, email character varying, u_name character varying, phone character varying, avatar character varying, active integer, u_role integer)
    LANGUAGE plpgsql
    AS $$
begin
	return query 
		(SELECT cast (u."ID" as integer) ,
				u."EMAIL" ,
				u."NAME" ,
				u."PHONE" ,
				u."AVATAR" ,
				cast (u."ACTIVE" as integer) ,
				cast (u."IDROLE" as integer) 
	   	FROM "USER" u
	  	WHERE u."ID" = iduser);	
END;
$$;
 B   DROP FUNCTION timphongtro.function_get_user_info(iduser numeric);
       timphongtro          postgres    false    26            &           1255    43596 J   function_search_home(numeric, numeric, numeric, numeric, numeric, numeric)    FUNCTION     @  CREATE FUNCTION timphongtro.function_search_home(minprice numeric, maxprice numeric, minarea numeric, maxarea numeric, iddistrict numeric, idward numeric) RETURNS TABLE(id integer, title character varying, description character varying, address character varying, image character varying, verify integer, min_price integer, min_area real, point real, created_at timestamp with time zone, id_ward integer)
    LANGUAGE plpgsql
    AS $$
begin
	drop table IF EXISTS  listIdHome;
	CREATE TEMP TABLE listIdHome AS
	SELECT distinct(r."IDHOME") from "ROOM" r where r."PRICE" between minprice and maxprice and r."AREA" between minarea and maxarea;
	
	if(idward != 0) then
		return query
		(SELECT 
				cast (h."ID" as integer) ,
				h."TITLE" ,
				h."DESCRIPTION" ,
				h."ADDRESS" ,
				h."IMAGE" ,
				cast (h."VERIFY" as integer) ,
				cast (h."MIN_PRICE" as integer) ,
				h."MIN_AREA" ,
				h."POINT" ,
				h."CREATED_AT",
				cast (h."IDWARD" as integer)
	   	FROM "HOME" h, listIdHome
	  	WHERE h."ID" = listIdHome."IDHOME" and h."IDWARD" = idward order by h."ID" desc);
	 else
	 	if(iddistrict != 0) then
	 		drop table IF EXISTS  listIdWard;
	
			CREATE TEMP TABLE listIdWard AS
			SELECT w."ID" from "WARD" w where w."IDDISTRICT" = iddistrict;
	
	 		return query
			(SELECT 
				cast (h."ID" as integer) ,
				h."TITLE" ,
				h."DESCRIPTION" ,
				h."ADDRESS" ,
				h."IMAGE" ,
				cast (h."VERIFY" as integer) ,
				cast (h."MIN_PRICE" as integer) ,
				h."MIN_AREA" ,
				h."POINT" ,
				h."CREATED_AT",
				cast (h."IDWARD" as integer)
	   		FROM "HOME" h, listIdWard, listIdHome
	  		WHERE h."ID" = listIdHome."IDHOME" and h."IDWARD" = listIdWard."ID" order by h."ID" desc);
	  	else
	  		return query
			(SELECT 
				cast (h."ID" as integer) ,
				h."TITLE" ,
				h."DESCRIPTION" ,
				h."ADDRESS" ,
				h."IMAGE" ,
				cast (h."VERIFY" as integer) ,
				cast (h."MIN_PRICE" as integer) ,
				h."MIN_AREA" ,
				h."POINT" ,
				h."CREATED_AT",
				cast (h."IDWARD" as integer)
	   		FROM "HOME" h, listIdHome
	  		WHERE h."ID" = listIdHome."IDHOME" order by h."ID" desc);
	  	end if;
	 end if;
END;
$$;
 �   DROP FUNCTION timphongtro.function_search_home(minprice numeric, maxprice numeric, minarea numeric, maxarea numeric, iddistrict numeric, idward numeric);
       timphongtro          postgres    false    26                       1255    24807 <   prc_process_city_info(numeric, character varying, character)    FUNCTION     @  CREATE FUNCTION timphongtro.prc_process_city_info(p_id numeric, p_name character varying, p_action character, OUT p_err_code character, OUT p_err_desc character) RETURNS record
    LANGUAGE plpgsql
    AS $$

begin
	p_err_code := '0';
	p_err_desc := 'OK';
	if p_action = 'ADD' then
		if exists (select 1 from "CITY" c where c."NAME" = p_name) then
			p_err_code := '-1';
			p_err_desc := 'Thành phố đã tồn tại!';
		else
			INSERT INTO "CITY" 
			("ID" , "NAME" )
			VALUES(nextval('seq_city'), p_name);
		end if;
	elseif p_action = 'EDIT' then
		if not exists (select 1 from "CITY" c where c."ID" = p_id) then
			p_err_code := '-1';
			p_err_desc := 'Mã thành phố không tồn tại!';
		elseif exists (select 1 from "CITY" c where c."NAME" = p_name and c."ID" != p_id) then 
			p_err_code := '-1';
			p_err_desc := 'Tên thành phố đã tồn tại!';
		else
			UPDATE "CITY" 
			SET "NAME" = p_name
			WHERE "ID" = p_id;
		end if;
	elseif p_action = 'DEL' then 
		if not exists (select 1 from "CITY" c where c."ID" = p_id) then
			p_err_code := '-1';
			p_err_desc := 'Mã thành phố không tồn tại!';
		elseif exists (select 1 from "DISTRICT" d where d."IDCITY" = p_id) then 
			p_err_code := '-1';
			p_err_desc := 'Không thể xóa thành phố!';
		else
			delete from "CITY" c 
			WHERE c."ID" = p_id;
		end if;
	else
		p_err_code := '-1';
		p_err_desc := 'Error';
	end if;	
	EXCEPTION
  	WHEN others THEN
		p_err_code := '-1';
		p_err_desc := 'Error';
	RAISE LOG  'prc_insert_citran:%, context: %','ERROR:', 'sqlstate: ' || sqlstate || ',sqlerrm: ' || sqlerrm ;
end
$$;
 �   DROP FUNCTION timphongtro.prc_process_city_info(p_id numeric, p_name character varying, p_action character, OUT p_err_code character, OUT p_err_desc character);
       timphongtro          postgres    false    26                       1255    24808 I   prc_process_district_info(numeric, character varying, numeric, character)    FUNCTION     �  CREATE FUNCTION timphongtro.prc_process_district_info(p_id numeric, p_name character varying, p_idcity numeric, p_action character, OUT p_err_code character, OUT p_err_desc character) RETURNS record
    LANGUAGE plpgsql
    AS $$

begin
	p_err_code := '0';
	p_err_desc := 'OK';
	if p_action = 'ADD' then
		if exists (select 1 from "DISTRICT" d where d."NAME" = p_name) then
			p_err_code := '-1';
			p_err_desc := 'Quận đã tồn tại!';
		elseif not exists (select  1 from "CITY" c where c."ID" = p_idcity) then 
			p_err_code := '-1';
			p_err_desc := 'Mã thành phố không tồn tại!';
		else
			INSERT INTO "DISTRICT"
			("ID" , "NAME", "IDCITY")
			VALUES(nextval('seq_district'), p_name, p_idcity);
		end if;
	elseif p_action = 'EDIT' then
		if not exists (select 1 from "DISTRICT" d where d."ID" = p_id) then
			p_err_code := '-1';
			p_err_desc := 'Mã quận không tồn tại!';
		elseif exists (select 1 from "DISTRICT" d where d."NAME" = p_name and d."ID" != p_id) then 
			p_err_code := '-1';
			p_err_desc := 'Tên quận đã tồn tại!';
		elseif not exists (select  1 from "CITY" c where c."ID" = p_idcity) then 
			p_err_code := '-1';
			p_err_desc := 'Mã thành phố không tồn tại!';
		else
			UPDATE "DISTRICT" 
			SET "NAME" = p_name, "IDCITY" = p_idcity
			WHERE "ID" = p_id;
		end if;
	elseif p_action = 'DEL' then 
		if not exists (select 1 from "DISTRICT" d where d."ID" = p_id) then
			p_err_code := '-1';
			p_err_desc := 'Mã quận không tồn tại!';
		elseif exists (select 1 from "STREET" s where s."IDDISTRICT" = p_id) then 
			p_err_code := '-1';
			p_err_desc := 'Không thể xóa quận!';
		else
			delete from "DISTRICT" d 
			WHERE d."ID" = p_id;
		end if;
	else
		p_err_code := '-1';
		p_err_desc := 'Error';
	end if;	
	EXCEPTION
  	WHEN others THEN
		p_err_code := '-1';
		p_err_desc := 'Error';
	RAISE LOG  'prc_insert_citran:%, context: %','ERROR:', 'sqlstate: ' || sqlstate || ',sqlerrm: ' || sqlerrm ;
end
$$;
 �   DROP FUNCTION timphongtro.prc_process_district_info(p_id numeric, p_name character varying, p_idcity numeric, p_action character, OUT p_err_code character, OUT p_err_desc character);
       timphongtro          postgres    false    26                       1255    41594 �   prc_process_home_info(numeric, character varying, character varying, character varying, character varying, numeric, numeric, character)    FUNCTION     �  CREATE FUNCTION timphongtro.prc_process_home_info(p_id numeric, p_title character varying, p_description character varying, p_address character varying, p_image character varying, p_iduser numeric, p_idward numeric, p_action character, OUT p_err_code character, OUT p_err_desc character) RETURNS record
    LANGUAGE plpgsql
    AS $$

begin
	p_err_code := '0';
	p_err_desc := 'OK';
	if p_action = 'ADD' then
		if not exists (select 1 from "USER" u where u."ID" = p_iduser) then
			p_err_code := '-1';
			p_err_desc := 'User không tồn tại!';
		elseif not exists (select 1 from "WARD" w where w."ID" = p_idward) then
			p_err_code := '-1';
			p_err_desc := 'Phường không tồn tại!';
		else
			INSERT INTO "HOME" 
			("ID" , "TITLE" , "DESCRIPTION" , "ADDRESS" , "IMAGE" , "VERIFY" , "IDUSER" , "MIN_PRICE" , "MIN_AREA" , "POINT" , "CREATED_AT" , "IDWARD")
			VALUES(nextval('seq_home'), p_title, p_description, p_address, p_image, 0, p_iduser, 0, 0, 0, now(), p_idward);
		end if;
	elseif p_action = 'EDIT' then
		if not exists (select 1 from "HOME" h where h."ID" = p_id) then
			p_err_code := '-1';
			p_err_desc := 'Mã Home không tồn tại!';
		elseif not exists (select 1 from "WARD" w where w."ID" = p_idward) then
			p_err_code := '-1';
			p_err_desc := 'Phường không tồn tại!';
		else
			UPDATE "HOME" 
			SET "TITLE" = p_title, "DESCRIPTION" = p_description, "ADDRESS" = p_address, "IMAGE" = p_image, "IDWARD" = p_idward
			WHERE "ID" = p_id;
		end if;
	elseif p_action = 'DEL' then 
		if not exists (select 1 from "HOME" h where h."ID" = p_id) then
			p_err_code := '-1';
			p_err_desc := 'Mã Home không tồn tại!';
		elseif exists (select 1 from "ROOM" r where r."IDHOME" = p_id and r."STATUS" = 3) then 
			p_err_code := '-1';
			p_err_desc := 'Đang có người đặt giữ phòng. Không thể xóa!';
		else
			delete from "ROOM" r where r."IDHOME" = p_id;
			delete from "RATING" r1 where r1."IDHOME" = p_id;
			delete from "HOME" h where h."ID" = p_id;
		end if;
	else
		p_err_code := '-1';
		p_err_desc := 'Error';
	end if;	
	EXCEPTION
  	WHEN others THEN
		p_err_code := '-1';
		p_err_desc := 'Error';
	RAISE LOG  'prc_insert_citran:%, context: %','ERROR:', 'sqlstate: ' || sqlstate || ',sqlerrm: ' || sqlerrm ;
end
$$;
   DROP FUNCTION timphongtro.prc_process_home_info(p_id numeric, p_title character varying, p_description character varying, p_address character varying, p_image character varying, p_iduser numeric, p_idward numeric, p_action character, OUT p_err_code character, OUT p_err_desc character);
       timphongtro          postgres    false    26                       1255    25179 Y   prc_process_rating_info(numeric, numeric, double precision, character varying, character)    FUNCTION     Y  CREATE FUNCTION timphongtro.prc_process_rating_info(p_iduser numeric, p_idhome numeric, p_point double precision, p_comment character varying, p_action character, OUT p_err_code character, OUT p_err_desc character) RETURNS record
    LANGUAGE plpgsql
    AS $$

begin
	p_err_code := '0';
	p_err_desc := 'OK';
	if p_action = 'ADD' then
		if not exists (select 1 from "USER" u where u."ID" = p_iduser) then
			p_err_code := '-1';
			p_err_desc := 'User không tồn tại!';
		elseif not exists (select 1 from "HOME" h where h."ID" = p_idhome) then
			p_err_code := '-1';
			p_err_desc := 'Mã Home không tồn tại!';
		elseif exists (select 1 from "RATING" r where r."IDUSER" = p_iduser and r."IDHOME" = p_idhome) then
			p_err_code := '-1';
			p_err_desc := 'User này đã đánh giá bài viết này rồi!';
		else
			INSERT INTO "RATING"
			("IDUSER" , "IDHOME" , "POINT" , "COMMENT")
			VALUES(p_iduser, p_idhome, p_point, p_comment);
		end if;
	elseif p_action = 'DEL' then
		if not exists (select 1 from "USER" u where u."ID" = p_iduser) then
			p_err_code := '-1';
			p_err_desc := 'User không tồn tại!';
		elseif not exists (select 1 from "HOME" h where h."ID" = p_idhome) then
			p_err_code := '-1';
			p_err_desc := 'Mã Home không tồn tại!';
		else
			delete from "RATING" r where r."IDUSER" = p_iduser and r."IDHOME" = p_idhome;
		end if;
	else
		p_err_code := '-1';
		p_err_desc := 'Error';
	end if;	
	EXCEPTION
  	WHEN others THEN
		p_err_code := '-1';
		p_err_desc := 'Error';
	RAISE LOG  'prc_insert_citran:%, context: %','ERROR:', 'sqlstate: ' || sqlstate || ',sqlerrm: ' || sqlerrm ;
end
$$;
 �   DROP FUNCTION timphongtro.prc_process_rating_info(p_iduser numeric, p_idhome numeric, p_point double precision, p_comment character varying, p_action character, OUT p_err_code character, OUT p_err_desc character);
       timphongtro          postgres    false    26            (           1255    41571 9   prc_process_reservation_info(numeric, numeric, character)    FUNCTION     �  CREATE FUNCTION timphongtro.prc_process_reservation_info(p_iduser numeric, p_idroom numeric, p_action character, OUT p_err_code character, OUT p_err_desc character) RETURNS record
    LANGUAGE plpgsql
    AS $$

begin
	p_err_code := '0';
	p_err_desc := 'OK';
	if p_action = 'ADD' then
		if not exists (select 1 from "USER" u where u."ID" = p_iduser) then
			p_err_code := '-1';
			p_err_desc := 'User không tồn tại!';
		elseif not exists (select 1 from "ROOM" r where r."ID" = p_idroom) then
			p_err_code := '-1';
			p_err_desc := 'Mã Room không tồn tại!';
		elseif exists (select 1 from "RESERVATION" r where r."IDUSER" = p_iduser and r."IDROOM" = p_idroom) then
			p_err_code := '-1';
			p_err_desc := 'User này đã đặt phòng này rồi!';
		else
			INSERT INTO timphongtro."RESERVATION"
				("IDUSER", "IDROOM", "CREATED_AT")
				VALUES(p_iduser, p_idroom, now());
		end if;
	elseif p_action = 'DEL' then
		if not exists (select 1 from "ROOM" r where r."ID" = p_idroom) then
			p_err_code := '-1';
			p_err_desc := 'Mã Room không tồn tại!';
		else
			delete from "RESERVATION" r where r."IDUSER" = p_iduser and r."IDROOM" = p_idroom;
		end if;
	else
		p_err_code := '-1';
		p_err_desc := 'Error';
	end if;	
	EXCEPTION
  	WHEN others THEN
		p_err_code := '-1';
		p_err_desc := 'Error';
	RAISE LOG  'prc_insert_citran:%, context: %','ERROR:', 'sqlstate: ' || sqlstate || ',sqlerrm: ' || sqlerrm ;
end
$$;
 �   DROP FUNCTION timphongtro.prc_process_reservation_info(p_iduser numeric, p_idroom numeric, p_action character, OUT p_err_code character, OUT p_err_desc character);
       timphongtro          postgres    false    26                       1255    24810 <   prc_process_role_info(numeric, character varying, character)    FUNCTION     �  CREATE FUNCTION timphongtro.prc_process_role_info(p_id numeric, p_name character varying, p_action character, OUT p_err_code character, OUT p_err_desc character) RETURNS record
    LANGUAGE plpgsql
    AS $$

begin
	p_err_code := '0';
	p_err_desc := 'OK';
	if p_action = 'ADD' then
		if exists (select 1 from "ROLE" r where r."ID" = p_id) then 
			p_err_code := '-1';
			p_err_desc := 'Mã Role đã tồn tại!';
		elseif exists (select 1 from "ROLE" r where r."NAME" = p_name) then
			p_err_code := '-1';
			p_err_desc := 'Tên Role đã tồn tại!';
		else
			INSERT INTO "ROLE" 
			("ID" , "NAME")
			VALUES(p_id, p_name);
		end if;
	elseif p_action = 'EDIT' then
		if not exists (select 1 from "ROLE" r where r."ID" = p_id) then
			p_err_code := '-1';
			p_err_desc := 'Role không tồn tại!';
		elseif exists (select 1 from "ROLE" r where r."NAME" = p_name and r."ID" != p_id) then 
			p_err_code := '-1';
			p_err_desc := 'Tên Role đã tồn tại!';
		else
			UPDATE "ROLE"
			SET "NAME" = p_name
			WHERE "ID" = p_id;
		end if;
	elseif p_action = 'DEL' then 
		if not exists (select 1 from "ROLE" r where r."ID" = p_id) then
			p_err_code := '-1';
			p_err_desc := 'Role không tồn tại!';
		elseif exists (select 1 from "USER" u where u."IDROLE" = p_id) then 
			p_err_code := '-1';
			p_err_desc := 'Không thể xóa role!';
		else
			delete from "ROLE" r
			WHERE r."ID" = p_id;
		end if;
	else
		p_err_code := '-1';
		p_err_desc := 'Error';
	end if;	
	EXCEPTION
  	WHEN others THEN
		p_err_code := '-1';
		p_err_desc := 'Error';
	RAISE LOG  'prc_insert_citran:%, context: %','ERROR:', 'sqlstate: ' || sqlstate || ',sqlerrm: ' || sqlerrm ;
end
$$;
 �   DROP FUNCTION timphongtro.prc_process_role_info(p_id numeric, p_name character varying, p_action character, OUT p_err_code character, OUT p_err_desc character);
       timphongtro          postgres    false    26                       1255    25177 �   prc_process_room_info(numeric, numeric, double precision, character varying, numeric, character varying, numeric, numeric, character)    FUNCTION     B  CREATE FUNCTION timphongtro.prc_process_room_info(p_id numeric, p_price numeric, p_area double precision, p_description character varying, p_maximum numeric, p_image character varying, p_status numeric, p_idhome numeric, p_action character, OUT p_err_code character, OUT p_err_desc character) RETURNS record
    LANGUAGE plpgsql
    AS $$

begin
	p_err_code := '0';
	p_err_desc := 'OK';
	if p_action = 'ADD' then
		if not exists (select 1 from "HOME" h where h."ID" = p_idhome) then
			p_err_code := '-1';
			p_err_desc := 'Mã Home không tồn tại!';
		else
			INSERT INTO "ROOM" 
			("ID" , "PRICE" , "AREA" , "DESCRIPTION" , "MAXIMUM" , "IMAGE" , "STATUS" , "IDHOME")
			VALUES(nextval('seq_room'), p_price, p_area, p_description, p_maximum, p_image, 1, p_idhome);
		end if;
	elseif p_action = 'EDIT' then
		if not exists (select 1 from "ROOM" r where r."ID" = p_id) then
			p_err_code := '-1';
			p_err_desc := 'Mã Room không tồn tại!';
		else
			UPDATE "ROOM" 
			SET "PRICE" = p_price, "AREA" = p_area, "DESCRIPTION" = p_description, "MAXIMUM" = p_maximum, "IMAGE" = p_image
			WHERE "ID" = p_id;
		end if;
	elseif p_action = 'DEL' then 
		if not exists (select 1 from "ROOM" r where r."ID" = p_id) then
			p_err_code := '-1';
			p_err_desc := 'Mã Room không tồn tại!';
		elseif exists (select 1 from "ROOM" r where r."ID" = p_id and r."STATUS" = 3) then 
			p_err_code := '-1';
			p_err_desc := 'Đang có người đặt giữ phòng. Không thể xóa!';
		else
			delete from "RESERVATION" r1 where r1."IDROOM" = p_id;
			delete from "ROOM" r where r."ID" = p_id;
		end if;
	else
		p_err_code := '-1';
		p_err_desc := 'Error';
	end if;	
	EXCEPTION
  	WHEN others THEN
		p_err_code := '-1';
		p_err_desc := 'Error';
	RAISE LOG  'prc_insert_citran:%, context: %','ERROR:', 'sqlstate: ' || sqlstate || ',sqlerrm: ' || sqlerrm ;
end
$$;
 $  DROP FUNCTION timphongtro.prc_process_room_info(p_id numeric, p_price numeric, p_area double precision, p_description character varying, p_maximum numeric, p_image character varying, p_status numeric, p_idhome numeric, p_action character, OUT p_err_code character, OUT p_err_desc character);
       timphongtro          postgres    false    26                       1255    33379 �   prc_process_user_info(numeric, character varying, character varying, character varying, character varying, character varying, numeric, numeric, character)    FUNCTION       CREATE FUNCTION timphongtro.prc_process_user_info(p_id numeric, p_email character varying, p_password character varying, p_name character varying, p_phone character varying, p_avatar character varying, p_active numeric, p_idrole numeric, p_action character, OUT p_err_code character, OUT p_err_desc character) RETURNS record
    LANGUAGE plpgsql
    AS $$

begin
	p_err_code := '0';
	p_err_desc := 'OK';
	if p_action = 'ADD' then
		if exists (select 1 from "USER" u where u."EMAIL" = p_email) then
			p_err_code := '-1';
			p_err_desc := 'Email đã tồn tại!';
		elseif exists (select 1 from "USER" u where u."PHONE" = p_phone) then
			p_err_code := '-1';
			p_err_desc := 'Số điện thoại đã tồn tại!';
		elseif not exists (select 1 from "ROLE" r where r."ID" = p_idrole) then
			p_err_code := '-1';
			p_err_desc := 'Role không tồn tại!';
		else
			INSERT INTO "USER"
			("ID" , "EMAIL" , "PASSWORD" , "NAME" , "PHONE" , "AVATAR" , "ACTIVE" , "IDROLE")
			VALUES(nextval('seq_user'),p_email, p_password, p_name, p_phone, p_avatar, 1, p_idrole);
		end if;
	elseif p_action = 'EDIT' then
		if not exists (select 1 from "USER" u where u."ID" = p_id) then
			p_err_code := '-1';
			p_err_desc := 'User đăng nhập không tồn tại!';
		elseif exists (select 1 from "USER" u where u."PHONE" = p_phone and u."ID" != p_id) then 
			p_err_code := '-1';
			p_err_desc := 'Số điện thoại đã tồn tại!';
		else
			UPDATE "USER"
			SET "NAME" = p_name, "PHONE" = p_phone, "AVATAR" = p_avatar
			WHERE "ID" = p_id;
		end if;
	elseif p_action = 'DEL' then 
		if not exists (select 1 from "USER" u where u."ID" = p_id ) then
			p_err_code := '-1';
			p_err_desc := 'User đăng nhập không tồn tại!';
		else
			UPDATE "USER"
			SET "ACTIVE" = 0
			WHERE "ID" = p_id;
		end if;
	else
		p_err_code := '-1';
		p_err_desc := 'Error';
	end if;	
	EXCEPTION
  	WHEN others THEN
		p_err_code := '-1';
		p_err_desc := 'Error';
	RAISE LOG  'prc_insert_citran:%, context: %','ERROR:', 'sqlstate: ' || sqlstate || ',sqlerrm: ' || sqlerrm ;
end
$$;
 5  DROP FUNCTION timphongtro.prc_process_user_info(p_id numeric, p_email character varying, p_password character varying, p_name character varying, p_phone character varying, p_avatar character varying, p_active numeric, p_idrole numeric, p_action character, OUT p_err_code character, OUT p_err_desc character);
       timphongtro          postgres    false    26                       1255    42000 E   prc_process_ward_info(numeric, character varying, numeric, character)    FUNCTION     n  CREATE FUNCTION timphongtro.prc_process_ward_info(p_id numeric, p_name character varying, p_iddistrict numeric, p_action character, OUT p_err_code character, OUT p_err_desc character) RETURNS record
    LANGUAGE plpgsql
    AS $$

begin
	p_err_code := '0';
	p_err_desc := 'OK';
	if p_action = 'ADD' then
		if not exists (select 1 from "DISTRICT" d where d."ID" = p_iddistrict) then 
			p_err_code := '-1';
			p_err_desc := 'Mã quận không tồn tại!';
		elseif exists (select 1 from "WARD" w where w."NAME" = p_name and w."IDDISTRICT" = p_iddistrict) then 
			p_err_code := '-1';
			p_err_desc := 'Tên phường/xã đã tồn tại!';
		else
			INSERT INTO "WARD" 
			("ID" , "NAME", "IDDISTRICT" )
			VALUES(nextval('seq_ward'), p_name, p_iddistrict);
		end if;
	elseif p_action = 'EDIT' then
		if not exists (select 1 from "WARD" w where w."ID" = p_id) then
			p_err_code := '-1';
			p_err_desc := 'Mã phường/xã không tồn tại!';
		elseif not exists (select  1 from "DISTRICT" d where d."ID" = p_iddistrict) then 
			p_err_code := '-1';
			p_err_desc := 'Mã quận không tồn tại!';
		elseif exists (select 1 from "WARD" w where w."NAME" = p_name and w."IDDISTRICT" = p_iddistrict) then 
			p_err_code := '-1';
			p_err_desc := 'Tên phường/xã đã tồn tại!';
		else
			UPDATE "WARD" 
			SET "NAME" = p_name, "IDDISTRICT" = p_iddistrict
			WHERE "ID" = p_id;
		end if;
	elseif p_action = 'DEL' then 
		if not exists (select 1 from "WARD" w where w."ID" = p_id) then
			p_err_code := '-1';
			p_err_desc := 'Mã phường/xã không tồn tại!';
		else
			delete from "WARD" w
			WHERE w."ID" = p_id;
		end if;
	else
		p_err_code := '-1';
		p_err_desc := 'Error';
	end if;	
	EXCEPTION
  	WHEN others THEN
		p_err_code := '-1';
		p_err_desc := 'Error';
	RAISE LOG  'prc_insert_citran:%, context: %','ERROR:', 'sqlstate: ' || sqlstate || ',sqlerrm: ' || sqlerrm ;
end
$$;
 �   DROP FUNCTION timphongtro.prc_process_ward_info(p_id numeric, p_name character varying, p_iddistrict numeric, p_action character, OUT p_err_code character, OUT p_err_desc character);
       timphongtro          postgres    false    26            �            1259    16568    CITY    TABLE     f   CREATE TABLE timphongtro."CITY" (
    "ID" numeric NOT NULL,
    "NAME" character varying NOT NULL
);
    DROP TABLE timphongtro."CITY";
       timphongtro         heap    postgres    false    26            �            1259    16576    DISTRICT    TABLE     �   CREATE TABLE timphongtro."DISTRICT" (
    "ID" numeric NOT NULL,
    "NAME" character varying NOT NULL,
    "IDCITY" numeric NOT NULL
);
 #   DROP TABLE timphongtro."DISTRICT";
       timphongtro         heap    postgres    false    26            �            1259    16527    HOME    TABLE     �  CREATE TABLE timphongtro."HOME" (
    "ID" numeric NOT NULL,
    "TITLE" character varying NOT NULL,
    "DESCRIPTION" character varying NOT NULL,
    "ADDRESS" character varying NOT NULL,
    "IMAGE" character varying NOT NULL,
    "VERIFY" numeric NOT NULL,
    "IDUSER" numeric NOT NULL,
    "MIN_PRICE" numeric,
    "MIN_AREA" real,
    "POINT" real,
    "CREATED_AT" timestamp with time zone NOT NULL,
    "IDWARD" numeric NOT NULL
);
    DROP TABLE timphongtro."HOME";
       timphongtro         heap    postgres    false    26            �            1259    16545    RATING    TABLE     �   CREATE TABLE timphongtro."RATING" (
    "IDUSER" numeric NOT NULL,
    "IDHOME" numeric NOT NULL,
    "POINT" real NOT NULL,
    "COMMENT" character varying(200)
);
 !   DROP TABLE timphongtro."RATING";
       timphongtro         heap    postgres    false    26            �            1259    16627    RESERVATION    TABLE     �   CREATE TABLE timphongtro."RESERVATION" (
    "IDUSER" numeric NOT NULL,
    "IDROOM" numeric NOT NULL,
    "CREATED_AT" timestamp with time zone NOT NULL
);
 &   DROP TABLE timphongtro."RESERVATION";
       timphongtro         heap    postgres    false    26            �            1259    16614    ROLE    TABLE     j   CREATE TABLE timphongtro."ROLE" (
    "ID" numeric NOT NULL,
    "NAME" character varying(50) NOT NULL
);
    DROP TABLE timphongtro."ROLE";
       timphongtro         heap    postgres    false    26            �            1259    16555    ROOM    TABLE     +  CREATE TABLE timphongtro."ROOM" (
    "ID" numeric NOT NULL,
    "PRICE" numeric NOT NULL,
    "AREA" real NOT NULL,
    "DESCRIPTION" character varying NOT NULL,
    "MAXIMUM" numeric NOT NULL,
    "IMAGE" character varying NOT NULL,
    "STATUS" numeric NOT NULL,
    "IDHOME" numeric NOT NULL
);
    DROP TABLE timphongtro."ROOM";
       timphongtro         heap    postgres    false    26            �            1259    16519    USER    TABLE     Q  CREATE TABLE timphongtro."USER" (
    "ID" numeric NOT NULL,
    "EMAIL" character varying(50) NOT NULL,
    "PASSWORD" character varying(200) NOT NULL,
    "NAME" character varying(100) NOT NULL,
    "PHONE" character varying(12) NOT NULL,
    "AVATAR" character varying,
    "ACTIVE" numeric NOT NULL,
    "IDROLE" numeric NOT NULL
);
    DROP TABLE timphongtro."USER";
       timphongtro         heap    postgres    false    26            �            1259    16589    WARD    TABLE     �   CREATE TABLE timphongtro."WARD" (
    "ID" numeric NOT NULL,
    "NAME" character varying NOT NULL,
    "IDDISTRICT" numeric NOT NULL
);
    DROP TABLE timphongtro."WARD";
       timphongtro         heap    postgres    false    26            �            1259    16645    seq_city    SEQUENCE     v   CREATE SEQUENCE timphongtro.seq_city
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE timphongtro.seq_city;
       timphongtro          postgres    false    26            �            1259    16647    seq_district    SEQUENCE     z   CREATE SEQUENCE timphongtro.seq_district
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE timphongtro.seq_district;
       timphongtro          postgres    false    26            �            1259    16653    seq_home    SEQUENCE     v   CREATE SEQUENCE timphongtro.seq_home
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE timphongtro.seq_home;
       timphongtro          postgres    false    26            �            1259    16651    seq_role    SEQUENCE     v   CREATE SEQUENCE timphongtro.seq_role
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE timphongtro.seq_role;
       timphongtro          postgres    false    26            �            1259    16655    seq_room    SEQUENCE     v   CREATE SEQUENCE timphongtro.seq_room
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE timphongtro.seq_room;
       timphongtro          postgres    false    26            �            1259    16649 
   seq_street    SEQUENCE     x   CREATE SEQUENCE timphongtro.seq_street
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE timphongtro.seq_street;
       timphongtro          postgres    false    26            �            1259    16612    seq_user    SEQUENCE     v   CREATE SEQUENCE timphongtro.seq_user
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE timphongtro.seq_user;
       timphongtro          postgres    false    26            �            1259    41998    seq_ward    SEQUENCE     v   CREATE SEQUENCE timphongtro.seq_ward
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE timphongtro.seq_ward;
       timphongtro          postgres    false    26            �            1259    42014    v_list_city    VIEW     u   CREATE VIEW timphongtro.v_list_city AS
 SELECT (c."ID")::integer AS "ID",
    c."NAME"
   FROM timphongtro."CITY" c;
 #   DROP VIEW timphongtro.v_list_city;
       timphongtro          postgres    false    235    235    26            �            1259    42018    v_list_district    VIEW     �   CREATE VIEW timphongtro.v_list_district AS
 SELECT (d."ID")::integer AS "ID",
    d."NAME",
    (d."IDCITY")::integer AS "IDCITY"
   FROM timphongtro."DISTRICT" d;
 '   DROP VIEW timphongtro.v_list_district;
       timphongtro          postgres    false    236    236    236    26            �            1259    42022    v_list_ward    VIEW     �   CREATE VIEW timphongtro.v_list_ward AS
 SELECT (w."ID")::integer AS "ID",
    w."NAME",
    (w."IDDISTRICT")::integer AS "IDDISTRICT"
   FROM timphongtro."WARD" w;
 #   DROP VIEW timphongtro.v_list_ward;
       timphongtro          postgres    false    237    237    237    26            �            1259    43583    view_list_home    VIEW     �  CREATE VIEW timphongtro.view_list_home AS
 SELECT (h."ID")::integer AS id,
    h."TITLE" AS title,
    h."DESCRIPTION" AS description,
    h."ADDRESS" AS address,
    h."IMAGE" AS image,
    (h."MIN_PRICE")::integer AS min_price,
    h."MIN_AREA" AS min_area,
    h."POINT" AS point,
    (h."VERIFY")::integer AS verify,
    (h."IDUSER")::integer AS id_user,
    h."CREATED_AT" AS created_at,
    (h."IDWARD")::integer AS id_ward
   FROM timphongtro."HOME" h
  ORDER BY h."ID" DESC;
 &   DROP VIEW timphongtro.view_list_home;
       timphongtro          postgres    false    232    232    232    232    232    232    232    232    232    232    232    232    26            �            1259    43579    view_list_home_active    VIEW       CREATE VIEW timphongtro.view_list_home_active AS
 SELECT (h."ID")::integer AS id,
    h."TITLE" AS title,
    h."DESCRIPTION" AS description,
    h."ADDRESS" AS address,
    h."IMAGE" AS image,
    (h."MIN_PRICE")::integer AS min_price,
    h."MIN_AREA" AS min_area,
    h."POINT" AS point,
    (h."VERIFY")::integer AS verify,
    (h."IDUSER")::integer AS id_user,
    h."CREATED_AT" AS created_at,
    (h."IDWARD")::integer AS id_ward
   FROM timphongtro."HOME" h
  WHERE (h."VERIFY" = (1)::numeric)
  ORDER BY h."ID" DESC;
 -   DROP VIEW timphongtro.view_list_home_active;
       timphongtro          postgres    false    232    232    232    232    232    232    232    232    232    232    232    232    26            �            1259    43706    view_list_user    VIEW     *  CREATE VIEW timphongtro.view_list_user AS
 SELECT (u."ID")::integer AS id,
    u."EMAIL" AS email,
    u."NAME" AS u_name,
    u."PHONE" AS phone,
    u."AVATAR" AS avatar,
    (u."ACTIVE")::integer AS active,
    (u."IDROLE")::integer AS u_role
   FROM timphongtro."USER" u
  ORDER BY u."IDROLE";
 &   DROP VIEW timphongtro.view_list_user;
       timphongtro          postgres    false    231    231    231    231    231    231    231    26            '          0    16568    CITY 
   TABLE DATA           3   COPY timphongtro."CITY" ("ID", "NAME") FROM stdin;
    timphongtro          postgres    false    235   E�       (          0    16576    DISTRICT 
   TABLE DATA           A   COPY timphongtro."DISTRICT" ("ID", "NAME", "IDCITY") FROM stdin;
    timphongtro          postgres    false    236   ��       $          0    16527    HOME 
   TABLE DATA           �   COPY timphongtro."HOME" ("ID", "TITLE", "DESCRIPTION", "ADDRESS", "IMAGE", "VERIFY", "IDUSER", "MIN_PRICE", "MIN_AREA", "POINT", "CREATED_AT", "IDWARD") FROM stdin;
    timphongtro          postgres    false    232   s�       %          0    16545    RATING 
   TABLE DATA           O   COPY timphongtro."RATING" ("IDUSER", "IDHOME", "POINT", "COMMENT") FROM stdin;
    timphongtro          postgres    false    233   2�       ,          0    16627    RESERVATION 
   TABLE DATA           N   COPY timphongtro."RESERVATION" ("IDUSER", "IDROOM", "CREATED_AT") FROM stdin;
    timphongtro          postgres    false    240   ��       +          0    16614    ROLE 
   TABLE DATA           3   COPY timphongtro."ROLE" ("ID", "NAME") FROM stdin;
    timphongtro          postgres    false    239   ��       &          0    16555    ROOM 
   TABLE DATA           s   COPY timphongtro."ROOM" ("ID", "PRICE", "AREA", "DESCRIPTION", "MAXIMUM", "IMAGE", "STATUS", "IDHOME") FROM stdin;
    timphongtro          postgres    false    234   $       #          0    16519    USER 
   TABLE DATA           o   COPY timphongtro."USER" ("ID", "EMAIL", "PASSWORD", "NAME", "PHONE", "AVATAR", "ACTIVE", "IDROLE") FROM stdin;
    timphongtro          postgres    false    231   h      )          0    16589    WARD 
   TABLE DATA           A   COPY timphongtro."WARD" ("ID", "NAME", "IDDISTRICT") FROM stdin;
    timphongtro          postgres    false    237   6      :           0    0    seq_city    SEQUENCE SET     ;   SELECT pg_catalog.setval('timphongtro.seq_city', 1, true);
          timphongtro          postgres    false    241            ;           0    0    seq_district    SEQUENCE SET     @   SELECT pg_catalog.setval('timphongtro.seq_district', 24, true);
          timphongtro          postgres    false    242            <           0    0    seq_home    SEQUENCE SET     <   SELECT pg_catalog.setval('timphongtro.seq_home', 23, true);
          timphongtro          postgres    false    245            =           0    0    seq_role    SEQUENCE SET     <   SELECT pg_catalog.setval('timphongtro.seq_role', 34, true);
          timphongtro          postgres    false    244            >           0    0    seq_room    SEQUENCE SET     <   SELECT pg_catalog.setval('timphongtro.seq_room', 33, true);
          timphongtro          postgres    false    246            ?           0    0 
   seq_street    SEQUENCE SET     =   SELECT pg_catalog.setval('timphongtro.seq_street', 1, true);
          timphongtro          postgres    false    243            @           0    0    seq_user    SEQUENCE SET     <   SELECT pg_catalog.setval('timphongtro.seq_user', 23, true);
          timphongtro          postgres    false    238            A           0    0    seq_ward    SEQUENCE SET     =   SELECT pg_catalog.setval('timphongtro.seq_ward', 321, true);
          timphongtro          postgres    false    247            �           2606    16575    CITY CITY_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY timphongtro."CITY"
    ADD CONSTRAINT "CITY_pkey" PRIMARY KEY ("ID");
 A   ALTER TABLE ONLY timphongtro."CITY" DROP CONSTRAINT "CITY_pkey";
       timphongtro            postgres    false    235            �           2606    16583    DISTRICT DISTRICT_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY timphongtro."DISTRICT"
    ADD CONSTRAINT "DISTRICT_pkey" PRIMARY KEY ("ID");
 I   ALTER TABLE ONLY timphongtro."DISTRICT" DROP CONSTRAINT "DISTRICT_pkey";
       timphongtro            postgres    false    236            �           2606    16534    HOME HOME_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY timphongtro."HOME"
    ADD CONSTRAINT "HOME_pkey" PRIMARY KEY ("ID");
 A   ALTER TABLE ONLY timphongtro."HOME" DROP CONSTRAINT "HOME_pkey";
       timphongtro            postgres    false    232            �           2606    16552    RATING RATING_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY timphongtro."RATING"
    ADD CONSTRAINT "RATING_pkey" PRIMARY KEY ("IDUSER", "IDHOME");
 E   ALTER TABLE ONLY timphongtro."RATING" DROP CONSTRAINT "RATING_pkey";
       timphongtro            postgres    false    233    233            �           2606    16634    RESERVATION RESERVATION_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY timphongtro."RESERVATION"
    ADD CONSTRAINT "RESERVATION_pkey" PRIMARY KEY ("IDUSER", "IDROOM");
 O   ALTER TABLE ONLY timphongtro."RESERVATION" DROP CONSTRAINT "RESERVATION_pkey";
       timphongtro            postgres    false    240    240            �           2606    16621    ROLE ROLE_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY timphongtro."ROLE"
    ADD CONSTRAINT "ROLE_pkey" PRIMARY KEY ("ID");
 A   ALTER TABLE ONLY timphongtro."ROLE" DROP CONSTRAINT "ROLE_pkey";
       timphongtro            postgres    false    239            �           2606    16562    ROOM ROOM_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY timphongtro."ROOM"
    ADD CONSTRAINT "ROOM_pkey" PRIMARY KEY ("ID");
 A   ALTER TABLE ONLY timphongtro."ROOM" DROP CONSTRAINT "ROOM_pkey";
       timphongtro            postgres    false    234            �           2606    16596    WARD STREET_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY timphongtro."WARD"
    ADD CONSTRAINT "STREET_pkey" PRIMARY KEY ("ID");
 C   ALTER TABLE ONLY timphongtro."WARD" DROP CONSTRAINT "STREET_pkey";
       timphongtro            postgres    false    237                       2606    16526    USER USER_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY timphongtro."USER"
    ADD CONSTRAINT "USER_pkey" PRIMARY KEY ("ID");
 A   ALTER TABLE ONLY timphongtro."USER" DROP CONSTRAINT "USER_pkey";
       timphongtro            postgres    false    231            �           2620    41573    RATING tr_after_delete    TRIGGER     �   CREATE TRIGGER tr_after_delete AFTER DELETE ON timphongtro."RATING" FOR EACH ROW EXECUTE FUNCTION timphongtro.calculate_point_delete();
 6   DROP TRIGGER tr_after_delete ON timphongtro."RATING";
       timphongtro          postgres    false    272    233            �           2620    41629    ROOM tr_after_delete    TRIGGER     �   CREATE TRIGGER tr_after_delete AFTER DELETE ON timphongtro."ROOM" FOR EACH ROW EXECUTE FUNCTION timphongtro.calculate_price_area_delete();
 4   DROP TRIGGER tr_after_delete ON timphongtro."ROOM";
       timphongtro          postgres    false    234    273            �           2620    33371    RATING tr_after_inser    TRIGGER     �   CREATE TRIGGER tr_after_inser AFTER INSERT ON timphongtro."RATING" FOR EACH ROW EXECUTE FUNCTION timphongtro.calculate_point_insert();
 5   DROP TRIGGER tr_after_inser ON timphongtro."RATING";
       timphongtro          postgres    false    233    270            �           2620    41628    ROOM tr_after_insert    TRIGGER     �   CREATE TRIGGER tr_after_insert AFTER INSERT ON timphongtro."ROOM" FOR EACH ROW EXECUTE FUNCTION timphongtro.calculate_price_area_insert();
 4   DROP TRIGGER tr_after_insert ON timphongtro."ROOM";
       timphongtro          postgres    false    234    274            �           2620    41633    ROOM tr_after_update    TRIGGER     �   CREATE TRIGGER tr_after_update AFTER UPDATE ON timphongtro."ROOM" FOR EACH ROW EXECUTE FUNCTION timphongtro.calculate_price_area_update();
 4   DROP TRIGGER tr_after_update ON timphongtro."ROOM";
       timphongtro          postgres    false    234    275            �           2606    16584    DISTRICT FK_DISTRICT_CITY    FK CONSTRAINT     �   ALTER TABLE ONLY timphongtro."DISTRICT"
    ADD CONSTRAINT "FK_DISTRICT_CITY" FOREIGN KEY ("IDCITY") REFERENCES timphongtro."CITY"("ID") ON UPDATE CASCADE NOT VALID;
 L   ALTER TABLE ONLY timphongtro."DISTRICT" DROP CONSTRAINT "FK_DISTRICT_CITY";
       timphongtro          postgres    false    235    3207    236            �           2606    16540    HOME FK_HOME_USER    FK CONSTRAINT     �   ALTER TABLE ONLY timphongtro."HOME"
    ADD CONSTRAINT "FK_HOME_USER" FOREIGN KEY ("IDUSER") REFERENCES timphongtro."USER"("ID") ON UPDATE CASCADE NOT VALID;
 D   ALTER TABLE ONLY timphongtro."HOME" DROP CONSTRAINT "FK_HOME_USER";
       timphongtro          postgres    false    231    232    3199            �           2606    41589    HOME FK_HOME_WARD    FK CONSTRAINT     �   ALTER TABLE ONLY timphongtro."HOME"
    ADD CONSTRAINT "FK_HOME_WARD" FOREIGN KEY ("IDWARD") REFERENCES timphongtro."WARD"("ID") NOT VALID;
 D   ALTER TABLE ONLY timphongtro."HOME" DROP CONSTRAINT "FK_HOME_WARD";
       timphongtro          postgres    false    237    232    3211            �           2606    16607    RATING FK_RATING_HOME    FK CONSTRAINT     �   ALTER TABLE ONLY timphongtro."RATING"
    ADD CONSTRAINT "FK_RATING_HOME" FOREIGN KEY ("IDHOME") REFERENCES timphongtro."HOME"("ID") ON UPDATE CASCADE NOT VALID;
 H   ALTER TABLE ONLY timphongtro."RATING" DROP CONSTRAINT "FK_RATING_HOME";
       timphongtro          postgres    false    3201    233    232            �           2606    16602    RATING FK_RATING_USER    FK CONSTRAINT     �   ALTER TABLE ONLY timphongtro."RATING"
    ADD CONSTRAINT "FK_RATING_USER" FOREIGN KEY ("IDUSER") REFERENCES timphongtro."USER"("ID") ON UPDATE CASCADE NOT VALID;
 H   ALTER TABLE ONLY timphongtro."RATING" DROP CONSTRAINT "FK_RATING_USER";
       timphongtro          postgres    false    3199    233    231            �           2606    16563    ROOM FK_ROOM_HOME    FK CONSTRAINT     �   ALTER TABLE ONLY timphongtro."ROOM"
    ADD CONSTRAINT "FK_ROOM_HOME" FOREIGN KEY ("IDHOME") REFERENCES timphongtro."HOME"("ID") ON UPDATE CASCADE NOT VALID;
 D   ALTER TABLE ONLY timphongtro."ROOM" DROP CONSTRAINT "FK_ROOM_HOME";
       timphongtro          postgres    false    234    3201    232            �           2606    16597    WARD FK_STREET_DISTRICT    FK CONSTRAINT     �   ALTER TABLE ONLY timphongtro."WARD"
    ADD CONSTRAINT "FK_STREET_DISTRICT" FOREIGN KEY ("IDDISTRICT") REFERENCES timphongtro."DISTRICT"("ID") ON UPDATE CASCADE NOT VALID;
 J   ALTER TABLE ONLY timphongtro."WARD" DROP CONSTRAINT "FK_STREET_DISTRICT";
       timphongtro          postgres    false    237    3209    236            �           2606    16622    USER FK_USER_ROLE    FK CONSTRAINT     �   ALTER TABLE ONLY timphongtro."USER"
    ADD CONSTRAINT "FK_USER_ROLE" FOREIGN KEY ("IDROLE") REFERENCES timphongtro."ROLE"("ID") ON UPDATE CASCADE NOT VALID;
 D   ALTER TABLE ONLY timphongtro."USER" DROP CONSTRAINT "FK_USER_ROLE";
       timphongtro          postgres    false    239    231    3213            �           2606    16640    RESERVATION PK_RESERVATION_ROOM    FK CONSTRAINT     �   ALTER TABLE ONLY timphongtro."RESERVATION"
    ADD CONSTRAINT "PK_RESERVATION_ROOM" FOREIGN KEY ("IDROOM") REFERENCES timphongtro."ROOM"("ID") ON UPDATE CASCADE NOT VALID;
 R   ALTER TABLE ONLY timphongtro."RESERVATION" DROP CONSTRAINT "PK_RESERVATION_ROOM";
       timphongtro          postgres    false    234    240    3205            �           2606    16635    RESERVATION PK_RESERVATION_USER    FK CONSTRAINT     �   ALTER TABLE ONLY timphongtro."RESERVATION"
    ADD CONSTRAINT "PK_RESERVATION_USER" FOREIGN KEY ("IDUSER") REFERENCES timphongtro."USER"("ID") ON UPDATE CASCADE NOT VALID;
 R   ALTER TABLE ONLY timphongtro."RESERVATION" DROP CONSTRAINT "PK_RESERVATION_USER";
       timphongtro          postgres    false    3199    240    231            '   ,   x�3��8� /C� ���
wOVp�8�V�73/�+F��� 4�      (   �   x�]�1�0 ��y���JX@ !&�.�R�0�V>�H�`�t�O��l��&Koo�� B͠b�!aH�m�C���EHR��!C�Hn�A�*@2�:@Bz�Z5u��t򧍷���D���f�d%tl�U#�H4mn��N4"+����zm|})��`�\�z�=�qM���t$7%Y-v���'��X�ȸ�:�M�V�>����V�o���      $   �  x���Ak�@�ϳ��ݻ�3��n������Z1²�N�k"�(<	OR�n�����i�~��&��t��PݰC2��������D
��0�B6Ia�&�<:�,J`?�$�v�5!�u6{�d�_���Hї�H#�e�m@8�M؃<��N.�M�t�U��8�7q^g��*Ly�/��]¦.�BO�3���SNCJ���]�J��c��Γ�`Haq��Ɖo3֩��Ty�ux'� ���E�P��עx]���.�P�:9����N!��4�P�H����^B+uq>]�Ǭ�gY��懗2�J�YyeV�3���EO��:�-�\��h��mף��R{-���J`m���c�e�j78_�����f�a�V���d�:j5;<��X�S]�"�m�R(,���M33�>X�n&������W9��K4�y����V4��Z�f�����k�����OM��c3c,��b��HM�c�+J��>�S3x��O|?J�H��Kw����?6��L�����Gd�%�dlc��}�Wd��W������-m��.�c�*��G��$����QF
v��iX�0Iԩi$����C�lӰVSs�i���;|��Y�ߔ�
�au�4�f�4���q����ފnC����}�G��9�L�����}^E��w��op��      %   n   x�34�4��44��8�)/]�$#��B �{xa��B��]�3@�^=����'�(hTjr�4Yr:&%s�t[��� ��: A$�'�)�e�e�4pZp�gs��qqq t�$�      ,   1   x�34�42�4202�5��52U04�25�2��32�042�60����� �I7      +   #   x�3�tt����2�v�2�������� O�^      &   4  x�u��N�0���S��(�$M3��20"����Ʃڂ�0��������S:0��=�&8iR*�X^|��~�}���9�Uj>�ę����We�S���ŝ��s5O֘�j����ŋ��^����{\*�%���kD�E#:��2[�Ʒ�<�ܻE"���w4 �v��x���Y��\�|L�y��X~��`�h���w\��m@�?��rT�SDM�.��[F�+|�7VQ%�L���x��*��#1���e������N{��Ӝa#�{~\���j�l_��٩��������Nn\B�/E"ě      #   �  x�m�ˎ�F���S���*�w3�}l0(RT��pL�`o����2�H%�(Ӌ,z���7��ne��7��ￜs�� �.Lq|`�,?@����u�Pxg�u�sz���9����Q�-v¡O���Б~a�N��s����H���ϟ?R�񒤈�"
 @�����0�|L���k+]oy-M��/��Y�肓�%��n"�9�L^��͵FXTϏ?��=}$��dU�EAodԂ<86FC��(&�=�ra��I����r��>t�@X���/��\�ʅ�c�?���Q�w)����Ix�>���4|"Q�YVI�����I�A�*6Rp�	�e�#ѝ�]�@k�tϡYz�&w�IeAk^1��|��c���u�>?�Q���|~�����yI�P���:$P��e���Fa��PLV�n���M��5e30P�іj�dU�X��+������MRyE慷T@�[�=�اCg3_=�ż��6a?�	:��ܝ�mfp��� �<q�c~1b�+��}��%w������`?��=�3�kr��~����{��nZ]����0T�^��r<q�ۉ���ڝۇ_AM���
[�~Q�C+�R]�\KN
R���F@�"5�+˛S�fey���f퐜�����!���+���(x�)#�q����W'��V�Ug�Z�C�K��|����z��ay�_� âjV�3�=���M��E��A���*�����G�=��x��8�W�y��X����a�E��ͱ45��p`�p[ܿ�U2�Q��fYA�$q� }�o!�����\�)����$wJ�Lgyǝ�du������Z��X��2�0Z���(�
��_��ˏ�m�_2GHT�m�D@o�k��Q>�=5��8;=͗~x�����-ُ��ήү�q��>\��&�>��d��~��*����V�����      )   �  x�}��n[7�gݧ���K����c$�t�bx�4Xk�XE��@�.AP �Q�4m�TB��~�I�R�G�Y���Q��|<$Ϲ6�G����կ����z��lx|6�o�(3e<�_�&$U���^��'�����?���Y�����ӓ��6�>��ú��ͯ׫f�������Tgw�9.�ý��qѐG��rqN#����+�(���o3z�z�\~jL�=�Q�����0%
G��͔~��`H�P~4闌codz$2o2�}S�i�˻��Rx[w�
�X0}qE�/�,�ތ�������F��d���x�^}�/�����i�朵�"3��26�d�Q1�}���7�P[qh�8$K��#p�I�����\�x��'[œ5<�*����V-�\U!�2!הr5�+������3i�Ho���Do�|��sE=3�6`&��$P��j0�@�fi�L"�IĢ�D�YM<]��m`�x��XS4�c0�`��#�9F s� �XS��c�#���$ǈ$9F$�1"-�B��Ek�Lh�n&0`�L P�	j0�@&h�"�@Ģ	D��v�&���O��|�|7t���ι/'U*D?���]s�'(+M����L�{�B�.Uϯ����;Ip��'���p�M��9O ��p%d�
2�@�@��L �B&� X�2��;�T`d0���*�F5�#�&� H�VP<�Z����ь��0��%�J�ԕ�v���=*#L6�����Y��W�E�G�fbp�??�hr�Д����/ �.7��(x� f`F�$��RKP�%����@�	j!�u�d�,�� �y�
 ���@�*@#�:@C�J@c�Z``�t�b�TԡE�,Z�ȡE���n��Q�1��"Fub�&��Y�XĬK,bf����"bx�kMR_KV���p]G�\����-�� ��m
��Ѿ/ŵ�c�C~�k�Þ+ޗSxNv��1Ǵ�~��1�'�aA���S�w�����Y"�IA��%��/��_���v�Yײ\�K+R�
!��]��s��}�#��e;"<%�c�1{:fW#C��&%x����6��Q��.�P)���N�?����P��a�)�OAx�
��T�M�#3��GbX��6��ȬL�#38���P�� ,^�R�uO����/T���q�� �F.�tB�dV+��Y�j4�Q��3����☜"X��2�,WC}�(Y.f&Y.fe�\̪d���Ҵʚd	�ajZB؅
�>Tv��v���g�]� �a�((��%ݣ���t��Y�t��Lb�dCw���(�Ќ���� �)aW)�JF��AIo),�.�%��������.S؎�y,ג%1�F��P@�����ڪP�u���_x�����Z�7\��WT��=X�I��&��O���g�@((X���L8)�1��
۟pO9G򎻋��(����P��)��E���M�i@U%j��Y�SQ���L��b�M5_ذ�����,�D��M�{���K��7��R?����`��2�R�(�"쿍2���ꍳ��Z�p˧�zԿ>��.J'��:���������҅�}�N����|����v��HѿчwfK�]�u���b�[o:����P�R�#B�	{*4������\*��K0%Ӡ4$�a	�������k��F>K-T��c���
����3����������ҋ�i��wt֪�&��� �j/�2��_����EkQS���?��v	ȅ���V��;��V
�A����pgbQ���;������z��h7���Q���)=f�P�ɴ��~&�b��N�i.��$����J����\���L��瓀�'�j�V�1�3:�E���ߙL}�:��1N�؇p�0W�!�a�Xns�o�\��� ^Q�J�[��)��V8���jI�DEVl���5�bmo�
�Y?���l�hE�N����vk�9"�X)�Y����#�@��O���'CX�MF�f���Vy ��(��\%     