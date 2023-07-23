-- Active: 1682455860970@@127.0.0.1@5432@worlds
/****************************
JOINS
 ****************************/


/*  1. Mostrando os países e suas cidades */
SELECT country.code, country.name, city.name FROM country INNER JOIN city ON country.code = city.countrycode;

/* 2. Mostrando os países e suas capitais */
SELECT country.code, country.name, city.name FROM country INNER JOIN city ON country.capital = city.id;

/* 3. Mostrando as cidades e o continente que elas pertencem por ordem alfabética dos nomes das cidades */
SELECT city.name, country.continent FROM city INNER JOIN country ON city.countrycode = country.code ORDER BY city.name ASC;

/* 4. Mostrando o nome, código, continente e as linguas que são faladas em cada país */
SELECT C.name, C.code, C.continent, L.language, L.percentage FROM country AS C INNER JOIN countrylanguage AS L ON C.code = L.countrycode ORDER BY C.name ASC;

/* 5. Mostrando a lingua oficial falada de cada país */
SELECT C.name, C.code, C.continent, L.language, L.percentage FROM country AS C INNER JOIN countrylanguage AS L ON C.code = L.countrycode WHERE L.isofficial = true;

/* 6. Mostrando quais países falam o inglês */
SELECT C.name, C.code, C.continent, L.language, L.percentage FROM country AS C INNER JOIN countrylanguage AS L ON C.code = L.countrycode WHERE L.language like 'English' AND L.percentage != 0;