/* «Операторы, фильтрация, сортировка и ограничение». Для задания 1. */

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME,
  updated_at DATETIME
) COMMENT = 'Покупатели';

INSERT INTO
  users (name, birthday_at, created_at, updated_at)
VALUES
  ('Геннадий', '1990-10-05', NULL, NULL),
  ('Наталья', '1984-11-12', NULL, NULL),
  ('Александр', '1985-05-20', NULL, NULL),
  ('Сергей', '1988-02-14', NULL, NULL),
  ('Иван', '1998-01-12', NULL, NULL),
  ('Мария', '2006-08-29', NULL, NULL);
  
UPDATE users 
	SET created_at = now(), updated_at = now()
	
USE shop;
SHOW tables;
DESCRIBE users;
SELECT*FROM users;	

/* «Операторы, фильтрация, сортировка и ограничение». Для заданий 2, 4. */
/* «Агрегация данных». Для заданий 1, 2. */

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(255),
  updated_at VARCHAR(255)
) COMMENT = 'Покупатели';

INSERT INTO
  users (name, birthday_at, created_at, updated_at)
VALUES
  ('Геннадий', '1990-10-05', '07.01.2016 12:05', '07.01.2016 12:05'),
  ('Наталья', '1984-11-12', '20.05.2016 16:32', '20.05.2016 16:32'),
  ('Александр', '1985-05-20', '14.08.2016 20:10', '14.08.2016 20:10'),
  ('Сергей', '1988-02-14', '21.10.2016 9:14', '21.10.2016 9:14'),
  ('Иван', '1998-01-12', '15.12.2016 12:45', '15.12.2016 12:45'),
  ('Мария', '2006-08-29', '12.01.2017 8:56', '12.01.2017 8:56');
 
-- Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.
/*ALTER TABLE users ADD COLUMN created_at_n datetime, 
    			  ADD COLUMN updated_at_n datetime;*/
  UPDATE users 
   SET created_at = str_to_date(created_at, '%d.%m.%Y %k:%i'),
       updated_at = str_to_date(updated_at, '%d.%m.%Y %k:%i');
  ALTER TABLE users MODIFY COLUMN created_at datetime;



-- Необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка английских названий (may, august)

  SELECT name, created_at, updated_at, date_format(birthday_at, '%M %Y') FROM users 
 WHERE birthday_at RLIKE '....-08|05-..' ;  
  
  
 /* «Операторы, фильтрация, сортировка и ограничение». Для задания 3. */

SHOW tables;
DESCRIBE storehouses_products;
SELECT*FROM storehouses_products;
  
  DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';

INSERT INTO
  storehouses_products (storehouse_id, product_id, value)
VALUES
  (1, 543, 0),
  (1, 789, 2500),
  (1, 3432, 0),
  (1, 826, 30),
  (1, 719, 500),
  (1, 638, 1);
 
 /*Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value.
  * Однако нулевые запасы должны выводиться в конце, после всех*/
 SELECT*FROM storehouses_products ORDER BY IF (value > 0, 0, 1), value 


DESCRIBE catalogs;
SELECT*FROM catalogs;

 /* «Операторы, фильтрация, сортировка и ограничение». Для задания 5. */
DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');
-- Из таблицы catalogs извлекаются записи при помощи запроса. 
-- SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN
  SELECT*FROM catalogs WHERE id IN (5, 1, 2) 
  ORDER BY field(id, 5, 1, 2); 

-- «Агрегация данных» Подсчитайте средний возраст пользователей в таблице users.
USE shop;
SHOW tables;
DESCRIBE users;
SELECT*FROM users;

SELECT avg(timestampdiff(YEAR, birthday_at, now())) AS mid_age FROM users;

/*Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
Следует учесть, что необходимы дни недели текущего года, а не года рождения.*/ -- Я что-то долго в задание вникал. Можно было и проще выразиться)))

SELECT weekday(concat(YEAR(now()),'-',EXTRACT(MONTH FROM birthday_at),'-',EXTRACT(day FROM birthday_at))) AS day_week,
	   count(*) AS birthday FROM users GROUP BY day_week;
-- 0 - понедельник, 6 - суббота

/*(по желанию) Подсчитайте произведение чисел в столбце таблицы.*/
-- Взял столбец id в таблице users (от 1 до 7)

USE shop;
SHOW tables;
DESCRIBE users;
SELECT*FROM users;

SELECT exp(sum(ln(id))) from users;