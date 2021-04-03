USE x;
SHOW TABLES;

SELECT * FROM catalogs;
SELECT * FROM discounts;
SELECT * FROM orders;
SELECT * FROM orders_products;
SELECT * FROM products;
SELECT * FROM rubrics;
SELECT * FROM storehouses;
SELECT * FROM storehouses_products;
SELECT * FROM users;

 -- 1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.

SELECT id, (SELECT name FROM users WHERE id = orders.user_id ) AS name, created_at, updated_at FROM orders;

-- 2. Выведите список товаров products и разделов catalogs, который соответствует товару.

SELECT id, name, price, (SELECT name FROM catalogs WHERE id = products.catalog_id) AS name_catalog FROM products; 

/* 3. (по желанию) Пусть имеется таблица рейсов flights (id, from_, to_) и таблица городов cities (label, name). 
		Поля from, to и label содержат английские названия городов, поле name — русское. 
		Выведите список рейсов flights с русскими названиями городов.*/
-- Создание таблиц (Количество содержимого значение всё равно не имеет)
DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
	id SERIAL PRIMARY KEY,
	from_ VARCHAR(255),
	to_ VARCHAR(255));
 
 INSERT INTO flights VALUES
 	(NULL, 'St-Pb', 'Moscow'),
 	(NULL, 'Moscow', 'Novosibirsk');
 
DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
	label VARCHAR(255),
	name VARCHAR(255));

INSERT INTO cities VALUES
 	('St-Pb', 'Санкт-Петербург'),
 	('Moscow', 'Москва'),
 	('Novosibirsk', 'Новосибирск');
 
SELECT * FROM flights;
SELECT * FROM cities;

-- Выполнение задаия
SELECT id, (
	SELECT name FROM cities WHERE label = flights.from_
	) AS name_from, (
	SELECT name FROM cities WHERE label = flights.from_
	) AS name_to FROM flights;