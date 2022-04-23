SET NAMES UTF8MB4;

CREATE DATABASE TL;

USE TL;

-- Authors
CREATE TABLE IF NOT EXISTS USERS (
  id VARCHAR(50) NOT NULL PRIMARY KEY,
  cognitoUserName VARCHAR(50) NOT NULL,
  fName VARCHAR(100) NOT NULL,
  lName VARCHAR(100) NOT NULL,
  profileImgUrl VARCHAR(500) NULL,
  username VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL,
  contactPhone VARCHAR(50) NULL,
  createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Luna categories
CREATE TABLE IF NOT EXISTS LUNA_CATEGORIES (
  id VARCHAR(50) NOT NULL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  iconName VARCHAR(100) NOT NULL,
  color INT NOT NULL,
  createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Display types
CREATE TABLE IF NOT EXISTS LUNA_DISPLAY_TYPES (
  id VARCHAR(50) NOT NULL PRIMARY KEY,
  name VARCHAR(200) NOT NULL
);

-- Lunas
CREATE TABLE IF NOT EXISTS LUNAS (
  id VARCHAR(50) NOT NULL PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  expressSynopsis VARCHAR(500) NOT NULL,
  is18 TINYINT NOT NULL,
  content VARCHAR(5000) NOT NULL,
  authorId VARCHAR(50) NOT NULL,
  authorData JSON NOT NULL DEFAULT '{}',
  popularity INT NOT NULL,
  statisticsData JSON NOT NULL DEFAULT '{"numViews":0,"numComments":0}',
  displayType VARCHAR(50) NOT NULL,
  -- If "displayType" is Text, there will be a field shaped like this: "lunaModel" {bgColor (N), text (S), textColor (N)}
  -- If "displayType" is Image, there will be a field shaped like this: "lunaModel" {displayUrl (S)}
  lunaModel JSON NULL DEFAULT '{}',
  categories JSON NOT NULL DEFAULT '[]',
  keywords JSON NOT NULL DEFAULT '[]',
  createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updatedAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

ALTER TABLE LUNAS
ADD FOREIGN KEY (authorId) REFERENCES USERS(id);


-- Procedures

-- This gets the most popular lunas for the home (this is ordered by popularity DESC and createdAt DESC) without querying authors or statistics table, it gets that information from authorData and statisticsData respectively
DROP PROCEDURE IF EXISTS USP_GET_LUNAS_PREVIEW_BY_POPULARITY;
DELIMITER //
CREATE PROCEDURE USP_GET_LUNAS_PREVIEW_BY_POPULARITY (IN P_LIMIT INT)
BEGIN
	SELECT
    id,
    title,
    expressSynopsis,
    is18,
    authorId,
    authorData,
    statisticsData,
    displayType,
    lunaModel,
    categories,
    createdAt
	FROM LUNAS
    ORDER BY popularity DESC, createdAt DESC
    LIMIT P_LIMIT;
END; //
DELIMITER ;

-- This gets a luna with its content and the most updated data. This is used to read a luna
DROP PROCEDURE IF EXISTS USP_GET_LUNA_WITH_CONTENT_BY_ID;
DELIMITER //
CREATE PROCEDURE USP_GET_LUNA_WITH_CONTENT_BY_ID (IN P_LUNA_ID VARCHAR(50))
BEGIN
	SELECT
    L.id,
    L.title,
    L.expressSynopsis,
    L.is18,
    L.authorId,
    U.fName AS 'authorFName',
    U.lName AS 'authorLName',
    U.profileImgUrl AS 'authorProfileImgUrl',
    U.username AS 'authorUsername',
    L.content,
    L.statisticsData,
    L.displayType,
    L.lunaModel,
    L.categories,
    L.createdAt
	FROM LUNAS L
	JOIN USERS U
	ON L.authorId = U.id
	WHERE L.id = P_LUNA_ID
   ORDER BY popularity DESC, createdAt DESC;
END; //
DELIMITER ;

-- This creates a luna
DROP PROCEDURE IF EXISTS USP_CREATE_LUNA;
DELIMITER //
CREATE PROCEDURE USP_CREATE_LUNA (
IN P_LUNA_ID VARCHAR(50),
IN P_LUNA_TITLE VARCHAR(200),
IN P_LUNA_EXPRESS_SYNOPSIS VARCHAR(500),
IN P_LUNA_IS18 TINYINT,
IN P_LUNA_CONTENT VARCHAR(5000),
IN P_LUNA_AUTHOR_ID VARCHAR(50),
IN P_LUNA_DISPLAY_TYPE VARCHAR(50),
IN P_LUNA_MODEL JSON,
IN P_LUNA_CATEGORIES JSON,
IN P_LUNA_KEYWORDS JSON
)
BEGIN
	DECLARE V_AUTHOR_FNAME VARCHAR(100);
   DECLARE V_AUTHOR_LNAME VARCHAR(100);
   DECLARE V_AUTHOR_USERNAME VARCHAR(100);
   DECLARE V_AUTHOR_DISPLAY_URL VARCHAR(500);
   DECLARE V_AUTHOR_JSON_DATA JSON;
   
   SELECT fName, lName, username, profileImgUrl INTO V_AUTHOR_FNAME, V_AUTHOR_LNAME, V_AUTHOR_USERNAME, V_AUTHOR_DISPLAY_URL FROM USERS WHERE id = P_LUNA_AUTHOR_ID;
   
   SET V_AUTHOR_JSON_DATA = JSON_OBJECT("fName", V_AUTHOR_FNAME, "lName", V_AUTHOR_LNAME, "username", V_AUTHOR_USERNAME, "profileImgUrl", V_AUTHOR_DISPLAY_URL);
   
	INSERT INTO LUNAS VALUES (P_LUNA_ID, P_LUNA_TITLE, P_LUNA_EXPRESS_SYNOPSIS, P_LUNA_IS18, P_LUNA_CONTENT, P_LUNA_AUTHOR_ID, V_AUTHOR_JSON_DATA, 1, DEFAULT, P_LUNA_DISPLAY_TYPE, P_LUNA_MODEL, P_LUNA_CATEGORIES, P_LUNA_KEYWORDS, DEFAULT, DEFAULT);
END; //
DELIMITER ;


-- Insertions

INSERT INTO USERS VALUES (
  'ueytg-ert-234',
  'jsdfhgf-234',
  'Alyoh',
  'Mascaritah',
   NULL,-- 'https://apksos.com/storage/images/com/animated/florkstickersmemes/com.animated.florkstickersmemes_1.png',
  'alyohmascarita',
  'gricardov@gmail.com',
  NULL,
  DEFAULT,
  DEFAULT
);

INSERT INTO LUNAS VALUES (
 'ubf3d-1233-gf',
 'El misterio de Shany Dubi',
 '¿Te atreverías a nadar en el subconsciente humano?',
 0,
 'Sus notas feas eran peor que las del gato, su canto era mása que un desacato',
 'ueytg-ert-234',
 '{"fName":"Alyoh","lName":"Mascaritah","username":"alyohmascarita","profileImgUrl":"https://apksos.com/storage/images/com/animated/florkstickersmemes/com.animated.florkstickersmemes_1.png"}',
  1,
  '{"numViews":1,"numComments":3}',
  'Text',
  '{"bgColor":4278238420,"text":"¿Leerías una historia donde dos hermanas se enamoran? Desliza para leer 🤗","textColor":4278190080}',
  '[{"id":"sdfsdf","color":4283657726,"name":"Bestiality","weight":1},{"id":"ertert","color":4278238420,"name":"Lesbian","weight":2},{"id":"oiuy","color":4284809178,"name":"Adventure","weight":3}]',
  '["el","misterio","de","shany","dubi"]',
  DEFAULT,
  DEFAULT
);

INSERT INTO LUNAS VALUES (
 'ubf3d-1233-gf2',
 'La chica que nunca se me declaró',
 '¿Quién dice que solo uno debe tener iniciativa?',
 0,
 'What is Lorem Ipsum? Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
 'ueytg-ert-234',
 '{"fName":"Alyoh","lName":"Mascaritah","username":"alyohmascarita","profileImgUrl":"https://apksos.com/storage/images/com/animated/florkstickersmemes/com.animated.florkstickersmemes_1.png"}',
  1,
  '{"numViews":2,"numComments":8}',
  'Image',
  '{"displayUrl":"https://w0.peakpx.com/wallpaper/760/936/HD-wallpaper-couple-separation-sunlight-love-sad.jpg"}',
  '[{"id":"sdfsdf","color":4283657726,"name":"Amor","weight":1},{"id":"ertert","color":4278238420,"name":"Desamor","weight":2},{"id":"oiuy","color":4284809178,"name":"Llorona","weight":3}]',
  '["la","chica","que","nunca","declaró"]',
  DEFAULT,
  DEFAULT
);


-- Tests

CALL USP_GET_LUNAS_PREVIEW_BY_POPULARITY (1);
CALL USP_GET_LUNA_WITH_CONTENT_BY_ID ('ubf3d-1233-gf');
CALL USP_CREATE_LUNA ('bella-linda','La maldita primavera','Pasa ligera la maldita primaverx',0, 'Princesa de fresa, ¡Cuánto te extraño!','ueytg-ert-234','Image','{"displayUrl":"https://buidln.clipdealer.com/001/813/868//player/1--1813868-young-sexy-girl-kiss-with-passion.jpg"}','[{"id":"sdfsdf","color":4283657726,"name":"Scissoring","weight":1},{"id":"ertert","color":4278238420,"name":"Lesbianism","weight":2},{"id":"oiuy","color":4284809178,"name":"Tribing","weight":3}]','["bailan","las","negras"]');
DELETE FROM LUNAS WHERE id = 'bella-linda';
SELECT*FROM LUNAS;