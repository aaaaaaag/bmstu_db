-- 3) Много операторная табличная функция
-- Функция возвращает названия цвет товара с максимальным кол-вом сделок
CREATE OR REPLACE FUNCTION get_bestseller_color()
    RETURNS text AS
$func$
    declare
        group_name text;
    BEGIN
        group_name := (select color
                    from deals
                    JOIN items i on i.id = deals.sold_item_id
                    GROUP BY color
                    order by count(*) desc
                    limit 1);
        return group_name;
    END;
$func$
language 'plpgsql';
