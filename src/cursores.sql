/*********************
 * CURSORES
 * Bartolomeu Rangel Dantas
 * 32/07
 *********************/

--LINGUAGENS DE UM CONTINENTE QUE COMESSAM COM CERTA LETRA
CREATE OR REPLACE FUNCTION letterslangs( IN nomecontinente TEXT, IN letra TEXT )
RETURNS void AS
$$
DECLARE
	linguagens CURSOR ( nomecontinentecursor TEXT, letracursor TEXT ) FOR
	SELECT *
	FROM countrylanguage
	WHERE countrycode IN
	(
		SELECT code
		FROM country
		WHERE continent = nomecontinentecursor
	) AND LEFT(language,1) = letracursor ;

	lingua countrylanguage%ROWTYPE;
BEGIN
	OPEN linguagens( $1, $2 );

	LOOP
		FETCH NEXT FROM linguagens INTO lingua;

		IF lingua IS NULL THEN
			EXIT;
		END IF;

		RAISE NOTICE '%', lingua.language;
	END LOOP;

	CLOSE linguagens;
END;
$$
LANGUAGE PLPGSQL;

--SUPERFICIE DOS PAISES DE UM CONTINENTE.
CREATE OR REPLACE FUNCTION surfacecontinent( IN nomecontinente TEXT )
RETURNS void AS $$
DECLARE
	area REFCURSOR;
	tmp REAL := 0;
	areatotal REAL := 0;
BEGIN
	OPEN area FOR
	SELECT surfacearea
	FROM country
	WHERE continent = $1
	AND surfacearea IS NOT NULL;

	LOOP
		FETCH NEXT FROM area INTO tmp;

		IF tmp IS NULL THEN
			EXIT;
		END IF;

		areatotal = tmp + areatotal;

	END LOOP;

	RAISE NOTICE 'AREA DAS NACOES DO CONTINENTE % E %', $1, areatotal ;

	CLOSE area;
END;
$$ LANGUAGE PLPGSQL;


