# Normalização — Prime Funilaria

Este documento demonstra a aplicação de 1FN, 2FN e 3FN ao modelo lógico implementado em `sql/ddl/01_estrutura.sql`. Para cada decisão, registra-se a **estrutura analisada → dependência funcional → problema identificado → correção realizada**, conforme a etapa 11 do manual.

## 1. Critérios

| Forma normal | Critério | Pergunta-chave |
|---|---|---|
| 1FN | Atributos atômicos, sem grupos repetitivos | "Cada campo armazena um único valor?" |
| 2FN | Em tabelas com chave composta, nenhum atributo não chave depende de apenas parte da chave | "Depende da chave toda?" |
| 3FN | Nenhum atributo não chave depende de outro atributo não chave | "O atributo depende diretamente da chave ou de outro atributo?" |

## 2. Dependências funcionais (DF) do modelo implementado

Cada tabela tem chave simples, exceto `fornecedor_peca`, cuja chave é composta por `(id_fornecedor, id_peca)`.

| Tabela | Chave | Dependências funcionais principais |
|---|---|---|
| cliente | id_cliente | id_cliente → nome, cpf_cnpj, telefone |
| veiculo | id_veiculo | id_veiculo → id_cliente, placa, chassi, marca, modelo, cor, ano |
| funcionario | id_funcionario | id_funcionario → nome, cpf, cargo, telefone, data_contratacao |
| servico | id_servico | id_servico → descricao, valor_padrao, tempo_padrao_horas, ativo |
| peca | id_peca | id_peca → descricao, preco_unitario, estoque, ativo |
| fornecedor | id_fornecedor | id_fornecedor → nome, cnpj, endereco, telefone, email |
| fornecedor_peca | (id_fornecedor, id_peca) | (id_fornecedor, id_peca) → preco_compra, data_atualizacao |
| ordem_servico | id_os | id_os → id_cliente, id_veiculo, id_funcionario, data_abertura, descricao_problema, previsao_entrega, status |
| orcamento | id_orcamento | id_orcamento → id_os, data_orcamento, validade, status |
| item_orcamento | id_item | id_item → id_orcamento, id_servico, id_peca, quantidade, valor_unitario |
| pagamento | id_pagamento | id_pagamento → id_orcamento, data_pagamento, valor, forma_pagamento, status |

## 3. Verificação por tabela

| Tabela | 1FN | 2FN | 3FN | Observação |
|---|---|---|---|---|
| cliente | Sim | Sim (chave simples) | Sim | — |
| veiculo | Sim | Sim (chave simples) | Sim | `id_cliente` é do proprietário; não há DF entre atributos não chave |
| funcionario | Sim | Sim (chave simples) | Sim | — |
| servico | Sim | Sim (chave simples) | Sim | — |
| peca | Sim | Sim (chave simples) | Sim | — |
| fornecedor | Sim* | Sim (chave simples) | Sim | *`endereco` é texto único; ver caso 4 |
| fornecedor_peca | Sim | Sim | Sim | `preco_compra` e `data_atualizacao` dependem do par inteiro |
| ordem_servico | Sim | Sim (chave simples) | Sim | ver caso 3 |
| orcamento | Sim | Sim (chave simples) | Sim | `valor_total` não é armazenado; ver caso 2 |
| item_orcamento | Sim | Sim (chave simples) | Sim | `valor_unitario` é fato do item; ver caso 5 |
| pagamento | Sim | Sim (chave simples) | Sim | — |

## 4. Casos analisados

### Caso 1 — 2FN: preço de compra e dados do fornecedor/peça na associação

- **Estrutura analisada (descartada):** `FORNECEDOR_PECA(id_fornecedor, id_peca, nome_fornecedor, cnpj_fornecedor, descricao_peca, preco_compra, data_atualizacao)`.
- **Dependências:** `id_fornecedor → nome_fornecedor, cnpj_fornecedor` e `id_peca → descricao_peca`. São dependências **parciais** da chave composta.
- **Problema:** violação da 2FN. Nome do fornecedor repetido em cada peça fornecida, e descrição da peça repetida em cada fornecedor. Uma correção de nome exigiria alterar várias linhas.
- **Correção realizada:** separação em `FORNECEDOR(id_fornecedor, nome, cnpj, …)`, `PECA(id_peca, descricao, …)` e `FORNECEDOR_PECA(id_fornecedor, id_peca, preco_compra, data_atualizacao)`. Na tabela associativa restam somente os atributos que dependem do par inteiro (RN18).

### Caso 2 — 3FN: `valor_total` derivado não armazenado

- **Estrutura analisada (descartada):** `ORCAMENTO(id_orcamento, id_os, data_orcamento, validade, status, valor_total)` e `ITEM_ORCAMENTO(…, valor_total)` com `valor_total = quantidade × valor_unitario`.
- **Dependências:** `id_item → valor_total` (por fórmula, a partir de `quantidade` e `valor_unitario`) e `id_orcamento → valor_total` (por soma dos itens). São dependências transitivas por cálculo, e o valor fica redundante.
- **Problema:** redundância. Se um item for alterado sem recalcular o total, o orçamento fica inconsistente.
- **Correção realizada:** os dois `valor_total` não são armazenados. Foram criadas as visões `vw_item_orcamento` e `vw_orcamento_total`, que calculam o valor na consulta (ver `sql/ddl/01_estrutura.sql`).

### Caso 3 — 3FN avaliada e mantida: solicitante × proprietário em `ordem_servico`

- **Estrutura analisada:** `ORDEM_SERVICO(id_os, id_cliente, id_veiculo, id_funcionario, …)`, em que `id_cliente` é o solicitante.
- **Pergunta:** `id_veiculo → id_cliente` (solicitante)? Se sim, haveria dependência transitiva `id_os → id_veiculo → id_cliente`, e o solicitante poderia ser removido da OS.
- **Resultado:** **não há essa dependência**. O veículo tem um proprietário (`veiculo.id_cliente`), mas quem solicita o serviço pode ser outra pessoa (RN23), e um mesmo veículo pode ser atendido em diferentes ocasiões por solicitantes diferentes.
- **Evidência:** a OS 4 é solicitada por Rogerio Matos (cliente 4), enquanto o veículo MNO0P12 pertence a Carlos Pereira (cliente 1). Essa situação é listada pela consulta de auditoria A10 (`sql/consultas/05_consultas_auditoria.sql`).
- **Decisão:** manter `id_cliente` em `ORDEM_SERVICO`. Não é redundância, porque são papéis diferentes.

### Caso 4 — 1FN: `endereco` de FORNECEDOR (decisão consciente)

- **Estrutura analisada:** `FORNECEDOR.endereco` (texto único, por exemplo `Rua das Pecas, 100`).
- **Análise:** um endereço é, em tese, um atributo composto (logradouro, número, cidade, UF, CEP). Isso poderia ser lido como violação da 1FN.
- **Decisão:** manter como campo de texto único. As regras de negócio não exigem consultar, filtrar ou validar partes do endereço, e o campo é apenas informativo (contato do fornecedor). Se a empresa passar a precisar de consultas por cidade ou UF, o atributo será decomposto em colunas, sem afetar outras tabelas.
- **Justificativa registrada no dicionário:** "Campo único de texto nesta etapa" (`docs/dicionario_de_dados_conceitual.md`).

### Caso 5 — 3FN avaliada: `valor_unitario` em `ITEM_ORCAMENTO`

- **Estrutura analisada:** `ITEM_ORCAMENTO(id_item, id_servico, id_peca, quantidade, valor_unitario)`.
- **Pergunta:** `id_servico → valor_unitario` (ou `id_peca → valor_unitario`)? Se sim, o preço ficaria em `SERVICO`/`PECA` e o item guardaria apenas a referência.
- **Resultado:** **não há essa dependência**. O preço padrão pode mudar, mas o valor cobrado em um orçamento já emitido deve permanecer o mesmo (RN21, P06). `valor_unitario` é um fato histórico do item, e não uma função do serviço ou da peça.
- **Decisão:** manter `valor_unitario` no item.

### Caso 6 — 1FN e 2FN: telefones e contatos

- **Análise:** `CLIENTE.telefone` e `FORNECEDOR.telefone` guardam um único telefone. Não há grupo repetitivo (`telefone1`, `telefone2`) nem lista dentro do campo, por isso a 1FN é atendida.
- **Evolução prevista:** se for necessário mais de um telefone por cliente, criar `CLIENTE_TELEFONE(id_cliente, telefone)`, com chave composta. Essa tabela já estaria em 3FN.

## 5. Conclusão

Após a análise, o modelo implementado está na **3FN**. As únicas decomposições necessárias foram as dos casos 1 e 2, que já estão aplicadas ao modelo. As situações dos casos 3, 4, 5 e 6 foram avaliadas e **mantidas de propósito**, com justificativa. Não foram criados erros artificiais para demonstrar normalização.
