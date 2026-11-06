# Revisão da primeira entrega — Prime Funilaria

Este documento registra as correções feitas no modelo conceitual da primeira entrega ao construir o modelo lógico, conforme a etapa 2 do manual ("registrem as principais alterações") e o item 1 da seção 3 ("Revisão da primeira entrega").

## 1. Revisão do DER

O DER (`diagramas/DER.png`) foi revisado com a pergunta da etapa 1: "Nosso DER ainda representa corretamente o negócio?" Conferidos requisitos, regras de negócio, entidades, atributos, relacionamentos, cardinalidades, entidade associativa e possíveis entidades fracas.

Resultado: **as entidades, os relacionamentos e as cardinalidades foram mantidos**. O modelo conceitual já representava corretamente o negócio. As mudanças foram de **implementação**, documentadas abaixo, e não de decisão de modelagem.

## 2. Alterações principais (como era × como ficou)

| O que foi alterado | Como era (conceitual) | Como ficou (lógico/físico) | Por que alteramos | Regra |
|---|---|---|---|---|
| `valor_total` de ORCAMENTO e ITEM_ORCAMENTO | Atributo derivado no DER | Não armazenado; calculado pelas visões `vw_item_orcamento` e `vw_orcamento_total` | Evitar redundância e inconsistência (3FN, ver `docs/normalizacao.md`, caso 2) | RF14 |
| Status da OS, do orçamento e do pagamento | Lista de valores descrita no dicionário | Domínio fechado com `CHECK ... IN (...)` | Impedir valores fora do processo, como "CANCELADA" | RN26, RN27, RN28 |
| Exclusividade serviço × peça em ITEM_ORCAMENTO | Linha tracejada vermelha no DER | `CHECK` que exige exatamente um entre `id_servico` e `id_peca` | Transformar a regra do diagrama em restrição verificável pelo banco | RN13 |
| Cardinalidade 1:1 ORDEM_SERVICO—ORCAMENTO | (0,1)—(1,1) no DER | `id_os` em ORCAMENTO com `UNIQUE` e `NOT NULL` | Garantir que cada OS gere no máximo um orçamento | RN07, RN08 |
| Cardinalidade 1:1 ORCAMENTO—PAGAMENTO | (0,1)—(1,1) no DER | `id_orcamento` em PAGAMENTO com `UNIQUE` e `NOT NULL` | Garantir no máximo um pagamento por orçamento | RN14, RN15 |
| Relacionamento N:N FORNECEDOR—PECA | Entidade associativa FORNECEDOR_PECA | PK composta `(id_fornecedor, id_peca)` com `preco_compra` e `data_atualizacao` | Impedir par duplicado e manter o preço por fornecedor | RN16, RN17, RN18 |
| CPF/CNPJ, placa, chassi, CPF do funcionário e CNPJ do fornecedor | Identificadores únicos descritos no dicionário | `UNIQUE` em cada coluna; CPF/CNPJ armazenados só com dígitos e com tamanho validado | Evitar cadastro duplicado (problema da ficha de papel) | RN29, RNF05 |
| Quantidade e estoque | Regras RN24 e RN25 descritas no dicionário, sem verificação no banco | `quantidade > 0` e `estoque >= 0` como `CHECK` | Fazer o banco impedir quantidade inválida e estoque negativo | RN24, RN25 |
| Validade do orçamento | Atributo obrigatório; expiração (RN27) descrita, sem verificação de consistência | `CHECK (validade >= data_orcamento)` | Impedir validade anterior à emissão | RN27 |
| Valor do pagamento | Atributo obrigatório; igualdade ao total do orçamento descrita (RN32) | `CHECK (valor > 0)`; igualdade com o total verificada pela consulta de auditoria A4 | RN32 depende de duas tabelas e não cabe em constraint simples | RN32 |
| ITEM_ORCAMENTO | Identificador `id_item` e dependência do orçamento descrita (RN10) | `id_item` como chave substituta; dependência imposta por `NOT NULL` e `ON DELETE CASCADE` | Item sem orçamento não tem sentido (classificação de entidade fraca, ver README, seção 18.2) | RN10 |

## 3. Regras de negócio que mudaram ou foram esclarecidas

Nenhuma regra de negócio foi removida. Foram feitas duas precisões:

- **RN21 / P06 (preço no item):** o valor unitário é copiado para o item, e reajustes posteriores não alteram orçamentos já emitidos. Antes, a regra estava implícita no atributo `valor_padrao`.
- **RN30 / P05 (baixa de estoque na aprovação):** a baixa só é permitida com quantidade suficiente. A regra é aplicada pela aplicação e verificada pela consulta de auditoria A7. O banco garante apenas que o estoque não fique negativo.

## 4. Itens do modelo conceitual que não foram implementados como entidades

- **Usuário, perfil e registro de operações (RNF02, RNF03):** não modelados como entidades nesta etapa, pelo mesmo motivo descrito no README (seção 17.1). Ficam para a evolução do sistema.

## 5. Correções de documentação feitas nesta revisão

- Lista de integrantes: o dicionário conceitual antigo tinha o nome "Davi Melo Salgueiro **Leonardo**" e duas linhas "Leonardo" com RA "não informado". Foi regenerado com a lista do README (Davi Melo Salgueiro **Leonardi**, e Leonardo Augusto com RA 47733497).
- Estrutura do repositório reorganizada conforme o manual (`docs/`, `sql/ddl`, `sql/dados`, `sql/testes`, `sql/consultas`).
- Massa de dados ampliada de 42 para 53 registros, para permitir consultas gerenciais em mais de um período (ver `sql/dados/02_carga_valida.sql`).
