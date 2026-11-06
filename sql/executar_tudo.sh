#!/usr/bin/env bash
# =====================================================================
# Executa o projeto inteiro em um servidor MySQL/MariaDB vazio:
#   DDL -> carga valida -> testes de integridade -> consultas gerenciais -> auditoria
# Uso:  bash sql/executar_tudo.sh            (usa: mysql -uroot)
#       MYSQL_ARGS="-uusuario -p" bash sql/executar_tudo.sh
# =====================================================================
set -uo pipefail
cd "$(dirname "$0")"
MYSQL_ARGS="${MYSQL_ARGS:--uroot}"

run() { mysql $MYSQL_ARGS "$@"; }

echo "== 01 estrutura (DDL)";        run < ddl/01_estrutura.sql || { echo "FALHA na DDL"; exit 1; }
echo "== 02 carga valida";           run < dados/02_carga_valida.sql || { echo "FALHA na carga valida"; exit 1; }

# Os testes T01-T15 SAO erros esperados: o script usa --force para seguir
# e a contagem de erros e comparada com o numero de testes invalidos (15).
echo "== 03 testes de integridade (15 erros esperados)"
erros=$(run --force < testes/03_testes_integridade.sql 2>&1 >/dev/null | grep -c '^ERROR')
echo "   erros capturados: $erros (esperado: 15)"
[ "$erros" -eq 15 ] || { echo "ATENCAO: numero de erros diferente do esperado"; }

echo "== 04 consultas gerenciais";   run prime_funilaria < consultas/04_consultas_gerenciais.sql || exit 1
echo "== 05 consultas de auditoria"; run prime_funilaria < consultas/05_consultas_auditoria.sql || exit 1
echo "Concluido."
