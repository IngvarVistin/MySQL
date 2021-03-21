USE vk;
SHOW tables;

-- Кто посещал мой профиль.
CREATE TABLE visitor (
 user_id BIGINT UNSIGNED NOT NULL, -- id страница `Пети` (профиль, который посящают)
 visit_id BIGINT UNSIGNED NOT NULL, -- id Посетитель `Вася`
 in_visited DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP -- время, когда `Вася` посешал страницу `Пети`
 
 );


-- Чёрный список
CREATE TABLE blacklist (
 user_id BIGINT UNSIGNED NOT NULL, -- id страница `Пети` (на котором действует blacklist)
 bl_user_id BIGINT UNSIGNED NOT NULL, -- id забаненого пользователя
 blacklist_id BIGINT UNSIGNED NOT NULL 
 CONSTRAINT pk_blacklist_bl_user PRIMARY KEY (bl_user_id) REFERENCES (blacklist_id), -- В чёрный список нельзя поместить пользователя более 1 раза
 CONSTRAINT fk_bl_user_user FOREIGN KEY (bl_user_id) REFERENCES users(id) -- юзер из черного списка забанен только у `Пети`
);

-- Школы, университеты для профиля пользователя
ALTER TABLE users ADD COLUMN school varchar(145);
ALTER TABLE users ADD COLUMN university varchar(145);
