-- 1) Инструкция SELECT использующая предикат сравнения
-- Получить все сделки которые были совершены с доставкой из России
SELECT deals.id, sellers.country as delivery_from, buyers.country as delivery_to, date
FROM deals
JOIN sellers ON deals.seller_id = sellers.id
JOIN buyers on deals.buyer_id = buyers.id
WHERE deals.has_delivery = true AND sellers.country = 'Russia'
ORDER BY delivery_from;

-- 2) Инструкция SELECT использующая предикат BETWEEN
-- Получить все сделки с доставкой из россии за определенный период времени
SELECT deals.id, sellers.country as delivery_from, buyers.country as delivery_to, date
FROM deals
JOIN sellers ON deals.seller_id = sellers.id
JOIN buyers on deals.buyer_id = buyers.id
WHERE deals.has_delivery = true AND sellers.country = 'Russia' AND
      date BETWEEN '2021-05-01 00:00:01.000000' AND '2021-05-31 23:59:59.000000'
ORDER BY delivery_from;

-- 3) Инструкция SELECT использующая предикат LIKE
-- Получить все проданные бутылки с доставкой из России
SELECT deals.id, sellers.country as delivery_from, buyers.country as delivery_to, date, items.name
FROM deals
JOIN sellers ON deals.seller_id = sellers.id
JOIN buyers on deals.buyer_id = buyers.id
JOIN items on deals.sold_item_id = items.id
WHERE deals.has_delivery = true AND sellers.country = 'Russia' AND
      items.name LIKE '%Bottle%'
ORDER BY delivery_from;


-- 4) Инструкция SELECT использующая предикат IN с вложенным подзапросом
-- Получить все проданные бутылки с доставкой из России
SELECT deals.id, sellers.country as delivery_from, buyers.country as delivery_to, date, items.name
FROM deals
JOIN sellers ON deals.seller_id = sellers.id
JOIN buyers on deals.buyer_id = buyers.id
JOIN items on deals.sold_item_id = items.id
WHERE deals.has_delivery = true AND sellers.country = 'Russia' AND
      items.name IN (SELECT name
                        FROM items
                        WHERE name LIKE '%Bottle%')
ORDER BY delivery_from;

-- 5) Инструкция SELECT использующая предикат EXISTS с вложенным подзапросом
-- Получить все сделки где была доставка и есть покупатели с рейтингом 1
SELECT deals.id, sellers.country as delivery_from, buyers.country as delivery_to, date
FROM deals
JOIN sellers ON deals.seller_id = sellers.id
JOIN buyers on deals.buyer_id = buyers.id
WHERE deals.has_delivery = true AND EXISTS(
    SELECT rating
    FROM buyers
    WHERE buyers.rating = '1'
    )
ORDER BY delivery_from;

-- 6) Инструкция SELECT использующая предикат сравнения с квантором
-- Получить все сделки где была доставка и цена проданного товара больше чем любая цена за выставленную бутылку
SELECT deals.id, sellers.country as delivery_from, buyers.country as delivery_to, date, items.price
FROM deals
JOIN sellers ON deals.seller_id = sellers.id
JOIN buyers on deals.buyer_id = buyers.id
JOIN items on deals.sold_item_id = items.id
WHERE deals.has_delivery = true AND
      items.price > ALL (SELECT price
                            FROM items
                            WHERE items.name LIKE '%Bottle%')
ORDER BY delivery_from;

-- 7) Инструкция SELECT использующая агрегатные функции в выражениях столбцов
-- Получить среднюю цену товаров сгруппированных по цветам
SELECT AVG(TotalPrice) AS AvgPrice, SUM(TotalPrice) / COUNT(color) AS CalcAvg
FROM (SELECT color, SUM(price) AS TotalPrice
    FROM items
    GROUP BY color
    ) AS TotItems;

-- 8) Инструкция SELECT использующая скалярные подзапросы в выражениях столбцов
-- Получить среднюю и максимальную цену товаров продавца
SELECT DISTINCT id, first_name, second_name, organization_id,
       (SELECT AVG(price)
           FROM items
           WHERE items.owner_id = sellers.id) AS AVGPrice,
       (SELECT MAX(price)
           FROM items
           WHERE items.owner_id = sellers.id) AS MAXPrice
FROM sellers;

-- 9) Инструкция SELECT использующая простое выражение CASE
-- вывести список цен сделок с фановыми комментами к цене
SELECT date, set_buyer_rating,
    CASE
    WHEN price > 50000
    THEN 'Ohhhh, you so rich. Phone me pls <з'
    ELSE CAST(price as char(10))
    END itemPrice
FROM deals
JOIN sellers ON deals.seller_id = sellers.id
JOIN items on deals.sold_item_id = items.id;

-- 10) Инструкция SELECT использующая поисковое выражение CASE
-- вывести список цен сделок с фановыми комментами к цене
SELECT date, set_buyer_rating,
    CASE
    WHEN price < 10000 THEN 'you so poor'
    WHEN price < 35000 THEN 'not bad'
    WHEN price < 50000 THEN 'Ohhhh, you so rich. Phone me pls <з'
    ELSE 'ohhhhhh myyyyyyyy!!!!'
    END AS itemPrice
FROM deals
JOIN sellers ON deals.seller_id = sellers.id
JOIN items on deals.sold_item_id = items.id;

-- 11) Создание новой временной локальной таблицы из результирующего набора данных инструкции SELECT
-- Создать таблицу с максимальными ценами за товар по цвету
SELECT color, p
INTO task_11
FROM (SELECT color, MAX(price) as p
    FROM items
    GROUP BY color) as maxPrice;

SELECT * FROM task_11;

-- 12) Инструкция SELECT использующая вложенные корреляционные подзапросы в качестве производных таблиц в предложении FROM
-- Вывести среднюю и максимальную цену товаров продавцов
SELECT id, sum as bestPrice
FROM deals d JOIN (SELECT owner_id, MAX(price) as sum
                    FROM items
                    GROUP BY owner_id) AS P ON P.owner_id = d.seller_id
UNION
SELECT id, avg as avgPrice
FROM deals d JOIN (SELECT owner_id, AVG(price) as avg
                    FROM items
                    GROUP BY owner_id) AS P ON P.owner_id = d.seller_id
ORDER BY id;

--13) Инструкция SELECT использующая вложенные подзапросы с уровнем вложенности 3
-- Вывести список продавцов совершивших сделки которые являются юр лицом организации с правовой формой ООО
SELECT id, seller_id
FROM deals
WHERE seller_id IN (
    SELECT id
    FROM sellers
    WHERE organization_id IN (
        SELECT id
        FROM organization
        WHERE legal_form_id IN (
            SELECT id
            FROM legal_form
            WHERE legal_form.name = 'LLC')));

-- 14) Инструкция SELECT консолидирующая данные с помощью предлодения GROUP BY но без предложения HAVING
-- Для каждого продавца получить среднюю и минимальную цену его белых товаров
SELECT *
FROM (
         SELECT d.seller_id, s.first_name, AVG(i.price) as avgPrice, MAX(i.price) as maxPrice, MIN(i.price) as minPrice, COUNT(i.price) as cnt
         FROM deals d
                  JOIN items i on d.sold_item_id = i.id
                  JOIN sellers s on s.id = d.seller_id
         GROUP BY d.seller_id, s.first_name
     ) as dis
WHERE dis.cnt > 2
ORDER BY dis.seller_id;


SELECT sellers.id as sid, sellers.first_name, i.price
FROM sellers
full JOIN deals d on sellers.id = d.seller_id
full JOIN items i on i.id = d.sold_item_id
WHERE sellers.id = 975;

SELECT *
FROM deals
WHERE seller_id = 975;

SELECT *
FROM items
WHERE owner_id = 975;

-- 15) Инструкция SELECT консолидирующая данные с помощью проедложения GROUP BY и предложения HAVING
-- Получить список цветов товаров, средняя цена которых больше общей цены товаров
SELECT color, AVG(price) as avgPrice
FROM items
GROUP BY color
HAVING AVG(price) > (
    SELECT AVG(price) as MPrice
    FROM items
    );

-- 16) Однострочная инструкция INSERT выполняющая вставку в таблицу одной строки значений
INSERT INTO items(name, weight, price, color, guarantee_years, owner_id) VALUES
('Trash', 10, 5000, 'White', 1, 3);

-- 17) Многострочная инструкция INSERT выполняющая вставку в таблицу результирующего набора данных вложенного подзапроса
INSERT INTO items(name, weight, price, color, guarantee_years, owner_id)
SELECT 'Trash', 10, 5000, 'White', 1, (SELECT MAX(sold_item_id)
        FROM deals
        WHERE buyer_id = 123)
FROM items
WHERE color = 'White' and guarantee_years = 1;

-- 18) Простая инструкция UPDATE
SELECT * FROM items;
UPDATE items
SET guarantee_years = guarantee_years + 1
WHERE id = 5;

-- 19) Инструкция UPDATE со скалярным подзапросом в предложении SET
UPDATE items
SET guarantee_years = (SELECT AVG(guarantee_years)
                        FROM items
                        WHERE color = 'White')
WHERE id = 5;

-- 20) Простая инструкция DELETE
DELETE FROM items WHERE name = 'Trash';

-- 21) Инструкция DELETE с вложенным коррелированным подзапросом в предложении WHERE
DELETE FROM deals
WHERE buyer_id IN
      (SELECT id
        FROM buyers
        WHERE rating = 1);

-- 22) Инструкция SELECT использующая простое обобщенное табличное выражение
WITH CTE (avgRating, populate, sex) AS (
    SELECT avg(rating), count(sex), sex
    FROM buyers
    where country = 'Russia'
    GROUP BY sex
)
SELECT avgRating, populate, sex
FROM CTE;

-- 23) Инструкция SELECT использующая рекурсивное обобщенное выражение
-- Создание таблицы.
CREATE TABLE MyEmployees (
    EmployeeID SERIAL PRIMARY KEY NOT NULL,
    FirstName text NOT NULL,
    LastName text NOT NULL,
    Title text NOT NULL,
    DeptID int NOT NULL,
    ManagerID int NULL
);
-- Заполнение таблицы значениями.
INSERT INTO MyEmployees
VALUES (1, 'Иван', 'Петров', 'Главный исполнительный директор',16,NULL) ;
SELECT * FROM MyEmployees;
-- Определение ОТВ
WITH RECURSIVE DirectReports (ManagerID, EmployeeID, Title, DeptID, Level) AS
(
 -- Определение закрепленного элемента
 SELECT e.ManagerID, e.EmployeeID, e.Title, e.DeptID, 0 AS Level
 FROM MyEmployees AS e
 WHERE ManagerID IS NULL
 UNION ALL
 -- Определение рекурсивного элемента
 SELECT e.ManagerID, e.EmployeeID, e.Title, e.DeptID, Level + 1
 FROM MyEmployees AS e INNER JOIN DirectReports AS d
 ON e.ManagerID = d.EmployeeID
)
-- Инструкция, использующая ОТВ
SELECT ManagerID, EmployeeID, Title, DeptID, Level
FROM DirectReports;

-- 24) Оконные функции. Использование конструкций MIN/MAX/AVG OVER()
SELECT id, name, color, price,
       AVG(price) OVER(PARTITION BY color) as avgPrice,
       MAX(price) OVER(PARTITION BY color) as maxPrice,
       MIN(price) OVER(PARTITION BY color) as minPrice
FROM items
ORDER BY color;

-- 25) Придумать запрос, в результате которого в данных появляются полные дубли.
-- Устранить дублирующиеся строки с использованием функции ROW_NUMBER()
SELECT color, guarantee_years, row_number() over (ORDER BY color)
FROM items
