/****************************
TRIGGERS
LPLA-br
22/07/2023
 ****************************/

CREATE TABLE IF NOT EXISTS infomundo
(
	id SERIAL PRIMARY KEY,
	populacaoglobal BIGINT,
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
		SELECT cast( sum( population ) AS BIGINT )
		FROM country WHERE population IS NOT NULL
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

CREATE OR REPLACE FUNCTION tratamentolinguas()
RETURNS TRIGGER AS $$
BEGIN
	--impor restrição de línguas que tenha apenas mais de 25% de uso
	IF NEW.percentage < 25.0 THEN
		RAISE EXCEPTION 'línguas com menos de 25% de uso não podem mais serem inseridas';
	ELSE IF NEW.percentage IS NULL THEN
		RAISE EXCEPTION 'ERRO: não é admitido porcentagem de uso nula';
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE TRIGGER populacaoglobalgatilho
AFTER INSERT OR UPDATE OR DELETE ON country EXECUTE FUNCTION atualizarpopulacaogeral();

CREATE OR REPLACE TRIGGER espectativavidaglobalgatilho
AFTER INSERT OR UPDATE OR DELETE ON country EXECUTE FUNCTION atualizarespectativavida();

CREATE OR REPLACE TRIGGER cidademaispopulosagatilho
AFTER INSERT OR UPDATE OR DELETE ON city EXECUTE FUNCTION atualizarcidademaispopulosa();

CREATE OR REPLACE TRIGGER lingua
BEFORE INSERT OR UPDATE ON countrylanguage EXECUTE FUNCTION tratamentolinguas();
