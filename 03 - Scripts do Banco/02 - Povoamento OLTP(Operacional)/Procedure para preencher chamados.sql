USE PROJETO_SAD

/*
CREATE TABLE TB_CHAMADO(
	ID_CHAMADO INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	TITULO VARCHAR(45) NOT NULL,
	DESCRICAO VARCHAR(200) NOT NULL,
	LOCAL VARCHAR(60) NOT NULL,
	PRIORIDADE VARCHAR(45) CHECK (PRIORIDADE IN ('BAIXA', 'MEDIA', 'ALTA')) NOT NULL,
	MOTIVO VARCHAR(100),
	DATA_ABERTURA DATETIME DEFAULT GETDATE() NOT NULL,
	DATA_FECHAMENTO DATETIME,
	ID_REQUISITOR INT NOT NULL,
	ID_RESOLUTOR INT,
	ID_ORGAO_RESPONSAVEL INT,
	ID_STATUS INT NOT NULL,
	ID_CATEGORIA INT NOT NULL
)
*/

--ASSOCIAR O CHAMADO A UM ORGAO
CREATE OR ALTER PROCEDURE SP_ASSOCIA_ORGAO(@ID_CHAMADO INT) AS
BEGIN
	DECLARE @ID_ORGAO INT

	--UMA CONSULTA AO ID DO ORGAO ATRAVES DO DEPARTAMENTO DO REQUISITOR
	SET @ID_ORGAO = (SELECT O.ID_ORGAO_RESPONSAVEL
					 FROM TB_CHAMADO C JOIN 
					 TB_DEPARTAMENTO DE ON (C.ID_REQUISITOR = DE.ID_DIRETOR)
					 JOIN TB_ORGAO_RESPONSAVEL O ON (DE.ID_CAMPUS = O.ID_CAMPUS)
					 WHERE C.ID_CHAMADO = @ID_CHAMADO
					)

	UPDATE TB_CHAMADO
	SET ID_ORGAO_RESPONSAVEL = @ID_ORGAO
	WHERE ID_CHAMADO = @ID_CHAMADO
END

CREATE OR ALTER PROCEDURE SP_CHAMADOS(@DATA_INICIAL DATETIME, @DATA_FINAL DATETIME, @QUANTIDADE_DEPARTAMENTOS INT, @MAXIMO_CHAMADOS_SEMANAIS INT) AS
BEGIN
	DECLARE @PROXIMO_DEPARTAMENTO INT, @QT_CHAMADOS INT, @DIAS_CORRIDOS INT,
			@PRIORIDADE INT, @PRIORIDADE_STR VARCHAR(20), @TITULO VARCHAR(80), @SIGLA_D VARCHAR(6),
			@DATA_AUX DATETIME, @CATEGORIA INT, @WEEKDAY VARCHAR(20), @ID_CHAMADO INT

	SET @PROXIMO_DEPARTAMENTO = 1

	--FAR� AT� QUE AS DATAS INICIAIS E FINAIS COINCIDAM
	WHILE (@DATA_INICIAL <= @DATA_FINAL)
	BEGIN
		SET @DATA_AUX = @DATA_INICIAL

		--ESSE WHILE GARANTE QUE TODOS OS DEPARTAMENTOS SER�O USADOS PARA CRIAR OS CHAMADOS
		WHILE(@PROXIMO_DEPARTAMENTO <= @QUANTIDADE_DEPARTAMENTOS)
		BEGIN
			SET @QT_CHAMADOS = (SELECT (ABS(CHECKSUM(NEWID())) % @MAXIMO_CHAMADOS_SEMANAIS) + 1)
			
			WHILE @QT_CHAMADOS > 0
			BEGIN
				-- definir prioridade
				SET @PRIORIDADE = (SELECT (ABS(CHECKSUM(NEWID())) % 3) + 1)
				IF @PRIORIDADE = 1
					SET @PRIORIDADE_STR = 'ALTA'
				ELSE
					IF @PRIORIDADE = 2
						SET @PRIORIDADE_STR = 'MEDIA'
					ELSE
						SET @PRIORIDADE_STR = 'BAIXA'

				--TITULO
				SET @TITULO = NEWID()
				SET @TITULO = TRIM(STR(@PROXIMO_DEPARTAMENTO) + ' - ' + SUBSTRING(@TITULO,1,8) + ' - ' + @PRIORIDADE_STR)

				--SIGLA DEPARTAMENTO
				SET @SIGLA_D = (SELECT SIGLA FROM TB_DEPARTAMENTO WHERE ID_DEPARTAMENTO = @PROXIMO_DEPARTAMENTO)

				--CATEGORIA
				SET @CATEGORIA = (SELECT (ABS(CHECKSUM(NEWID())) % 6) + 1)

				--INSERT NO TB_CHAMADOS
				INSERT INTO TB_CHAMADO (TITULO, DESCRICAO, LOCAL_PROBLEMA, PRIORIDADE, MOTIVO, DATA_ABERTURA, ID_REQUISITOR, ID_STATUS, ID_CATEGORIA)
				VALUES (@TITULO, NEWID(), 'LOCALTESTES ' + @SIGLA_D, @PRIORIDADE_STR,
						'MOTIVOTESTE - ' + @SIGLA_D, @DATA_AUX, (SELECT ID_DIRETOR FROM TB_DEPARTAMENTO WHERE ID_DEPARTAMENTO = @PROXIMO_DEPARTAMENTO),
						1, @CATEGORIA)
				
				SET @ID_CHAMADO = (SELECT ID_CHAMADO FROM TB_CHAMADO WHERE TITULO = @TITULO)

				EXEC SP_ASSOCIA_ORGAO @ID_CHAMADO

				SET @DATA_AUX = DATEADD(DD, 1, @DATA_AUX)
				SET @QT_CHAMADOS = @QT_CHAMADOS - 1
			END

			SET @PROXIMO_DEPARTAMENTO = @PROXIMO_DEPARTAMENTO + 1 
		END

		SET @DATA_INICIAL = DATEADD(WW,1,@DATA_INICIAL)
	END	
END

SELECT C.ID_CHAMADO, C.TITULO, C.PRIORIDADE, C.DATA_ABERTURA, C.DATA_FECHAMENTO, S.STATUS, CA.CATEGORIA, O.SIGLA AS 'ORGAO_RESPONSAVEL', CU.NOME AS 'CAMPUS'
FROM TB_CHAMADO C JOIN TB_STATUS S
ON (C.ID_STATUS = S.ID_STATUS) JOIN TB_CATEGORIA CA
ON (C.ID_CATEGORIA = CA.ID_CATEGORIA) JOIN TB_ORGAO_RESPONSAVEL O
ON (C.ID_ORGAO_RESPONSAVEL = O.ID_ORGAO_RESPONSAVEL) JOIN TB_CAMPUS CU
ON (O.ID_CAMPUS = CU.ID_CAMPUS)
order by PRIORIDADE

UPDATE TB_CHAMADO
SET ID_STATUS = 2
WHERE ID_CHAMADO = 1

SELECT * FROM TB_CHAMADO

EXEC SP_CHAMADOS '20221101', '20221130', 4, 15


