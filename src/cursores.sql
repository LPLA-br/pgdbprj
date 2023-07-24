/****************************
 * CURSORES
 * Bartolomeu Rangel Dantas
 * 32/07
 *********************/

select countrylanguage.Language, countrylanguage.Percentage, country.Population from countrylanguage join country on countrylanguage.CountryCode = country.Code;
select * from country;
select countrylanguage.Language, round(countrylanguage.Percentage*country.population/100,2) from countrylanguage join country on countrylanguage.CountryCode = country.Code where countrylanguage.Language = "Chinese";
select countrylanguage.Language,round(countrylanguage.Percentage*country.population/100,0) as total from 
countrylanguage join country on countrylanguage.CountryCode = country.Code order by countrylanguage.Language;
select round(countrylanguage.Percentage*country.population/100,2) as total
		from countrylanguage join country on countrylanguage.CountryCode = country.Code
		where countrylanguage.Language = "English";
DELIMITER $$
CREATE PROCEDURE somaLanguage(x char(30),out soma float)
BEGIN 
	DECLARE total float DEFAULT 0;
	DECLARE fimloop int DEFAULT 0;
    

	DECLARE meucursor CURSOR FOR select round(countrylanguage.Percentage*country.population/100,2) as total
		from countrylanguage join country on countrylanguage.CountryCode = country.Code
		where countrylanguage.Language = x;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET fimloop = 1;

	SET soma = 0;

	OPEN meucursor;
	WHILE(fimloop !=1) DO
		FETCH meucursor into total;
		SET soma = soma + total;
	END WHILE;
END $$
DELIMITER ;
call somaLanguage("Chinese",@ret);
select @ret;

SELECT LifeExpectancy, Name FROM country where Continent = "Europe" and LifeExpectancy is not null;
DELIMITER $$
CREATE PROCEDURE MediaLife(x char(30),out soma float)
BEGIN 
	DECLARE total float DEFAULT 0;
	DECLARE fimloop int DEFAULT 0;
    declare count int default 0;
    

	DECLARE Mediacursor CURSOR FOR SELECT LifeExpectancy as total FROM country where Continent = x and LifeExpectancy is not null;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET fimloop = 1;

	SET soma = 0;

	OPEN Mediacursor;
	WHILE(fimloop !=1) DO
		FETCH Mediacursor into total;
		SET soma = soma + total;
        set count = count + 1;
	END WHILE;
    set soma = soma/count;
END $$
DELIMITER ;
call MediaLife("South America",@ret);
select @ret;
