-- Поиск по flight_id
CREATE OR REPLACE FUNCTION fn_select_flight(p_flight_id integer)
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

-- Поиск по flight_id и scheduled_departure (равенство)
CREATE OR REPLACE FUNCTION fn_select_flight(p_flight_id integer, p_scheduled_departure timestamp with time zone)
RETURNS refcursor AS $$
DECLARE
    result_cursor refcursor;
BEGIN
    OPEN result_cursor FOR
        SELECT flight_id, flight_no, scheduled_departure, scheduled_arrival,
               departure_airport, arrival_airport, status, aircraft_code,
               actual_departure, actual_arrival
        FROM bookings.flights
        WHERE flight_id = p_flight_id AND scheduled_departure = p_scheduled_departure;
    RETURN result_cursor;
END;
$$ LANGUAGE plpgsql;

-- Поиск по flight_id и scheduled_departure с оператором ('>', '<', '>=', '<=')
CREATE OR REPLACE FUNCTION fn_select_flight(p_flight_id integer, p_scheduled_departure timestamp with time zone, p_operator text)
RETURNS refcursor AS $$
DECLARE
    result_cursor refcursor;
    sql_query text;
BEGIN
    IF p_operator NOT IN ('>', '<', '>=', '<=') THEN
        RAISE EXCEPTION 'Неподдерживаемый оператор: %. Поддерживаются только: >, <, >=, <=', p_operator;
    END IF;
    sql_query := format('
        SELECT flight_id, flight_no, scheduled_departure, scheduled_arrival,
               departure_airport, arrival_airport, status, aircraft_code,
               actual_departure, actual_arrival
        FROM bookings.flights
        WHERE flight_id = $1 AND scheduled_departure %s $2
        ORDER BY scheduled_departure, flight_id', p_operator);
    OPEN result_cursor FOR EXECUTE sql_query USING p_flight_id, p_scheduled_departure;
    RETURN result_cursor;
END;
$$ LANGUAGE plpgsql;

