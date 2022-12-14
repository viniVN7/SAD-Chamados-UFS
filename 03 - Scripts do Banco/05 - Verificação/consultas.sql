USE PROJETO_SAD

--Qual o n?mero de chamados abertos por campus? Por per?odo?
SELECT SUM(CH.QUANTIDADE) AS 'Quantidade', C.NM_CAMPUS, T.NM__MES
FROM FATO_CHAMADO CH
INNER JOIN DIM_CAMPUS C
ON(CH.ID_CAMPUS = C.ID_CAMPUS)
INNER JOIN DIM_TEMPO T
ON(CH.DATA_ABERTURA = T.ID_TEMPO)
WHERE T.SEMESTRE = 2
GROUP BY C.NM_CAMPUS, T.NM__MES

--Qual o n?mero de chamados atendidos por um determinado ??rg?o respons?vel??
SELECT SUM(CH.QUANTIDADE) AS 'QUANTIDADE', O.NM_ORGAO_RESPONSAVEL
FROM FATO_CHAMADO CH
INNER JOIN DIM_ORGAO_RESPONSAVEL O
ON(CH.ID_ORGAO_RESPONSAVEL = O.ID_ORGAO_RESPONSAVEL)
INNER JOIN DIM_STATUS S
ON(CH.ID_STATUS = S.ID_STATUS)
WHERE S.NM_STATUS = 'Resolvido'
GROUP BY CH.QUANTIDADE, O.NM_ORGAO_RESPONSAVEL, S.NM_STATUS

--Qual o n?mero de chamados abertos por departamento? 
SELECT SUM(CH.QUANTIDADE) AS 'QUANTIDADE', D.NM_DEPARTAMENTO, C.NM_CAMPUS
FROM FATO_CHAMADO CH
INNER JOIN DIM_DEPARTAMENTO D
ON(CH.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO)
INNER JOIN DIM_CAMPUS C
ON(CH.ID_CAMPUS = C.ID_CAMPUS)
GROUP BY CH.QUANTIDADE, D.NM_DEPARTAMENTO, C.NM_CAMPUS

--Qual o n?mero de chamados abertos por funcion?rio? 
SELECT SUM(CH.QUANTIDADE) AS 'QUANTIDADE', F.NM_FUNCIONARIO, D.NM_DEPARTAMENTO, C.NM_CAMPUS
FROM FATO_CHAMADO CH
INNER JOIN DIM_FUNCIONARIO F
ON(CH.ID_FUNCIONARIO = F.ID_FUNCIONARIO)
INNER JOIN DIM_DEPARTAMENTO D
ON(CH.ID_DEPARTAMENTO = D.ID_DEPARTAMENTO)
INNER JOIN DIM_CAMPUS C
ON(CH.ID_CAMPUS = C.ID_CAMPUS)
GROUP BY CH.QUANTIDADE, F.NM_FUNCIONARIO, D.NM_DEPARTAMENTO, C.NM_CAMPUS

--Qual o n?mero de chamados abertos por categoria?
SELECT SUM(CH.QUANTIDADE) AS 'QUANTIDADE', C.NM_CATEGORIA
FROM FATO_CHAMADO CH
INNER JOIN DIM_CATEGORIA C
ON(CH.ID_CATEGORIA = C.ID_CATEGORIA)
GROUP BY CH.QUANTIDADE, C.NM_CATEGORIA

--Qual o n?mero de chamados atendidos por funcion?rio? 
SELECT SUM(CH.QUANTIDADE) AS 'Quantidade', F.NM_FUNCIONARIO, O.NM_ORGAO_RESPONSAVEL
FROM FATO_CHAMADO CH
INNER JOIN DIM_FUNCIONARIO F
ON(CH.ID_FUNCIONARIO_ORGAO_RESPONSAVEL = F.ID_FUNCIONARIO)
INNER JOIN DIM_ORGAO_RESPONSAVEL O
ON(CH.ID_ORGAO_RESPONSAVEL = O.ID_ORGAO_RESPONSAVEL)
INNER JOIN DIM_STATUS S
ON(CH.ID_STATUS = S.ID_STATUS AND S.NM_STATUS = 'Resolvido')
GROUP BY CH.QUANTIDADE, F.NM_FUNCIONARIO, O.NM_ORGAO_RESPONSAVEL

--Quantos chamados est?o com o status ?Resolvido/Fechado?? Por campus? Por ?rg?o
--respons?vel? 
SELECT SUM(CH.QUANTIDADE) AS 'Quantidade', S.NM_STATUS, C.NM_CAMPUS
FROM FATO_CHAMADO CH
INNER JOIN DIM_CAMPUS C
ON(CH.ID_CAMPUS = C.ID_CAMPUS)
INNER JOIN DIM_STATUS S
ON(CH.ID_STATUS = S.ID_STATUS)
GROUP BY CH.QUANTIDADE, S.NM_STATUS, C.NM_CAMPUS

SELECT SUM(CH.QUANTIDADE) AS 'Quantidade', S.NM_STATUS, O.NM_ORGAO_RESPONSAVEL
FROM FATO_CHAMADO CH
INNER JOIN DIM_STATUS S
ON(CH.ID_STATUS = S.ID_STATUS)
INNER JOIN DIM_ORGAO_RESPONSAVEL O
ON(CH.ID_ORGAO_RESPONSAVEL = O.ID_ORGAO_RESPONSAVEL)
GROUP BY CH.QUANTIDADE, S.NM_STATUS, O.NM_ORGAO_RESPONSAVEL

--Quantos chamados est?o com o status ?Em Aberto?? Por campus? Por ?rg?o
--respons?vel? 
SELECT SUM(CH.QUANTIDADE) AS 'Quantidade', S.NM_STATUS, C.NM_CAMPUS
FROM FATO_CHAMADO CH
INNER JOIN DIM_CAMPUS C
ON(CH.ID_CAMPUS = C.ID_CAMPUS)
INNER JOIN DIM_STATUS S
ON(CH.ID_STATUS = S.ID_STATUS AND S.NM_STATUS='Em Aberto')
GROUP BY CH.QUANTIDADE, S.NM_STATUS, C.NM_CAMPUS

SELECT SUM(CH.QUANTIDADE) AS 'Quantidade', S.NM_STATUS, O.NM_ORGAO_RESPONSAVEL
FROM FATO_CHAMADO CH
INNER JOIN DIM_STATUS S
ON(CH.ID_STATUS = S.ID_STATUS AND S.NM_STATUS = 'Em Aberto')
INNER JOIN DIM_ORGAO_RESPONSAVEL O
ON(CH.ID_ORGAO_RESPONSAVEL = O.ID_ORGAO_RESPONSAVEL)
GROUP BY CH.QUANTIDADE, S.NM_STATUS, O.NM_ORGAO_RESPONSAVEL

--Qual o tempo m?dio entre a abertura de um chamado e o fechamento?
SELECT AVG(CH.TEMPO_ABERTURA_FECHAMENTO) AS 'Tempo medio de fechamento', O.NM_ORGAO_RESPONSAVEL
FROM FATO_CHAMADO CH
INNER JOIN DIM_ORGAO_RESPONSAVEL O 
ON(CH.ID_ORGAO_RESPONSAVEL = O.ID_ORGAO_RESPONSAVEL)
GROUP BY CH.TEMPO_ABERTURA_FECHAMENTO, O.NM_ORGAO_RESPONSAVEL





