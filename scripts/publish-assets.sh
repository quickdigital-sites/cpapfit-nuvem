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

REMOTE="${ASSETS_REMOTE:-git@github.com:quickdigital-sites/quickdigital-sites-cpapfit-assets.git}"
SLUG="$(echo "$REMOTE" | sed -E 's#^(git@github.com:|https://github.com/)##; s#\.git$##')"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

git clone --quiet "$REMOTE" "$TMP/repo" 2>/dev/null || { mkdir -p "$TMP/repo" && git -C "$TMP/repo" init -q -b main && git -C "$TMP/repo" remote add origin "$REMOTE"; }
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
  git push -q origin HEAD:main
fi
SHA="$(git rev-parse HEAD)"
cd - >/dev/null

printf '{\n  "repo": "%s",\n  "ref": "%s"\n}\n' "$SLUG" "$SHA" > design/assets.json
echo "assets: publicado $SLUG@$SHA → design/assets.json"
echo "próximo: (cd frontend && npm run build) e theme push"
