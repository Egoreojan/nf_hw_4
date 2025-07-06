-- Функция для поиска рейсов с задержками
CREATE OR REPLACE FUNCTION fn_select_flight_delayed()
RETURNS refcursor AS $$
DECLARE
    result_cursor refcursor;
BEGIN
    OPEN result_cursor FOR
        SELECT flight_id, flight_no, scheduled_departure, scheduled_arrival,
               departure_airport, arrival_airport, status, aircraft_code,
               actual_departure, actual_arrival,
               CASE 
                   WHEN actual_departure IS NOT NULL THEN 
                       EXTRACT(EPOCH FROM (actual_departure - scheduled_departure))/60
                   ELSE NULL 
               END as departure_delay_minutes
        FROM bookings.flights
        WHERE status = 'Delayed' OR 
              (actual_departure IS NOT NULL AND actual_departure > scheduled_departure)
        ORDER BY scheduled_departure, flight_id;
    
    RETURN result_cursor;
END;
$$ LANGUAGE plpgsql;

-- Функция для поиска рейсов на сегодня
CREATE OR REPLACE FUNCTION fn_select_flight_today()
RETURNS refcursor AS $$
DECLARE
    result_cursor refcursor;
    today_date date;
BEGIN
    today_date := CURRENT_DATE;
    
    OPEN result_cursor FOR
        SELECT flight_id, flight_no, scheduled_departure, scheduled_arrival,
               departure_airport, arrival_airport, status, aircraft_code,
               actual_departure, actual_arrival
        FROM bookings.flights
        WHERE DATE(scheduled_departure) = today_date
        ORDER BY scheduled_departure, flight_id;
    
    RETURN result_cursor;
END;
$$ LANGUAGE plpgsql;

-- Функция для поиска рейсов по городу отправления
CREATE OR REPLACE FUNCTION fn_select_flight_by_departure_city(p_city text)
RETURNS refcursor AS $$
DECLARE
    result_cursor refcursor;
BEGIN
    OPEN result_cursor FOR
        SELECT f.flight_id, f.flight_no, f.scheduled_departure, f.scheduled_arrival,
               f.departure_airport, f.arrival_airport, f.status, f.aircraft_code,
               f.actual_departure, f.actual_arrival,
               a.city as departure_city
        FROM bookings.flights f
        JOIN bookings.airports a ON f.departure_airport = a.airport_code
        WHERE a.city = p_city
        ORDER BY f.scheduled_departure, f.flight_id;
    
    RETURN result_cursor;
END;
$$ LANGUAGE plpgsql;

-- Функция для поиска рейсов по городу прибытия
CREATE OR REPLACE FUNCTION fn_select_flight_by_arrival_city(p_city text)
RETURNS refcursor AS $$
DECLARE
    result_cursor refcursor;
BEGIN
    OPEN result_cursor FOR
        SELECT f.flight_id, f.flight_no, f.scheduled_departure, f.scheduled_arrival,
               f.departure_airport, f.arrival_airport, f.status, f.aircraft_code,
               f.actual_departure, f.actual_arrival,
               a.city as arrival_city
        FROM bookings.flights f
        JOIN bookings.airports a ON f.arrival_airport = a.airport_code
        WHERE a.city = p_city
        ORDER BY f.scheduled_arrival, f.flight_id;
    
    RETURN result_cursor;
END;
$$ LANGUAGE plpgsql;