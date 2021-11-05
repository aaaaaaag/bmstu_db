-- 2) Подставляемая табличная функция
-- Функция возвращает сделки за определенный промежуток времени
CREATE OR REPLACE FUNCTION deals_between(first_date timestamp, last_date timestamp)
    RETURNS setof deals AS
$func$
BEGIN
    RETURN QUERY (SELECT * from deals where deals.date BETWEEN first_date AND last_date);
END
$func$
language 'plpgsql';
