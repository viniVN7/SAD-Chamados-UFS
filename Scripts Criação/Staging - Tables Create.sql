USE PROJETO_SAD

DROP TABLE IF EXISTS TB_AUX_CHAMADO
DROP TABLE IF EXISTS TB_AUX_CAMPUS
DROP TABLE IF EXISTS TB_AUX_DEPARTAMENTO
DROP TABLE IF EXISTS TB_AUX_FUNCIONARIO
DROP TABLE IF EXISTS TB_AUX_CATEGORIA
DROP TABLE IF EXISTS TB_AUX_ORGAO_RESPONSAVEL
DROP TABLE IF EXISTS TB_AUX_STATUS
DROP TABLE IF EXISTS TB_VIOLACAO_CHAMADO

CREATE TABLE TB_AUX_CHAMADO (
	DATA_CARGA DATETIME NOT NULL,
	DATA_ABERTURA DATETIME NOT NULL,
	DATA_FECHAMENTO DATETIME NULL,
	TITULO VARCHAR(100) NOT NULL,
	TIPO_SERVICO VARCHAR(50) NOT NULL,
	PRIORIDADE VARCHAR(30) NOT NULL,
	COD_STATUS INT NOT NULL,
	STATUS VARCHAR(30) NOT NULL,
	COD_CATEGORIA INT NOT NULL,
	CATEGORIA VARCHAR(70) NOT NULL,
	COD_DEPARTAMENTO INT NOT NULL,
	DEPARTAMENTO VARCHAR(100) NOT NULL,
	COD_CAMPUS INT NOT NULL,
	CAMPUS VARCHAR(100) NOT NULL,
	COD_ORGAO_RESPONSAVEL INT NOT NULL,
	ORGAO_RESPONSAVEL VARCHAR(80) NOT NULL,
	COD_REQUISITOR INT NOT NULL,
	FUNCIONARIO_REQUISITOR VARCHAR(100) NOT NULL,
	COD_RESOLUTOR INT NULL,
	FUNCIONARIO_RESOLUTOR VARCHAR(100) NULL
)

/*ATRIBUTOS QUE FORAM ADICIONADOS: CAMPUS e COD_STATUS*/

CREATE TABLE TB_VIOLACAO_CHAMADO (
	ID_VIOLACAO INT IDENTITY(1,1) PRIMARY KEY,
	DATA_CARGA DATETIME NOT NULL,
	DATA_ERRO DATETIME NOT NULL,
	VIOLACAO VARCHAR(120) NOT NULL,
	DATA_ABERTURA DATETIME NOT NULL,
	DATA_FECHAMENTO DATETIME NULL,
	TITULO VARCHAR(100) NOT NULL,
	TIPO_SERVICO VARCHAR(50) NOT NULL,
	PRIORIDADE VARCHAR(30) NOT NULL,
	COD_STATUS INT NOT NULL,
	STATUS VARCHAR(30) NOT NULL,
	COD_CATEGORIA INT NOT NULL,
	CATEGORIA VARCHAR(70) NOT NULL,
	COD_DEPARTAMENTO INT NOT NULL,
	DEPARTAMENTO VARCHAR(100) NOT NULL,
	COD_CAMPUS INT NOT NULL,
	CAMPUS VARCHAR(100) NOT NULL,
	COD_ORGAO_RESPONSAVEL INT NOT NULL,
	ORGAO_RESPONSAVEL VARCHAR(80) NOT NULL,
	COD_REQUISITOR INT NOT NULL,
	FUNCIONARIO_REQUISITOR VARCHAR(100) NOT NULL,
	COD_RESOLUTOR INT NULL,
	FUNCIONARIO_RESOLUTOR VARCHAR(100) NULL
)
/*ATRIBUTOS QUE FORAM ADICIONADOS: CAMPUS e COD_STATUS*/

CREATE TABLE TB_AUX_FUNCIONARIO (
	DATA_CARGA DATETIME NOT NULL,
	COD_FUNCIONARIO INT NOT NULL,
	FUNCIONARIO VARCHAR(100) NOT NULL,
	COD_DEPARTAMENTO INT NULL,
	DEPARTAMENTO VARCHAR(100) NULL,  
	COD_ORGAO_RESPONSAVEL INT NULL,
	ORGAO_RESPONSAVEL VARCHAR(80) NULL,
	FUNCIONARIO_ORGAO_RESPONSAVEL VARCHAR(5) NOT NULL CHECK(FUNCIONARIO_ORGAO_RESPONSAVEL IN ('SIM','NAO')),
	COD_CAMPUS INT NOT NULL,
	CAMPUS VARCHAR(100) NOT NULL
)
/*O CÓDIGO DO DEPARTAMENTO, DEPARTAMENTO, COD_ORGAO_RESPONSAVEL E ORGAO_RESPONSAVEL PODEM SER NULOS
  POIS, O FUNCIONARIO PODE NÃO ESTAR EM NENHUM DEPARTAMENTO (CASO ELE SEJA RESOLUTOR)
  E PODE NÃO ESTAR EM NENHUM ORGÃO PÚBLICO (CASO ELE NÃO SEJA RESOLUTOR, OU SEJA, NÃO ESTEJA ASSOCIADO
  A NENHUM ÓRGÃO)*/

/*O ATRIBUTO FUNCIONARIO_ORGAO_RESPONSAVEL DIZ RESPEITO AO FUNCIONÁRIO TRABALHAR OU NÃO EM UM ÓRGÃO RESPONSÁVEL.
  LOGO, ELE TERÁ APENAS DOIS VALORES POSSÍVEIS (SIM OU NÃO)
  ESTE ATRIBUTO EQUIVALE AO ATRIBUTO "FUNCIONARIO_RESOLUTOR, PRESENTE NO PROJETO LÓGICO"*/

/* O ATRIBUTO CAMPUS FOI ADICIONADO */

CREATE TABLE TB_AUX_CAMPUS (
	DATA_CARGA DATETIME NOT NULL,
	COD_CAMPUS INT NOT NULL,
	CAMPUS VARCHAR(100) NOT NULL,
	CNPJ VARCHAR(20) NOT NULL,
	TELEFONE VARCHAR(20) NOT NULL,
	CIDADE VARCHAR(70) NOT NULL,
	BAIRRO VARCHAR(100) NOT NULL,
	RUA VARCHAR(100) NOT NULL,
	NUMERO VARCHAR(5) NULL
)

CREATE TABLE TB_AUX_DEPARTAMENTO (
	DATA_CARGA DATETIME NOT NULL,
	COD_DEPARTAMENTO INT NOT NULL,
	DEPARTAMENTO VARCHAR(100) NOT NULL,
	SIGLA VARCHAR(10) NOT NULL,
	DESCRICAO VARCHAR(150) NULL,
	COD_CAMPUS INT NOT NULL,
	CAMPUS VARCHAR(100) NOT NULL
)

CREATE TABLE TB_AUX_ORGAO_RESPONSAVEL (
	DATA_CARGA DATETIME NOT NULL,
	COD_ORGAO_RESPONSAVEL INT NOT NULL,
	ORGAO_RESPONSAVEL VARCHAR(100) NOT NULL,
	SIGLA VARCHAR(10) NOT NULL,
	COD_CAMPUS INT NOT NULL,
	CAMPUS VARCHAR(100) NOT NULL
)

CREATE TABLE TB_AUX_CATEGORIA (
	DATA_CARGA DATETIME NOT NULL,
	COD_CATEGORIA INT NOT NULL,
	CATEGORIA VARCHAR(100) NOT NULL
)

CREATE TABLE TB_AUX_STATUS (
	DATA_CARGA DATETIME NOT NULL,
	COD_STATUS INT NOT NULL,
	STATUS VARCHAR(100) NOT NULL
)



