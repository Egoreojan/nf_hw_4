-- Функция получения записи из таблицы bookings
CREATE OR REPLACE FUNCTION fn_select_bookings(p_book_ref character(6))
RETURNS refcursor AS $$
DECLARE
    result_cursor refcursor;
BEGIN
    OPEN result_cursor FOR
        SELECT book_ref, book_date, total_amount
        FROM bookings.bookings
        WHERE book_ref = p_book_ref;
    
    RETURN result_cursor;
END;
$$ LANGUAGE plpgsql;

-- Функция вставки записи в таблицу bookings
CREATE OR REPLACE FUNCTION fn_insert_bookings(
    p_book_ref character(6),
    p_book_date timestamp with time zone,
    p_total_amount numeric(10,2)
)
RETURNS integer AS $$
BEGIN
    INSERT INTO bookings.bookings (book_ref, book_date, total_amount)
    VALUES (p_book_ref, p_book_date, p_total_amount);
    
    RETURN 1;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ошибка при вставке в bookings: %', SQLERRM;
        RETURN -1;
END;
$$ LANGUAGE plpgsql;

-- Функция изменения записи в таблице bookings
CREATE OR REPLACE FUNCTION fn_update_bookings(
    p_book_ref character(6),
    p_book_date timestamp with time zone,
    p_total_amount numeric(10,2)
)
RETURNS integer AS $$
DECLARE
    affected_rows integer;
BEGIN
    DELETE FROM bookings.bookings WHERE book_ref = p_book_ref;
    
    GET DIAGNOSTICS affected_rows = ROW_COUNT;
    
    IF affected_rows = 0 THEN
        RETURN 0;
    END IF;
    
    INSERT INTO bookings.bookings (book_ref, book_date, total_amount)
    VALUES (p_book_ref, p_book_date, p_total_amount);
    
    RETURN 1;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ошибка при изменении bookings: %', SQLERRM;
        RETURN -1;
END;
$$ LANGUAGE plpgsql;

-- Функция удаления записи из таблицы bookings
CREATE OR REPLACE FUNCTION fn_delete_bookings(p_book_ref character(6))
RETURNS integer AS $$
DECLARE
    affected_rows integer;
BEGIN
    DELETE FROM bookings.bookings WHERE book_ref = p_book_ref;
    
    GET DIAGNOSTICS affected_rows = ROW_COUNT;
    
    IF affected_rows = 0 THEN
        RETURN 0;
    ELSE
        RETURN 1;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ошибка при удалении из bookings: %', SQLERRM;
        RETURN -1;
END;
$$ LANGUAGE plpgsql;