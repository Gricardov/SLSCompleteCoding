CREATE DATABASE TL;

USE TL;

SET NAMES UTF8MB4;

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
  statisticsData JSON NOT NULL DEFAULT '{}',
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


-- Insertions

INSERT INTO USERS VALUES (
  'ueytg-ert-234',
  'jsdfhgf-234',
  'Alyoh',
  'Mascaritah',
  'https://apksos.com/storage/images/com/animated/florkstickersmemes/com.animated.florkstickersmemes_1.png',
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
  '{"bgColor":0,"text":"Hola bola","textColor":1}',
  '[{"id":"sdfsdf","color":0,"name":"Bestiality","weight":1},{"id":"ertert","color":0,"name":"Lesbian","weight":2},{"id":"oiuy","color":0,"name":"Adventure","weight":3}]',
  '["el","misterio","de","shany","dubi"]',
  DEFAULT,
  DEFAULT
);

UPDATE LUNAS SET
lunaModel = '{"bgColor":4278238420,"text":"¿Leerías una historia donde dos hermanas se enamoran? Desliza para leer 🤗","textColor":4278190080}',
categories = '[{"id":"sdfsdf","color":4283657726,"name":"Bestiality","weight":1},{"id":"ertert","color":4278238420,"name":"Lesbian","weight":2},{"id":"oiuy","color":4284809178,"name":"Adventure","weight":3}]'
WHERE id =  'ubf3d-1233-gf';


-- Tests

CALL USP_GET_LUNAS_PREVIEW_BY_POPULARITY (1);
CALL USP_GET_LUNA_WITH_CONTENT_BY_ID ('ubf3d-1233-gf');


