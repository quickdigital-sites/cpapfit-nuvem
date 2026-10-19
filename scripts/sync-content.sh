#!/usr/bin/env bash
# Protege o conteúdo editado no editor da Nuvemshop (Brand Editor) antes de um push.
#
# O editor grava textos, imagens e a ordem das seções nos arquivos de conteúdo do tema:
#   templates/pages/*.json, templates/pages/account/*.json, templates/layout/*.json, config/settings_data.json
# O build (frontend/compose.mjs) regera alguns deles a partir de design/pages/*.yaml. Para um push não apagar o
# que o lojista mudou, este script baixa esses arquivos do tema remoto e os coloca por cima do build local.
# Assim o push só leva código.
#
# Uso: scripts/sync-content.sh <theme_id>            (antes de "nuvemshop theme push")
#      FORCE_CONTENT=1 scripts/sync-content.sh <id>  (não baixa: o push leva o conteúdo do repositório —
#                                                     só quando a mudança de conteúdo é intencional)
# Requer a CLI autorizada (theme/.nuvem) ou NUVEMSHOP_CLI_TOKEN no ambiente.
set -euo pipefail
cd "$(dirname "$0")/.."
THEME_ID="${1:?informe o id do tema}"
if [ "${FORCE_CONTENT:-0}" = "1" ]; then
  echo ">> FORCE_CONTENT=1: o conteúdo do repositório vai substituir o do editor no tema $THEME_ID"
  exit 0
fi
TOKEN_FLAG=(); [ -n "${NUVEMSHOP_CLI_TOKEN:-}" ] && TOKEN_FLAG=(--token "$NUVEMSHOP_CLI_TOKEN")
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
cp theme/.nuvem "$TMP/" 2>/dev/null || true
echo ">> baixando o conteúdo do editor (tema $THEME_ID)"
( cd "$TMP" && nuvemshop theme pull --theme-id "$THEME_ID" ${TOKEN_FLAG[@]+"${TOKEN_FLAG[@]}"} >/dev/null )
n=0
for f in "$TMP"/templates/pages/*.json "$TMP"/templates/pages/account/*.json "$TMP"/templates/layout/*.json "$TMP"/config/settings_data.json; do
  [ -f "$f" ] || continue
  rel="${f#"$TMP"/}"
  mkdir -p "theme/$(dirname "$rel")"
  if ! cmp -s "$f" "theme/$rel"; then echo "   mantido do editor: $rel"; n=$((n+1)); fi
  cp "$f" "theme/$rel"
done
echo ">> $n arquivo(s) de conteúdo diferente(s) do repositório foram preservados"
