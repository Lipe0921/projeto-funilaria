# Dicionário de Dados Conceitual — Prime Funilaria

Projeto ERP — Prime Funilaria · Curso: Engenharia de Software · Disciplina: Modelagem de Dados · Grupo 04

| Integrante | RA |
|---|---|
| Felipe de Souza Ferreira | 48120863 |
| Kayke Queriquieri da Silva | 47556897 |
| Jonathan Nery Lacerda | 47734213 |
| Kaiky dos Santos Ferreira | 47802928 |
| Davi Melo Salgueiro Leonardi | 48129470 |
| Ruan Sousa Silva | 47347805 |
| Vinicius de Oliveira | 47710608 |
| Leonardo Augusto | 47733497 |

> Versão revisada. Substitui a versão anterior em PDF (removida; disponível no histórico do git), que trazia a lista de integrantes com nomes divergentes e um integrante como "não informado". A fonte de verdade é a seção 15 do README.

## Dicionário por entidade

Para cada entidade, os atributos são descritos (que dado é e para que serve), classificados e associados às regras de negócio. Classificação: **identificador**, **obrigatório**, **opcional** e **derivado**. Como o modelo é conceitual, os tipos de dados e as chaves estrangeiras serão definidos nas próximas etapas (modelo lógico e físico); aqui os vínculos entre entidades aparecem na linha **Relacionamentos** de cada entidade e na seção 14.

### CLIENTE
*Pessoa física ou empresa que solicita serviços e pode ser proprietária de veículos.*

| Atributo | Descrição | Classificação | Regra / observação |
|---|---|---|---|
| `id_cliente` | Identificador único do cliente | Identificador | Identificação única |
| `nome` | Nome completo ou razão social | Obrigatório | — |
| `cpf_cnpj` | CPF ou CNPJ do cliente | Obrigatório | Não deve ser duplicado (RN29, RNF05) |
| `telefone` | Telefone de contato | Opcional | Pode ser informado depois |

**Relacionamentos:** possui VEICULO (RN01, RN02); solicita ORDEM_SERVICO (RN22, RN23).

### VEICULO
*Veículo atendido pela funilaria.*

| Atributo | Descrição | Classificação | Regra / observação |
|---|---|---|---|
| `id_veiculo` | Identificador do veículo | Identificador | Identificação única |
| `placa` | Placa do veículo | Obrigatório | Não deve ser duplicada (RN29, RNF05) |
| `chassi` | Número do chassi | Obrigatório | Não deve ser duplicado (RN29, RNF05) |
| `cor` | Cor do veículo | Opcional | Consta na ficha atual; não é necessária para abrir a OS |
| `ano` | Ano do veículo (fabricação ou modelo, conforme o documento do veículo) | Opcional | Consta na ficha atual; não é necessário para abrir a OS |
| `marca` | Fabricante do veículo | Obrigatório | Identifica o veículo no atendimento e no orçamento |
| `modelo` | Modelo do veículo | Obrigatório | Identifica o veículo no atendimento e no orçamento |

**Relacionamentos:** pertence a CLIENTE (RN01, RN02: todo veículo tem exatamente um proprietário); associado_a ORDEM_SERVICO (RN03, RN04).

### FUNCIONARIO
*Funcionário que responde pelas ordens de serviço.*

| Atributo | Descrição | Classificação | Regra / observação |
|---|---|---|---|
| `id_funcionario` | Identificador do funcionário | Identificador | Identificação única |
| `nome` | Nome completo | Obrigatório | — |
| `cpf` | CPF do funcionário | Obrigatório | Não deve ser duplicado (RN29) |
| `cargo` | Função exercida | Obrigatório | Identifica a função e apoia o controle de acesso por perfil (RNF02) |
| `telefone` | Telefone de contato | Opcional | — |
| `data_contratacao` | Data de contratação | Obrigatório | Dado cadastral do funcionário |

**Relacionamentos:** atende ORDEM_SERVICO (RN05, RN06).

### ORDEM_SERVICO
*Atendimento solicitado por um cliente para um veículo.*

| Atributo | Descrição | Classificação | Regra / observação |
|---|---|---|---|
| `id_os` | Identificador da ordem de serviço | Identificador | Identificação única |
| `data_abertura` | Data e hora de abertura da ordem | Obrigatório | Base do histórico por veículo (RF19) |
| `descricao_problema` | Problema apresentado pelo cliente | Obrigatório | — |
| `previsao_entrega` | Prazo estimado de entrega | Opcional | Pode ser definido após a análise do veículo |
| `status` | Situação da ordem | Obrigatório | Aberta, em andamento ou concluída (RN26) |

**Relacionamentos:** solicitada por CLIENTE (RN22, RN23: o solicitante pode ser diferente do proprietário do veículo); referente a VEICULO (RN03, RN04); atendida por FUNCIONARIO (RN05, RN06); gera ORCAMENTO (RN07, RN08).

### ORCAMENTO
*Proposta de valores de uma ordem de serviço.*

| Atributo | Descrição | Classificação | Regra / observação |
|---|---|---|---|
| `id_orcamento` | Identificador do orçamento | Identificador | Identificação única |
| `data_orcamento` | Data de criação do orçamento | Obrigatório | Ponto de partida da validade |
| `validade` | Data limite de validade | Obrigatório | Vencida a validade sem aprovação, o status passa a expirado (RN27) |
| `valor_total` | Valor total do orçamento | Derivado | Soma dos valores totais dos itens (RF14) |
| `status` | Situação do orçamento | Obrigatório | Pendente, aprovado ou expirado (RN27) |

**Relacionamentos:** gerado por ORDEM_SERVICO (RN07, RN08: a ordem gera no máximo um orçamento); contem ITEM_ORCAMENTO (RN09, RN10); gera_pagamento PAGAMENTO (RN14, RN15).

### ITEM_ORCAMENTO
*Linha do orçamento: um serviço ou uma peça, com quantidade e valor.*

| Atributo | Descrição | Classificação | Regra / observação |
|---|---|---|---|
| `id_item` | Identificador do item | Identificador | Identificação única |
| `quantidade` | Quantidade do serviço ou da peça | Obrigatório | Maior que zero (RN24) |
| `valor_unitario` | Preço unitário no momento do orçamento | Obrigatório | Não muda se o preço padrão for alterado depois (RN21) |
| `valor_total` | Valor total do item | Derivado | quantidade × valor_unitario |

**Relacionamentos:** pertence a ORCAMENTO (RN09, RN10); utilizado_em SERVICO (RN11); compoe PECA (RN12).

> Regra RN13: cada item refere-se a exatamente um serviço ou uma peça, nunca aos dois e nunca a nenhum.

### SERVICO
*Serviço de mão de obra oferecido pela funilaria.*

| Atributo | Descrição | Classificação | Regra / observação |
|---|---|---|---|
| `id_servico` | Identificador do serviço | Identificador | Identificação única |
| `descricao` | Descrição do serviço | Obrigatório | — |
| `valor_padrao` | Valor de referência do serviço | Obrigatório | Evita reescrever o preço a cada orçamento; o valor cobrado fica no item (RN21) |
| `tempo_padrao_horas` | Tempo estimado de execução, em horas | Opcional | Apoia a definição da previsão de entrega |
| `ativo` | Indica se o serviço está disponível | Obrigatório | Serviço inativo não entra em novos orçamentos (RN20) |

**Relacionamentos:** utilizado_em ITEM_ORCAMENTO (RN11).

### PECA
*Peça utilizada nos reparos, com controle de estoque.*

| Atributo | Descrição | Classificação | Regra / observação |
|---|---|---|---|
| `id_peca` | Identificador da peça | Identificador | Identificação única |
| `descricao` | Descrição da peça | Obrigatório | — |
| `preco_unitario` | Preço de venda de referência | Obrigatório | O valor cobrado fica no item (RN21) |
| `estoque` | Quantidade disponível | Obrigatório | Não pode ser negativa (RN25); baixa na aprovação do orçamento (RN30); acréscimo no recebimento de peças (RN31) |
| `ativo` | Indica se a peça está disponível | Obrigatório | Peça inativa não entra em novos orçamentos (RN20) |

**Relacionamentos:** compoe ITEM_ORCAMENTO (RN12); participa de FORNECEDOR_PECA (RN17).

### FORNECEDOR
*Empresa que fornece peças.*

| Atributo | Descrição | Classificação | Regra / observação |
|---|---|---|---|
| `id_fornecedor` | Identificador do fornecedor | Identificador | Identificação única |
| `nome` | Nome ou razão social | Obrigatório | — |
| `cnpj` | CNPJ do fornecedor | Obrigatório | Não deve ser duplicado (RN29) |
| `endereco` | Endereço | Opcional | Campo único de texto nesta etapa |
| `telefone` | Telefone de contato | Opcional | Os preços hoje são combinados por telefone ou mensagem |
| `email` | E-mail de contato | Opcional | — |

**Relacionamentos:** fornece, por meio de FORNECEDOR_PECA (RN16).

### FORNECEDOR_PECA (entidade associativa)
*Fornecimento de uma peça por um fornecedor; resolve o N:N entre FORNECEDOR e PECA.*

| Atributo | Descrição | Classificação | Regra / observação |
|---|---|---|---|
| (identificador) | Combinação de FORNECEDOR e PECA | Identificador | O par não pode se repetir (RN16, RN17) |
| `preco_compra` | Preço pago ao fornecedor por esta peça | Obrigatório | Pertence ao relacionamento, não à peça nem ao fornecedor (RN18) |
| `data_atualizacao` | Data da última atualização do preço | Obrigatório | RN18 |

**Relacionamentos:** liga FORNECEDOR (RN16) e PECA (RN17).

### PAGAMENTO
*Pagamento de um orçamento aprovado.*

| Atributo | Descrição | Classificação | Regra / observação |
|---|---|---|---|
| `id_pagamento` | Identificador do pagamento | Identificador | Identificação única |
| `data_pagamento` | Data e hora do pagamento | Obrigatório | — |
| `valor` | Valor pago | Obrigatório | Corresponde ao valor total do orçamento (RN32) |
| `forma_pagamento` | Forma de pagamento | Obrigatório | Dinheiro, cartão ou PIX (RN28) |
| `status` | Situação do pagamento | Obrigatório | Pendente ou confirmado (RN28) |

**Relacionamentos:** referente a ORCAMENTO (RN14, RN15: o orçamento tem no máximo um pagamento).

---
