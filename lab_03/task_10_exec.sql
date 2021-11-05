-- 2) Триггер INSTEAD OF
-- Вместо обновления в таблице вывести сообщение "permission denied"

select *
from group_view;

update group_view
set color = 'White'
where id = 1;
