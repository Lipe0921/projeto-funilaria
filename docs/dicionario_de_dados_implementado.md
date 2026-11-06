# Dicionário de Dados — Modelo Implementado (MariaDB)

Projeto ERP — Prime Funilaria · Grupo 04 · Modelagem de Dados

Gerado automaticamente a partir do `information_schema` do banco `prime_funilaria` (MariaDB 10.11.14), criado por `sql/ddl/01_estrutura.sql`, em 2026-11-06. Por ser gerado do próprio banco, este dicionário representa a estrutura efetivamente implementada (manual, etapa 13).

Legenda: **PK** chave primária · **FK** chave estrangeira (com a tabela/coluna referenciada) · **NULL** permite nulo (`Sim`/`Não`) · **UNIQUE** valor não repetível · **DEFAULT** valor padrão · **Regra/Restrição** nome da constraint de CHECK ou UNIQUE no banco, com a regra de negócio correspondente no README.

Observação: `id_item`, `id_orcamento` etc. em `ITEM_ORCAMENTO` são colunas técnicas do modelo lógico; a descrição de cada atributo segue o dicionário conceitual (`docs/dicionario_de_dados_conceitual.md`).

## cliente

| Atributo | Descrição | Tipo | Tamanho | PK | FK | NULL | UNIQUE | DEFAULT | Regra/Restrição |
|---|---|---|---|---|---|---|---|---|---|
| `id_cliente` | Identificador único do cliente | INT | 11 (INT) | Sim | Não | Não | Não | - | - |
| `nome` | Nome completo ou razão social | VARCHAR | 100 | Não | Não | Não | Não | - | - |
| `cpf_cnpj` | CPF ou CNPJ do cliente | VARCHAR | 14 | Não | Não | Não | Sim | - | ck_cliente_cpf_cnpj, uq_cliente_cpf_cnpj |
| `telefone` | Telefone de contato | VARCHAR | 20 | Não | Não | Sim | Não | NULL | - |

## veiculo

| Atributo | Descrição | Tipo | Tamanho | PK | FK | NULL | UNIQUE | DEFAULT | Regra/Restrição |
|---|---|---|---|---|---|---|---|---|---|
| `id_veiculo` | Identificador do veículo | INT | 11 (INT) | Sim | Não | Não | Não | - | - |
| `id_cliente` | Chave estrangeira: referencia cliente.id_cliente | INT | 11 (INT) | Não | Sim → cliente.id_cliente | Não | Não | - | - |
| `placa` | Placa do veículo | VARCHAR | 8 | Não | Não | Não | Sim | - | uq_veiculo_placa |
| `chassi` | Número do chassi | CHAR | 17 | Não | Não | Não | Sim | - | ck_veiculo_chassi, uq_veiculo_chassi |
| `marca` | Fabricante do veículo | VARCHAR | 50 | Não | Não | Não | Não | - | - |
| `modelo` | Modelo do veículo | VARCHAR | 60 | Não | Não | Não | Não | - | - |
| `cor` | Cor do veículo | VARCHAR | 30 | Não | Não | Sim | Não | NULL | - |
| `ano` | Ano do veículo (fabricação ou modelo, conforme o documento do veículo) | SMALLINT | 6 | Não | Não | Sim | Não | NULL | ck_veiculo_ano |

## funcionario

| Atributo | Descrição | Tipo | Tamanho | PK | FK | NULL | UNIQUE | DEFAULT | Regra/Restrição |
|---|---|---|---|---|---|---|---|---|---|
| `id_funcionario` | Identificador do funcionário | INT | 11 (INT) | Sim | Não | Não | Não | - | - |
| `nome` | Nome completo | VARCHAR | 100 | Não | Não | Não | Não | - | - |
| `cpf` | CPF do funcionário | CHAR | 11 | Não | Não | Não | Sim | - | ck_funcionario_cpf, uq_funcionario_cpf |
| `cargo` | Função exercida | VARCHAR | 50 | Não | Não | Não | Não | - | - |
| `telefone` | Telefone de contato | VARCHAR | 20 | Não | Não | Sim | Não | NULL | - |
| `data_contratacao` | Data de contratação | DATE | - | Não | Não | Não | Não | - | - |

## servico

| Atributo | Descrição | Tipo | Tamanho | PK | FK | NULL | UNIQUE | DEFAULT | Regra/Restrição |
|---|---|---|---|---|---|---|---|---|---|
| `id_servico` | Identificador do serviço | INT | 11 (INT) | Sim | Não | Não | Não | - | - |
| `descricao` | Descrição do serviço | VARCHAR | 150 | Não | Não | Não | Não | - | - |
| `valor_padrao` | Valor de referência do serviço | DECIMAL | 10,2 | Não | Não | Não | Não | - | ck_servico_valor |
| `tempo_padrao_horas` | Tempo estimado de execução, em horas | DECIMAL | 5,2 | Não | Não | Sim | Não | NULL | ck_servico_tempo |
| `ativo` | Indica se o serviço está disponível | TINYINT | 1 | Não | Não | Não | Não | 1 | ck_servico_ativo |

## peca

| Atributo | Descrição | Tipo | Tamanho | PK | FK | NULL | UNIQUE | DEFAULT | Regra/Restrição |
|---|---|---|---|---|---|---|---|---|---|
| `id_peca` | Identificador da peça | INT | 11 (INT) | Sim | Não | Não | Não | - | - |
| `descricao` | Descrição da peça | VARCHAR | 150 | Não | Não | Não | Não | - | - |
| `preco_unitario` | Preço de venda de referência | DECIMAL | 10,2 | Não | Não | Não | Não | - | ck_peca_preco |
| `estoque` | Quantidade disponível | INT | 11 (INT) | Não | Não | Não | Não | 0 | ck_peca_estoque |
| `ativo` | Indica se a peça está disponível | TINYINT | 1 | Não | Não | Não | Não | 1 | ck_peca_ativo |

## fornecedor

| Atributo | Descrição | Tipo | Tamanho | PK | FK | NULL | UNIQUE | DEFAULT | Regra/Restrição |
|---|---|---|---|---|---|---|---|---|---|
| `id_fornecedor` | Identificador do fornecedor | INT | 11 (INT) | Sim | Não | Não | Não | - | - |
| `nome` | Nome ou razão social | VARCHAR | 100 | Não | Não | Não | Não | - | - |
| `cnpj` | CNPJ do fornecedor | CHAR | 14 | Não | Não | Não | Sim | - | ck_fornecedor_cnpj, uq_fornecedor_cnpj |
| `endereco` | Endereço | VARCHAR | 200 | Não | Não | Sim | Não | NULL | - |
| `telefone` | Telefone de contato | VARCHAR | 20 | Não | Não | Sim | Não | NULL | - |
| `email` | E-mail de contato | VARCHAR | 100 | Não | Não | Sim | Não | NULL | - |

## fornecedor_peca

| Atributo | Descrição | Tipo | Tamanho | PK | FK | NULL | UNIQUE | DEFAULT | Regra/Restrição |
|---|---|---|---|---|---|---|---|---|---|
| `id_fornecedor` | Chave estrangeira: referencia fornecedor.id_fornecedor | INT | 11 (INT) | Sim | Sim → fornecedor.id_fornecedor | Não | Não | - | - |
| `id_peca` | Chave estrangeira: referencia peca.id_peca | INT | 11 (INT) | Sim | Sim → peca.id_peca | Não | Não | - | - |
| `preco_compra` | Preço pago ao fornecedor por esta peça | DECIMAL | 10,2 | Não | Não | Não | Não | - | ck_fp_preco |
| `data_atualizacao` | Data da última atualização do preço | DATE | - | Não | Não | Não | Não | - | - |

## ordem_servico

| Atributo | Descrição | Tipo | Tamanho | PK | FK | NULL | UNIQUE | DEFAULT | Regra/Restrição |
|---|---|---|---|---|---|---|---|---|---|
| `id_os` | Identificador da ordem de serviço | INT | 11 (INT) | Sim | Não | Não | Não | - | - |
| `id_cliente` | Chave estrangeira: referencia cliente.id_cliente | INT | 11 (INT) | Não | Sim → cliente.id_cliente | Não | Não | - | - |
| `id_veiculo` | Chave estrangeira: referencia veiculo.id_veiculo | INT | 11 (INT) | Não | Sim → veiculo.id_veiculo | Não | Não | - | - |
| `id_funcionario` | Chave estrangeira: referencia funcionario.id_funcionario | INT | 11 (INT) | Não | Sim → funcionario.id_funcionario | Não | Não | - | - |
| `data_abertura` | Data e hora de abertura da ordem | DATETIME | - | Não | Não | Não | Não | - | - |
| `descricao_problema` | Problema apresentado pelo cliente | VARCHAR | 500 | Não | Não | Não | Não | - | - |
| `previsao_entrega` | Prazo estimado de entrega | DATE | - | Não | Não | Sim | Não | NULL | - |
| `status` | Situação da ordem | VARCHAR | 20 | Não | Não | Não | Não | 'ABERTA' | ck_os_status |

## orcamento

| Atributo | Descrição | Tipo | Tamanho | PK | FK | NULL | UNIQUE | DEFAULT | Regra/Restrição |
|---|---|---|---|---|---|---|---|---|---|
| `id_orcamento` | Identificador do orçamento | INT | 11 (INT) | Sim | Não | Não | Não | - | - |
| `id_os` | Chave estrangeira: referencia ordem_servico.id_os | INT | 11 (INT) | Não | Sim → ordem_servico.id_os | Não | Sim | - | uq_orcamento_os |
| `data_orcamento` | Data de criação do orçamento | DATE | - | Não | Não | Não | Não | - | ck_orcamento_validade |
| `validade` | Data limite de validade | DATE | - | Não | Não | Não | Não | - | ck_orcamento_validade |
| `status` | Situação do orçamento | VARCHAR | 20 | Não | Não | Não | Não | 'PENDENTE' | ck_orcamento_status |

## item_orcamento

| Atributo | Descrição | Tipo | Tamanho | PK | FK | NULL | UNIQUE | DEFAULT | Regra/Restrição |
|---|---|---|---|---|---|---|---|---|---|
| `id_item` | Identificador do item | INT | 11 (INT) | Sim | Não | Não | Não | - | - |
| `id_orcamento` | Chave estrangeira: referencia orcamento.id_orcamento | INT | 11 (INT) | Não | Sim → orcamento.id_orcamento | Não | Não | - | - |
| `id_servico` | Chave estrangeira: referencia servico.id_servico | INT | 11 (INT) | Não | Sim → servico.id_servico | Sim | Não | NULL | ck_item_servico_ou_peca |
| `id_peca` | Chave estrangeira: referencia peca.id_peca | INT | 11 (INT) | Não | Sim → peca.id_peca | Sim | Não | NULL | ck_item_servico_ou_peca |
| `quantidade` | Quantidade do serviço ou da peça | INT | 11 (INT) | Não | Não | Não | Não | - | ck_item_quantidade |
| `valor_unitario` | Preço unitário no momento do orçamento | DECIMAL | 10,2 | Não | Não | Não | Não | - | ck_item_valor |

## pagamento

| Atributo | Descrição | Tipo | Tamanho | PK | FK | NULL | UNIQUE | DEFAULT | Regra/Restrição |
|---|---|---|---|---|---|---|---|---|---|
| `id_pagamento` | Identificador do pagamento | INT | 11 (INT) | Sim | Não | Não | Não | - | - |
| `id_orcamento` | Chave estrangeira: referencia orcamento.id_orcamento | INT | 11 (INT) | Não | Sim → orcamento.id_orcamento | Não | Sim | - | uq_pagamento_orcamento |
| `data_pagamento` | Data e hora do pagamento | DATETIME | - | Não | Não | Não | Não | - | - |
| `valor` | Valor pago | DECIMAL | 10,2 | Não | Não | Não | Não | - | ck_pagamento_valor |
| `forma_pagamento` | Forma de pagamento | VARCHAR | 10 | Não | Não | Não | Não | - | ck_pagamento_forma |
| `status` | Situação do pagamento | VARCHAR | 10 | Não | Não | Não | Não | 'PENDENTE' | ck_pagamento_status |

## Visões (atributos derivados)

| Visão | Conteúdo | Atributo derivado |
|---|---|---|
| `vw_item_orcamento` | itens com `valor_total` = quantidade × valor_unitario | ITEM_ORCAMENTO.valor_total |
| `vw_orcamento_total` | orçamentos com `valor_total` = soma dos itens | ORCAMENTO.valor_total |
