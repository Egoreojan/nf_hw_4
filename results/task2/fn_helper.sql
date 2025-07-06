-- Вспомогательная функция для поиска по scheduled_departure (равенство)
CREATE OR REPLACE FUNCTION fn_select_flight_by_departure_equals(p_scheduled_departure timestamp with time zone)
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

-- Функция для поиска по неравенству scheduled_departure
CREATE OR REPLACE FUNCTION fn_select_flight_by_departure_inequality(
    p_scheduled_departure timestamp with time zone,
    p_operator text
)
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
        WHERE scheduled_departure %s $1
        ORDER BY scheduled_departure, flight_id
    ', p_operator);
    
    OPEN result_cursor FOR EXECUTE sql_query USING p_scheduled_departure;
    
    RETURN result_cursor;
END;
$$ LANGUAGE plpgsql;