-- 2) Рекурсивная хранимая процедура или хранимая процедура с рекурсивным ОТВ
-- Рекурсивно повысить нужным предметам цену
create or replace procedure recursive_increment_items_price(int, int, int)
as
$$
    begin
        if $1 < $2 then
            call recursive_increment_items_price($1 + 1, $2, $3);
        end if;
        update items
        set price = price + 1;
    end
$$
language 'plpgsql';
