/****************************
TRIGGERS
LPLA-br
22/07/2023
 ****************************/

CREATE TABLE IF NOT EXISTS infomundo
(
	id SERIAL PRIMARY KEY,
	populacaoglobal INT,
	espectativavidaglobal INT,
	cidademaispopulosa TEXT
);

INSERT INTO infomundo VALUES (1,12,12,'aaa');

CREATE OR REPLACE FUNCTION atualizarpopulacaogeral()
RETURNS TRIGGER
AS $$
BEGIN
	UPDATE infomundo SET populacaoglobal =
	(
		SELECT cast( sum( population ) AS INT ) FROM country
		WHERE population IS NOT NULL
	)
	WHERE id = 1;
	RETURN NULL;
END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION atualizarespectativavida()
RETURNS TRIGGER
AS $$
BEGIN
	UPDATE infomundo SET espectativavidaglobal =
	(
		SELECT CAST( AVG(lifeexpectancy) AS INT ) FROM country WHERE lifeexpectancy IS NOT NULL
	) WHERE id = 1;
	RETURN NULL;
END;
$$LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION atualizarcidademaispopulosa()
RETURNS TRIGGER
AS $$
BEGIN
	UPDATE infomundo SET cidademaispopulosa =
	(
		SELECT name FROM city
		ORDER BY population DESC
		LIMIT 1
	) WHERE id = 1;
	RETURN NULL;
END;
$$LANGUAGE PLPGSQL;


CREATE OR REPLACE TRIGGER populacaoglobalgatilho
AFTER INSERT OR UPDATE OR DELETE ON country EXECUTE PROCEDURE atualizarpopulacaogeral();

CREATE OR REPLACE TRIGGER espectativavidaglobalgatilho
AFTER INSERT OR UPDATE OR DELETE ON country EXECUTE PROCEDURE atualizarpopulacaogeral();

CREATE OR REPLACE TRIGGER cidademaispopulosagatilho
AFTER INSERT OR UPDATE OR DELETE ON city EXECUTE PROCEDURE atualizarcidademaispopulosa();

