-- Функция 1: Поиск по flight_id
CREATE OR REPLACE FUNCTION fn_select_flight(p_flight_id integer)
RETURNS refcursor AS $$
DECLARE
    result_cursor refcursor;
BEGIN
    result_cursor := fn_select_flights(p_flight_id);
    RETURN result_cursor;
END;
$$ LANGUAGE plpgsql;

-- Функция 2: Поиск по scheduled_departure (равенство)
CREATE OR REPLACE FUNCTION fn_select_flight(p_scheduled_departure timestamp with time zone)
RETURNS refcursor AS $$
DECLARE
    result_cursor refcursor;
BEGIN
    OPEN result_cursor FOR
        SELECT flight_id, flight_no, scheduled_departure, scheduled_arrival,
               departure_airport, arrival_airport, status, aircraft_code,
               actual_departure, actual_arrival
        FROM bookings.flights
        WHERE scheduled_departure = p_scheduled_departure
        ORDER BY flight_id;
    
    RETURN result_cursor;
END;
$$ LANGUAGE plpgsql;

-- Функция 3: Поиск по scheduled_departure с оператором сравнения
CREATE OR REPLACE FUNCTION fn_select_flight(
    p_scheduled_departure timestamp with time zone,
    p_operator text DEFAULT '>'
)
RETURNS refcursor AS $$
DECLARE
    result_cursor refcursor;
    sql_query text;
BEGIN
    IF p_operator NOT IN ('>', '<', '>=', '<=') THEN
        RAISE EXCEPTION 'Неподдерживаемый оператор: %. Поддерживаются: >, <, >=, <=', p_operator;
    END IF;
    
    sql_query := format('
        SELECT flight_id, flight_no, scheduled_departure, scheduled_arrival,
               departure_airport, arrival_airport, status, aircraft_code,
               actual_departure, actual_arrival
        FROM bookings.flights
        WHERE scheduled_departure %s $1
        ORDER BY scheduled_departure, flight_id
    ', p_operator);
    
    OPEN result_cursor FOR EXECUTE sql_query USING p_scheduled_departure;
    
    RETURN result_cursor;
END;
$$ LANGUAGE plpgsql;

-- Функция 4: Поиск по диапазону scheduled_departure (между двумя датами)
CREATE OR REPLACE FUNCTION fn_select_flight(
    p_scheduled_departure_from timestamp with time zone,
    p_scheduled_departure_to timestamp with time zone
)
RETURNS refcursor AS $$
DECLARE
    result_cursor refcursor;
BEGIN
    OPEN result_cursor FOR
        SELECT flight_id, flight_no, scheduled_departure, scheduled_arrival,
               departure_airport, arrival_airport, status, aircraft_code,
               actual_departure, actual_arrival
        FROM bookings.flights
        WHERE scheduled_departure >= p_scheduled_departure_from 
          AND scheduled_departure <= p_scheduled_departure_to
        ORDER BY scheduled_departure, flight_id;
    
    RETURN result_cursor;
END;
$$ LANGUAGE plpgsql;

-- Функция 5: Поиск по аэропортам отправления и прибытия
CREATE OR REPLACE FUNCTION fn_select_flight(
    p_departure_airport character(3),
    p_arrival_airport character(3)
)
RETURNS refcursor AS $$
DECLARE
    result_cursor refcursor;
BEGIN
    OPEN result_cursor FOR
        SELECT flight_id, flight_no, scheduled_departure, scheduled_arrival,
               departure_airport, arrival_airport, status, aircraft_code,
               actual_departure, actual_arrival
        FROM bookings.flights
        WHERE departure_airport = p_departure_airport 
          AND arrival_airport = p_arrival_airport
        ORDER BY scheduled_departure, flight_id;
    
    RETURN result_cursor;
END;
$$ LANGUAGE plpgsql;

-- Функция 6: Поиск по статусу рейса
CREATE OR REPLACE FUNCTION fn_select_flight(p_status character varying(20))
RETURNS refcursor AS $$
DECLARE
    result_cursor refcursor;
BEGIN
    OPEN result_cursor FOR
        SELECT flight_id, flight_no, scheduled_departure, scheduled_arrival,
               departure_airport, arrival_airport, status, aircraft_code,
               actual_departure, actual_arrival
        FROM bookings.flights
        WHERE status = p_status
        ORDER BY scheduled_departure, flight_id;
    
    RETURN result_cursor;
END;
$$ LANGUAGE plpgsql;

-- Функция 7: Поиск по коду самолета
CREATE OR REPLACE FUNCTION fn_select_flight(p_aircraft_code character(3))
RETURNS refcursor AS $$
DECLARE
    result_cursor refcursor;
BEGIN
    OPEN result_cursor FOR
        SELECT flight_id, flight_no, scheduled_departure, scheduled_arrival,
               departure_airport, arrival_airport, status, aircraft_code,
               actual_departure, actual_arrival
        FROM bookings.flights
        WHERE aircraft_code = p_aircraft_code
        ORDER BY scheduled_departure, flight_id;
    
    RETURN result_cursor;
END;
$$ LANGUAGE plpgsql;

-- Функция 8: Поиск по номеру рейса
CREATE OR REPLACE FUNCTION fn_select_flight_by_number(p_flight_no character(6))
RETURNS refcursor AS $$
DECLARE
    result_cursor refcursor;
BEGIN
    OPEN result_cursor FOR
        SELECT flight_id, flight_no, scheduled_departure, scheduled_arrival,
               departure_airport, arrival_airport, status, aircraft_code,
               actual_departure, actual_arrival
        FROM bookings.flights
        WHERE flight_no = p_flight_no
        ORDER BY scheduled_departure, flight_id;
    
    RETURN result_cursor;
END;
$$ LANGUAGE plpgsql;