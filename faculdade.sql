/*Uma empresa tem clientes, fornecedores e funcionários.
Um problema da empresa é gerar uma única agenda com todos os contatos (fornecedores e clientes) (Camada de controle já deve receber pronta)
Outro problema é filtrar as informações de funcionários para que dados sensíveis sejam visíveis apenas nas camadas do software que devem aparecer:
- Salário apenas para RH
- login e senha apenas para TI
- Id e Nome são comuns a todas as camadas do sistema
*/
 
CREATE DATABASE unionview2
GO
USE unionview2
GO
CREATE TABLE cliente(
	id_cliente 		INT		NOT NULL,
	nome_cliente 		VARCHAR(40) 	NOT NULL,
	email_cliente 		VARCHAR(50) 	NOT NULL,
	telefone_cliente 	CHAR(11) 	NOT NULL
	PRIMARY KEY (id_cliente)
)
GO
CREATE TABLE fornecedor(
	id_fornecedor 		INT		NOT NULL,
	nome_fornecedor 	VARCHAR(40) 	NOT NULL,
	email_fornecedor 	VARCHAR(50) 	NOT NULL,
	telefone_fornecedor 	CHAR(11) 	NOT NULL
	PRIMARY KEY (id_fornecedor)
)
GO
CREATE TABLE funcionario(
	id_func 	INT		NOT NULL,
	nome_func 	VARCHAR(100) 	NOT NULL,
	salario_func 	DECIMAL(7, 2) 	NULL,
	login_func 	CHAR(8) 	NULL,
	senha_func 	CHAR(8) 	NULL
	PRIMARY KEY (id_func)
)
 
INSERT INTO cliente VALUES 
(1001,	'Quote Voamo',	'quo@email.com',	'11987654321'),
(1002,	'Arvane Woxao',	'arv@email.com',	'11912837465'),
(1003,	'Sokay Puygu',	'sok@email.com',	'11932569874'),
(1004,	'Leaga Gaur',	'lea@email.com',	'11912458632'),
(1005,	'Laoxo Uses',	'lao@email.com',	'11902365400')
GO
INSERT INTO fornecedor VALUES
(1001,	'Nitour',	'nitour@email.com',	'11977889966'),
(1002,	'Buroze',	'buroze@email.com',	'11933669988'),
(1003,	'Hiluy',	'hiluy@email.com',	'11911220044'),
(1004,	'Orde',		'orde@email.com',	'11933654477'),
(1005,	'Ciagoa',	'ciagoa@email.com',	'11933001177')
GO
SELECT * FROM cliente
SELECT * FROM fornecedor
SELECT * FROM funcionario

SELECT id_cliente AS id, nome_cliente AS nome, 
	email_cliente AS email, telefone_cliente AS telefone,
	'CLIENTE' AS tipo
FROM cliente
UNION ALL --UNION remove duplicidades | UNION ALL apresenta todas as linhas
SELECT id_fornecedor AS id, nome_fornecedor AS nome, 
	email_fornecedor AS email, telefone_fornecedor AS telefone,
	'FORNECEDOR' AS tipo
FROM fornecedor
ORDER BY id
 
/* VIEW - VISÃO / EXIBIÇÃO
DDL - CREATE (ALTER | DROP) VIEW v_nome
*/
CREATE VIEW v_agenda
AS
SELECT id_cliente AS id, nome_cliente AS nome, 
	email_cliente AS email, telefone_cliente AS telefone,
	'CLIENTE' AS tipo
FROM cliente
UNION --UNION remove duplicidades | UNION ALL apresenta todas as linhas
SELECT id_fornecedor AS id, nome_fornecedor AS nome, 
	email_fornecedor AS email, telefone_fornecedor AS telefone,
	'FORNECEDOR' AS tipo
FROM fornecedor
 
SELECT * FROM v_agenda
ORDER BY id
 
CREATE VIEW v_ti
AS
SELECT id_func, nome_func, login_func, senha_func
FROM funcionario
 
CREATE VIEW v_rh
AS
SELECT id_func, nome_func, salario_func
FROM funcionario
 
SELECT * FROM v_ti
SELECT * FROM v_rh
 
INSERT INTO v_ti VALUES
(100001, 'Fulano', 'ful@emp', '123mudar')
 
INSERT INTO v_rh VALUES
(100001, 'Fulano', 5000.00) --Violação de FK
 
UPDATE v_rh
SET salario_func = 5000.00
WHERE id_func = 100001