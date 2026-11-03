# Projeto ERP — Prime Funilaria

Projeto Integrador de Modelagem de Dados: do problema real ao Modelo Conceitual de Dados (DER) de um sistema ERP para uma funilaria automotiva.

---

## 1. Identificação da equipe

**Curso:** Engenharia de Software
**Disciplina:** Modelagem de Dados
**Projeto:** Sistema ERP — Prime Funilaria
**Grupo:** 04

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
| Leonardo (segundo integrante) | não informado |

---

## 2. Caracterização da empresa

**Nome:** Prime Funilaria
**Segmento:** funilaria automotiva (reparação de lataria e pintura, com substituição de peças).

**O que oferece.** Serviços de reparação automotiva, prestados com a utilização de peças. O valor cobrado do cliente é composto por **serviços** (mão de obra) e **peças**, apresentados em um orçamento.

**Principais clientes.** Proprietários ou responsáveis por veículos (pessoas físicas ou empresas, identificados por CPF ou CNPJ) que procuram a empresa para reparar danos ao veículo.

**Principais setores e envolvidos.**

| Setor / envolvido | Papel |
|---|---|
| Clientes | Solicitam serviços e são proprietários dos veículos atendidos |
| Atendimento | Cadastra clientes e veículos, abre as ordens de serviço e registra a aprovação dos orçamentos |
| Funcionários | Executam e respondem pelas ordens de serviço |
| Orçamentação | Define serviços e peças necessários e calcula valores |
| Estoque | Controla as peças disponíveis e registra a entrada de peças recebidas |
| Fornecedores | Fornecem as peças utilizadas pela empresa |
| Financeiro | Registra os pagamentos |

**Como funciona atualmente.**
Hoje a Prime Funilaria não utiliza nenhum sistema: todo o controle é feito em papel, com fichas, formulários e anotações guardados em pastas, sem nada que ligue as etapas do atendimento:

- **Atendimento.** Quando o cliente chega, o atendente anota em uma ficha de papel o nome, o telefone e o CPF/CNPJ do cliente e os dados do veículo (placa, chassi, marca, modelo, cor e ano). Como não existe uma base única, o mesmo cliente pode ser anotado mais de uma vez, e para encontrar o histórico de atendimentos de um veículo é preciso procurar entre as fichas guardadas.
- **Ordem de serviço.** A ordem é preenchida em um formulário de papel, com a descrição do problema, a previsão de entrega e o nome do funcionário que cuidará do carro. O andamento (aberta, em andamento, concluída) só é conhecido perguntando ao responsável ou procurando o papel da ordem.
- **Orçamento.** O funcionário analisa o veículo e escreve o orçamento à mão, listando os serviços e as peças necessários, com quantidades e valores, e calcula o total e a validade. A ligação entre o orçamento e a ordem de serviço depende de os papéis estarem juntos, e os preços dos serviços e das peças são escritos novamente a cada orçamento. A aprovação do cliente não fica registrada de forma padronizada.
- **Peças, estoque e fornecedores.** O estoque de peças é conferido de forma manual (contagem e anotações em papel), o que gera divergência entre a quantidade registrada e a real. Os preços de compra são combinados com cada fornecedor por telefone ou mensagem e não ficam registrados em um só lugar, o que dificulta comparar fornecedores e saber o custo de cada peça.
- **Pagamento.** O recebimento é anotado no caixa ou em recibo de papel, sem indicar com clareza a qual orçamento ou ordem de serviço ele se refere.

Como consequência, a empresa tem dificuldade para saber qual veículo está em qual atendimento, quem é o responsável, quanto foi orçado e aprovado, quais peças ainda existem em estoque, qual fornecedor oferece o melhor preço e quanto já foi pago, além do risco de perda ou extravio dos papéis. É esse conjunto de problemas que o sistema ERP deverá resolver, integrando cadastros, ordens, orçamentos, estoque, fornecedores e pagamentos em uma única base de dados.

**Informações importantes para o negócio.** Dados do cliente e do veículo; histórico de ordens de serviço por veículo; funcionário responsável por cada atendimento; composição, validade e aprovação do orçamento; estoque e preço das peças; preço de compra por fornecedor; pagamentos.

---

## 3. Justificativa da escolha

A funilaria foi escolhida porque reúne, em um único negócio pequeno, processos encadeados que dependem uns dos outros: o atendimento gera uma ordem de serviço, que gera um orçamento, que consome serviços e peças, que dependem de estoque e fornecedores, e termina em um pagamento. Como a desorganização em uma etapa prejudica as demais, o negócio justifica a **integração** típica de um ERP.

Para a modelagem de dados, o negócio permite aplicar:

- relacionamentos **1:N** (cliente–veículo, orçamento–itens);
- relacionamento **1:1** (ordem de serviço–orçamento e orçamento–pagamento);
- relacionamento **N:N com atributos próprios** (fornecedor–peça, com preço de compra e data de atualização), resolvido por entidade associativa e chave composta;
- uma regra de **exclusividade** (item de orçamento é serviço ou peça);
- controle de **estoque** (com baixa na aprovação do orçamento e entrada no recebimento de peças) e de situação ativa/inativa de cadastros.

---

## 4. Problemas identificados

| Problema | Consequência | Requisitos que respondem |
|---|---|---|
| Dados de clientes sem centralização | Dificuldade para consultar informações e risco de duplicidade | RF01, RF02 |
| Dados dos veículos desorganizados | Dificuldade para identificar o veículo e seu histórico | RF03, RF04 |
| Controle manual das ordens de serviço | Dificuldade para acompanhar atendimentos, prazos e status | RF09, RF10, RF19, RF22 |
| Controle manual dos orçamentos | Dificuldade para acompanhar valores e validade | RF12, RF13, RF14, RF20 |
| Aprovação do orçamento e andamento da OS sem registro | Não se sabe o que foi aprovado nem em que etapa está o veículo | RF21, RF22 |
| Controle manual de peças e estoque | Erros na quantidade disponível | RF07, RF15, RF23, RF24, RF25 |
| Preços de fornecedores não registrados | Dificuldade para comparar fornecedores e saber o custo das peças | RF08, RF16, RF17, RF26 |
| Pagamentos sem vínculo claro com o orçamento | Dificuldade para acompanhar valores pagos | RF18, RF27 |
| Responsável pelo atendimento não registrado | Dificuldade para identificar quem responde pela ordem | RF05, RF11 |

**Necessidades.** Cadastrar clientes, veículos, funcionários, serviços, peças e fornecedores; abrir ordens de serviço ligadas a veículo e funcionário; gerar e aprovar orçamentos compostos por itens; controlar estoque (baixa e entrada); relacionar fornecedores e peças com preço de compra; registrar pagamentos; consultar essas informações.

---

## 5. Processos de negócio

| Processo | Quem participa | O que inicia | O que acontece | Informação gerada | Resultado |
|---|---|---|---|---|---|
| Cadastro de cliente | Atendimento, cliente | Cliente novo solicita atendimento | Registra nome, CPF/CNPJ e telefone | CLIENTE | Cliente cadastrado |
| Cadastro de veículo | Atendimento, cliente | Veículo ainda não cadastrado | Registra placa, chassi, cor, ano, marca e modelo vinculados ao proprietário | VEICULO | Veículo vinculado ao cliente |
| Abertura de ordem de serviço | Atendimento, funcionário | Cliente solicita reparo | Registra cliente solicitante, veículo, problema, previsão de entrega, status e funcionário responsável | ORDEM_SERVICO | OS aberta |
| Geração do orçamento | Funcionário, orçamentação | OS aberta | Define serviços e peças, quantidades e valores; calcula total e validade | ORCAMENTO, ITEM_ORCAMENTO | Orçamento emitido (pendente) |
| Aprovação do orçamento e baixa de estoque | Atendimento, cliente, estoque | Orçamento pendente dentro da validade | Cliente aprova; confere estoque das peças; baixa o estoque; atualiza status do orçamento e da OS | ORCAMENTO, PECA, ORDEM_SERVICO | Orçamento aprovado e OS em andamento |
| Controle de peças e fornecedores | Estoque, fornecedores | Necessidade de peça, atualização de preço ou recebimento de peças | Cadastra peça, relaciona fornecedor com preço de compra e data, registra entrada no estoque | PECA, FORNECEDOR, FORNECEDOR_PECA | Peça com fornecedores, custo e estoque atualizados |
| Registro do pagamento | Financeiro, cliente | Orçamento aprovado | Registra data, valor, forma e status | PAGAMENTO | Orçamento com pagamento associado |

---

## 6. Requisitos funcionais

- **RF01:** O sistema deverá cadastrar clientes.
- **RF02:** O sistema deverá consultar clientes.
- **RF03:** O sistema deverá cadastrar veículos.
- **RF04:** O sistema deverá associar cada veículo a um cliente proprietário.
- **RF05:** O sistema deverá cadastrar funcionários.
- **RF06:** O sistema deverá cadastrar serviços e permitir ativá-los ou inativá-los.
- **RF07:** O sistema deverá cadastrar peças e permitir ativá-las ou inativá-las.
- **RF08:** O sistema deverá cadastrar fornecedores.
- **RF09:** O sistema deverá abrir ordens de serviço.
- **RF10:** O sistema deverá associar a ordem de serviço ao cliente solicitante e ao veículo atendido.
- **RF11:** O sistema deverá associar um funcionário responsável à ordem de serviço.
- **RF12:** O sistema deverá gerar um orçamento a partir da ordem de serviço.
- **RF13:** O sistema deverá registrar os itens do orçamento, cada um sendo um serviço ou uma peça, com quantidade e valores.
- **RF14:** O sistema deverá calcular o valor total do orçamento.
- **RF15:** O sistema deverá controlar o estoque das peças.
- **RF16:** O sistema deverá relacionar fornecedores e peças.
- **RF17:** O sistema deverá registrar o preço de compra e a data de atualização na relação fornecedor/peça.
- **RF18:** O sistema deverá registrar o pagamento de um orçamento aprovado.
- **RF19:** O sistema deverá consultar ordens de serviço (inclusive por cliente e por veículo).
- **RF20:** O sistema deverá consultar orçamentos.
- **RF21:** O sistema deverá registrar a aprovação do orçamento pelo cliente e controlar o status do orçamento (pendente, aprovado ou expirado).
- **RF22:** O sistema deverá atualizar o status da ordem de serviço (aberta, em andamento ou concluída).
- **RF23:** O sistema deverá dar baixa no estoque das peças dos itens quando o orçamento for aprovado.
- **RF24:** O sistema deverá registrar a entrada de peças recebidas de fornecedores, acrescentando a quantidade ao estoque.
- **RF25:** O sistema deverá consultar peças e suas quantidades em estoque.
- **RF26:** O sistema deverá consultar os fornecedores de cada peça, comparando os preços de compra.
- **RF27:** O sistema deverá consultar pagamentos (inclusive por orçamento e por ordem de serviço).

---

## 7. Requisitos não funcionais

- **RNF01 — Segurança:** o sistema deverá proteger os dados armazenados contra acesso não autorizado.
- **RNF02 — Controle de acesso:** o sistema deverá controlar as operações permitidas conforme o perfil do usuário (atendimento, estoque e financeiro), de acordo com as políticas da seção 9.
- **RNF03 — Rastreabilidade:** o sistema deverá manter registro das operações realizadas pelos usuários.
- **RNF04 — Integridade:** o sistema deverá preservar a integridade dos relacionamentos entre os dados.
- **RNF05 — Confiabilidade:** o sistema deverá manter os dados consistentes, evitando duplicidade dos identificadores únicos definidos na RN29 (CPF/CNPJ do cliente, placa e chassi do veículo, CPF do funcionário e CNPJ do fornecedor).
- **RNF06 — Usabilidade:** o sistema deverá apresentar as informações de forma clara para usuários sem formação técnica.
- **RNF07 — Desempenho:** o sistema deverá apresentar as consultas em tempo adequado para uso operacional.
- **RNF08 — Disponibilidade:** o sistema deverá estar disponível durante o horário de funcionamento da empresa.

---

## 8. Regras de negócio

| Código | Regra |
|---|---|
| RN01 | Um cliente pode possuir nenhum ou vários veículos. |
| RN02 | Cada veículo pertence a exatamente um cliente. |
| RN03 | Um veículo pode ter nenhuma ou várias ordens de serviço. |
| RN04 | Cada ordem de serviço refere-se a exatamente um veículo. |
| RN05 | Um funcionário pode atender nenhuma ou várias ordens de serviço. |
| RN06 | Cada ordem de serviço possui exatamente um funcionário responsável. |
| RN07 | Cada ordem de serviço gera no máximo um orçamento: a ordem é aberta primeiro e o orçamento só é criado depois da análise do veículo. |
| RN08 | Cada orçamento pertence a exatamente uma ordem de serviço. |
| RN09 | Um orçamento pode possuir nenhum ou vários itens. |
| RN10 | Cada item pertence a exatamente um orçamento. |
| RN11 | Um serviço pode estar em nenhum ou vários itens; um item refere-se a no máximo um serviço. |
| RN12 | Uma peça pode estar em nenhum ou vários itens; um item refere-se a no máximo uma peça. |
| RN13 | Cada item deve referir-se a exatamente um serviço **ou** uma peça, nunca aos dois e nunca a nenhum. |
| RN14 | Cada orçamento possui no máximo um pagamento: o pagamento só é registrado depois que o orçamento é aprovado, e um orçamento que expira sem aprovação não terá pagamento. |
| RN15 | Cada pagamento pertence a exatamente um orçamento. |
| RN16 | Um fornecedor pode fornecer nenhuma ou várias peças. |
| RN17 | Uma peça pode ter nenhum ou vários fornecedores. |
| RN18 | A relação fornecedor/peça registra preço de compra e data de atualização. |
| RN19 | Cada peça possui uma quantidade em estoque registrada. |
| RN20 | Serviços e peças podem ser ativos ou inativos; inativos não devem ser incluídos em novos orçamentos. |
| RN21 | O valor unitário do item é gravado no orçamento e não muda se o preço padrão do serviço ou da peça for alterado depois. |
| RN22 | Um cliente pode solicitar nenhuma ou várias ordens de serviço. |
| RN23 | Cada ordem de serviço é solicitada por exatamente um cliente, que pode ou não ser o proprietário do veículo atendido. |
| RN24 | A quantidade de cada item de orçamento deve ser maior que zero. |
| RN25 | A quantidade em estoque de uma peça não pode ser negativa. |
| RN26 | A ordem de serviço possui status **aberta**, **em andamento** ou **concluída**: nasce aberta, passa a em andamento quando o orçamento é aprovado e a concluída quando o reparo é finalizado. |
| RN27 | O orçamento possui status **pendente**, **aprovado** ou **expirado**: nasce pendente, é aprovado pelo cliente dentro da validade e, se a validade vence sem aprovação, passa a expirado. Orçamento expirado não pode ser aprovado. |
| RN28 | O pagamento possui forma **dinheiro**, **cartão** ou **PIX** e status **pendente** ou **confirmado**. |
| RN29 | CPF/CNPJ do cliente, placa e chassi do veículo, CPF do funcionário e CNPJ do fornecedor não podem se repetir. |
| RN30 | Ao aprovar um orçamento, o estoque das peças dos itens sofre baixa; a aprovação só é permitida se houver quantidade suficiente de cada peça. |
| RN31 | Quando peças são recebidas de um fornecedor, a quantidade recebida é somada ao estoque da peça. |
| RN32 | O pagamento só pode ser registrado para orçamento aprovado e seu valor corresponde ao valor total do orçamento. |

---

## 9. Restrições e políticas organizacionais

### 9.1 Políticas organizacionais

Decisões da empresa que o sistema deve respeitar:

| Código | Política | Origem |
|---|---|---|
| P01 | Cadastro de clientes e veículos e abertura de ordens de serviço são feitos pelo perfil **Atendimento**. | RNF02 |
| P02 | Cadastro e alteração de peças, fornecedores, preços de compra e entrada de peças no estoque são feitos pelo perfil **Estoque**. | RNF02, RN31 |
| P03 | Registro de pagamentos é feito pelo perfil **Financeiro**. | RNF02, RN32 |
| P04 | A aprovação do orçamento é dada pelo cliente e registrada pelo Atendimento dentro da validade; orçamento vencido é identificado como expirado e não é tratado como vigente. | RN27 |
| P05 | Orçamento só é aprovado se houver estoque suficiente das peças; faltando peça, é feita a reposição junto ao fornecedor antes da aprovação. | RN30, RN31 |
| P06 | Reajustes de preço de serviços e peças valem apenas para novos orçamentos; orçamentos já emitidos mantêm o valor gravado. | RN21 |
| P07 | Serviços e peças inativos não são oferecidos em novos orçamentos, mas permanecem no histórico dos orçamentos antigos. | RN20 |
| P08 | Descontos e cancelamentos não foram modelados nesta etapa: eventual desconto é definido nos valores unitários do orçamento antes da aprovação, e a política de cancelamento será levantada com a empresa nas próximas etapas. | RN21 |

### 9.2 Restrições de integridade

Condições estruturais que decorrem das regras de negócio:

1. Um veículo não pode ser cadastrado sem cliente proprietário (RN02).
2. Uma ordem de serviço não pode ser registrada sem cliente solicitante, sem veículo e sem funcionário responsável (RN04, RN06, RN23).
3. Uma ordem de serviço gera no máximo um orçamento, e todo orçamento pertence a uma única ordem (RN07, RN08).
4. Cada item de orçamento representa uma peça ou um serviço (RN13).
5. Toda peça possui controle de estoque, e a quantidade em estoque não pode ser negativa (RN19, RN25).
6. O preço de compra e a data de atualização são registrados por par fornecedor/peça, pois a mesma peça pode ter preços diferentes em fornecedores diferentes (RN18).
7. Cada orçamento possui no máximo um pagamento; todo pagamento pertence a um único orçamento (RN14, RN15).

---

## 10. Fluxogramas

### 10.1 Cadastro e ordem de serviço

```mermaid
flowchart TD
    A([Início]) --> B[Cliente solicita atendimento]
    B --> C{Cliente cadastrado?}
    C -- Não --> D[Cadastrar cliente]
    D --> E
    C -- Sim --> E[Identificar veículo]
    E --> F{Veículo cadastrado?}
    F -- Não --> G[Cadastrar veículo vinculado ao proprietário]
    G --> H
    F -- Sim --> H[Registrar descrição do problema]
    H --> I[Registrar ordem de serviço]
    I --> J[Associar cliente solicitante, veículo e funcionário responsável]
    J --> K[Definir status aberta e previsão de entrega, se conhecida]
    K --> L([Fim])
```

### 10.2 Geração do orçamento

```mermaid
flowchart TD
    A([Início]) --> B[Selecionar ordem de serviço]
    B --> C[Analisar o problema]
    C --> D[Criar orçamento]
    D --> E[Adicionar item]
    E --> F{Serviço ou peça?}
    F -- Serviço --> G[Selecionar serviço ativo]
    F -- Peça --> H[Selecionar peça ativa]
    G --> I[Definir quantidade maior que zero e valor unitário]
    H --> I
    I --> J{Mais itens?}
    J -- Sim --> E
    J -- Não --> K[Calcular valor total]
    K --> L[Definir validade e status pendente]
    L --> M([Fim])
```

### 10.3 Aprovação do orçamento e baixa de estoque

```mermaid
flowchart TD
    A([Início]) --> B[Selecionar orçamento pendente]
    B --> C{Dentro da validade?}
    C -- Não --> D[Definir status expirado]
    D --> Z([Fim])
    C -- Sim --> E{Cliente aprova?}
    E -- Não --> F[Manter pendente até o fim da validade]
    F --> Z
    E -- Sim --> G{Estoque suficiente para as peças?}
    G -- Não --> H[Repor peças pelo fluxo 10.4]
    H --> G
    G -- Sim --> I[Dar baixa no estoque das peças]
    I --> J[Definir status do orçamento como aprovado]
    J --> K[Definir status da ordem de serviço como em andamento]
    K --> Z
```

### 10.4 Peças, fornecedores e entrada de estoque

```mermaid
flowchart TD
    A([Início]) --> B[Identificar peça]
    B --> C{Peça cadastrada?}
    C -- Não --> D[Cadastrar peça]
    D --> E
    C -- Sim --> E[Identificar fornecedor]
    E --> F{Fornecedor cadastrado?}
    F -- Não --> G[Cadastrar fornecedor]
    G --> H
    F -- Sim --> H[Relacionar fornecedor e peça]
    H --> I[Registrar preço de compra e data de atualização]
    I --> J{Peças recebidas do fornecedor?}
    J -- Sim --> K[Registrar entrada e somar ao estoque]
    K --> L([Fim])
    J -- Não --> L
```

### 10.5 Pagamento

```mermaid
flowchart TD
    A([Início]) --> B[Selecionar orçamento]
    B --> C{Orçamento aprovado e sem pagamento?}
    C -- Não --> D[Pagamento não permitido]
    D --> Z([Fim])
    C -- Sim --> E[Conferir valor total]
    E --> F[Registrar data, valor, forma e status]
    F --> G[Associar pagamento ao orçamento]
    G --> Z
```

### 10.6 Visão integrada dos processos

```mermaid
flowchart TD
    A([Início]) --> B[Cadastro e ordem de serviço 10.1]
    B --> C[Geração do orçamento 10.2]
    C --> D[Aprovação e baixa de estoque 10.3]
    P[Peças, fornecedores e entrada de estoque 10.4] -.->|abastece o estoque| D
    D --> E{Orçamento aprovado?}
    E -- Não --> Z([Fim])
    E -- Sim --> F[Executar o reparo]
    E -- Sim --> G[Registrar pagamento 10.5]
    F --> H[Concluir a ordem de serviço]
    H --> Z
    G --> Z
```

**Integração entre os processos.** O cadastro e a ordem de serviço (10.1) alimentam o orçamento (10.2); o orçamento usa serviços e peças cadastrados e, ao ser aprovado (10.3), consome o estoque, que é abastecido pelo processo de peças e fornecedores (10.4); o orçamento aprovado libera o pagamento (10.5) e a execução do reparo, que leva a ordem de serviço a concluída. O fluxo 10.6 resume esse encadeamento.

---

## 11. Entidades

| Entidade | Descrição | Por que existe |
|---|---|---|
| CLIENTE | Proprietário do veículo e/ou solicitante do serviço | Identifica quem solicita e paga o serviço |
| VEICULO | Veículo atendido | Permite histórico por veículo |
| FUNCIONARIO | Responsável pela OS | Identifica quem responde pelo atendimento |
| ORDEM_SERVICO | Atendimento solicitado | Registra problema, prazo e status |
| ORCAMENTO | Proposta de valores da OS | Controla total, validade e aprovação |
| ITEM_ORCAMENTO | Linha do orçamento | Compõe o orçamento com serviço ou peça |
| SERVICO | Serviço oferecido | Catálogo de mão de obra |
| PECA | Peça utilizada | Catálogo e estoque |
| FORNECEDOR | Quem fornece peças | Identifica a origem das peças |
| FORNECEDOR_PECA | Associativa fornecedor/peça | Resolve o N:N e guarda preço de compra e data |
| PAGAMENTO | Pagamento do orçamento | Controle financeiro |

---

## 12. Atributos

Classificação: **identificador** (chave primária), **obrigatório**, **opcional** e **derivado** (calculado a partir de outros). Todos os atributos são monovalorados. Os atributos são tratados como simples; a única exceção em potencial é `endereco` (FORNECEDOR), mantido como um campo único de texto nesta etapa e que poderá ser decomposto (logradouro, cidade, etc.) no modelo lógico.

| Entidade | Identificador | Obrigatórios | Opcionais | Derivados |
|---|---|---|---|---|
| CLIENTE | id_cliente | nome, cpf_cnpj | telefone | — |
| VEICULO | id_veiculo | placa, chassi, marca, modelo | cor, ano | — |
| FUNCIONARIO | id_funcionario | nome, cpf, cargo, data_contratacao | telefone | — |
| ORDEM_SERVICO | id_os | data_abertura, descricao_problema, status | previsao_entrega | — |
| ORCAMENTO | id_orcamento | data_orcamento, validade, status | — | valor_total (soma dos itens) |
| ITEM_ORCAMENTO | id_item | quantidade, valor_unitario | — | valor_total (quantidade × valor_unitario) |
| SERVICO | id_servico | descricao, valor_padrao, ativo | tempo_padrao_horas | — |
| PECA | id_peca | descricao, preco_unitario, estoque, ativo | — | — |
| FORNECEDOR | id_fornecedor | nome, cnpj | endereco, telefone, email | — |
| FORNECEDOR_PECA | combinação FORNECEDOR + PECA | preco_compra, data_atualizacao | — | — |
| PAGAMENTO | id_pagamento | data_pagamento, valor, forma_pagamento, status | — | — |

Os atributos derivados são calculados a partir de outros atributos do modelo; se o valor será armazenado ou calculado na consulta é uma decisão do modelo lógico (ver seção 17).

As chaves estrangeiras não são atributos do modelo conceitual: elas surgem do mapeamento dos relacionamentos no modelo lógico (prévia na seção 16). Os vínculos entre as entidades estão nas seções 13 e 14.

---

## 13. Relacionamentos

| Relacionamento | Entidades | Leitura |
|---|---|---|
| possui | CLIENTE — VEICULO | Um cliente possui veículos |
| solicita | CLIENTE — ORDEM_SERVICO | Um cliente solicita ordens de serviço |
| associado_a | VEICULO — ORDEM_SERVICO | Um veículo é associado a ordens de serviço |
| atende | FUNCIONARIO — ORDEM_SERVICO | Um funcionário atende ordens de serviço |
| gera | ORDEM_SERVICO — ORCAMENTO | Uma ordem gera, no máximo, um orçamento |
| contem | ORCAMENTO — ITEM_ORCAMENTO | Um orçamento contém itens |
| utilizado_em | SERVICO — ITEM_ORCAMENTO | Um serviço é utilizado em itens |
| compoe | PECA — ITEM_ORCAMENTO | Uma peça compõe itens |
| gera_pagamento | ORCAMENTO — PAGAMENTO | Um orçamento aprovado gera, no máximo, um pagamento |
| fornece | FORNECEDOR — FORNECEDOR_PECA | Um fornecedor fornece peças |
| participa | PECA — FORNECEDOR_PECA | Uma peça participa de fornecimentos |

### Atributos dos relacionamentos

| Relacionamento | Possui atributo próprio? | Justificativa |
|---|---|---|
| FORNECEDOR — PECA (N:N) | **Sim:** preco_compra, data_atualizacao | O preço de compra não descreve só o fornecedor nem só a peça, e sim o fornecimento daquela peça por aquele fornecedor (RN18). Por isso o relacionamento vira a entidade associativa FORNECEDOR_PECA. |
| Demais relacionamentos | Não | São 1:1 ou 1:N; qualquer informação descreve diretamente uma das entidades (quantidade e valor_unitario descrevem o item, não o vínculo orçamento–serviço). |

---

## 14. Cardinalidades

Método **"vá e volte"**: cada relacionamento foi analisado nos dois sentidos. Notação: ENTIDADE (mín,máx) — relacionamento — ENTIDADE (mín,máx), em que a cardinalidade ao lado de cada entidade indica com quantas ocorrências da outra entidade ela se relaciona.

| Relacionamento | Vá | Volta | Tipo | Regra |
|---|---|---|---|---|
| CLIENTE (0,N) — possui — VEICULO (1,1) | Um cliente possui quantos veículos? **0,N** | Um veículo pertence a quantos clientes? **1,1** | 1:N | RN01, RN02 |
| CLIENTE (0,N) — solicita — ORDEM_SERVICO (1,1) | Um cliente solicita quantas ordens? **0,N** | Uma ordem é solicitada por quantos clientes? **1,1** | 1:N | RN22, RN23 |
| VEICULO (0,N) — associado_a — ORDEM_SERVICO (1,1) | Um veículo tem quantas ordens? **0,N** | Uma ordem refere-se a quantos veículos? **1,1** | 1:N | RN03, RN04 |
| FUNCIONARIO (0,N) — atende — ORDEM_SERVICO (1,1) | Um funcionário atende quantas ordens? **0,N** | Uma ordem tem quantos responsáveis? **1,1** | 1:N | RN05, RN06 |
| ORDEM_SERVICO (0,1) — gera — ORCAMENTO (1,1) | Uma ordem gera quantos orçamentos? **0,1** | Um orçamento pertence a quantas ordens? **1,1** | 1:1 | RN07, RN08 |
| ORCAMENTO (0,N) — contem — ITEM_ORCAMENTO (1,1) | Um orçamento tem quantos itens? **0,N** | Um item pertence a quantos orçamentos? **1,1** | 1:N | RN09, RN10 |
| SERVICO (0,N) — utilizado_em — ITEM_ORCAMENTO (0,1) | Um serviço está em quantos itens? **0,N** | Um item tem quantos serviços? **0,1** | 1:N | RN11, RN13 |
| PECA (0,N) — compoe — ITEM_ORCAMENTO (0,1) | Uma peça está em quantos itens? **0,N** | Um item tem quantas peças? **0,1** | 1:N | RN12, RN13 |
| ORCAMENTO (0,1) — gera_pagamento — PAGAMENTO (1,1) | Um orçamento tem quantos pagamentos? **0,1** | Um pagamento pertence a quantos orçamentos? **1,1** | 1:1 | RN14, RN15, RN32 |
| FORNECEDOR (0,N) — fornece — PECA (0,N) | Um fornecedor fornece quantas peças? **0,N** | Uma peça tem quantos fornecedores? **0,N** | N:N | RN16, RN17 |

**Leitura dos relacionamentos 1:1.** Em ORDEM_SERVICO—ORCAMENTO e em ORCAMENTO—PAGAMENTO o mínimo é 0 do lado da ordem e do orçamento porque o processo é sequencial (seção 10): a ordem é aberta antes de existir orçamento, e o orçamento só gera pagamento depois de aprovado (um orçamento expirado sem aprovação nunca terá pagamento). Já o orçamento sempre pertence a uma ordem e o pagamento sempre pertence a um orçamento, por isso o lado de baixo é (1,1).

### Verificação de relacionamentos N:N

Só é N:N quando a resposta é "vários" nos **dois** sentidos.

| Par | A → B vários? | B → A vários? | N:N? |
|---|---|---|---|
| Cliente — Veículo | Sim | Não | Não |
| Cliente — Ordem de serviço | Sim | Não | Não |
| Veículo — Ordem de serviço | Sim | Não | Não |
| Funcionário — Ordem de serviço | Sim | Não | Não |
| Ordem de serviço — Orçamento | Não | Não | Não |
| Orçamento — Item | Sim | Não | Não |
| Serviço — Item | Sim | Não | Não |
| Peça — Item | Sim | Não | Não |
| Orçamento — Pagamento | Não | Não | Não |
| **Fornecedor — Peça** | **Sim** | **Sim** | **Sim** |

O único N:N é Fornecedor — Peça, resolvido por **FORNECEDOR_PECA**:

- FORNECEDOR (0,N) — fornece — FORNECEDOR_PECA (1,1)
- PECA (0,N) — participa — FORNECEDOR_PECA (1,1)

---

## 15. Dicionário de dados conceitual

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

## 16. DER

Notação: o DER é conceitual, por isso não mostra chaves estrangeiras (os vínculos são representados pelos relacionamentos). Retângulos são entidades (identificador sublinhado, atributos opcionais e derivados indicados ao lado do nome), losangos são relacionamentos (com os códigos das regras de negócio que os sustentam) e as cardinalidades (mín,máx) aparecem ao lado de cada entidade, como na seção 14. Uma prévia das chaves estrangeiras (modelo lógico) está ao final desta seção.

![Diagrama Entidade-Relacionamento](diagramas/DER.png)

> **RN13:** a linha tracejada vermelha entre `utilizado_em` e `compoe` indica que cada item de orçamento refere-se a **exatamente um** dos dois: um serviço **ou** uma peça, nunca aos dois e nunca a nenhum. As cardinalidades (0,1) do lado do item expressam que cada vínculo, isoladamente, é opcional; a obrigatoriedade de existir um dos dois vem da RN13.
>
> **FORNECEDOR_PECA:** o N:N entre FORNECEDOR e PECA foi decomposto já no modelo conceitual, de forma intencional, em uma entidade associativa que guarda `preco_compra` e `data_atualizacao` (RN18). Ela é identificada pela combinação das duas entidades e se liga a cada uma por um relacionamento (0,N)—(1,1).
>
> **Atributos derivados** (em marrom no desenho): `valor_total` de ORCAMENTO (soma dos itens) e `valor_total` de ITEM_ORCAMENTO (quantidade × valor_unitario), conforme a seção 12.

**Prévia para o modelo lógico — chaves primárias e estrangeiras**

O DER é conceitual e não mostra chaves estrangeiras. A tabela abaixo apenas antecipa como os relacionamentos serão implementados na próxima etapa.

| Tabela | Chave primária | Chaves estrangeiras |
|---|---|---|
| CLIENTE | id_cliente | — |
| VEICULO | id_veiculo | id_cliente |
| FUNCIONARIO | id_funcionario | — |
| ORDEM_SERVICO | id_os | id_cliente, id_veiculo, id_funcionario |
| ORCAMENTO | id_orcamento | id_os |
| PAGAMENTO | id_pagamento | id_orcamento |
| SERVICO | id_servico | — |
| PECA | id_peca | — |
| FORNECEDOR | id_fornecedor | — |
| ITEM_ORCAMENTO | id_item | id_orcamento, id_servico, id_peca |
| FORNECEDOR_PECA | id_fornecedor + id_peca | id_fornecedor, id_peca |

---

## 17. Justificativas técnicas

Cada decisão responde: **o que decidimos, por que, e qual regra ou necessidade a sustenta.**

### 17.1 Decisões de modelagem

| O que decidimos | Por que | Regra / necessidade |
|---|---|---|
| Cliente (0,N) e veículo (1,1) em CLIENTE—VEICULO | Um cliente pode estar cadastrado sem veículo e ter vários; um veículo nunca existe sem proprietário. | RN01, RN02 |
| Veículo (0,N) e ordem (1,1) em VEICULO—ORDEM_SERVICO | Um veículo novo ainda não tem ordens e pode ter várias ao longo do tempo; cada ordem trata de um único veículo. | RN03, RN04 |
| Funcionário (0,N) e ordem (1,1) em FUNCIONARIO—ORDEM_SERVICO | Um funcionário pode ainda não ter atendimentos; cada ordem tem exatamente um responsável. | RN05, RN06 |
| **Manter o relacionamento CLIENTE—ORDEM_SERVICO (solicita)**, além do vínculo com o veículo | Quem solicita e paga o serviço nem sempre é o proprietário do veículo (como um familiar ou o motorista de uma empresa). Guardar o solicitante na ordem também preserva o histórico se o proprietário do veículo mudar, por venda do carro. Por isso não é redundância: são papéis diferentes (proprietário do veículo × solicitante do serviço). | RN22, RN23 |
| ORDEM_SERVICO (0,1) e ORCAMENTO (1,1) em ORDEM_SERVICO—ORCAMENTO (1:1), em entidades separadas | A ordem é aberta antes do orçamento: na abertura ainda não há orçamento, por isso o mínimo é 0 do lado da ordem. Todo orçamento nasce de uma ordem, por isso é (1,1). A ordem registra o atendimento (problema, prazo, responsável); o orçamento registra valores, itens, validade e aprovação, com status próprio. | RN07, RN08, RN26, RN27 |
| ORCAMENTO—ITEM_ORCAMENTO como 1:N | Um orçamento é composto por vários itens e cada item pertence a um só orçamento. | RN09, RN10 |
| ITEM_ORCAMENTO ligado a SERVICO (0,1) e a PECA (0,1), com exclusividade | Uma única entidade permite compor o orçamento com serviços e peças. Cada item refere-se a exatamente um dos dois, o que explica a cardinalidade (0,1) do lado do item em cada relacionamento e a regra de exclusividade (linha tracejada no DER). Na implementação física, deve ser garantido por restrição (CHECK). | RN11, RN12, RN13 |
| `valor_total` do item e do orçamento tratados como atributos derivados | São calculados (quantidade × valor_unitario; soma dos itens) e, como o `valor_unitario` é congelado no item, o resultado não muda depois de emitido. Se o valor será armazenado ou calculado na consulta é decisão do modelo lógico. | RF14, RN21 |
| `valor_unitario` copiado para o item | Congela o preço do momento do orçamento; reajustes futuros não alteram orçamentos antigos. | RN21 |
| ORCAMENTO (0,1) e PAGAMENTO (1,1) em ORCAMENTO—PAGAMENTO (1:1), em entidades separadas | O pagamento só existe depois que o orçamento é aprovado, e um orçamento pode expirar sem aprovação e sem pagamento, por isso o mínimo é 0 do lado do orçamento. Todo pagamento pertence a um orçamento, por isso é (1,1). O pagamento tem dados e status próprios, o que o torna uma entidade e facilita evoluir para vários pagamentos no futuro. | RN14, RN15, RN28, RN32 |
| Fornecedor—Peça considerado N:N | Um fornecedor fornece várias peças e uma peça pode ter vários fornecedores. | RN16, RN17 |
| Criar a entidade associativa FORNECEDOR_PECA | O N:N precisa ser decomposto em duas relações 1:N e há informação própria do fornecimento. | RN16, RN17, RN18 |
| `preco_compra` e `data_atualizacao` pertencem ao relacionamento, não a PECA nem a FORNECEDOR | O preço varia conforme o par fornecedor/peça: a mesma peça tem preços diferentes em fornecedores diferentes. | RN18, RF17 |
| FORNECEDOR_PECA identificada pela combinação FORNECEDOR + PECA (no modelo lógico, chave primária composta por `id_fornecedor` + `id_peca`) | A combinação dos dois identifica de forma única cada fornecimento e impede registrar o mesmo par duas vezes. | RN16, RN17 |
| Atributo `ativo` em SERVICO e PECA em vez de exclusão | Preserva o histórico de orçamentos antigos que usaram o cadastro. | RN20 |
| Atributo `estoque` em PECA, com baixa na aprovação do orçamento e entrada no recebimento | Cada peça precisa de quantidade controlada que reflita o que foi comprometido em orçamentos aprovados e o que foi recebido de fornecedores. Nesta etapa o estoque é apenas somado ou baixado; o histórico de cada movimentação fica para etapas futuras. | RN19, RN25, RN30, RN31, RF15, RF23, RF24 |
| Atributos `status` em ORDEM_SERVICO, ORCAMENTO e PAGAMENTO | Substituem a consulta ao responsável ou ao papel, que é um dos problemas identificados; cada status tem valores e transições definidos nas regras. | RN26, RN27, RN28, RF21, RF22 |
| Identificador próprio (id_*) em todas as entidades | Identificação única de cada ocorrência; na etapa lógica servirá de base para as chaves estrangeiras, preservando a integridade. | RNF04 |
| DER sem chaves estrangeiras | O DER é conceitual: os vínculos são representados pelos relacionamentos e suas cardinalidades; as chaves estrangeiras surgem no modelo lógico (prévia na seção 16). | Etapas 16 e 17 do manual da entrega |
| Usuário, perfil de acesso e registro de operações **não** modelados como entidades nesta etapa | RNF02 e RNF03 são requisitos não funcionais e descrevem como o sistema deve operar (autenticação, perfis, auditoria), não informações do negócio da funilaria. Serão avaliados no modelo lógico, quando se definir como o sistema autentica usuários e registra operações; as políticas P01 a P03 já definem quais perfis existem. | RNF02, RNF03, P01–P03 |

### 17.2 Justificativa dos atributos

| Atributo | Por que existe nesta entidade |
|---|---|
| CLIENTE.`cpf_cnpj` | Identifica pessoa física ou empresa e evita o cadastro duplicado do mesmo cliente, problema da ficha de papel (RN29). |
| CLIENTE.`telefone` | Contato do cliente; opcional porque pode ser informado depois. |
| VEICULO.`placa`, `chassi` | Identificam o veículo e permitem localizar o histórico de atendimentos sem procurar entre fichas (RN29). |
| VEICULO.`marca`, `modelo` | Identificam o veículo no atendimento e no orçamento. |
| VEICULO.`cor`, `ano` | Constam na ficha atual de atendimento, mas não são necessários para abrir a OS, por isso opcionais. |
| FUNCIONARIO.`cpf` | Identifica o funcionário e evita duplicidade (RN29). |
| FUNCIONARIO.`cargo` | Registra a função exercida e apoia o controle de acesso por perfil (RNF02). |
| FUNCIONARIO.`data_contratacao` | Dado cadastral do funcionário, mantido para o registro de pessoal; não é usado nos processos desta etapa. |
| ORDEM_SERVICO.`data_abertura` | Registra quando o atendimento começou e sustenta o histórico por veículo (RF19). |
| ORDEM_SERVICO.`descricao_problema` | A ordem nasce da queixa do cliente; é a base da análise e do orçamento. |
| ORDEM_SERVICO.`previsao_entrega` | A ficha atual já informa a previsão; é opcional porque pode ser definida só após a análise do veículo. |
| ORDEM_SERVICO.`status` | Permite saber o andamento sem perguntar ao responsável (RN26, RF22). |
| ORCAMENTO.`data_orcamento`, `validade` | Definem por quanto tempo os valores propostos valem; a validade sustenta a expiração (RN27). |
| ORCAMENTO.`status` | Registra se foi aprovado ou expirou, o que libera o pagamento e a baixa de estoque (RN27, RN30, RN32). |
| ITEM_ORCAMENTO.`quantidade` | Quantas unidades do serviço ou da peça compõem a linha; base do cálculo e da baixa de estoque (RN24, RN30). |
| SERVICO.`valor_padrao`, PECA.`preco_unitario` | Valores de referência que evitam reescrever preços a cada orçamento; o valor cobrado é gravado no item (RN21). |
| SERVICO.`tempo_padrao_horas` | Apoia a definição da previsão de entrega; opcional por não ser conhecido para todo serviço. |
| PECA.`estoque` | Controla a quantidade disponível, corrigindo a divergência da contagem manual (RN19, RN25, RN30, RN31). |
| FORNECEDOR.`cnpj` | Identifica a empresa fornecedora e evita duplicidade (RN29). |
| FORNECEDOR.`endereco`, `telefone`, `email` | Meios de contato com o fornecedor; hoje os preços são combinados por telefone ou mensagem; opcionais por nem sempre estarem disponíveis. |
| PAGAMENTO.`valor` | Valor recebido, que deve corresponder ao total do orçamento (RN32). |
| PAGAMENTO.`forma_pagamento`, `status` | Registram como e se o pagamento foi concluído, o que hoje não fica claro no caixa ou no recibo de papel (RN28). |

### 17.3 Escalabilidade e integração

**Integração.** As entidades formam uma cadeia ligada por relacionamentos: CLIENTE → VEICULO → ORDEM_SERVICO (ligada também ao CLIENTE solicitante) → ORCAMENTO → ITEM_ORCAMENTO → SERVICO/PECA → FORNECEDOR_PECA → FORNECEDOR, e ORCAMENTO → PAGAMENTO. Um dado cadastrado em um processo é reaproveitado nos seguintes, sem redigitação, e o estoque conecta orçamento (baixa) e fornecimento (entrada).

**Preparação para evolução.** O modelo permite, nas próximas etapas, sem refazer a base:

- transformar ORCAMENTO—PAGAMENTO em 1:N, caso a empresa passe a receber sinal e parcelas;
- criar tabelas de domínio para status e forma de pagamento;
- decompor `endereco` de FORNECEDOR (e de CLIENTE, se necessário) em atributos separados;
- registrar o histórico de movimentações de estoque e o histórico de preços de compra;
- incluir usuário, perfil e registro de operações para atender RNF02 e RNF03;
- tratar descontos e cancelamentos, caso a empresa defina essas políticas (P08).

---

## 18. Modelo lógico

O modelo lógico transforma entidades, relacionamentos e cardinalidades em tabelas, chaves primárias (PK), chaves estrangeiras (FK) e restrições. Fio condutor: **regra de negócio → modelo lógico → restrição → DDL → teste**.

![Modelo lógico](modelo_logico/modelo_logico.png)

### 18.1 Regras de mapeamento do DER para o modelo lógico

- Entidade → tabela; o identificador vira a chave primária (`INT AUTO_INCREMENT`).
- Relacionamento 1:N → FK no lado N (`NOT NULL` quando a cardinalidade mínima do lado N é 1): `veiculo.id_cliente` (RN02), `ordem_servico.id_cliente`, `id_veiculo`, `id_funcionario` (RN23, RN04, RN06) e `item_orcamento.id_orcamento` (RN10).
- Relacionamento 1:1 → FK no lado (1,1) com `UNIQUE`: `orcamento.id_os` (RN07, RN08) e `pagamento.id_orcamento` (RN14, RN15).
- Relacionamento N:N → tabela associativa: `fornecedor_peca` com PK composta (`id_fornecedor`, `id_peca`) e os atributos `preco_compra` e `data_atualizacao` (RN16, RN17, RN18).
- Exclusividade RN13 → duas FK opcionais em `item_orcamento` + `CHECK` que exige exatamente uma delas preenchida.
- Atributos derivados (`valor_total`) não são armazenados: são calculados pelas visões `vw_item_orcamento` e `vw_orcamento_total`.
- Domínios fechados (status, forma de pagamento) → `VARCHAR` + `CHECK ... IN (...)` (RN26, RN27, RN28).

### 18.2 Classificação das entidades (forte, fraca e associativa)

| Tabela | Classificação | Justificativa |
|---|---|---|
| CLIENTE, FUNCIONARIO, SERVICO, PECA, FORNECEDOR | Forte | Identificador próprio, existem sem depender de outra tabela. |
| VEICULO, ORDEM_SERVICO, ORCAMENTO, PAGAMENTO | Forte (com FK) | Ter FK não torna a entidade fraca: a identidade não é composta pela chave de outra tabela. |
| ITEM_ORCAMENTO | Fraca (dependência existencial) | Como a linha de um cupom fiscal, o item perde o sentido sem o orçamento (RN10). Mantém `id_item` como chave substituta (conveniência técnica); a dependência é imposta por `id_orcamento NOT NULL` + FK com `ON DELETE CASCADE`. |
| FORNECEDOR_PECA | Associativa | Resolve o N:N entre FORNECEDOR e PECA, com PK composta e atributos próprios (RN18). |

---

## 19. Normalização

Todas as tabelas foram verificadas até a 3FN.

- **1FN:** atributos atômicos, sem grupos repetitivos (`endereco` de FORNECEDOR fica como texto único nesta etapa).
- **2FN:** só `fornecedor_peca` tem PK composta, e `preco_compra` e `data_atualizacao` dependem do par inteiro (RN18). As demais têm PK simples.
- **3FN:** sem dependências transitivas. `valor_total` não é armazenado. `ordem_servico.id_cliente` (solicitante) não é determinado por `id_veiculo`, pois o solicitante pode ser diferente do proprietário (RN23). `valor_unitario` é um fato do item, congelado por RN21.

---

## 20. Implementação em SQL e testes de integridade

Scripts para MySQL 8.0.16+ (InnoDB), validados também em MariaDB 10.11. Todos os dados são fictícios. Execute na ordem:

| Script | Conteúdo |
|---|---|
| [`sql/01_estrutura.sql`](sql/01_estrutura.sql) | Cria o banco `prime_funilaria`, as 11 tabelas, as restrições e as 2 visões. |
| [`sql/02_carga_valida.sql`](sql/02_carga_valida.sql) | Insere 42 registros válidos (pais primeiro, depois dependentes). |
| [`sql/03_testes_integridade.sql`](sql/03_testes_integridade.sql) | 15 tentativas inválidas, 3 UPDATE, 1 DELETE controlado e 4 SELECT. |

### 20.1 Origem de cada restrição

| Regra | Restrição no banco | Tabela |
|---|---|---|
| RN02, RN04, RN06, RN23 | FK `NOT NULL` | veiculo, ordem_servico |
| RN07, RN08 | `UNIQUE` + `NOT NULL` + FK em `id_os` | orcamento |
| RN10 | `NOT NULL` + FK com `ON DELETE CASCADE` | item_orcamento |
| RN13 | `CHECK` de exclusividade serviço/peça | item_orcamento |
| RN14, RN15 | `UNIQUE` + `NOT NULL` + FK em `id_orcamento` | pagamento |
| RN16, RN17, RN18 | PK composta + duas FK | fornecedor_peca |
| RN20 | `CHECK (ativo IN (0,1))` | servico, peca |
| RN24 | `CHECK (quantidade > 0)` | item_orcamento |
| RN25 | `CHECK (estoque >= 0)` | peca |
| RN26 | `CHECK` da lista de status da OS | ordem_servico |
| RN27 | `CHECK` do status e `validade >= data_orcamento` | orcamento |
| RN28 | `CHECK` de forma e status do pagamento | pagamento |
| RN29 | `UNIQUE` em cpf_cnpj, placa, chassi, cpf, cnpj | cliente, veiculo, funcionario, fornecedor |

### 20.2 Tentativas inválidas (todas rejeitadas pelo SGBD)

| Teste | Comando | Restrição violada | Regra protegida |
|---|---|---|---|
| T01 | INSERT cliente com `id_cliente` já existente | PK duplicada (erro 1062) | Identidade única do cliente |
| T02 | INSERT veículo com `id_cliente = 9999` | FK (erro 1452) | RN02 |
| T03 | INSERT cliente com CPF/CNPJ repetido | UNIQUE (erro 1062) | RN29 |
| T04 | INSERT cliente com `nome` nulo | NOT NULL (erro 1048) | Nome obrigatório |
| T05 | INSERT peça com estoque -5 | CHECK (erro 4025) | RN25 |
| T06 | INSERT item com quantidade 0 | CHECK (erro 4025) | RN24 |
| T07 | INSERT item com serviço **e** peça | CHECK de exclusividade | RN13 |
| T08 | INSERT item sem serviço e sem peça | CHECK de exclusividade | RN13 |
| T09 | Segundo orçamento para a mesma OS | UNIQUE em `id_os` | RN07 |
| T10 | Segundo pagamento para o mesmo orçamento | UNIQUE em `id_orcamento` | RN14 |
| T11 | Repetir o par fornecedor/peça | PK composta | RN16/RN17 |
| T12 | UPDATE status da OS para `CANCELADA` | CHECK | RN26 |
| T13 | Orçamento com validade anterior à data | CHECK | RN27 |
| T14 | UPDATE baixando 10 de estoque com saldo 2 | CHECK | RN25/RN30 |
| T15 | DELETE de cliente com veículos/OS | FK em DELETE (erro 1451) | RN02 |

O comando completo, a mensagem real do SGBD e a correção de cada teste estão no relatório em PDF e em `sql/03_testes_integridade.sql`.

### 20.3 Regras que não cabem em uma constraint simples

RN27 (expiração e transições de status), RN30 (baixa de estoque na aprovação), RN31 (entrada de peças soma ao estoque), RN32 (pagamento só de orçamento aprovado e igual ao total) e as permissões por perfil (P01 a P03) dependem de mais de uma tabela, de sequência ou da data corrente. Ficam documentadas para tratamento na lógica da aplicação.

---

## 21. Conclusão

A modelagem organiza os principais dados e processos da Prime Funilaria, de clientes e veículos até o pagamento, passando por ordens de serviço, orçamentos, aprovação, estoque, serviços, peças e fornecedores. O DER foi construído a partir dos processos, requisitos e regras de negócio levantados, e cada entidade, atributo, relacionamento e cardinalidade tem justificativa ligada a uma regra. O modelo conceitual foi transformado em modelo lógico, verificado até a 3FN e implementado em SQL, onde as restrições derivadas das regras de negócio foram testadas e rejeitaram corretamente os dados inválidos.

---

### Anexo — Estrutura do repositório

```
projeto-funilaria/
├── README.md
├── diagramas/
│   └── DER.png
├── modelo_logico/
│   └── modelo_logico.png
├── sql/
│   ├── 01_estrutura.sql
│   ├── 02_carga_valida.sql
│   └── 03_testes_integridade.sql
└── documentos/
    ├── dicionario_de_dados.pdf
    └── DIARIO DE BORDO_000205.pdf
```

- [DER (imagem)](diagramas/DER.png)
- [Modelo lógico (imagem)](modelo_logico/modelo_logico.png)
- [Scripts SQL](sql/)
- [Dicionário de dados conceitual (PDF)](documentos/dicionario_de_dados.pdf)
- [Diário de bordo (PDF)](documentos/DIARIO%20DE%20BORDO_000205.pdf)
