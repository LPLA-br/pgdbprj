/****************************
VIEWS
Autor: Luigi Eduardo
23/07/2023
****************************/

/*Línguas mais disseminadas (Em número de países)*/
CREATE OR REPLACE VIEW language_dissemination AS
	SELECT count(C.code) AS Paises, L.language FROM country C
    INNER JOIN countrylanguage L ON C.code = L.countrycode
    GROUP BY L.language
    ORDER BY Paises DESC LIMIT 10 ;

SELECT * FROM language_dissemination;

/*Megacidades existentes*/
CREATE OR REPLACE VIEW megacity AS
	SELECT I.name AS city, I.population, C.name AS country FROM city I
    INNER JOIN country C ON I.countrycode = C.code
    WHERE I.population > 10000000
    ORDER BY I.population DESC;

SELECT * FROM megacity;
