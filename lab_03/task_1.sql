-- А. Четыре функции

-- 1) Скалярная функция
-- Функция возвращает число в процентах от введенного
CREATE OR REPLACE FUNCTION percent(value real, percent real)
    RETURNS real
    LANGUAGE plpgsql STRICT IMMUTABLE AS
$func$
BEGIN
    RETURN value / 100 * percent;
END
$func$;
