USE PROJETO_SAD

CREATE TABLE DIM_TEMPO(
	ID_TEMPO INT PRIMARY KEY NOT NULL,
	DATA DATETIME,
	DIA INT,
	NM__DIA VARCHAR(25),
	MES INT,
	NM__MES VARCHAR(20),
	SEMESTRE INT,
	NM__SEMESTRE VARCHAR(45),
	TIMESTRE INT,
	NM_TRIMESTRE VARCHAR(45),
	ANO INT NOT NULL
)

CREATE TABLE DIM_DEPARTAMENTO(
	ID_DEPARTAMENTO INT PRIMARY KEY NOT NULL,
	COD_DEPARTAMENTO INT NOT NULL,
	NM_DEPARTAMENTO VARCHAR(80) NOT NULL,
	SIGLA VARCHAR(10) NOT NULL
)

CREATE TABLE DIM_ORGAO_RESPONSAVEL(
	ID_ORGAO_RESPONSAVEL INT PRIMARY KEY NOT NULL,
	COD_ORGAO_RESPONSAVEL INT NOT NULL,
	NM_ORGAO_RESPONSAVEL VARCHAR(80) NOT NULL,
	SIGLA VARCHAR(10) NOT NULL
)

CREATE TABLE DIM_CATEGORIA (
	ID_CATEGORIA INT PRIMARY KEY NOT NULL,
	COD_CATEGORIA INT NOT NULL,
	NM_CATEGORIA VARCHAR(45) NOT NULL
)
CREATE TABLE DIM_STATUS (
	ID_STATUS INT PRIMARY KEY NOT NULL,
	COD_STATUS INT NOT NULL,
	NM_STATUS VARCHAR(45) NOT NULL
)
CREATE TABLE DIM_CAMPUS (
	ID_CAMPUS INT PRIMARY KEY NOT NULL,
	COD_CAMPUS INT NOT NULL,
	NM_CAMPUS VARCHAR(80) NOT NULL,
	COD_ENDERECO INT NOT NULL
)
CREATE TABLE DIM_FUNCIONARIO (
	ID_FUNCIONARIO INT PRIMARY KEY NOT NULL,
	COD_FUNCIONARIO INT NOT NULL,
	NM_FUNCIONARIO VARCHAR(80) NOT NULL
)

CREATE TABLE FATO_CHAMADA(
	ID INT PRIMARY KEY NOT NULL,
	QUANTIDADE INT,
	TEMPO_ABERTURA_ANDAMENTO INT,
	TEMPO_ABERTURA_FECHAMENTO INT,

	ID_CAMPUS INT FOREIGN KEY REFERENCES DIM_CAMPUS(ID_CAMPUS) NOT NULL,
	ID_ORGAO_RESPONSAVEL INT FOREIGN KEY REFERENCES DIM_ORGAO_RESPONSAVEL(ID_ORGAO_RESPONSAVEL) NOT NULL,
	ID_DEPARTAMENTO INT FOREIGN KEY REFERENCES DIM_DEPARTAMENTO(ID_DEPARTAMENTO) NOT NULL,

	ID_CATEGORIA INT FOREIGN KEY REFERENCES DIM_CATEGORIA(ID_CATEGORIA) NOT NULL,
	ID_STATUS INT FOREIGN KEY REFERENCES DIM_STATUS(ID_STATUS) NOT NULL,

	ID_FUNCIONARIO INT FOREIGN KEY REFERENCES DIM_FUNCIONARIO(ID_FUNCIONARIO) NOT NULL,
	ID_FUNCIONARIO_ORGAO_RESPONSAVEL INT FOREIGN KEY REFERENCES DIM_FUNCIONARIO(ID_FUNCIONARIO),

	DATA_ABERTURA INT FOREIGN KEY REFERENCES DIM_TEMPO(ID_TEMPO) NOT NULL,
	DATA_FECHAMENTO INT FOREIGN KEY REFERENCES DIM_TEMPO(ID_TEMPO),
	DATA_ANDAMENTO INT FOREIGN KEY REFERENCES DIM_TEMPO(ID_TEMPO) NOT NULL,
)
