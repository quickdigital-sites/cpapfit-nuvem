# AGENTS.md — regras para quem edita este repo com IA (Claude Code, Cursor…)

Loja **CPAP Fit** na Nuvemshop — redesign do tema feito pela Quick Digital. Este arquivo é a fonte única das
regras; o `CLAUDE.md` só aponta para cá. Contexto longo: [HANDOVER.md](HANDOVER.md). Backlog vivo:
[PENDENCIAS.md](PENDENCIAS.md) — **leia antes de começar** e anote lá o que ficar pendente.

## Stack

| Camada | Onde roda | Arquivos |
|---|---|---|
| Twig (`.tpl`) | servidor da Nuvemshop | `theme/sections`, `theme/blocks`, `theme/snippets`, `theme/layouts` |
| JSON de páginas/layout (seções, blocos, valores do editor) | servidor | `theme/templates/**/*.json`, `theme/config/settings_data.json` |
| CSS próprio (Tailwind v4, prefixo `tw:`, sem preflight) | navegador | fonte em `frontend/src/css/` → `theme/static/css/tailwind.css` (gerado) |
| JS próprio (esbuild, progressive enhancement) | navegador | fonte em `frontend/src/js/` → `theme/static/js/app.js` (gerado) |
| Componentes HTML (`tw:`) | viram blocks "Código" | `design/components/*.html` + `design/pages/*.yaml` → `frontend/compose.mjs` |
| Checkout | servidor (SASS) | bloco "CPAP Fit" no fim de `theme/static/checkout.scss.tpl` |

Tema base: **Ipanema** (sectionable), instalação **forkada** — o push grava todos os arquivos.

## Mapa de pastas

```
theme/          tema da loja (CLI @tiendanube/cli). Ipanema + mudanças CPAP Fit (prefixo qd- / qd_)
frontend/       build: Tailwind, esbuild, compose (YAML → JSON), inject; lint de CSS (Stylelint)
design/         pages/*.yaml (ordem e conteúdo das páginas), components/*.html, assets/
docs/           frontend.md, editor-mapa.md (campos do editor), gap-report.md (Figma × loja)
nube-apps/      app NubeSDK do checkout (rodapé azul)
mcp-server/     servidor MCP próprio (Admin API + CLI de tema)
scripts/        theme-push.sh, sync-content.sh, publish-assets.sh
.claude/skills/ receitas: figma-parity-check, theme-section, css-units
```

## Rodar, ver e publicar

```bash
cd frontend && npm ci          # uma vez
npm run build                  # CSS + JS + compose + inject (gera arquivos em theme/)
npm run lint                   # Stylelint (regra de unidades)
scripts/theme-push.sh homolog  # build + preserva o conteúdo do editor + diff + push
```

- Credenciais (nunca no git): `.env` (`THEME_ID_HOMOLOG`), `theme/.nuvem` (`nuvemshop theme authorize`).
- **Hoje o `THEME_ID_HOMOLOG` (14473488) é o tema publicado** — todo push vai para a loja (ainda fechada ao
  público). Antes de abrir a loja: criar um rascunho de homolog (ver HANDOVER §2).
- Sempre `nuvemshop theme diff` antes de push. Se alguém mexeu no editor da loja, `theme pull` primeiro.
- `scripts/sync-content.sh` mantém o conteúdo do editor (JSON de templates e `settings_data.json`) por cima do
  build. Mudança intencional em JSON de template (seção nova, padrão novo) precisa de `FORCE_CONTENT=1`.
- Preview: `https://cpapfit4.lojavirtualnuvem.com.br/?theme_installation_id=<id>` (só logado no admin, para
  rascunhos). CI: PR → push em homolog; merge na `main` → push em prod (`.github/workflows/theme-deploy.yml`).

## Figma

Arquivo do redesign (Dev Mode): https://www.figma.com/design/1P4JHFz4FEG8UEBkDOB1qm/-Quick--Redesign-CPAP-Fit---Nuvemshop?node-id=0-1&m=dev
(fileKey `1P4JHFz4FEG8UEBkDOB1qm`). MCP oficial do Figma em `.mcp.json` (login OAuth na primeira vez, sem token
no repo). O MCP só lê arquivos em que a conta tem acesso de edição; sem isso, use a cópia
`QOFUK135D5y7jq7aWyKMth` (mesmos ids de nó). Última auditoria: [claude/figma-parity-report.md](claude/figma-parity-report.md). Comentários de CSS citam o nó (`Figma 24:661`); mantenha esse hábito. Comparação página × frame:
skill `figma-parity-check`.

## Convenções

- **Nomes:** classes, settings e blocos próprios com prefixo `qd-` / `qd_` (`qd-nav-pill`, `qd_enabled`,
  `blocks/qd-footer-links.tpl`). Classes Tailwind sempre com `tw:`.
- **Ipanema:** estenda o que existe (seção, bloco, setting) antes de criar algo novo. Comentário curto
  `{# CPAP Fit: … #}` onde o arquivo do Ipanema foi alterado.
- **Editor (Personalizar layout):** rótulos em português simples para o lojista; cada campo novo entra em
  [docs/editor-mapa.md](docs/editor-mapa.md). Receita: skill `theme-section`.
- **CSS:** em `frontend/src/css/<área>.css` (main, home, plp, pdp, cart, footer, institucional, product-card).
  Seletores escopados (`.js-navigation-bar …`, `div[data-section-id="footer"] …`), sem `#id`. Cores do projeto
  em variáveis `--qd-*` (`:root` de `main.css`).
- **Links:** use `{% include 'snippets/qd-link-attrs.tpl' with { url: … } %}` em todo `<a>` com URL de setting
  ou menu — link para outro domínio abre em nova aba. HTML cru é coberto por `external-links.js`.
- **Texto para o cliente:** sempre em português. Não invente texto, link nem regra de negócio — se o Figma
  tiver placeholder, registre em PENDENCIAS.md.
- **Commits:** pequenos, `tipo(área): descrição` em português (`fix(checkout): …`, `feat(pix): …`).

## Regra de unidades (CSS)

- Fonte, espaçamento (margin/padding/gap), raio, largura/altura de componente → **`rem`** (raiz 16px:
  `px / 16`, no máximo 4 casas). Não mude o `font-size` da raiz.
- Larguras de layout e containers fluidos → `%`, `max-width` em `rem`, ou `clamp()` quando o Figma é fluido.
- Media queries → **`em`** (`768px` → `48em`).
- `px` permitido: bordas e hairlines de 1px/2px, offsets de `box-shadow`, e valores impostos por CSS da
  plataforma/terceiros que não controlamos (com `/* stylelint-disable-next-line … -- motivo */`).
- Detalhes e exemplos: skill `css-units`. O `npm run lint` aplica a regra.

## Peculiaridades da Nuvemshop

- **Página de conteúdo só fica publicada se estiver num menu.** O menu oculto **"Institucional (páginas de
  conteúdo)"** existe só para isso — **nunca apague**.
- Excluir item de menu no admin só vale depois do **Salvar** no fim da página.
- Os editores do admin (TinyMCE, formulários React) perdem estado com automação — prefira resolver no tema ou no
  editor do tema a automatizar o admin.
- Só 2 instalações de tema por loja. `paginate` da listagem é ignorado (60 por página).
- No checkout só roda NubeSDK (JS do tema não entra) e `static_url` quebra o `checkout.scss.tpl`.

## O que não tocar

- CSS/JS do Ipanema: `theme/static/css/style-*.css`, `theme/static/js/store.js`, `libraries*` (vêm do tema base).
- Arquivos gerados: `theme/static/css/tailwind.css`, `theme/static/js/app.js`, o bloco entre
  `/* nuvemshop-dev:start */`…`end` em `settings_data.json`, as seções `cmp_*` e blocks "Código" gerados pelo
  `compose.mjs` — edite a fonte (`frontend/src`, `design/`).
- Segredos: `.env`, `theme/.nuvem`, `theme/manifest.json`, tokens em `.mcp.json`.
- No admin da loja: o menu "Institucional (páginas de conteúdo)"; nada de publicar tema sem pedido explícito.
