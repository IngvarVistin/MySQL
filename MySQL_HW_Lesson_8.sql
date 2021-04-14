SHOW DATABASES;
USE shop;
USE sample;
SHOW TABLES;
SELECT * FROM users;
SELECT * FROM catalogs;
SELECT * FROM products;


/*Практическое задание по теме “Транзакции, переменные, представления”*/
/* 1 В базе данных shop и sample присутствуют одни и те же таблицы 
 * учебной базы данных. Переместите запись id = 1 из таблицы 
 * shop.users в таблицу sample.users. Используйте транзакции
 */
START TRANSACTION;
	INSERT INTO sample.users SELECT * FROM shop.users WHERE id = 1;
COMMIT;

/* 2 Создайте представление, которое выводит название name 
 * товарной позиции из таблицы products и соответствующее название
 * каталога name из таблицы catalogs.
 */

DROP VIEW IF EXISTS vision;
CREATE VIEW vision (name_prod, name_cat) AS 
SELECT products.name, catalogs.name 
 	FROM products  
		JOIN catalogs ON products.catalog_id = catalogs.id;

	SELECT * FROM vision;
	
/* 3 по желанию) Пусть имеется таблица с календарным полем created_at. 
 * В ней размещены разряженые календарные записи за август 2018 года 
 * '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. 
 * Составьте запрос, который выводит полный список дат за август, 
 * выставляя в соседнем поле значение 1, если дата присутствует в исходном таблице и 0, если она отсутствует.
*/
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at, created_at) VALUES
  ('Геннадий', '1990-10-05', '2018-08-01'),
  ('Наталья', '1984-11-12', '2016-08-04'),
  ('Александр', '1985-05-20', '2018-08-16'),
  ('Сергей', '1988-02-14', '2018-08-17');
  
SELECT * FROM date_august;
SELECT * FROM users;

 -- Выполнение ДЗ
DROP TEMPORARY TABLE IF EXISTS date_august;
CREATE TEMPORARY TABLE date_august (
 	day_august DATETIME,
 	match_ char(255) comment '0 или 1' 
 	);
INSERT INTO date_august (day_august)
	VALUES	('2018-08-01'), ('2018-08-02'), ('2018-08-03'), ('2018-08-04'), ('2018-08-05'), ('2018-08-06'), ('2018-08-07'),
			('2018-08-08'), ('2018-08-09'), ('2018-08-10'), ('2018-08-11'), ('2018-08-12'), ('2018-08-13'), ('2018-08-14'),
			('2018-08-15'), ('2018-08-16'), ('2018-08-17'), ('2018-08-18'), ('2018-08-19'), ('2018-08-20'), ('2018-08-21'), 
			('2018-08-22'), ('2018-08-23'), ('2018-08-24'), ('2018-08-25'), ('2018-08-26'), ('2018-08-27'), ('2018-08-28'),
			('2018-08-29'), ('2018-08-30'), ('2018-08-31');
UPDATE date_august SET match_ = '1' WHERE day_august IN (SELECT created_at FROM users);
UPDATE date_august SET match_ = '0' WHERE day_august NOT IN (SELECT created_at FROM users);


/* 4 (по желанию) Пусть имеется любая таблица с календарным полем created_at. 
 * Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 
 * 5 самых свежих записей.*/
-- дополню таблицу users в БД shop
INSERT INTO users (name, birthday_at, created_at) VALUES
  ('Петр', '1999-10-05', '2019-08-01'),
  ('Дмитрий', '1988-04-07', '2020-08-04'),
  ('Вафлентин', '2010-05-20', '2021-08-16'),
  ('Маргариний', '1988-02-14', '2019-08-17'),
  ('Спанчбоб', '1992-10-11', '2020-09-15');
 
 SELECT * FROM users;
 SELECT * FROM del_user;
-- Выполнение ДЗ 
-- SELECT id, name, created_at FROM users ORDER BY created_at DESC LIMIT 5 ; -- смотрим 5 самых свежих записей.
/* DELETE FROM users 
 * 		WHERE created_at NOT IN (
 * 			SELECT id, name, created_at FROM users ORDER BY created_at DESC LIMIT 5); - что-то пошло не так)*/

CREATE TEMPORARY TABLE del_user (
 	created_at DATETIME);
INSERT INTO del_user (created_at) 
	SELECT created_at FROM users ORDER BY created_at DESC LIMIT 5
DELETE FROM users WHERE created_at NOT IN (SELECT * FROM del_user);

/*Практическое задание по теме “Хранимые процедуры и функции, триггеры"*/
/*1. Создайте хранимую функцию hello(), которая будет возвращать приветствие,
 * в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро",
 * с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", 
 * с 00:00 до 6:00 — "Доброй ночи".*/
DROP FUNCTION IF EXISTS hello;
SHOW FUNCTION status;

delimiter // 
CREATE FUNCTION hello()
RETURNS text DETERMINISTIC
BEGIN
	DECLARE hour_ int DEFAULT hour(now()); 
		CASE 
			WHEN hour_ BETWEEN 6 AND 11 THEN
				RETURN 'Доброе утро!';
			WHEN hour_ BETWEEN 12 AND 17 THEN
				RETURN 'Добрый день!';
			WHEN hour_ BETWEEN 18 AND 23 THEN
				RETURN 'Добрый вечер!';
			ELSE 
				RETURN 'Доброй ночи!';
		END CASE;
END//
delimiter ;

SELECT hello();

/*2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием.
 * Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное
 * значение NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля
 * были заполнены. При попытке присвоить полям NULL-значение необходимо отменить операцию.*/

SELECT * FROM products;
DROP TRIGGER IF EXISTS ctrl_upd_name_desr;
DROP TRIGGER IF EXISTS ctrl_ins_name_desr;


DELIMITER //
CREATE TRIGGER ctrl_upd_name_desr BEFORE UPDATE ON products
FOR EACH ROW 
	BEGIN
		IF name IS NULL AND desription IS NULL THEN 
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Name and description can`t be null. Operation canceled!';
		END IF;  
	END//
CREATE TRIGGER ctrl_ins_name_desr BEFORE INSERT ON products
FOR EACH ROW 
	BEGIN
		IF NEW.name IS NULL AND NEW.desription IS NULL THEN 
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Name and description can`t be null. Operation canceled!';
		END IF;  
	END//

DELIMITER ;

UPDATE products set name = NULL, desription = NULL WHERE id = 4;

SHOW TRIGGERS 


/*3. (по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. 
 * Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел. 
 * Вызов функции FIBONACCI(10) должен возвращать число 55.
*/

DROP FUNCTION IF EXISTS FIBONACCI;

DELIMITER //
CREATE FUNCTION FIBONACCI(value INT)
RETURNS INT DETERMINISTIC
	BEGIN
		DECLARE X_2 INT DEFAULT 0;
	    DECLARE X_1 INT DEFAULT 1;
	    DECLARE X INT DEFAULT 0;
		DECLARE i INT DEFAULT 1;
	    
		IF (value = 1) THEN
			RETURN 1;
		ELSE
			WHILE i < value DO
				SET X = X_1 + X_2;
				SET i = i + 1;
				SET X_2 = X_1;
				SET X_1 = X;
			END WHILE;
        
        	RETURN X;
		END IF;

	END//
DELIMITER ;

SELECT fibonacci(10);