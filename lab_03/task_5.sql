-- B. Четыре хранимые процедуры

-- 1) Хранимую процедуру без параметров или с параметрами
-- Повысить всем предметам цену
create or replace procedure increment_items_price(int)
as
$$
    begin
        update items
        set price = price + $1;
    end
$$
language 'plpgsql';

