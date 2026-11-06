-- =====================================================================
-- Projeto ERP - Prime Funilaria (Grupo 04)
-- Script 05: consultas de auditoria (qualidade e consistencia dos dados)
-- Cada consulta responde: "O que esta consulta esta verificando?"
-- Resultado vazio = nenhuma situacao suspeita encontrada.
-- Execute apos 01_estrutura.sql e 02_carga_valida.sql.
-- =====================================================================
USE prime_funilaria;

-- A1 - OS abertas ha mais de 7 dias que ainda nao tem orcamento.
-- Verifica: atendimentos parados sem analise do veiculo (RN07, RN26).
SELECT os.id_os, c.nome AS cliente, os.data_abertura, os.status
FROM ordem_servico os
JOIN cliente c ON c.id_cliente = os.id_cliente
LEFT JOIN orcamento o ON o.id_os = os.id_os
WHERE o.id_orcamento IS NULL
  AND os.status = 'ABERTA'
  AND os.data_abertura < NOW() - INTERVAL 7 DAY;

-- A2 - Orcamentos PENDENTES cuja validade ja venceu.
-- Verifica: expiracao nao registrada (RN27). Devem constar como EXPIRADO.
SELECT id_orcamento, id_os, validade, status
FROM orcamento
WHERE status = 'PENDENTE' AND validade < CURDATE();

-- A3 - Orcamentos APROVADOS sem nenhum pagamento lancado.
-- Verifica: servico concluido ou aprovado sem registro financeiro.
SELECT o.id_orcamento, o.id_os, t.valor_total
FROM orcamento o
JOIN vw_orcamento_total t ON t.id_orcamento = o.id_orcamento
LEFT JOIN pagamento p ON p.id_orcamento = o.id_orcamento
WHERE o.status = 'APROVADO' AND p.id_pagamento IS NULL;

-- A4 - Pagamentos cujo valor difere do total do orcamento.
-- Verifica: RN32 (valor pago = valor total do orcamento).
SELECT p.id_pagamento, p.id_orcamento, p.valor AS valor_pago, t.valor_total
FROM pagamento p
JOIN vw_orcamento_total t ON t.id_orcamento = p.id_orcamento
WHERE p.valor <> t.valor_total;

-- A5 - Pagamentos registrados para orcamentos que nao estao aprovados.
-- Verifica: RN14 e RN32 (pagamento so existe para orcamento aprovado).
SELECT p.id_pagamento, p.id_orcamento, o.status AS status_orcamento
FROM pagamento p
JOIN orcamento o ON o.id_orcamento = p.id_orcamento
WHERE o.status <> 'APROVADO';

-- A6 - Itens de orcamentos em aberto (pendente) que usam servico ou peca inativos.
-- Verifica: RN20/P07 (inativos nao entram em novos orcamentos).
SELECT i.id_item, i.id_orcamento, s.descricao AS servico, pe.descricao AS peca
FROM item_orcamento i
JOIN orcamento o ON o.id_orcamento = i.id_orcamento
LEFT JOIN servico s ON s.id_servico = i.id_servico
LEFT JOIN peca pe   ON pe.id_peca = i.id_peca
WHERE o.status = 'PENDENTE'
  AND ((s.id_servico IS NOT NULL AND s.ativo = 0)
    OR (pe.id_peca   IS NOT NULL AND pe.ativo = 0));

-- A7 - Pecas com estoque negativo.
-- Verifica: RN25. O CHECK do banco deve impedir; a consulta confirma.
SELECT id_peca, descricao, estoque FROM peca WHERE estoque < 0;

-- A8 - Precos de compra desatualizados (mais de 180 dias sem atualizacao).
-- Verifica: RN18 (data de atualizacao do preco por fornecedor/peca).
SELECT fo.nome AS fornecedor, pe.descricao AS peca, fp.preco_compra, fp.data_atualizacao
FROM fornecedor_peca fp
JOIN fornecedor fo ON fo.id_fornecedor = fp.id_fornecedor
JOIN peca pe       ON pe.id_peca = fp.id_peca
WHERE fp.data_atualizacao < CURDATE() - INTERVAL 180 DAY;

-- A9 - Pecas ativas sem nenhum fornecedor cadastrado.
-- Verifica: peca que nao pode ser comprada nem reposta (RN17, RN16).
SELECT pe.id_peca, pe.descricao
FROM peca pe
LEFT JOIN fornecedor_peca fp ON fp.id_peca = pe.id_peca
WHERE pe.ativo = 1 AND fp.id_peca IS NULL;

-- A10 - Ordens em que o solicitante e diferente do proprietario do veiculo.
-- Verifica: RN23 (caso previsto pelo modelo, listado para conferencia do atendimento).
SELECT os.id_os, sol.nome AS solicitante, prop.nome AS proprietario, v.placa
FROM ordem_servico os
JOIN veiculo v   ON v.id_veiculo = os.id_veiculo
JOIN cliente sol ON sol.id_cliente = os.id_cliente
JOIN cliente prop ON prop.id_cliente = v.id_cliente
WHERE os.id_cliente <> v.id_cliente;
