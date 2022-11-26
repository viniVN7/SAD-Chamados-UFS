USE PROJETO_SAD

DROP PROCEDURE IF EXISTS SP_INSERT_FATO_CHAMADO

CREATE OR ALTER PROCEDURE SP_INSERT_FATO_CHAMADO(@DATA_CARGA DATETIME)
AS
BEGIN
	DECLARE @DATA_ABERTURA DATETIME, @DATA_FECHAMENTO DATETIME, @ID_CAMPUS INT, @ID_ORGAO_RESPONSAVEL INT, @ID_DEPARTAMENTO INT, @PRIORIDADE VARCHAR(20),
			@ID_CATEGORIA INT, @ID_STATUS INT, @ID_REQUISITOR INT, @ID_RESOLUTOR INT, @STATUS VARCHAR(20), @ID_CHAMADO INT


	DECLARE @ID_DATA_ANDAMENTO INT, @TEMPO_ABERTURA_ANDAMENTO INT, @TEMPO_ABERTURA_FECHAMENTO INT, @ID_DATA_ABERTURA INT, @ID_DATA_FECHAMENTO INT,
			@ATUALIZACAO DATETIME

	
	DECLARE C_CHAMADO CURSOR FOR
		SELECT
		COD_CHAMADO, 
		DATA_ABERTURA, 
		DATA_FECHAMENTO, 
		PRIORIDADE,
		COD_CATEGORIA, 
		COD_STATUS, 
		COD_DEPARTAMENTO,
		COD_CAMPUS, 
		COD_ORGAO_RESPONSAVEL, 
		COD_REQUISITOR,
		COD_RESOLUTOR, 
		STATUS, 
		ATUALIZACAO
		FROM TB_AUX_CHAMADO
		WHERE DATA_CARGA = @DATA_CARGA

	OPEN C_CHAMADO
	FETCH C_CHAMADO
	INTO
	@ID_CHAMADO,
	@DATA_ABERTURA,
	@DATA_FECHAMENTO, 
	@PRIORIDADE, 
	@ID_CATEGORIA, 
	@ID_STATUS,
	@ID_DEPARTAMENTO, 
	@ID_CAMPUS,
	@ID_ORGAO_RESPONSAVEL, 
	@ID_REQUISITOR, 
	@ID_RESOLUTOR, 
	@STATUS, 
	@ATUALIZACAO

	WHILE(@@FETCH_STATUS = 0)
	BEGIN
		SET @ID_DATA_ABERTURA = (SELECT ID_TEMPO FROM DIM_TEMPO WHERE DATA = @DATA_ABERTURA)
		SET @ID_DATA_FECHAMENTO = (SELECT ID_TEMPO FROM DIM_TEMPO WHERE DATA = @DATA_FECHAMENTO)
		SET @ID_CAMPUS = (SELECT ID_CAMPUS FROM DIM_CAMPUS WHERE COD_CAMPUS = @ID_CAMPUS)
		SET @ID_CATEGORIA = (SELECT ID_CATEGORIA FROM DIM_CATEGORIA WHERE COD_CATEGORIA = @ID_CATEGORIA)
		SET @ID_DEPARTAMENTO = (SELECT ID_DEPARTAMENTO FROM DIM_DEPARTAMENTO WHERE COD_DEPARTAMENTO = @ID_DEPARTAMENTO)
		SET @ID_ORGAO_RESPONSAVEL = (SELECT ID_ORGAO_RESPONSAVEL FROM DIM_ORGAO_RESPONSAVEL WHERE COD_ORGAO_RESPONSAVEL = @ID_ORGAO_RESPONSAVEL)
		SET @ID_REQUISITOR = (SELECT ID_FUNCIONARIO FROM DIM_FUNCIONARIO WHERE COD_FUNCIONARIO = @ID_REQUISITOR)
		SET @ID_RESOLUTOR = (SELECT ID_FUNCIONARIO FROM DIM_FUNCIONARIO WHERE COD_FUNCIONARIO = @ID_RESOLUTOR)
		SET @ID_STATUS = (SELECT ID_STATUS FROM DIM_STATUS WHERE COD_STATUS = @ID_STATUS)


		SET @ID_DATA_ANDAMENTO = (SELECT ID_TEMPO FROM DIM_TEMPO WHERE DATA = @ATUALIZACAO)

		IF	@ID_DATA_ABERTURA IS NOT NULL AND @ID_CAMPUS IS NOT NULL AND @ID_CATEGORIA IS NOT NULL AND
			@ID_DEPARTAMENTO IS NOT NULL AND @ID_ORGAO_RESPONSAVEL IS NOT NULL AND @ID_REQUISITOR IS NOT NULL AND
			@ID_STATUS IS NOT NULL
		BEGIN
			IF @DATA_ABERTURA > @DATA_FECHAMENTO
			BEGIN
				INSERT INTO TB_VIOLACAO_CHAMADO(
					DATA_CARGA, DATA_ERRO, VIOLACAO, DATA_ABERTURA,
					DATA_FECHAMENTO, PRIORIDADE, COD_STATUS, COD_CATEGORIA,
					COD_DEPARTAMENTO, COD_CAMPUS, COD_ORGAO_RESPONSAVEL,
					COD_REQUISITOR, COD_RESOLUTOR
				)
				VALUES(
					@DATA_CARGA, GETDATE(), 'Data de abertura maior que data de fechamento', @DATA_ABERTURA,
					@DATA_FECHAMENTO, @PRIORIDADE, @ID_STATUS, @ID_CATEGORIA, @ID_DEPARTAMENTO, @ID_CAMPUS,
					@ID_ORGAO_RESPONSAVEL, @ID_REQUISITOR, @ID_RESOLUTOR
				)
			END

			ELSE
			BEGIN
				IF @STATUS = 'Resolvido' AND @ID_RESOLUTOR IS NULL
				BEGIN
					INSERT INTO TB_VIOLACAO_CHAMADO(
					DATA_CARGA, DATA_ERRO, VIOLACAO, DATA_ABERTURA,
					DATA_FECHAMENTO, PRIORIDADE, COD_STATUS, COD_CATEGORIA,
					COD_DEPARTAMENTO, COD_CAMPUS, COD_ORGAO_RESPONSAVEL,
					COD_REQUISITOR, COD_RESOLUTOR
					)
					VALUES(
						@DATA_CARGA, GETDATE(), 'Chamado resolvido, mas n�o consta resolutor', @DATA_ABERTURA,
						@DATA_FECHAMENTO, @PRIORIDADE, @ID_STATUS, @ID_CATEGORIA, @ID_DEPARTAMENTO, @ID_CAMPUS,
						@ID_ORGAO_RESPONSAVEL, @ID_REQUISITOR, @ID_RESOLUTOR
					)
				END

				ELSE
				BEGIN
					SET @TEMPO_ABERTURA_ANDAMENTO = DATEDIFF(DAY, (SELECT DATA FROM DIM_TEMPO WHERE ID_TEMPO = @ID_DATA_ABERTURA),
																	(SELECT DATA FROM DIM_TEMPO WHERE ID_TEMPO = @ID_DATA_ANDAMENTO))

					IF @DATA_FECHAMENTO IS NOT NULL
					BEGIN
						SET @TEMPO_ABERTURA_FECHAMENTO = DATEDIFF(DAY, (SELECT DATA FROM DIM_TEMPO WHERE ID_TEMPO = @ID_DATA_ABERTURA),
																		(SELECT DATA FROM DIM_TEMPO WHERE ID_TEMPO = @ID_DATA_FECHAMENTO))
					END

					IF EXISTS(SELECT ID FROM FATO_CHAMADO WHERE COD_CHAMADO = @ID_CHAMADO)
					BEGIN
						UPDATE FATO_CHAMADO
						SET ID_ORGAO_RESPONSAVEL = @ID_ORGAO_RESPONSAVEL,
							ID_CATEGORIA = @ID_CATEGORIA,
							ID_STATUS = @ID_STATUS,
							ID_FUNCIONARIO_ORGAO_RESPONSAVEL = @ID_RESOLUTOR,
							DATA_ABERTURA = @ID_DATA_ABERTURA,
							DATA_FECHAMENTO = @ID_DATA_FECHAMENTO,
							DATA_ANDAMENTO = @ID_DATA_ANDAMENTO,
							TEMPO_ABERTURA_FECHAMENTO = @TEMPO_ABERTURA_FECHAMENTO,
							TEMPO_ABERTURA_ANDAMENTO = @TEMPO_ABERTURA_ANDAMENTO
						WHERE COD_CHAMADO = @ID_CHAMADO
					END

					ELSE
					BEGIN
						INSERT INTO FATO_CHAMADO (
							COD_CHAMADO,
							TEMPO_ABERTURA_ANDAMENTO,
							TEMPO_ABERTURA_FECHAMENTO,
							PRIORIDADE,
							ID_CAMPUS,
							ID_ORGAO_RESPONSAVEL,
							ID_DEPARTAMENTO,
							ID_CATEGORIA,
							ID_STATUS, 
							ID_FUNCIONARIO, 
							ID_FUNCIONARIO_ORGAO_RESPONSAVEL,
							DATA_ABERTURA, 
							DATA_FECHAMENTO, 
							DATA_ANDAMENTO,
							QUANTIDADE
						)
						VALUES(
							@ID_CHAMADO, 
							@TEMPO_ABERTURA_ANDAMENTO,
							@TEMPO_ABERTURA_FECHAMENTO, 
							@PRIORIDADE, 
							@ID_CAMPUS,
							@ID_ORGAO_RESPONSAVEL, 
							@ID_DEPARTAMENTO, 
							@ID_CATEGORIA,
							@ID_STATUS, 
							@ID_REQUISITOR, 
							@ID_RESOLUTOR, 
							@ID_DATA_ABERTURA,
							@ID_DATA_FECHAMENTO,
							@ID_DATA_ANDAMENTO,
							1
						)
					END
				END
			
			END
		END

		ELSE
		BEGIN
			PRINT 'ENTROU'

			INSERT INTO TB_VIOLACAO_CHAMADO(
			DATA_CARGA, DATA_ERRO, VIOLACAO, DATA_ABERTURA,
			DATA_FECHAMENTO, PRIORIDADE, COD_STATUS, COD_CATEGORIA,
			COD_DEPARTAMENTO, COD_CAMPUS, COD_ORGAO_RESPONSAVEL,
			COD_REQUISITOR, COD_RESOLUTOR
			)
			VALUES(
				@DATA_CARGA, GETDATE(), 'Uma ou mais chaves prim�rias n�o existem nas dimens�es', @DATA_ABERTURA,
				@DATA_FECHAMENTO, @PRIORIDADE, @ID_STATUS, @ID_CATEGORIA, @ID_DEPARTAMENTO, @ID_CAMPUS,
				@ID_ORGAO_RESPONSAVEL, @ID_REQUISITOR, @ID_RESOLUTOR
			)
		END

		FETCH C_CHAMADO
		INTO @ID_CHAMADO, @DATA_ABERTURA, @DATA_FECHAMENTO, @PRIORIDADE, @ID_CATEGORIA, @ID_STATUS,
			 @ID_DEPARTAMENTO, @ID_CAMPUS, @ID_ORGAO_RESPONSAVEL, @ID_REQUISITOR, @ID_RESOLUTOR, @STATUS, @ATUALIZACAO
	END

	CLOSE C_CHAMADO
	DEALLOCATE C_CHAMADO
END

EXEC SP_INSERT_FATO_CHAMADO '20221124'

SELECT * FROM FATO_CHAMADO

SELECT * FROM TB_VIOLACAO_CHAMADO

select * FROM TB_AUX_CHAMADO

