-- =====================================================================
-- Projeto ERP - Prime Funilaria (Grupo 04)
-- Script 04: consultas gerenciais
-- Formato de cada consulta: PERGUNTA DO NEGOCIO + SQL + INFORMACAO PARA DECISAO
-- Execute apos 01_estrutura.sql e 02_carga_valida.sql.
-- =====================================================================
USE prime_funilaria;

-- G1 - Quais pecas sao mais vendidas (em orcamentos aprovados)?
-- Decisao apoiada: reorganizar estoque e compras de reposicao.
SELECT p.id_peca, p.descricao AS peca,
       SUM(i.quantidade) AS quantidade_vendida,
       SUM(i.quantidade * i.valor_unitario) AS receita
FROM item_orcamento i
JOIN orcamento o ON o.id_orcamento = i.id_orcamento
JOIN peca p      ON p.id_peca = i.id_peca
WHERE o.status = 'APROVADO'
GROUP BY p.id_peca, p.descricao
ORDER BY quantidade_vendida DESC, receita DESC;

-- G2 - Quais servicos sao mais procurados (em orcamentos aprovados)?
-- Decisao apoiada: priorizar equipe e divulgacao dos servicos de maior demanda.
SELECT s.id_servico, s.descricao AS servico,
       SUM(i.quantidade) AS quantidade_executada,
       SUM(i.quantidade * i.valor_unitario) AS receita
FROM item_orcamento i
JOIN orcamento o ON o.id_orcamento = i.id_orcamento
JOIN servico s   ON s.id_servico = i.id_servico
WHERE o.status = 'APROVADO'
GROUP BY s.id_servico, s.descricao
ORDER BY quantidade_executada DESC, receita DESC;

-- G3 - Quais clientes mais compram (valor de orcamentos aprovados)?
-- Decisao apoiada: campanhas de fidelizacao e condicoes para clientes recorrentes.
SELECT c.id_cliente, c.nome AS cliente,
       COUNT(DISTINCT o.id_orcamento) AS orcamentos_aprovados,
       SUM(t.valor_total) AS valor_aprovado
FROM orcamento o
JOIN vw_orcamento_total t ON t.id_orcamento = o.id_orcamento
JOIN ordem_servico os     ON os.id_os = o.id_os
JOIN cliente c            ON c.id_cliente = os.id_cliente
WHERE o.status = 'APROVADO'
GROUP BY c.id_cliente, c.nome
ORDER BY valor_aprovado DESC;

-- G4 - Qual foi o volume de vendas aprovadas por mes?
-- Decisao apoiada: planejar equipe e compras conforme a sazonalidade.
SELECT DATE_FORMAT(o.data_orcamento, '%Y-%m') AS mes,
       COUNT(*) AS orcamentos_aprovados,
       SUM(t.valor_total) AS valor_vendido
FROM orcamento o
JOIN vw_orcamento_total t ON t.id_orcamento = o.id_orcamento
WHERE o.status = 'APROVADO'
GROUP BY DATE_FORMAT(o.data_orcamento, '%Y-%m')
ORDER BY mes;

-- G5 - Quanto ja foi recebido, por forma de pagamento?
-- Decisao apoiada: avaliar quais meios de pagamento a oficina mais usa.
SELECT p.forma_pagamento, COUNT(*) AS pagamentos, SUM(p.valor) AS valor_recebido
FROM pagamento p
WHERE p.status = 'CONFIRMADO'
GROUP BY p.forma_pagamento
ORDER BY valor_recebido DESC;

-- G6 - Quanto ainda falta receber de orcamentos aprovados?
-- Decisao apoiada: cobranca de saldos em aberto (aprovado sem pagamento ou pagamento pendente).
SELECT o.id_orcamento, c.nome AS cliente, t.valor_total AS valor_orcado,
       COALESCE(p.valor, 0) AS valor_pago_ou_lancado,
       t.valor_total - COALESCE(p.valor, 0) AS saldo_em_aberto,
       COALESCE(p.status, 'SEM PAGAMENTO') AS situacao_pagamento
FROM orcamento o
JOIN vw_orcamento_total t ON t.id_orcamento = o.id_orcamento
JOIN ordem_servico os     ON os.id_os = o.id_os
JOIN cliente c            ON c.id_cliente = os.id_cliente
LEFT JOIN pagamento p     ON p.id_orcamento = o.id_orcamento
WHERE o.status = 'APROVADO'
  AND (p.id_pagamento IS NULL OR p.status = 'PENDENTE')
ORDER BY saldo_em_aberto DESC;

-- G7 - Quais pecas ativas estao com estoque baixo ou zerado?
-- Decisao apoiada: acionar fornecedores antes de precisar aprovar um orcamento (P05).
SELECT id_peca, descricao AS peca, estoque
FROM peca
WHERE ativo = 1 AND estoque <= 2
ORDER BY estoque, descricao;

-- G8 - Qual o andamento das ordens de servico por funcionario responsavel?
-- Decisao apoiada: redistribuir carga de trabalho entre funileiros e atendentes.
SELECT f.nome AS responsavel, os.status, COUNT(*) AS ordens
FROM ordem_servico os
JOIN funcionario f ON f.id_funcionario = os.id_funcionario
GROUP BY f.nome, os.status
ORDER BY f.nome, os.status;

-- G9 - Qual fornecedor oferece o menor preco de compra para cada peca?
-- Decisao apoiada: escolher o fornecedor de menor custo (RF26).
SELECT pe.descricao AS peca, fo.nome AS fornecedor_mais_barato,
       fp.preco_compra, fp.data_atualizacao
FROM fornecedor_peca fp
JOIN peca pe       ON pe.id_peca = fp.id_peca
JOIN fornecedor fo ON fo.id_fornecedor = fp.id_fornecedor
WHERE fp.preco_compra = (SELECT MIN(x.preco_compra)
                         FROM fornecedor_peca x
                         WHERE x.id_peca = fp.id_peca)
ORDER BY pe.descricao;
