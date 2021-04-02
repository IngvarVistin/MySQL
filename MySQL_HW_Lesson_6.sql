USE VKN;
SHOW tables;
SELECT*FROM profiles;
SELECT*FROM users;
SELECT*FROM messages;
SELECT*FROM posts;
SELECT*FROM posts_likes;
SELECT*FROM communities_users;
SELECT*FROM friend_requests;

/*1. Найдите человека, который больше всех общался с нашим пользователем, 
 иначе, кто написал пользователю наибольшее число сообщений. (можете взять пользователя с любым id).*/

SELECT from_user_id, count(from_user_id) FROM messages WHERE to_user_id = 6 GROUP BY from_user_id ORDER BY count(from_user_id) DESC LIMIT 1;
		
/*2. Подсчитать общее количество лайков на посты, которые получили пользователи младше 18 лет.*/

SELECT sum(like_type) FROM posts_likes WHERE user_id IN (SELECT user_id FROM profiles WHERE birthday >= now() - INTERVAL 18 YEAR);

/* SELECT like_type, post_id FROM posts_likes WHERE user_id IN (SELECT user_id FROM profiles WHERE birthday >= now() - INTERVAL 18 YEAR);
 -- Проверка)*/

/*3. Определить, кто больше поставил лайков (всего) - мужчины или женщины?*/

SELECT sex, summ FROM (
		SELECT 'f' AS sex, sum(like_type) AS summ FROM posts_likes WHERE user_id IN (SELECT user_id FROM profiles WHERE gender IN ('f'))
		UNION 
		SELECT 'x' AS sex, sum(like_type) AS summ FROM posts_likes WHERE user_id IN (SELECT user_id FROM profiles WHERE gender IN ('x'))
		UNION 
		SELECT 'm' AS sex, sum(like_type) AS summ FROM posts_likes WHERE user_id IN (SELECT user_id FROM profiles WHERE gender IN ('m'))
						) AS sort ORDER BY summ DESC LIMIT 1;

/*4. (по желанию) Найти пользователя, который проявляет наименьшую активность в использовании социальной сети.*/

SELECT user_id, sum(points) AS total_poits FROM (
			SELECT * FROM (
				SELECT user_id, 0 AS points -- sum_mess 
					FROM profiles 
						WHERE user_id NOT IN (SELECT from_user_id FROM messages)
				UNION 
				SELECT from_user_id, count(*) AS points -- sum_mess 
					FROM messages 
						GROUP BY from_user_id 						-- отправленные сообщения
				) AS result_mess
			UNION ALL 
			SELECT * FROM (
				SELECT user_id, 0 AS points -- sum_comm
					FROM profiles 
						WHERE user_id NOT IN (SELECT user_id FROM communities_users) 
				UNION
				SELECT user_id, count(*) AS points -- sum_comm 
					FROM communities_users 
				 		GROUP BY user_id   							--  количество групп, в которых сосотоит
				) AS result_comm
			UNION ALL
			SELECT * FROM (
				SELECT user_id, 0 AS points -- sum_friend
					FROM profiles 
						WHERE user_id NOT IN (SELECT from_user_id FROM friend_requests WHERE request_type = 1) 
				UNION
					SELECT from_user_id, count(*) AS points --  sum_friend 
				 		FROM friend_requests 
				 			WHERE request_type = 1 
				 				GROUP BY from_user_id 				-- Количество друзей
				) AS result_friend
			UNION ALL 				
			SELECT * FROM (
				SELECT user_id, 0 AS points -- sum_likes
					FROM profiles 
						WHERE user_id NOT IN (SELECT user_id FROM posts_likes) 
				UNION
				SELECT user_id, count(*) AS points -- sum_likes 
					FROM posts_likes 
						WHERE like_type > 0 
							GROUP BY user_id 						-- Количество лайков поставлено
				) AS result_likes
			UNION ALL
			SELECT * FROM (
				SELECT user_id, 0 AS points -- sum_post
					FROM profiles 
						WHERE user_id NOT IN (SELECT user_id FROM posts) 
							GROUP BY user_id
				UNION 				
				SELECT user_id, count(*) AS points -- sum_post
					FROM posts 
						GROUP BY user_id 							-- Наименьшее количество постов	
				)AS result_post
) AS total_table 
	GROUP BY user_id ORDER BY total_poits LIMIT 1 ;
/* Изначально хотел данные по сообщениям, состоянии в группах и т.д. разместить в разных столбцах таблицы, 
 * но что-то не сообразил как сделать... UNION такого не поддерживает...
