CREATE DATABASE faculdade

USE faculdade

CREATE TABLE curso (
Codigo			INT,
Nome			VARCHAR(70)			NOT NULL,
Sigla			VARCHAR(10)			NOT NULL
PRIMARY KEY (Codigo)
)
GO

CREATE TABLE aluno(
Ra				CHAR(7)				NOT NULL,
Nome			VARCHAR(250)		NOT NULL,
Codigo_Curso	INT					NOT NULL
PRIMARY KEY (Ra)
FOREIGN KEY (Codigo_Curso) REFERENCES Curso (Codigo)
)
GO

CREATE TABLE palestrante(
Codigo_Palestrante			INT				IDENTITY(1,1),
Nome						VARCHAR(250)    NOT NULL,
Empresa						VARCHAR(100)	NOT NULL
PRIMARY KEY (Codigo_Palestrante)
)
GO

CREATE TABLE palestra(
Codigo_Palestra				INT				IDENTITY(1,1),
Titulo						VARCHAR(MAX)	NOT NULL,
Carga_Horaria				INT				NOT NULL,
Data						DATE			NOT NULL,
Codigo_Palestrante			INT				NOT NULL
PRIMARY KEY (Codigo_Palestra)
FOREIGN KEY (Codigo_Palestrante) REFERENCES palestrante (Codigo_Palestrante) 
)
GO

CREATE TABLE alunos_inscritos(
Ra					CHAR(7)			NOT NULL,
Codigo_Palestra		INT				NOT NULL
PRIMARY KEY (Ra, Codigo_Palestra)
FOREIGN KEY (Ra) REFERENCES aluno (Ra),
FOREIGN KEY	(Codigo_Palestra) REFERENCES palestra (Codigo_Palestra)
)
GO

CREATE TABLE nao_alunos(
RG			VARCHAR(9)			NOT NULL,
Orgao_Exp	CHAR(5)				NOT NULL,
Nome		VARCHAR(250)		NOT NULL
PRIMARY KEY (RG,Orgao_Exp)
)
GO

CREATE TABLE nao_alunos_inscritos(
Codigo_Palestra				INT			NOT NULL,
RG							VARCHAR(9)	NOT NULL,
Orgao_Exp					CHAR(5)		NOT NULL
PRIMARY KEY (Codigo_Palestra,RG,Orgao_Exp)
FOREIGN KEY (Codigo_Palestra) REFERENCES palestra (Codigo_Palestra),
FOREIGN KEY	(RG,Orgao_Exp) REFERENCES nao_alunos (RG,Orgao_Exp) 
)
GO


INSERT INTO curso (Codigo, Nome, Sigla) VALUES
(1, 'Engenharia da Computação', 'EC'),
(2, 'Administração de Empresas', 'ADM'),
(3, 'Direito', 'DIR'),
(4, 'Medicina', 'MED'),
(5, 'Psicologia', 'PSI');

INSERT INTO aluno (Ra, Nome, Codigo_Curso) VALUES
('1234567', 'João Silva', 1),
('2345678', 'Maria Santos', 2),
('3456789', 'Pedro Oliveira', 3),
('4567890', 'Ana Souza', 4),
('5678901', 'Carlos Ferreira', 5);

INSERT INTO palestrante (Nome, Empresa) VALUES
('Lucas Mendes', 'Tech Solutions'),
('Ana Costa', 'Data Insights Inc.'),
('Marcos Santos', 'InnovateX'),
('Carla Oliveira', 'FutureTech Co.'),
('Rafaela Pereira', 'AI Dynamics');

INSERT INTO palestra (Titulo, Carga_Horaria, Data, Codigo_Palestrante) VALUES
('Introdução à Inteligência Artificial', 2, '2024-03-10', 1),
('Gestão de Projetos Ágeis', 3, '2024-03-15', 2),
('Inovação e Tecnologia', 2, '2024-03-20', 3),
('Desenvolvimento de Carreira', 1, '2024-03-25', 4),
('Psicologia Organizacional', 2, '2024-03-30', 5);

INSERT INTO alunos_inscritos (Ra, Codigo_Palestra) VALUES
('1234567', 1),
('2345678', 2),
('3456789', 3),
('4567890', 4),
('5678901', 5);

INSERT INTO nao_alunos (RG, Orgao_Exp, Nome) VALUES
('123456789', 'SSP', 'José da Silva'),
('234567890', 'SESP', 'Mariana Oliveira'),
('345678901', 'SSP', 'Paulo Souza'),
('456789012', 'SESP', 'Luana Santos'),
('567890123', 'SSP', 'Mateus Ferreira');

INSERT INTO nao_alunos_inscritos (Codigo_Palestra, RG, Orgao_Exp) VALUES
(1, '123456789', 'SSP'),
(2, '234567890', 'SESP'),
(3, '345678901', 'SSP'),
(4, '456789012', 'SESP'),
(5, '567890123', 'SSP');

DROP VIEW  Lista_Presenca 

CREATE VIEW Lista_Presenca AS
SELECT
    a.Ra AS Num_Documento,
    a.Nome AS Nome_Pessoa,
    pa.Titulo AS Titulo_Palestra,
    pal.Nome AS Nome_Palestrante,
    pa.Carga_Horaria,
    pa.Data,
	'Aluno' AS Tipo_Aluno
FROM
    alunos_inscritos ai JOIN aluno a ON ai.Ra = a.Ra
 JOIN palestra pa 
  ON ai.Codigo_Palestra = pa.Codigo_Palestra
JOIN palestrante pal 
 ON pa.Codigo_Palestrante = pal.Codigo_Palestrante
UNION ALL
SELECT
    CONCAT(na.RG, ' - ', na.Orgao_Exp) AS Num_Documento,
    na.Nome AS Nome_Pessoa,
    pa.Titulo AS Titulo_Palestra,
    pal.Nome AS Nome_Palestrante,
    pa.Carga_Horaria,
    pa.Data,
	'Não Aluno' AS Tipo_Aluno
FROM
    nao_alunos_inscritos nai JOIN nao_alunos na 
	 ON nai.RG = na.RG AND nai.Orgao_Exp = na.Orgao_Exp
 JOIN palestra pa 
  ON nai.Codigo_Palestra = pa.Codigo_Palestra
JOIN palestrante pal 
 ON pa.Codigo_Palestrante = pal.Codigo_Palestrante

SELECT * FROM Lista_Presenca
 ORDER BY Nome_Pessoa;





