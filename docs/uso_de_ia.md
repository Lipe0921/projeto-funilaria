# Uso de Inteligência Artificial no projeto

Conforme as orientações do manual da entrega final (etapa 17), este documento registra o uso de IA na elaboração do projeto e a responsabilidade técnica do grupo.

## 1. Onde a IA foi usada

| Artefato | Uso de IA | Como foi validado |
|---|---|---|
| Registros complementares da massa de dados (`sql/dados/02_carga_valida.sql`, a partir do bloco "Complemento da massa de dados") | Elaborados com apoio do assistente Claude (modelo Claude Haiku 5.5) a partir das tabelas e regras do modelo | Executados no MariaDB 10.11.14: chaves estrangeiras, CHECK e UNIQUE aceitos; pagamentos conferidos com o total do orçamento (RN32) |
| Consultas gerenciais e de auditoria (`sql/consultas/`) | Redigidas com apoio do assistente | Executadas no banco; resultados conferidos manualmente contra a massa de dados |
| Scripts de execução (`sql/executar_tudo.sh`) | Redigido com apoio do assistente | Executado do zero em banco vazio |
| Documentos em `docs/` e README | Redigidos com apoio do assistente a partir do conteúdo do projeto | Conferidos contra o SQL real; links e contagens verificados |

Não houve geração em escala de registros por IA: a massa tem 53 registros, e o complemento foi escrito em um único bloco, não gerado em lote.

## 2. Prompts utilizados

Os pedidos ao assistente foram do tipo: "arrume o projeto de acordo com o que o professor pediu" (manual da entrega final e manual da apresentação), seguido de pedidos específicos por artefato (normalização, dicionário, consultas, testes). O conteúdo gerado foi revisado com os testes e com o manual.

## 3. Responsabilidade técnica

Conforme o manual, a responsabilidade técnica pelo conteúdo é do grupo. Toda resposta de IA foi tratada como hipótese até ser confirmada pela execução no banco ou pela leitura dos documentos. Os integrantes devem ser capazes de explicar qualquer decisão do projeto na apresentação, inclusive as que foram geradas com apoio da IA.
