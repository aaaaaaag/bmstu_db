DROP TABLE IF EXISTS creators_copy;
DROP TABLE IF EXISTS creators_education;
DROP TABLE IF EXISTS creators_info;
DROP TABLE IF EXISTS creators_json;

-- 1. Из таблиц базы данных, созданной в первой
-- лабораторной работе, извлечь данные в JSON.

SELECT row_to_json(c) result FROM creators c;
SELECT row_to_json(a) result FROM auctions a;
SELECT row_to_json(ar) result FROM arts ar;
SELECT row_to_json(l) result FROM lots l;

-- 2. Выполнить загрузку и сохранение JSON файла в таблицу.

SELECT * FROM creators_json;
SELECT * FROM creators_copy;

-- 3. Создать таблицу, в которой будет атрибут(-ы) с типом JSON, или
-- добавить атрибут с типом JSON к уже существующей таблице.
-- Заполнить атрибут правдоподобными данными с помощью команд INSERT или UPDATE

DROP TABLE IF EXISTS  creators_info;

CREATE TABLE creators_info
(
    about jsonb
);

INSERT INTO creators_info (about) VALUES
('{"id": 50, "about": "Люблю фрукты и закаты"}'),
('{"id": 3, "about": "Первую картину нарисовал в 9 лет"}');

SELECT * FROM creators_info;

-- 4. Выполнить следующие действия:

-- 1. Извлечь XML/JSON фрагмент из XML/JSON документа

SELECT about->'about' about_myself FROM creators_info;

-- 2. Извлечь значения конкретных узлов или атрибутов XML/JSON документа

DROP TABLE IF EXISTS  creators_education;

CREATE TABLE creators_education
(
    education jsonb
);

INSERT INTO creators_education (education) VALUES
('{"id": 50, "education": {"university": "Университет искусства", "grade": 5}}'),
('{"id": 3, "education": {"university": "МПБГСУ", "grade": 3}}');

SELECT * FROM creators_education;

SELECT education->'id' id,
       education->'education'->'university' uni
FROM creators_education;

-- 3. Выполнить проверку существования узла или атрибута

CREATE FUNCTION if_key_exists(json_to_check jsonb, key text)
RETURNS BOOLEAN
AS $$
BEGIN
    RETURN (json_to_check->key) IS NOT NULL;
END;
$$ LANGUAGE PLPGSQL;

SELECT if_key_exists('{"type": "Кубизм", "year": 2001}', 'creator');
SELECT if_key_exists('{"type": "Кубизм", "year": 2001, "creator": "Алекс"}', 'creator');

-- 4. Изменить JSON документ.

SELECT * FROM creators_info;

SELECT about || '{"id": 0}'::jsonb
FROM creators_info;

UPDATE creators_info
SET about = about || '{"id": 10, "about": "Пусто"}'::jsonb
WHERE (about->'id')::INT = 50;

-- 5. Разделить XML/JSON документ на несколько строк по узлам

DROP TABLE IF EXISTS some_creators;

CREATE TABLE IF NOT EXISTS some_creators
(
    data jsonb
);

INSERT INTO some_creators VALUES (
    '[
    {"name": "Gogol", "age": 26, "art": {"type": "Импрессионизм", "year": 2020}},
    {"name": "Master", "age": 12, "art": {"type": "Кубизм", "year": 2003}},
    {"name": "Lorsik", "age": 50, "art": {"type": "Реализм", "year": 1970}}
    ]'
);

SELECT * FROM some_creators;

SELECT jsonb_array_elements(data::jsonb)
FROM some_creators;


