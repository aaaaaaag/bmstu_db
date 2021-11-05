
-- 3) Хранимую процедуру с курсором
-- Добавить всем предметам число к цене, у которых она меньше необходимого
create or replace procedure increment_items_price_less_needed(int, int)
as
$$
    declare
        row record;
        cur cursor for
            select * from items
                where price < $2;
    begin
        open cur;
        loop
            fetch cur into row;
            exit when not found;
            update items
            set price = price + $1
            where id = row.hull_id;
        end loop;
    end
$$
language 'plpgsql';
