
-- 4) Рекурсивная функция или функция с рекурсивным ОТВ
-- Рекурсивный вывод информации о сделках по их id
create or replace function recursive_deals_information(int, int)
returns setof deals as
    $$
    begin
        if $1 < $2 then return query
            (
            select * from recursive_deals_information($1 + 1, $2)
        );
        end if;
        return query
            (
            select * from deals where id = $1
        );
    end;
    $$
language 'plpgsql';
