# Evidências de execução dos testes de integridade

Gerado em 2026-11-06 com **MariaDB 10.11.14** (executado a partir de um banco vazio: `01_estrutura.sql` → `02_carga_valida.sql` → `03_testes_integridade.sql`, um comando por vez).

Os testes **T01 a T15** são inválidos e **devem ser rejeitados**. Os comandos **U1 a U3** e **D1** são válidos e **devem ser aceitos**. Todos os resultados abaixo conferem com o esperado.

| Teste | Tipo de restrição | Regra protegida | Resultado | Código | Mensagem do SGBD (resumo) |
|---|---|---|---|---|---|
| T01 | PK duplicada | Identidade unica do cliente (PRIMARY KEY) -> PK deve rejeitar | Rejeitado - erro 1062 | 1062 | `Duplicate entry '1' for key 'PRIMARY'` |
| T02 | FK invalida | RN02 - todo veiculo pertence a um cliente existente -> FK deve rejeitar | Rejeitado - erro 1452 | 1452 | `Cannot add or update a child row: a foreign key constraint fails (`prime_funilaria`.`veiculo`, CONSTRAINT `fk_veiculo_cliente` FOREIGN KEY (` |
| T03 | UNIQUE | RN29 - CPF/CNPJ do cliente nao pode se repetir -> UNIQUE deve rejeitar | Rejeitado - erro 1062 | 1062 | `Duplicate entry '11122233344' for key 'uq_cliente_cpf_cnpj'` |
| T04 | NOT NULL | Nome do cliente e obrigatorio -> NOT NULL deve rejeitar | Rejeitado - erro 1048 | 1048 | `Column 'nome' cannot be null` |
| T05 | CHECK | RN25 - estoque da peca nao pode ser negativo -> CHECK deve rejeitar | Rejeitado - erro 4025 | 4025 | `CONSTRAINT `ck_peca_estoque` failed for `prime_funilaria`.`peca`` |
| T06 | CHECK | RN24 - quantidade do item deve ser maior que zero -> CHECK deve rejeitar | Rejeitado - erro 4025 | 4025 | `CONSTRAINT `ck_item_quantidade` failed for `prime_funilaria`.`item_orcamento`` |
| T07 | Regra do ERP (RN13) | RN13 - item e servico OU peca, nunca os dois -> CHECK de exclusividade deve rejeitar | Rejeitado - erro 4025 | 4025 | `CONSTRAINT `ck_item_servico_ou_peca` failed for `prime_funilaria`.`item_orcamento`` |
| T08 | Regra do ERP (RN13) | RN13 - item nao pode ficar sem servico e sem peca -> CHECK de exclusividade deve rejeitar | Rejeitado - erro 4025 | 4025 | `CONSTRAINT `ck_item_servico_ou_peca` failed for `prime_funilaria`.`item_orcamento`` |
| T09 | UNIQUE (1:1) | RN07 - cada OS gera no maximo um orcamento -> UNIQUE em id_os deve rejeitar | Rejeitado - erro 1062 | 1062 | `Duplicate entry '1' for key 'uq_orcamento_os'` |
| T10 | UNIQUE (1:1) | RN14 - cada orcamento possui no maximo um pagamento -> UNIQUE em id_orcamento deve rejeitar | Rejeitado - erro 1062 | 1062 | `Duplicate entry '1' for key 'uq_pagamento_orcamento'` |
| T11 | PK composta | RN16/RN17 - o par fornecedor/peca nao se repete -> PK composta deve rejeitar | Rejeitado - erro 1062 | 1062 | `Duplicate entry '1-1' for key 'PRIMARY'` |
| T12 | CHECK | RN26 - status da OS restrito a aberta/em andamento/concluida -> CHECK deve rejeitar | Rejeitado - erro 4025 | 4025 | `CONSTRAINT `ck_os_status` failed for `prime_funilaria`.`ordem_servico`` |
| T13 | CHECK | Validade do orcamento nao pode ser anterior a data de criacao -> CHECK deve rejeitar | Rejeitado - erro 4025 | 4025 | `CONSTRAINT `ck_orcamento_validade` failed for `prime_funilaria`.`orcamento`` |
| T14 | CHECK (baixa de estoque) | RN25/RN30 - baixa maior que o estoque disponivel -> CHECK deve rejeitar | Rejeitado - erro 4025 | 4025 | `CONSTRAINT `ck_peca_estoque` failed for `prime_funilaria`.`peca`` |
| T15 | FK em DELETE | RN02 - cliente com veiculos/ordens nao pode ser excluido -> FK deve rejeitar | Rejeitado - erro 1451 | 1451 | `Cannot delete or update a parent row: a foreign key constraint fails (`prime_funilaria`.`ordem_servico`, CONSTRAINT `fk_os_cliente` FOREIGN ` |

## Comandos válidos (efeito esperado)

| Comando | Descrição | Resultado |
|---|---|---|
| U1 | UPDATE RN27 - cliente aprova o orcamento pendente dentro da validade | Aceito (comando valido) |
| U2 | UPDATE RN30 - baixa de estoque das pecas do orcamento aprovado (com saldo suficiente) | Aceito (comando valido) |
| U3 | UPDATE RN26 - OS passa a em andamento quando o orcamento e aprovado | Aceito (comando valido) |
| D1 | DELETE DELETE controlado (com WHERE): remove o item de um orcamento expirado | Aceito (comando valido) |
