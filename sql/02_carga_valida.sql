-- =====================================================================
-- Projeto ERP - Prime Funilaria (Grupo 04)
-- Script 02: carga de dados validos (dados ficticios)
-- Ordem: primeiro os registros pais, depois os dependentes.
-- =====================================================================
USE prime_funilaria;

INSERT INTO cliente (id_cliente, nome, cpf_cnpj, telefone) VALUES
(1, 'Carlos Pereira',        '11122233344',    '11990000001'),
(2, 'Marina Duarte',         '22233344455',    '11990000002'),
(3, 'Transportes Alfa Ltda', '12345678000199', '1133330003'),
(4, 'Rogerio Matos',         '33344455566',    NULL);

INSERT INTO veiculo (id_veiculo, id_cliente, placa, chassi, marca, modelo, cor, ano) VALUES
(1, 1, 'ABC1D23', '9BWZZZ377VT004251', 'Volkswagen', 'Gol',    'Prata', 2018),
(2, 2, 'EFG4H56', '9BD15822A52123456', 'Fiat',       'Palio', 'Branco', 2015),
(3, 3, 'IJK7L89', '93YLSR7UH9J123456', 'Renault',    'Master', NULL,     NULL),
(4, 1, 'MNO0P12', '9BGKS48U0LG123456', 'Chevrolet', 'Onix',    'Preto', 2020);

INSERT INTO funcionario (id_funcionario, nome, cpf, cargo, telefone, data_contratacao) VALUES
(1, 'Anderson Lopes', '44455566677', 'Funileiro',    '11990000010', '2022-03-01'),
(2, 'Beatriz Nunes',   '55566677788', 'Atendente',   NULL,          '2023-08-15'),
(3, 'Cesar Ribeiro',   '66677788899', 'Orcamentista','11990000012', '2021-05-10');

INSERT INTO servico (id_servico, descricao, valor_padrao, tempo_padrao_horas, ativo) VALUES
(1, 'Reparo de lataria (para-choque)', 900.00, 8.00, 1),
(2, 'Pintura completa de peca',        1200.00, 12.00, 1),
(3, 'Polimento tecnico',               350.00, NULL, 1);

INSERT INTO peca (id_peca, descricao, preco_unitario, estoque, ativo) VALUES
(1, 'Para-choque dianteiro Gol', 650.00, 3, 1),
(2, 'Farol dianteiro Palio',      480.00, 2, 1),
(3, 'Retrovisor externo Onix',    210.00, 0, 1),
(4, 'Grade frontal Master',       390.00, 1, 1);

INSERT INTO fornecedor (id_fornecedor, nome, cnpj, endereco, telefone, email) VALUES
(1, 'AutoPecas Central', '11222333000144', 'Rua das Pecas, 100', '1144440001', 'vendas@autopecascentral.exemplo'),
(2, 'Distribuidora Sul', '22333444000155', NULL,                  '1144440002', NULL),
(3, 'Pecas Express',      '33444555000166', 'Av. Industrial, 500', NULL, 'contato@pecasexpress.exemplo');

-- N:N com atributos proprios: mesma peca com precos diferentes por fornecedor (RN18)
INSERT INTO fornecedor_peca (id_fornecedor, id_peca, preco_compra, data_atualizacao) VALUES
(1, 1, 480.00, '2026-10-01'),
(2, 1, 455.00, '2026-10-05'),
(1, 2, 350.00, '2026-10-01'),
(3, 3, 140.00, '2026-10-10'),
(3, 4, 280.00, '2026-10-12'),
(2, 4, 295.00, '2026-10-08');

INSERT INTO ordem_servico (id_os, id_cliente, id_veiculo, id_funcionario, data_abertura, descricao_problema, previsao_entrega, status) VALUES
(1, 1, 1, 1, '2026-10-20 09:30:00', 'Para-choque dianteiro amassado apos colisao leve', '2026-10-30', 'EM_ANDAMENTO'),
(2, 2, 2, 2, '2026-10-25 14:00:00', 'Farol quebrado e arranhao na lateral',            NULL, 'ABERTA'),
(3, 3, 3, 3, '2026-10-02 10:15:00', 'Grade frontal danificada',                          '2026-10-15', 'ABERTA'),
(4, 4, 4, 2, '2026-11-03 08:45:00', 'Retrovisor trincado',                               NULL, 'ABERTA');
-- OS 4: cliente solicitante (4) e diferente do proprietario do veiculo (1) - RN23

INSERT INTO orcamento (id_orcamento, id_os, data_orcamento, validade, status) VALUES
(1, 1, '2026-10-21', '2026-10-28', 'APROVADO'),
(2, 2, '2026-10-26', '2026-11-10', 'PENDENTE'),
(3, 3, '2026-10-03', '2026-10-10', 'EXPIRADO');

INSERT INTO item_orcamento (id_item, id_orcamento, id_servico, id_peca, quantidade, valor_unitario) VALUES
(1, 1, 1,    NULL, 1, 900.00),
(2, 1, 2,    NULL, 1, 1200.00),
(3, 1, NULL, 1,    1, 650.00),
(4, 2, NULL, 2,    1, 480.00),
(5, 2, 3,    NULL, 1, 350.00),
(6, 3, NULL, 4,    1, 390.00),
(7, 3, 1,    NULL, 1, 900.00);

INSERT INTO pagamento (id_pagamento, id_orcamento, data_pagamento, valor, forma_pagamento, status) VALUES
(1, 1, '2026-10-22 16:20:00', 2750.00, 'PIX', 'CONFIRMADO');
