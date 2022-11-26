USE PROJETO_SAD

CREATE OR ALTER PROCEDURE SP_INSERT_AUX_CHAMADO (@DATA_CARGA DATETIME) 
AS
BEGIN
	DELETE FROM TB_AUX_CHAMADO WHERE DATA_CARGA = @DATA_CARGA
	
	INSERT INTO TB_AUX_CHAMADO (DATA_CARGA, DATA_ABERTURA, DATA_FECHAMENTO, TITULO, PRIORIDADE, 
								COD_CATEGORIA, CATEGORIA, COD_STATUS, STATUS, COD_DEPARTAMENTO, DEPARTAMENTO,
								COD_CAMPUS, CAMPUS, COD_ORGAO_RESPONSAVEL, ORGAO_RESPONSAVEL, 
								COD_REQUISITOR, FUNCIONARIO_REQUISITOR, COD_RESOLUTOR, FUNCIONARIO_RESOLUTOR)
	  
	  SELECT @DATA_CARGA, CH.DATA_ABERTURA, CH.DATA_FECHAMENTO, CH.TITULO, CH.PRIORIDADE,
			 CR.ID_CATEGORIA, CR.CATEGORIA, S.ID_STATUS, S.STATUS, D.ID_DEPARTAMENTO, D.NOME,
			 C.ID_CAMPUS, C.NOME, O.ID_ORGAO_RESPONSAVEL, O.NOME, 
			 F.ID_FUNCIONARIO, F.NOME, NULL, NULL
	    FROM TB_CHAMADO CH
		INNER JOIN TB_CATEGORIA CR
		ON (CH.ID_CATEGORIA = CR.ID_CATEGORIA)
		INNER JOIN TB_STATUS S
		ON (CH.ID_STATUS = S.ID_STATUS)
		INNER JOIN TB_ORGAO_RESPONSAVEL O
		ON (CH.ID_ORGAO_RESPONSAVEL = O.ID_ORGAO_RESPONSAVEL)
		INNER JOIN TB_CAMPUS C
		ON (O.ID_CAMPUS = C.ID_CAMPUS)
		INNER JOIN TB_DEPARTAMENTO D
		ON (D.ID_CAMPUS = C.ID_CAMPUS)
		INNER JOIN TB_FUNCIONARIO F
		ON (CH.ID_REQUISITOR = F.ID_FUNCIONARIO)
		WHERE (CH.ID_RESOLUTOR IS NULL) 
		
		UNION ALL
		
		SELECT @DATA_CARGA, CH.DATA_ABERTURA, CH.DATA_FECHAMENTO, CH.TITULO, CH.PRIORIDADE,
			 CR.ID_CATEGORIA, CR.CATEGORIA, S.ID_STATUS, S.STATUS, D.ID_DEPARTAMENTO, D.NOME,
			 C.ID_CAMPUS, C.NOME, O.ID_ORGAO_RESPONSAVEL, O.NOME, 
			 F.ID_FUNCIONARIO, F.NOME, FRS.ID_FUNCIONARIO, FRS.NOME
	    FROM TB_CHAMADO CH
		INNER JOIN TB_CATEGORIA CR
		ON (CH.ID_CATEGORIA = CR.ID_CATEGORIA)
		INNER JOIN TB_STATUS S
		ON (CH.ID_STATUS = S.ID_STATUS)
		INNER JOIN TB_ORGAO_RESPONSAVEL O
		ON (CH.ID_ORGAO_RESPONSAVEL = O.ID_ORGAO_RESPONSAVEL)
		INNER JOIN TB_CAMPUS C
		ON (O.ID_CAMPUS = C.ID_CAMPUS)
		INNER JOIN TB_DEPARTAMENTO D
		ON (D.ID_CAMPUS = C.ID_CAMPUS)
		INNER JOIN TB_FUNCIONARIO F
		ON (CH.ID_REQUISITOR = F.ID_FUNCIONARIO)
		INNER JOIN TB_FUNCIONARIO FRS
		ON (CH.ID_RESOLUTOR = FRS.ID_FUNCIONARIO)
END

/*TIPO SERVIÇO*/


EXEC SP_INSERT_AUX_CHAMADO '20221124'

SELECT * FROM TB_AUX_CHAMADO

UPDATE TB_CHAMADO
SET DATA_FECHAMENTO = '20110512', ID_RESOLUTOR = 7

UPDATE TB_CHAMADO
SET DATA_FECHAMENTO = NULL, ID_RESOLUTOR = NULL
WHERE DATA_ABERTURA < '20100113'

SELECT * FROM TB_FUNCIONARIO
WHERE ID_FUNCIONARIO = 7