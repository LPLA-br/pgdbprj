/****************************
FUNCTIONS
LPLA-br
24/07/2023
 ****************************/

CREATE OR REPLACE FUNCTION capitalde( IN pais TEXT )
RETURNS TEXT
AS $$
DECLARE
	caputpatriae TEXT;
BEGIN

	SELECT name INTO caputpatriae
	FROM city
	WHERE id IN
	(
		SELECT capital
		FROM country
		WHERE name = pais
	);

	RETURN caputpatriae;
END
$$
LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION aquepais( IN cidade TEXT )
RETURNS TEXT
AS $$
DECLARE
	patria TEXT;
BEGIN
	SELECT name INTO patria
	FROM country
	WHERE code IN
	(
		SELECT countrycode
		FROM city
		WHERE name = cidade
	);

	RETURN patria;
END
$$
LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION quehablas( IN pais )
RETURNS TABLE( lingua TEXT, porcentagem REAL )
AS $$
	SELECT language, percentage 
	FROM countrylanguage
	WHERE countrycode IN
	(
		SELECT code
		FROM country
		WHERE name = pais
	);
$$ LANGUAGE PLPGSQL;
