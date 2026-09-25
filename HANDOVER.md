# HANDOVER — Tema Nuvemshop CPAP Fit

Documento de transferência para novos desenvolvedores. Reúne o contexto do projeto,
as decisões técnicas, o fluxo de trabalho e o registro do que já foi desenvolvido.

> Leia também o [README.md](README.md) (kit de dev, passo a passo de setup) e
> [docs/frontend.md](docs/frontend.md) (stack do front). Este HANDOVER foca no
> **estado atual do projeto CPAP Fit** e nas **armadilhas** descobertas na prática.

Última atualização: 2026-09-25.

---

## 1. Visão geral

Redesenho completo da loja **CPAP Fit** (apneia do sono, oxigenoterapia, equipamentos
respiratórios) na plataforma **Nuvemshop**, a partir de um layout no **Figma**.

- Base: kit `nuvemshop-dev` (servidor MCP + tema Ipanema *sectionable* + build Tailwind/Alpine + CI).
- Tema base: **Ipanema** (único tema *sectionable* da Nuvemshop — dá sections/blocks editáveis no Brand Editor).
- Loja de produção atual (referência de comportamento): <https://www.cpapfit.com.br>.
- Agência: Quick Digital.

---

## 2. Acesso e ambiente

| Item | Valor |
|---|---|
| Repositório | `github.com/quickdigital-sites/cpapfit-nuvem` (**privado**) |
| Pasta local | `~/Documents/Quick-Digital/Workspace/Nuvemshop/cpapfit-nuvem` |
| Loja (store_id) | **8074130** |
| URL da loja | `https://cpapfit4.lojavirtualnuvem.com.br` |
| Tema **homolog** (dev) | instalação **`14473488`** — "CPAP Fit — Dev" (Ipanema, sectionable, **não** publicada) |
| Tema publicado (prod atual) | instalação **`14128437`** — "Morelia" (legacy; **será substituída** ao publicar o novo tema) |

**Limite da plataforma: 2 instalações de tema por loja.** Hoje: Morelia (publicada) + CPAP Fit — Dev (homolog) = 2/2.

### Credenciais (nunca commitar)
- `.env` (fora do git) tem `TIENDANUBE_ACCESS_TOKEN`, `TIENDANUBE_STORE_ID`, `THEME_ID_HOMOLOG=14473488`, `THEME_ID_PROD=` (vazio de propósito — a API recusa push em tema legacy).
- **Dois tokens diferentes:** o `TIENDANUBE_ACCESS_TOKEN` (Admin API) **não** serve para a CLI de tema. A CLI usa o token de `theme/.nuvem`, gerado por `nuvemshop theme authorize` (OAuth no navegador). Foi por isso que `theme list` dava 403 com o token da Admin API.
- `.env.example` documenta os campos.

### Preview do homolog
```
https://cpapfit4.lojavirtualnuvem.com.br/?theme_installation_id=14473488
```
Só renderiza o nosso tema **logado no admin da loja**; sem login mostra a Morelia publicada.

---

## 3. Setup rápido (novo dev)

```bash
# 1. ferramentas
python3 -m venv .venv && .venv/bin/pip install -r mcp-server/requirements.txt
cd frontend && npm ci && cd ..
npm install -g @tiendanube/cli

# 2. credenciais
cp .env.example .env         # preencher TIENDANUBE_ACCESS_TOKEN / STORE_ID / THEME_ID_HOMOLOG
nuvemshop theme authorize    # dentro de theme/ — gera theme/.nuvem (login como dono da loja)

# 3. desenvolver (ver seção 5)
cd frontend && npm run build
(cd theme && . ../.env && nuvemshop theme push --theme-id "$THEME_ID_HOMOLOG" -y)
```

O `.mcp.json` na raiz liga o servidor MCP da Nuvemshop no Claude Code automaticamente.

---

## 4. Arquitetura e RESTRIÇÕES CRÍTICAS

O tema **não roda local** — a Nuvemshop renderiza Twig + SASS no servidor. O build local só cobre CSS/JS estáticos.

### 4.1. Fork INDISPONÍVEL (a maior restrição)
A plataforma **ainda não libera fork** (`theme fork` → HTTP 400 "Forking not yet allowed. Coming soon...").
Sem fork, o `theme push/watch` só grava:
```
custom/  •  templates/  •  config/settings_data.json
```
Tudo o mais é **pulado** no push (regra do servidor `FILE_PATH_NOT_ALLOWED_WITHOUT_FORK`):
`static/`, `sections/*.tpl`, `snippets/`, `layouts/`, `translations/`, `config/settings_schema.json`.

**Consequências:**
- **Não dá para reescrever HTML** de header, footer, sections nativas (vêm de `{% layout_template %}` / seções nativas). Só dá para **configurar via Brand Editor** + **sobrescrever via CSS/JS**.
- Componentes custom em `.tpl` (com Twig) não chegam na loja. Por isso usamos componentes **HTML+Tailwind+Alpine** injetados (ver 4.3).

### 4.2. Como o build chega na loja (sem fork) — `frontend/inject.mjs`
O build gera `theme/static/css/tailwind.css` e `theme/static/js/app.js`, mas `static/` não é enviado. Então o `inject.mjs`:
- **CSS** → um bloco `<style>` dentro do **bloco de código do footer** (`templates/layout/footer.json`, section `nuvemshop_dev_js`).
- **JS** → `<script>` no mesmo bloco de código, + Alpine e collapse via CDN (versão travada no `package-lock`).

**Por que não usa `settings.css_code`?** O `css_code` (impresso no `<head>`) tem **limite de 15.000 caracteres** — apertado demais para um tema custom (batemos nesse teto ao adicionar o menu). Migramos o CSS para o `<style>` do footer (sem esse teto). O `inject.mjs` **limpa** qualquer bloco antigo que tenha ficado no `css_code`.
- **Contrapartida:** `<style>` no fim do `<body>` → leve **FOUC** (flash de estilo) no carregamento. **Pendência:** separar CSS crítico (header/menu) para o `<head>` e deixar o resto no footer, para eliminar o flash antes de publicar.

### 4.3. Layout a partir do Figma — `design/`
- `design/pages/home.yaml` — ordem das seções da home (mistura seções **nativas** do Ipanema + **componentes custom**). Compilado por `frontend/compose.mjs` → `theme/templates/pages/home.json`.
- `design/components/*.html` — HTML + Tailwind (prefixo `tw:`) + Alpine; cada um vira uma seção "Personalizada".
- ⚠️ Os componentes atuais (`beneficios`, `categorias-circulos`, `destaques-marcas`, `essenciais-titulo`) ainda são **placeholders** genéricos (Calças/Camisas/smartwatches) — **serão substituídos** pelo conteúdo real da CPAP Fit.

### 4.4. Assets (imagens) — hospedadas na LOJA
- Repo é **privado** → **jsDelivr não serve** (só repo público). Por isso `asset:` **não** é usado aqui.
- Estratégia: imagens hospedadas na **CDN da própria loja** (`dcdn.mitiendanube.com`), subidas pelo **Brand Editor** (campo de imagem das seções nativas) ou pelo logotipo da loja. O `compose.mjs` deixa URLs `https://` absolutas passarem intactas (só reescreve `asset:`).
- **Quando o fork for liberado:** migrar imagens para `theme/static/images/` via o endpoint de arquivos do tema (ver 4.5) e referenciar por `static_url`.
- Decisão em aberto: se um dia o repo virar público (ou criar um repo público só de assets via `ASSETS_REPO`), volta-se a usar `asset:` + jsDelivr.

### 4.5. Endpoint de arquivos do tema (o que a CLI usa)
Validado (GET → HTTP 200). Útil quando o fork liberar (ou para automações):
```
GET|PUT|DELETE  https://api.nuvemshop.com.br/v1/{store_id}/theme-installations/{installation_id}/files/{caminho}
Headers: Authentication: bearer {theme_access_token}  (do theme/.nuvem, NÃO o Admin API token)
         Content-Type: application/json  •  Accept: application/json  •  User-Agent: {obrigatório}
Body (PUT): { "content": <conteúdo>, "format": "text"|"json"|"base64" }
```
`format` por extensão: `.css/.js/.svg` → text; `.json` → json; imagens → base64.

---

## 5. Fluxo de desenvolvimento

Como a loja não roda local, o loop é **editar → build → push no homolog → conferir no preview** (logado no admin).

```bash
# build + push manual (o que usamos no dia a dia)
cd frontend && npm run build          # tailwind + esbuild + compose + inject
cd ../theme && . ../.env && nuvemshop theme push --theme-id "$THEME_ID_HOMOLOG" -y
```

Alternativa com auto-push a cada save (precisa do Docker Desktop rodando):
```bash
docker compose up   # frontend (watch) + theme (watch -> homolog) + mcp
```

**Onde mexer no CSS/JS:**
- CSS global do tema: `frontend/src/css/main.css` (Tailwind com prefixo `tw:` + regras raw que sobrescrevem o Ipanema). Vira o `<style>` do footer.
- JS: `frontend/src/js/main.js` (entry) + `frontend/src/js/components/*.js`. Vira o `<script>` do footer.
- Tokens de marca (cores/fontes): `theme/config/settings_data.json` (chaves do Brand Editor) — ver seção 6.

**Preview:** abrir a URL de preview logado no admin. Para ver mudança de menu/config feita no admin, recarregar (pode haver cache de alguns minutos).

---

## 6. Referência Figma + tokens de marca

- **Figma file key:** `1P4JHFz4FEG8UEBkDOB1qm`
  <https://www.figma.com/design/1P4JHFz4FEG8UEBkDOB1qm/-Quick--Redesign-CPAP-Fit---Nuvemshop>
- Acesso via **Figma MCP oficial** (autenticado como Quick Digital).
- Telas principais (nodeId): home desktop `0:326` / mobile `0:630`; catálogo/PLP desktop `24:2370` / mobile `24:2687`; produto/PDP desktop `35:10696` / mobile `66:17596`; header desktop `24:586` / mobile `24:1079`; menu desktop `24:621`; mega-menu `0:1068`.
- **Não há variáveis de design no Figma** — cores são fills diretos (extrair ao implementar cada seção).

### Tokens de marca (aplicados em `settings_data.json`)
| Token | Valor | Uso |
|---|---|---|
| Fonte | **Montserrat** | títulos e corpo (`font_headings`, `font_rest`) |
| Teal/verde | **`#23B9A3`** | botão primário, preços, badges, accent (`button_primary_background_color`, `accent_color`, `label_background_color`) |
| Indigo/azul | **`#2F3295`** | botão secundário, links terciários (`button_secondary_background_color`, `button_tertiary_foreground_color`) |
| Dourado/bronze | **`#AD9361`** | detalhes do header/menu (busca, ícone "Menu", chevrons, badge do carrinho) — só em CSS |
| Off-white | **`#FEFDFC`** | fundo do header, texto sobre escuro |
| Cinza texto | **`#4A4A48`** / `#2A282B` | texto do header/menu |
| Bege/creme | **`#F4F1ED`** | fundo da busca e dos ícones-círculo |
| Hairline | **`#E1DCD7`** | divisórias |

Variáveis CSS usadas no `main.css`: `--qd-cream`, `--qd-gold`, `--qd-ink`, `--qd-hairline`. As classes `tw:bg-brand`, `tw:text-brand-accent`, etc. mapeiam para as CSS custom properties do Ipanema (ver o `@theme` em `main.css`).

---

## 7. Registro de desenvolvimento (o que foi feito)

Cronológico, do início até agora:

1. **Análise e scaffolding.** Repo analisado; criados e commitados (commit `14c789e`, no `origin/main`):
   `.gitignore`, `.mcp.json`, `.env.example`, `.github/workflows/{theme-deploy,nube-apps}.yml`. CI verde.
2. **Ambiente.** CLI autorizada (`theme/.nuvem`); criada a instalação homolog **Ipanema** `14473488` (`theme create --base-theme ipanema`); `.env` completo. Validado o loop build→push→preview.
3. **Tokens de marca.** Aplicados em `settings_data.json` (Montserrat + teal/indigo/dourado, substituindo o placeholder laranja da Quick).
4. **Estratégia de assets.** Definida: imagens na loja (CDN), repo privado. READMEs atualizados.
5. **`inject.mjs` — CSS para o footer.** Migrado o CSS de `settings.css_code` (limite 15k) para `<style>` no bloco de código do footer.
6. **Header (desktop + mobile).** Restilizado o header **nativo** via CSS + JS (sem fork):
   - Busca vira **pílula creme com botão dourado** (reaproveita o form nativo `action=/search/`).
   - **Correção da busca:** o form nativo tinha `pointer-events:none` (estado fechado) e o Enter era bloqueado pelo `store.js`. `header-search.js` garante submit por Enter/clique e preserva o `theme_installation_id` no preview.
   - Ícones de conta/carrinho como **círculos creme**; badge do carrinho **dourado**.
   - **Pílula "Planos de Assinatura"** injetada via `header-plans.js` (o header nativo não tem esse slot). ⚠️ Link ainda é placeholder `#` — **falta a URL real**.
   - Layout de **duas linhas** (linha 1: logo/busca/planos/ícones; linha 2: menu).
   - Mobile: hambúrguer dourado, logo central, busca full-width.
   - Cores do header via `settings_data.json` (`header_background_color`, `header_foreground_color`).
   - ⚠️ **Logo:** ainda é o texto "CPAP FIT" — falta subir a imagem em Admin → Layout → "Logotipo da sua marca" (upload de arquivo, feito manualmente).
7. **Menu (desktop).** Estilizado o nav nativo (menu principal configurado no admin: `Menu` + Máscaras/Cpaps-Bipaps/Acessórios/Oxigenoterapia/Diagnóstico/Saúde respiratória/Serviços, cada um com dropdown; "Menu" abre a árvore completa de departamentos):
   - Item **"Menu"** com círculo dourado + hambúrguer + divisória.
   - **Chevrons dourados** (desenhados em CSS — o sprite nativo era fino demais).
   - **Setas de rolagem nativas removidas**; **pílula dourada na categoria em hover/ativa**, com o **chevron virando branco e "pra cima"**; categorias distribuídas **de ponta a ponta** (`justify-content: space-between`) — o **1º ("Menu") faceia o logo** e o **último faceia a sacola** (sem `padding-right`).
   - **Submenu**: overlay preto translúcido atrás (via `<div>.qd-menu-overlay` no body, z-index 999, sob o header 1000, com `:has()` no hover), painel branco **100% da largura da página**, sem border-radius. Hover estável (geometria nativa preservada).
   - Linha cinza entre header e menu removida.
8. **Layout/espaço.** `page_width` do setting **1320 → 1600** (`settings_data.json`); `.container` tornada **fluida** (`width:100%; max-width: var(--page-width)`, sem os degraus fixos por breakpoint do tema).
9. **Responsividade header+menu (sem scroll horizontal).** Corte em **1200px**: `≥1200` = desktop (logo/busca/planos/conta/carrinho + menu horizontal + benefícios; fonte do menu em degraus **15/14/13px** por faixa p/ caber); `<1200` = **padrão mobile completo** (hambúrguer + logo central + carrinho + busca full-width; esconde menu horizontal, "Planos" e conta). Motivo: o menu horizontal de 8 itens não cabia em 768–1150 (gerava ~375px de scroll). Verificado `docOverflow=0` em 320/375/414/768/1024/1199/1200/1280/1366/1440/1920 (submenu fechado e aberto). Touch targets mobile ≥ 44px. **Não** foi usado `overflow-x:hidden`.
10. **Menu (mobile) — concluído e validado** (390px). Painéis deslizantes nativos com: **botão "voltar" (‹) visível e funcional** (testado: entra em categoria → volta à raiz); **"Minha conta" no topo** em faixa creme, ícone dourado + texto inline (Montserrat); **chevrons dourados** (#AD9361, igual ao desktop); **touch targets** itens 56px, back/close ~59px, hambúrguer/carrinho/busca 44px. Obs.: o **X de fechar** existe (59px) — no preview logado fica sob a barra de rascunho, mas aparece em produção. Sem Figma de menu mobile, identidade aplicada de forma sóbria (creme + dourado + Montserrat).

Aprendizado importante: sobrescrever o header/menu **nativos** exige inspecionar o DOM real renderizado (logado no admin) para as classes certas (`.head-row`, `.search-container`, `.nav-desktop-list`, `.desktop-dropdown`, `.nav-desktop-container`, `.menu-container`, `.navigation-bar`, `.sticky-header-wrapper`). A barra de benefícios (`.navigation-bar`) é um **strip de scroll horizontal nativo** (não é overflow de página).

---

## 8. Estado do git

- **Commitado + no `origin/main`:**
  - `first commit` + **scaffolding** (`14c789e`).
  - **Conjunto header + menu** (tokens de marca; `page_width 1600` + `.container` fluida; header desktop/mobile; busca-pílula + correção de submit; pílula "Planos"; menu desktop + submenu/overlay; responsividade sem scroll horizontal; `inject.mjs` CSS→`<style>` do footer; `HANDOVER.md`, `PENDENCIAS.md`, READMEs).
- Identidade git: `Guilherme Borzoni <guilherme.borzoni@quickdigital.com.br>`.

> ⚠️ **Saída de build em arquivos versionados:** `theme/config/settings_data.json` (tokens + `css_code`), `theme/templates/layout/footer.json` (bloco `<style>/<script>`) e `theme/templates/pages/home.json` (composto) carregam saída do build — é como o tema chega na loja sem fork; **geram diff a cada build**. A fonte real está em `frontend/src/`, `design/` e nos tokens de `settings_data.json`.

---

## 9. Pendências / próximos passos

- [ ] **Logo:** subir a imagem oficial em Admin → Layout → "Logotipo da sua marca" (o texto some quando a imagem entra). Um PNG 200×60 exportado do Figma está disponível; ideal ter SVG/alta resolução.
- [ ] **Link da pílula "Planos de Assinatura"** (hoje `#`) → URL real da página de planos.
- [x] **Menu mobile:** "voltar um nível", "Minha conta no topo" e identidade — **concluído e validado** (2026-09-25).
- [ ] **Banners no submenu desktop** (ver [PENDENCIAS.md](PENDENCIAS.md)).
- [ ] **Tablet (768–1199):** hoje usa o padrão mobile completo (esconde "Planos" e conta). Reavaliar se quer um layout híbrido que preserve esses itens no tablet.
- [ ] **Barra de benefícios no mobile:** hoje é um strip de scroll horizontal nativo; avaliar quebrar em 2 linhas.
- [ ] **FOUC:** separar CSS crítico (header/menu) para o `<head>` (via `css_code`, respeitando o limite de 15k) e manter o resto no footer.
- [ ] **Home:** substituir os componentes placeholder pelos reais (hero, categorias em círculos, destaques, banners, marcas, vídeos, serviços) — ver `design/home.yaml`.
- [ ] **PLP e PDP** (catálogo e produto), desktop + mobile.
- [ ] **Secrets do CI** (quando for automatizar deploy): `NUVEMSHOP_CLI_TOKEN` (via `scripts/cli-token.sh`), `THEME_ID_HOMOLOG`, e a variable `STORE_URL=https://cpapfit4.lojavirtualnuvem.com.br`.
- [ ] **Go-live:** publicar a instalação Ipanema (substitui a Morelia). Rever estratégia de 2 instalações (homolog/prod) dado o limite da plataforma.

---

## 10. Armadilhas (gotchas)

- **Fork indisponível** → só `custom/`, `templates/`, `settings_data.json` são graváveis. HTML de header/footer/sections = só CSS/JS/Brand Editor.
- **`css_code` tem limite de 15.000 chars** → por isso o CSS vai no `<style>` do footer.
- **Dois tokens** (Admin API ≠ CLI de tema). CLI usa `theme/.nuvem`.
- **Menu/config do admin** pode demorar (cache) a refletir no preview — recarregar.
- **Header nativo:** o form de busca fica com `pointer-events:none` fechado; foi preciso forçar `pointer-events:auto` + handler próprio de submit.
- **Preview perde `theme_installation_id`** ao navegar (ex.: busca) → cai no tema publicado. `header-search.js` re-injeta o parâmetro.
- **Não usar seletor de ID em CSS** (regra da plataforma; IDs são reservados) — usar classes/`js-*`.
- **Deleção via MCP/CLI** (produto, cliente, webhook) não pede confirmação — cuidado.

---

## 11. Referências

- README do projeto: [README.md](README.md) • Front: [docs/frontend.md](docs/frontend.md) • Design: [design/README.md](design/README.md)
- CLI Nuvemshop: <https://dev.nuvemshop.com.br/docs/developer-tools/cli/overview>
- API: <https://tiendanube.github.io/api-documentation/resources>
- Produção (referência de comportamento): <https://www.cpapfit.com.br>
