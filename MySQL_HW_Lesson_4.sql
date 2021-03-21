-- VK_rename_media_types
USE VK2;
SHOW tables;
SELECT * FROM media_types;


	UPDATE media_types
SET 
	name = 'Photo'
WHERE id = 1;


	UPDATE media_types
SET 
	name = 'Video'
WHERE id = 2;


	UPDATE media_types
SET 
	name = 'Music'
WHERE id = 3;


	UPDATE media_types
SET 
	name = 'Books'
WHERE id = 4;
