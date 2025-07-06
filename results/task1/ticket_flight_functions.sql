-- Функция получения записи из таблицы ticket_flights
CREATE OR REPLACE FUNCTION fn_select_ticket_flights(
    p_ticket_no character(13),
    p_flight_id integer
)
RETURNS refcursor AS $$
DECLARE
    result_cursor refcursor;
BEGIN
    OPEN result_cursor FOR
        SELECT ticket_no, flight_id, fare_conditions, amount
        FROM bookings.ticket_flights
        WHERE ticket_no = p_ticket_no AND flight_id = p_flight_id;
    
    RETURN result_cursor;
END;
$$ LANGUAGE plpgsql;

-- Функция вставки записи в таблицу ticket_flights
CREATE OR REPLACE FUNCTION fn_insert_ticket_flights(
    p_ticket_no character(13),
    p_flight_id integer,
    p_fare_conditions character varying(10),
    p_amount numeric(10,2)
)
RETURNS integer AS $$
BEGIN
    INSERT INTO bookings.ticket_flights (ticket_no, flight_id, fare_conditions, amount)
    VALUES (p_ticket_no, p_flight_id, p_fare_conditions, p_amount);
    
    RETURN 1;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ошибка при вставке в ticket_flights: %', SQLERRM;
        RETURN -1;
END;
$$ LANGUAGE plpgsql;

-- Функция изменения записи в таблице ticket_flights
CREATE OR REPLACE FUNCTION fn_update_ticket_flights(
    p_ticket_no character(13),
    p_flight_id integer,
    p_fare_conditions character varying(10),
    p_amount numeric(10,2)
)
RETURNS integer AS $$
DECLARE
    affected_rows integer;
BEGIN
    DELETE FROM bookings.ticket_flights 
    WHERE ticket_no = p_ticket_no AND flight_id = p_flight_id;
    
    GET DIAGNOSTICS affected_rows = ROW_COUNT;
    
    IF affected_rows = 0 THEN
        RETURN 0;
    END IF;
    
    INSERT INTO bookings.ticket_flights (ticket_no, flight_id, fare_conditions, amount)
    VALUES (p_ticket_no, p_flight_id, p_fare_conditions, p_amount);
    
    RETURN 1;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ошибка при изменении ticket_flights: %', SQLERRM;
        RETURN -1;
END;
$$ LANGUAGE plpgsql;

-- Функция удаления записи из таблицы ticket_flights
CREATE OR REPLACE FUNCTION fn_delete_ticket_flights(
    p_ticket_no character(13),
    p_flight_id integer
)
RETURNS integer AS $$
DECLARE
    affected_rows integer;
BEGIN
    DELETE FROM bookings.ticket_flights 
    WHERE ticket_no = p_ticket_no AND flight_id = p_flight_id;
    
    GET DIAGNOSTICS affected_rows = ROW_COUNT;
    
    IF affected_rows = 0 THEN
        RETURN 0;
    ELSE
        RETURN 1;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ошибка при удалении из ticket_flights: %', SQLERRM;
        RETURN -1;
END;
$$ LANGUAGE plpgsql;