/****************************
SUBQUERIES
 ****************************/


/* 1. Mostrando a cidade com a maior população */
SELECT 
    name, 
    continent, 
    (SELECT name FROM city WHERE population = (SELECT MAX(population) FROM city)) AS city, 
    (SELECT MAX(population) FROM city) AS population 
FROM 
    country WHERE code = (SELECT countrycode FROM city WHERE population = (SELECT MAX(population) FROM city));


/* 2. Mostrando a cidade com a maior população de cada país */
SELECT 
    C.name,
    C.code,
    C.continent,
    (SELECT name FROM city WHERE city.countrycode = C.code ORDER BY city.population DESC LIMIT 1) AS city,
    (SELECT MAX(population) FROM city WHERE countrycode = C.code) AS population
FROM 
    country AS C WHERE (SELECT MAX(population) FROM city WHERE countrycode = C.code) IS NOT NULL  ORDER BY population DESC;


/* 3. Mostrando a cidade com a maior população de cada continente */
SELECT DISTINCT ON (C.continent)
    C.continent,
    C.name,
    C.code,
    (SELECT name FROM city WHERE city.countrycode = C.code ORDER BY city.population DESC LIMIT 1) AS city,
    (SELECT MAX(population) FROM city WHERE countrycode = C.code) AS population
FROM 
    country AS C WHERE (SELECT MAX(population) FROM city WHERE countrycode = C.code) IS NOT NULL ORDER BY C.continent, population DESC;