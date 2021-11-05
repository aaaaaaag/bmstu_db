
-- C. Два DML триггера

-- 1) Триггер AFTER
-- Создал урезанную копию таблицы items, добавил поле int, которое указывает,
-- сколько было добавлено записей в таблицу после текущей. Триггер увеличивает
-- этот атрибут у всех записей при добавлении

-- Создание таблицы
create temp table if not exists items_temp
(
   item_name text not null,
   item_price int not null,
   number_after_this int not null
);

-- Создание функции увеличения
create or replace function increment_number()
returns trigger AS
$$
    begin
        update items_temp
        set number_after_this = number_after_this + 1;
        return new;
    end;
$$
language 'plpgsql';

-- Создаю триггер
create trigger trigger_after_insert
    after insert on items_temp for each row
    execute function increment_number();
