
select * from items_temp order by number_after_this desc;

insert into items_temp (item_name, item_price, number_after_this)
values ('item_name_1', 100, -1);

insert into items_temp (item_name, item_price, number_after_this)
values ('item_name_2', 100, -1);

insert into items_temp (item_name, item_price, number_after_this)
values ('item_name_3', 100, -1);

insert into items_temp (item_name, item_price, number_after_this)
values ('item_name_4', 100, -1);

insert into items_temp (item_name, item_price, number_after_this)
values ('item_name_5', 100, -1);
