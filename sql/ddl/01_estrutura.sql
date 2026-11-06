-- =====================================================================
-- Projeto ERP - Prime Funilaria (Grupo 04)
-- Script 01: estrutura (DDL) - modelo logico implementado
-- SGBD: MySQL 8.0.16+ / MariaDB 10.2+ (InnoDB)
-- Fio condutor: REGRA DE NEGOCIO -> MODELO LOGICO -> RESTRICAO -> DDL -> TESTE
-- =====================================================================

DROP DATABASE IF EXISTS prime_funilaria;
CREATE DATABASE prime_funilaria CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE prime_funilaria;

-- ---------------------------------------------------------------------
-- Tabelas independentes (nao possuem FK)
-- ---------------------------------------------------------------------

-- RN29: CPF/CNPJ nao se repete (UNIQUE). Armazenado so com digitos (11 ou 14).
CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome         VARCHAR(100) NOT NULL,
    cpf_cnpj     VARCHAR(14) NOT NULL,
    telefone     VARCHAR(20) NULL,
    CONSTRAINT uq_cliente_cpf_cnpj UNIQUE (cpf_cnpj),
    CONSTRAINT ck_cliente_cpf_cnpj CHECK (CHAR_LENGTH(cpf_cnpj) IN (11, 14))
) ENGINE=InnoDB;

-- RN29: CPF do funcionario nao se repete.
CREATE TABLE funcionario (
    id_funcionario   INT AUTO_INCREMENT PRIMARY KEY,
    nome             VARCHAR(100) NOT NULL,
    cpf              CHAR(11)     NOT NULL,
    cargo            VARCHAR(50) NOT NULL,
    telefone         VARCHAR(20) NULL,
    data_contratacao DATE         NOT NULL,
    CONSTRAINT uq_funcionario_cpf UNIQUE (cpf),
    CONSTRAINT ck_funcionario_cpf CHECK (CHAR_LENGTH(cpf) = 11)
) ENGINE=InnoDB;

-- RN20: ativo/inativo em vez de exclusao (preserva historico de orcamentos).
CREATE TABLE servico (
    id_servico         INT AUTO_INCREMENT PRIMARY KEY,
    descricao          VARCHAR(150) NOT NULL,
    valor_padrao       DECIMAL(10,2) NOT NULL,
    tempo_padrao_horas DECIMAL(5,2) NULL,
    ativo              TINYINT(1)    NOT NULL DEFAULT 1,
    CONSTRAINT ck_servico_valor CHECK (valor_padrao >= 0),
    CONSTRAINT ck_servico_tempo CHECK (tempo_padrao_horas IS NULL OR tempo_padrao_horas > 0),
    CONSTRAINT ck_servico_ativo CHECK (ativo IN (0, 1))
) ENGINE=InnoDB;

-- RN19/RN25: toda peca tem estoque registrado e ele nunca fica negativo.
CREATE TABLE peca (
    id_peca         INT AUTO_INCREMENT PRIMARY KEY,
    descricao       VARCHAR(150) NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    estoque         INT           NOT NULL DEFAULT 0,
    ativo           TINYINT(1)    NOT NULL DEFAULT 1,
    CONSTRAINT ck_peca_preco    CHECK (preco_unitario >= 0),
    CONSTRAINT ck_peca_estoque CHECK (estoque >= 0),
    CONSTRAINT ck_peca_ativo    CHECK (ativo IN (0, 1))
) ENGINE=InnoDB;

-- RN29: CNPJ do fornecedor nao se repete.
CREATE TABLE fornecedor (
    id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
    nome          VARCHAR(100) NOT NULL,
    cnpj          CHAR(14)     NOT NULL,
    endereco      VARCHAR(200) NULL,
    telefone      VARCHAR(20) NULL,
    email         VARCHAR(100) NULL,
    CONSTRAINT uq_fornecedor_cnpj UNIQUE (cnpj),
    CONSTRAINT ck_fornecedor_cnpj CHECK (CHAR_LENGTH(cnpj) = 14)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Tabelas dependentes
-- ---------------------------------------------------------------------

-- RN01/RN02: cliente (0,N) - veiculo (1,1) => id_cliente NOT NULL.
-- RN29: placa e chassi nao se repetem.
CREATE TABLE veiculo (
    id_veiculo INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT         NOT NULL,
    placa      VARCHAR(8) NOT NULL,
    chassi     CHAR(17)    NOT NULL,
    marca      VARCHAR(50) NOT NULL,
    modelo     VARCHAR(60) NOT NULL,
    cor        VARCHAR(30) NULL,
    ano        SMALLINT    NULL,
    CONSTRAINT fk_veiculo_cliente FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente),
    CONSTRAINT uq_veiculo_placa UNIQUE (placa),
    CONSTRAINT uq_veiculo_chassi UNIQUE (chassi),
    CONSTRAINT ck_veiculo_chassi CHECK (CHAR_LENGTH(chassi) = 17),
    CONSTRAINT ck_veiculo_ano    CHECK (ano IS NULL OR ano BETWEEN 1900 AND 2100)
) ENGINE=InnoDB;

-- RN04/RN06/RN23: toda OS tem exatamente um veiculo, um funcionario responsavel
-- e um cliente solicitante (que pode ser diferente do proprietario do veiculo).
-- RN26: status aberta, em andamento ou concluida (nasce aberta).
CREATE TABLE ordem_servico (
    id_os              INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente         INT          NOT NULL,
    id_veiculo         INT          NOT NULL,
    id_funcionario     INT          NOT NULL,
    data_abertura      DATETIME     NOT NULL,
    descricao_problema VARCHAR(500) NOT NULL,
    previsao_entrega   DATE         NULL,
    status             VARCHAR(20) NOT NULL DEFAULT 'ABERTA',
    CONSTRAINT fk_os_cliente     FOREIGN KEY (id_cliente)     REFERENCES cliente (id_cliente),
    CONSTRAINT fk_os_veiculo     FOREIGN KEY (id_veiculo)     REFERENCES veiculo (id_veiculo),
    CONSTRAINT fk_os_funcionario FOREIGN KEY (id_funcionario) REFERENCES funcionario (id_funcionario),
    CONSTRAINT ck_os_status CHECK (status IN ('ABERTA', 'EM_ANDAMENTO', 'CONCLUIDA'))
) ENGINE=InnoDB;

-- RN07/RN08: OS (0,1) - orcamento (1,1) => id_os NOT NULL + UNIQUE (1:1).
-- RN27: status pendente, aprovado ou expirado (nasce pendente).
-- valor_total e DERIVADO (soma dos itens): nao e armazenado, ver vw_orcamento_total.
CREATE TABLE orcamento (
    id_orcamento   INT AUTO_INCREMENT PRIMARY KEY,
    id_os          INT         NOT NULL,
    data_orcamento DATE        NOT NULL,
    validade       DATE        NOT NULL,
    status         VARCHAR(20) NOT NULL DEFAULT 'PENDENTE',
    CONSTRAINT fk_orcamento_os FOREIGN KEY (id_os) REFERENCES ordem_servico (id_os),
    CONSTRAINT uq_orcamento_os UNIQUE (id_os),
    CONSTRAINT ck_orcamento_status   CHECK (status IN ('PENDENTE', 'APROVADO', 'EXPIRADO')),
    CONSTRAINT ck_orcamento_validade CHECK (validade >= data_orcamento)
) ENGINE=InnoDB;

-- ITEM_ORCAMENTO depende existencialmente do orcamento (cupom fiscal: a linha
-- perde o sentido sem o cabecalho). id_item e chave substituta (conveniencia
-- tecnica); a dependencia e imposta por id_orcamento NOT NULL + FK.
-- RN13: exatamente um entre servico e peca (CHECK de exclusividade).
-- RN21: valor_unitario e gravado no item (congela o preco). RN24: quantidade > 0.
-- valor_total do item e DERIVADO (quantidade x valor_unitario): ver vw_item_orcamento.
CREATE TABLE item_orcamento (
    id_item         INT AUTO_INCREMENT PRIMARY KEY,
    id_orcamento    INT           NOT NULL,
    id_servico      INT           NULL,
    id_peca         INT           NULL,
    quantidade      INT           NOT NULL,
    valor_unitario DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_item_orcamento FOREIGN KEY (id_orcamento) REFERENCES orcamento (id_orcamento) ON DELETE CASCADE,
    CONSTRAINT fk_item_servico    FOREIGN KEY (id_servico)   REFERENCES servico (id_servico),
    CONSTRAINT fk_item_peca       FOREIGN KEY (id_peca)      REFERENCES peca (id_peca),
    CONSTRAINT ck_item_quantidade CHECK (quantidade > 0),
    CONSTRAINT ck_item_valor       CHECK (valor_unitario >= 0),
    CONSTRAINT ck_item_servico_ou_peca CHECK (
         (id_servico IS NOT NULL AND id_peca IS NULL) OR
         (id_servico IS NULL AND id_peca IS NOT NULL))
) ENGINE=InnoDB;

-- N:N fornecedor x peca resolvido por tabela associativa.
-- PK composta (id_fornecedor, id_peca): o par nao se repete (RN16/RN17).
-- preco_compra e data_atualizacao pertencem ao fornecimento (RN18).
CREATE TABLE fornecedor_peca (
    id_fornecedor    INT           NOT NULL,
    id_peca          INT           NOT NULL,
    preco_compra     DECIMAL(10,2) NOT NULL,
    data_atualizacao DATE          NOT NULL,
    CONSTRAINT pk_fornecedor_peca PRIMARY KEY (id_fornecedor, id_peca),
    CONSTRAINT fk_fp_fornecedor FOREIGN KEY (id_fornecedor) REFERENCES fornecedor (id_fornecedor),
    CONSTRAINT fk_fp_peca       FOREIGN KEY (id_peca)       REFERENCES peca (id_peca),
    CONSTRAINT ck_fp_preco CHECK (preco_compra >= 0)
) ENGINE=InnoDB;

-- RN14/RN15: orcamento (0,1) - pagamento (1,1) => id_orcamento NOT NULL + UNIQUE (1:1).
-- RN28: forma dinheiro/cartao/PIX; status pendente/confirmado.
CREATE TABLE pagamento (
    id_pagamento    INT AUTO_INCREMENT PRIMARY KEY,
    id_orcamento    INT           NOT NULL,
    data_pagamento DATETIME       NOT NULL,
    valor           DECIMAL(10,2) NOT NULL,
    forma_pagamento VARCHAR(10)   NOT NULL,
    status          VARCHAR(10)   NOT NULL DEFAULT 'PENDENTE',
    CONSTRAINT fk_pagamento_orcamento FOREIGN KEY (id_orcamento) REFERENCES orcamento (id_orcamento),
    CONSTRAINT uq_pagamento_orcamento UNIQUE (id_orcamento),
    CONSTRAINT ck_pagamento_valor CHECK (valor > 0),
    CONSTRAINT ck_pagamento_forma CHECK (forma_pagamento IN ('DINHEIRO', 'CARTAO', 'PIX')),
    CONSTRAINT ck_pagamento_status CHECK (status IN ('PENDENTE', 'CONFIRMADO'))
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Atributos derivados (calculados na consulta; evitam redundancia - 3FN)
-- ---------------------------------------------------------------------
CREATE VIEW vw_item_orcamento AS
SELECT id_item, id_orcamento, id_servico, id_peca, quantidade, valor_unitario,
       quantidade * valor_unitario AS valor_total
FROM item_orcamento;

CREATE VIEW vw_orcamento_total AS
SELECT o.id_orcamento, o.id_os, o.status,
       COALESCE(SUM(i.quantidade * i.valor_unitario), 0) AS valor_total
FROM orcamento o
LEFT JOIN item_orcamento i ON i.id_orcamento = o.id_orcamento
GROUP BY o.id_orcamento, o.id_os, o.status;

-- ---------------------------------------------------------------------
-- Regras que NAO cabem em constraint simples (documentadas, aplicacao/SGBD):
-- RN27 (transicao e expiracao de status), RN30 (baixa de estoque na aprovacao,
-- so com quantidade suficiente), RN31 (entrada de pecas soma ao estoque),
-- RN32 (pagamento somente de orcamento aprovado e igual ao total).
-- ---------------------------------------------------------------------
