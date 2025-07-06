-- Функция получения записи из таблицы tickets
CREATE OR REPLACE FUNCTION fn_select_tickets(p_ticket_no character(13))
RETURNS refcursor AS $$
DECLARE
    result_cursor refcursor;
BEGIN
    OPEN result_cursor FOR
        SELECT ticket_no, book_ref, passenger_id, passenger_name, contact_data
        FROM bookings.tickets
        WHERE ticket_no = p_ticket_no;
    
    RETURN result_cursor;
END;
$$ LANGUAGE plpgsql;

-- Функция вставки записи в таблицу tickets
CREATE OR REPLACE FUNCTION fn_insert_tickets(
    p_ticket_no character(13),
    p_book_ref character(6),
    p_passenger_id character varying(20),
    p_passenger_name text,
    p_contact_data jsonb DEFAULT NULL
)
RETURNS integer AS $$
BEGIN
    INSERT INTO bookings.tickets (ticket_no, book_ref, passenger_id, passenger_name, contact_data)
    VALUES (p_ticket_no, p_book_ref, p_passenger_id, p_passenger_name, p_contact_data);
    
    RETURN 1;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ошибка при вставке в tickets: %', SQLERRM;
        RETURN -1;
END;
$$ LANGUAGE plpgsql;

-- Функция изменения записи в таблице tickets
CREATE OR REPLACE FUNCTION fn_update_tickets(
    p_ticket_no character(13),
    p_book_ref character(6),
    p_passenger_id character varying(20),
    p_passenger_name text,
    p_contact_data jsonb DEFAULT NULL
)
RETURNS integer AS $$
DECLARE
    affected_rows integer;
BEGIN
    DELETE FROM bookings.tickets WHERE ticket_no = p_ticket_no;
    
    GET DIAGNOSTICS affected_rows = ROW_COUNT;
    
    IF affected_rows = 0 THEN
        RETURN 0;
    END IF;
    
    INSERT INTO bookings.tickets (ticket_no, book_ref, passenger_id, passenger_name, contact_data)
    VALUES (p_ticket_no, p_book_ref, p_passenger_id, p_passenger_name, p_contact_data);
    
    RETURN 1;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ошибка при изменении tickets: %', SQLERRM;
        RETURN -1;
END;
$$ LANGUAGE plpgsql;

-- Функция удаления записи из таблицы tickets
CREATE OR REPLACE FUNCTION fn_delete_tickets(p_ticket_no character(13))
RETURNS integer AS $$
DECLARE
    affected_rows integer;
BEGIN
    DELETE FROM bookings.tickets WHERE ticket_no = p_ticket_no;
    
    GET DIAGNOSTICS affected_rows = ROW_COUNT;
    
    IF affected_rows = 0 THEN
        RETURN 0;
    ELSE
        RETURN 1;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ошибка при удалении из tickets: %', SQLERRM;
        RETURN -1;
END;
$$ LANGUAGE plpgsql;