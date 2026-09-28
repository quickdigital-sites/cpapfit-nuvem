#!/usr/bin/env bash
# Publica design/assets/ no repo PÚBLICO de assets e fixa o commit em design/assets.json.
#
# Por quê: o repo do tema é privado e o jsDelivr só serve repos públicos. As imagens
# (asset:home/x.webp no YAML/HTML) viram https://cdn.jsdelivr.net/gh/<repo>@<commit>/design/assets/…
#
# Uso (na raiz do repo, com acesso de push ao repo de assets):
#   scripts/publish-assets.sh
#   (cd frontend && npm run build)      # recompõe os templates com o novo commit
#   … theme push no homolog
#
# Repo padrão: quickdigital-sites/quickdigital-sites-cpapfit-assets (mude com ASSETS_REMOTE).
set -euo pipefail
cd "$(dirname "$0")/.."

# Usa o MESMO host SSH do origin (ex.: alias github.com-agency do ~/.ssh/config), para pegar a chave certa.
ORIGIN_HOST="$(git remote get-url origin 2>/dev/null | sed -nE 's#^git@([^:]+):.*#\1#p')"
REMOTE="${ASSETS_REMOTE:-git@${ORIGIN_HOST:-github.com}:quickdigital-sites/quickdigital-sites-cpapfit-assets.git}"
SLUG="$(echo "$REMOTE" | sed -E 's#^(git@[^:]+:|https://github.com/)##; s#\.git$##')"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# Falha cedo (e sem gravar design/assets.json) se não houver acesso ao repo de assets.
if ! git ls-remote "$REMOTE" >/dev/null 2>&1; then
  echo "assets: ✗ sem acesso a $REMOTE" >&2
  echo "        Peça permissão de escrita (Write) para o seu usuário do GitHub nesse repo" >&2
  echo "        (Settings → Collaborators and teams) e rode de novo. Teste: git ls-remote $REMOTE" >&2
  exit 1
fi
git clone --quiet "$REMOTE" "$TMP/repo" 2>/dev/null   # repo vazio também clona (só avisa)
git -C "$TMP/repo" checkout -q -B main
mkdir -p "$TMP/repo/design"
rm -rf "$TMP/repo/design/assets"
cp -R design/assets "$TMP/repo/design/assets"
[ -f "$TMP/repo/README.md" ] || printf '# CPAP Fit — assets públicos\n\nImagens do tema Nuvemshop CPAP Fit servidas pelo jsDelivr.\nNão edite aqui: a fonte é `design/assets/` do repo do tema (privado). Publicado por `scripts/publish-assets.sh`.\n' > "$TMP/repo/README.md"

cd "$TMP/repo"
git add -A
if git diff --cached --quiet; then
  echo "assets: nada mudou"
else
  git commit -q -m "assets: sync $(date +%Y-%m-%d)"
  git push -q origin HEAD:main || {
    echo "assets: ✗ push negado. A chave SSH usada não tem escrita em $SLUG." >&2
    echo "        Use a chave certa só neste comando (sem mexer nas outras):" >&2
    echo "          GIT_SSH_COMMAND='ssh -i ~/.ssh/SUA_CHAVE -o IdentitiesOnly=yes' scripts/publish-assets.sh" >&2
    echo "        ou um alias do ~/.ssh/config:  ASSETS_REMOTE=git@SEU_ALIAS:$SLUG.git scripts/publish-assets.sh" >&2
    exit 1
  }
fi
SHA="$(git rev-parse HEAD)"
cd - >/dev/null

printf '{\n  "repo": "%s",\n  "ref": "%s"\n}\n' "$SLUG" "$SHA" > design/assets.json
echo "assets: publicado $SLUG@$SHA → design/assets.json"
echo "próximo: (cd frontend && npm run build) e theme push"
