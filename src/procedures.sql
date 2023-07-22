/****************************
PROCEDURES
LPLA-br
22/07/2023
 ****************************/

/* procedimento responsável por adicionar cidade a um pais existente */
CREATE OR REPLACE PROCEDURE adicionarcidadeapais
(
	IN nome TEXT,
	IN codigopais CHAR(3),
	IN distrito TEXT,
	IN populacao INT
)
AS $$
DECLARE
	pais CHAR(3);
	distritovar TEXT;
BEGIN

	SELECT code INTO pais FROM country WHERE code = codigopais;

	IF FOUND THEN

		SELECT district INTO distritovar FROM city
		GROUP BY district HAVING district = distrito;

		IF FOUND THEN

			/* ausência de autoincrement -> subqueries */
			INSERT INTO city( id, name, countrycode, district, population )
			VALUES( ( SELECT 1 + ( SELECT MAX(id) FROM city ) ), nome, codigopais, distrito, populacao );

			RAISE NOTICE 'A cidade % foi registrada para o pais %', nome, codigopais;
		ELSE
			RAISE NOTICE 'A cidade não pode ser registrada para um distrito % inexistente', distrito;
		END IF;

	ELSE
		RAISE NOTICE 'A cidade % não pode ser registrada para um pais % inexistente', nome, codigopais;
	END IF;
END;
$$
LANGUAGE PLPGSQL;

/* procedimento responsável por atribuir uma língua
   a um pais existente.  */
CREATE OR REPLACE PROCEDURE adicionarlinguaapais
(
	IN codigopais CHAR(3),
	IN lingua TEXT,
	IN eoficial BOOLEAN,
	IN porcentagem REAL
)
AS $$
DECLARE
	pais CHAR(3);
BEGIN

	SELECT code INTO pais FROM country WHERE code = codigopais;
	
	/*verificar se countrycode existe em country*/
	IF FOUND THEN

		INSERT INTO countrylanguage( countrycode, language, isofficial, percentage )
		VALUES ( codigopais, lingua, eoficial, porcentagem );

		RAISE NOTICE 'A lingua % foi registrada ao pais %', lingua, codigopais;
	ELSE
		RAISE NOTICE 'A lingua % não pode ser registrada a um pais % inexistente', lingua, codigopais;
	END IF;
END;
$$
LANGUAGE plpgsql;

/* procedimento responsável por inserir uma nova nação no banco
 de dados fazendo as devidas verificações lógicas básicas.*/
CREATE OR REPLACE PROCEDURE adicionarpais
(
	IN codigo CHAR(3),
	IN nome TEXT,
	IN continente TEXT,
	IN regiao TEXT,
	IN superficisarea REAL,
	IN anoindep SMALLINT,
	IN populacao INT,
	IN expectativavida REAL,
	IN pib NUMERIC(10,2),
	IN pibvelho NUMERIC(10,2),
	IN localnome TEXT,
	IN formagovernis TEXT,
	IN governante TEXT,
	IN capital INT,
	IN segundocodigo CHAR(2)
)
AS $$
DECLARE
	verif INT;
BEGIN

	SELECT id INTO verif FROM city WHERE id = capital;

	IF FOUND THEN	
		INSERT INTO country
		(
			code,
			name,
			continent,
			region,
			surfacearea,
			indepyear,
			population,
			lifeexpectancy,
			gnp,
			gnpold,
			localname,
			governmentform,
			headofstate,
			capital,
			code2
		) VALUES
		(
			codigo,
			nome,
			continente,
			regiao,
			superficisarea,
			anoindep,
			populacao,
			expectativavida,
			pib,
			pibvelho,
			localnome,
			formagovernis,
			governante,
			capital,
			segundocodigo
		);
	ELSE
		RAISE EXCEPTION 'erro de restrição de chave estrangeira para capital';
	END IF;
END;
$$
LANGUAGE PLPGSQL;
