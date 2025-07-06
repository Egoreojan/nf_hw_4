-- Функция получения записи из таблицы flights
CREATE OR REPLACE FUNCTION fn_select_flights(p_flight_id integer)
RETURNS refcursor AS $$
DECLARE
    result_cursor refcursor;
BEGIN
    OPEN result_cursor FOR
        SELECT flight_id, flight_no, scheduled_departure, scheduled_arrival,
               departure_airport, arrival_airport, status, aircraft_code,
               actual_departure, actual_arrival
        FROM bookings.flights
        WHERE flight_id = p_flight_id;
    
    RETURN result_cursor;
END;
$$ LANGUAGE plpgsql;

-- Функция вставки записи в таблицу flights
CREATE OR REPLACE FUNCTION fn_insert_flights(
    p_flight_id integer,
    p_flight_no character(6),
    p_scheduled_departure timestamp with time zone,
    p_scheduled_arrival timestamp with time zone,
    p_departure_airport character(3),
    p_arrival_airport character(3),
    p_status character varying(20),
    p_aircraft_code character(3),
    p_actual_departure timestamp with time zone DEFAULT NULL,
    p_actual_arrival timestamp with time zone DEFAULT NULL
)
RETURNS integer AS $$
BEGIN
    INSERT INTO bookings.flights (
        flight_id, flight_no, scheduled_departure, scheduled_arrival,
        departure_airport, arrival_airport, status, aircraft_code,
        actual_departure, actual_arrival
    )
    VALUES (
        p_flight_id, p_flight_no, p_scheduled_departure, p_scheduled_arrival,
        p_departure_airport, p_arrival_airport, p_status, p_aircraft_code,
        p_actual_departure, p_actual_arrival
    );
    
    RETURN 1;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ошибка при вставке в flights: %', SQLERRM;
        RETURN -1;
END;
$$ LANGUAGE plpgsql;

-- Функция изменения записи в таблице flights
CREATE OR REPLACE FUNCTION fn_update_flights(
    p_flight_id integer,
    p_flight_no character(6),
    p_scheduled_departure timestamp with time zone,
    p_scheduled_arrival timestamp with time zone,
    p_departure_airport character(3),
    p_arrival_airport character(3),
    p_status character varying(20),
    p_aircraft_code character(3),
    p_actual_departure timestamp with time zone DEFAULT NULL,
    p_actual_arrival timestamp with time zone DEFAULT NULL
)
RETURNS integer AS $$
DECLARE
    affected_rows integer;
BEGIN
    DELETE FROM bookings.flights WHERE flight_id = p_flight_id;
    
    GET DIAGNOSTICS affected_rows = ROW_COUNT;
    
    IF affected_rows = 0 THEN
        RETURN 0;
    END IF;
    
    INSERT INTO bookings.flights (
        flight_id, flight_no, scheduled_departure, scheduled_arrival,
        departure_airport, arrival_airport, status, aircraft_code,
        actual_departure, actual_arrival
    )
    VALUES (
        p_flight_id, p_flight_no, p_scheduled_departure, p_scheduled_arrival,
        p_departure_airport, p_arrival_airport, p_status, p_aircraft_code,
        p_actual_departure, p_actual_arrival
    );
    
    RETURN 1;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ошибка при изменении flights: %', SQLERRM;
        RETURN -1;
END;
$$ LANGUAGE plpgsql;

-- Функция удаления записи из таблицы flights
CREATE OR REPLACE FUNCTION fn_delete_flights(p_flight_id integer)
RETURNS integer AS $$
DECLARE
    affected_rows integer;
BEGIN
    DELETE FROM bookings.flights WHERE flight_id = p_flight_id;
    
    GET DIAGNOSTICS affected_rows = ROW_COUNT;
    
    IF affected_rows = 0 THEN
        RETURN 0;
    ELSE
        RETURN 1;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ошибка при удалении из flights: %', SQLERRM;
        RETURN -1;
END;
$$ LANGUAGE plpgsql;