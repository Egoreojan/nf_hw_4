-- Функция получения записи из таблицы boarding_passes
CREATE OR REPLACE FUNCTION fn_select_boarding_passes(
    p_ticket_no character(13),
    p_flight_id integer
)
RETURNS refcursor AS $$
DECLARE
    result_cursor refcursor;
BEGIN
    OPEN result_cursor FOR
        SELECT ticket_no, flight_id, boarding_no, seat_no
        FROM bookings.boarding_passes
        WHERE ticket_no = p_ticket_no AND flight_id = p_flight_id;
    
    RETURN result_cursor;
END;
$$ LANGUAGE plpgsql;

-- Функция вставки записи в таблицу boarding_passes
CREATE OR REPLACE FUNCTION fn_insert_boarding_passes(
    p_ticket_no character(13),
    p_flight_id integer,
    p_boarding_no integer,
    p_seat_no character varying(4)
)
RETURNS integer AS $$
BEGIN
    INSERT INTO bookings.boarding_passes (ticket_no, flight_id, boarding_no, seat_no)
    VALUES (p_ticket_no, p_flight_id, p_boarding_no, p_seat_no);
    
    RETURN 1;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ошибка при вставке в boarding_passes: %', SQLERRM;
        RETURN -1;
END;
$$ LANGUAGE plpgsql;

-- Функция изменения записи в таблице boarding_passes
CREATE OR REPLACE FUNCTION fn_update_boarding_passes(
    p_ticket_no character(13),
    p_flight_id integer,
    p_boarding_no integer,
    p_seat_no character varying(4)
)
RETURNS integer AS $$
DECLARE
    affected_rows integer;
BEGIN
    DELETE FROM bookings.boarding_passes 
    WHERE ticket_no = p_ticket_no AND flight_id = p_flight_id;
    
    GET DIAGNOSTICS affected_rows = ROW_COUNT;
    
    IF affected_rows = 0 THEN
        RETURN 0;
    END IF;
    
    INSERT INTO bookings.boarding_passes (ticket_no, flight_id, boarding_no, seat_no)
    VALUES (p_ticket_no, p_flight_id, p_boarding_no, p_seat_no);
    
    RETURN 1;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ошибка при изменении boarding_passes: %', SQLERRM;
        RETURN -1;
END;
$$ LANGUAGE plpgsql;

-- Функция удаления записи из таблицы boarding_passes
CREATE OR REPLACE FUNCTION fn_delete_boarding_passes(
    p_ticket_no character(13),
    p_flight_id integer
)
RETURNS integer AS $$
DECLARE
    affected_rows integer;
BEGIN
    DELETE FROM bookings.boarding_passes 
    WHERE ticket_no = p_ticket_no AND flight_id = p_flight_id;
    
    GET DIAGNOSTICS affected_rows = ROW_COUNT;
    
    IF affected_rows = 0 THEN
        RETURN 0;
    ELSE
        RETURN 1;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ошибка при удалении из boarding_passes: %', SQLERRM;
        RETURN -1;
END;
$$ LANGUAGE plpgsql; 