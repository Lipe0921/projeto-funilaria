-- =====================================================================
-- Projeto ERP - Prime Funilaria (Grupo 04)
-- Script 03: testes de integridade, DML controlado e consultas
-- Execute apos os scripts 01 e 02. Rode CADA teste invalido separadamente:
-- o SGBD deve rejeitar todos (se algum for aceito, a constraint falhou).
-- =====================================================================
USE prime_funilaria;

-- ===== PARTE 1: tentativas INVALIDAS (todas devem gerar erro) =====
-- T01 [PK duplicada] Identidade unica do cliente (PRIMARY KEY) -> PK deve rejeitar
INSERT INTO cliente (id_cliente, nome, cpf_cnpj) VALUES (1, 'Outro Cliente', '99988877766');

-- T02 [FK invalida] RN02 - todo veiculo pertence a um cliente existente -> FK deve rejeitar
INSERT INTO veiculo (id_cliente, placa, chassi, marca, modelo) VALUES (9999, 'ZZZ9Z99', '9BWZZZ377VT999999', 'Fiat', 'Uno');

-- T03 [UNIQUE] RN29 - CPF/CNPJ do cliente nao pode se repetir -> UNIQUE deve rejeitar
INSERT INTO cliente (nome, cpf_cnpj) VALUES ('Cliente Duplicado', '11122233344');

-- T04 [NOT NULL] Nome do cliente e obrigatorio -> NOT NULL deve rejeitar
INSERT INTO cliente (nome, cpf_cnpj) VALUES (NULL, '77788899900');

-- T05 [CHECK] RN25 - estoque da peca nao pode ser negativo -> CHECK deve rejeitar
INSERT INTO peca (descricao, preco_unitario, estoque) VALUES ('Peca de teste', 100.00, -5);

-- T06 [CHECK] RN24 - quantidade do item deve ser maior que zero -> CHECK deve rejeitar
INSERT INTO item_orcamento (id_orcamento, id_servico, quantidade, valor_unitario) VALUES (2, 3, 0, 350.00);

-- T07 [Regra do ERP (RN13)] RN13 - item e servico OU peca, nunca os dois -> CHECK de exclusividade deve rejeitar
INSERT INTO item_orcamento (id_orcamento, id_servico, id_peca, quantidade, valor_unitario) VALUES (2, 3, 2, 1, 350.00);

-- T08 [Regra do ERP (RN13)] RN13 - item nao pode ficar sem servico e sem peca -> CHECK de exclusividade deve rejeitar
INSERT INTO item_orcamento (id_orcamento, quantidade, valor_unitario) VALUES (2, 1, 100.00);

-- T09 [UNIQUE (1:1)] RN07 - cada OS gera no maximo um orcamento -> UNIQUE em id_os deve rejeitar
INSERT INTO orcamento (id_os, data_orcamento, validade) VALUES (1, '2026-10-22', '2026-10-29');

-- T10 [UNIQUE (1:1)] RN14 - cada orcamento possui no maximo um pagamento -> UNIQUE em id_orcamento deve rejeitar
INSERT INTO pagamento (id_orcamento, data_pagamento, valor, forma_pagamento) VALUES (1, '2026-10-23 10:00:00', 100.00, 'PIX');

-- T11 [PK composta] RN16/RN17 - o par fornecedor/peca nao se repete -> PK composta deve rejeitar
INSERT INTO fornecedor_peca (id_fornecedor, id_peca, preco_compra, data_atualizacao) VALUES (1, 1, 470.00, '2026-11-01');

-- T12 [CHECK] RN26 - status da OS restrito a aberta/em andamento/concluida -> CHECK deve rejeitar
UPDATE ordem_servico SET status = 'CANCELADA' WHERE id_os = 4;

-- T13 [CHECK] Validade do orcamento nao pode ser anterior a data de criacao -> CHECK deve rejeitar
INSERT INTO orcamento (id_os, data_orcamento, validade) VALUES (4, '2026-11-03', '2026-11-01');

-- T14 [CHECK (baixa de estoque)] RN25/RN30 - baixa maior que o estoque disponivel -> CHECK deve rejeitar
UPDATE peca SET estoque = estoque - 10 WHERE id_peca = 2;

-- T15 [FK em DELETE] RN02 - cliente com veiculos/ordens nao pode ser excluido -> FK deve rejeitar
DELETE FROM cliente WHERE id_cliente = 1;

-- ===== PARTE 2: UPDATE e DELETE validos e controlados =====
-- U1 [UPDATE] RN27 - cliente aprova o orcamento pendente dentro da validade
UPDATE orcamento SET status = 'APROVADO' WHERE id_orcamento = 2 AND status = 'PENDENTE';

-- U2 [UPDATE] RN30 - baixa de estoque das pecas do orcamento aprovado (com saldo suficiente)
UPDATE peca SET estoque = estoque - 1 WHERE id_peca = 2 AND estoque >= 1;

-- U3 [UPDATE] RN26 - OS passa a em andamento quando o orcamento e aprovado
UPDATE ordem_servico SET status = 'EM_ANDAMENTO' WHERE id_os = 2;

-- D1 [DELETE] DELETE controlado (com WHERE): remove o item de um orcamento expirado
DELETE FROM item_orcamento WHERE id_item = 6;

-- ===== PARTE 3: SELECT para comprovar os efeitos =====
-- S1 OS com cliente solicitante, proprietario do veiculo e funcionario responsavel
SELECT os.id_os, sol.nome AS solicitante, prop.nome AS proprietario, v.placa, f.nome AS responsavel, os.status FROM ordem_servico os JOIN cliente sol ON sol.id_cliente = os.id_cliente JOIN veiculo v ON v.id_veiculo = os.id_veiculo JOIN cliente prop ON prop.id_cliente = v.id_cliente JOIN funcionario f ON f.id_funcionario = os.id_funcionario ORDER BY os.id_os;

-- S2 Total de cada orcamento (derivado) e situacao do pagamento
SELECT t.id_orcamento, t.status AS status_orcamento, t.valor_total, p.valor AS valor_pago, p.status AS status_pagamento FROM vw_orcamento_total t LEFT JOIN pagamento p ON p.id_orcamento = t.id_orcamento ORDER BY t.id_orcamento;

-- S3 Comparacao de precos de compra por peca e fornecedor (N:N com atributos)
SELECT pe.descricao AS peca, fo.nome AS fornecedor, fp.preco_compra, fp.data_atualizacao FROM fornecedor_peca fp JOIN peca pe ON pe.id_peca = fp.id_peca JOIN fornecedor fo ON fo.id_fornecedor = fp.id_fornecedor ORDER BY pe.descricao, fp.preco_compra;

-- S4 Estoque atual das pecas apos a baixa (RN30)
SELECT id_peca, descricao, estoque FROM peca ORDER BY id_peca;
