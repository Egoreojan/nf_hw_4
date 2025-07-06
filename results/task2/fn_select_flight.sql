CREATE OR REPLACE FUNCTION fn_select_flight(
    p_flight_id integer DEFAULT NULL,
    p_scheduled_departure text DEFAULT NULL
)
RETURNS refcursor AS $$
DECLARE
    result_cursor refcursor;
    op text;
    dt_text text;
    dt_value timestamp with time zone;
BEGIN
    IF p_flight_id IS NOT NULL AND p_scheduled_departure IS NULL THEN
        OPEN result_cursor FOR
            SELECT flight_id, flight_no, scheduled_departure, scheduled_arrival,
                   departure_airport, arrival_airport, status, aircraft_code,
                   actual_departure, actual_arrival
            FROM bookings.flights
            WHERE flight_id = p_flight_id;
        RETURN result_cursor;
    END IF;

    IF p_flight_id IS NULL AND p_scheduled_departure IS NOT NULL THEN
        IF left(p_scheduled_departure, 1) = '>' OR left(p_scheduled_departure, 1) = '<' THEN
            op := left(p_scheduled_departure, 1);
            dt_text := substr(p_scheduled_departure, 2);
        ELSE
            op := '=';
            dt_text := p_scheduled_departure;
        END IF;

        dt_value := dt_text::timestamp with time zone;
        
        IF op = '=' THEN
            result_cursor := fn_select_flight_by_departure_equals(dt_value);
        ELSE
            result_cursor := fn_select_flight_by_departure_inequality(dt_value, op);
        END IF;
        
        RETURN result_cursor;
    END IF;

    RAISE EXCEPTION 'Неправильная комбинация параметров. Используйте:
    - fn_select_flight(p_flight_id := integer) для поиска по ID
    - fn_select_flight(p_scheduled_departure := ''2024-06-01 12:00:00+03'') для поиска по равенству
    - fn_select_flight(p_scheduled_departure := ''>2024-06-01 12:00:00+03'') или ''<...'' для поиска с оператором';
END;
$$ LANGUAGE plpgsql;

