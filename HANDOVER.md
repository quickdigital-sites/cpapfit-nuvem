# HANDOVER — Tema Nuvemshop CPAP Fit

Documento de transferência para novos desenvolvedores. Reúne o contexto do projeto,
as decisões técnicas, o fluxo de trabalho e o registro do que já foi desenvolvido.

> Leia também o [README.md](README.md) (kit de dev, passo a passo de setup) e
> [docs/frontend.md](docs/frontend.md) (stack do front). Este HANDOVER foca no
> **estado atual do projeto CPAP Fit** e nas **armadilhas** descobertas na prática.

Última atualização: 2026-09-28.

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
| Tema **publicado** (desde 2026-10-14) | instalação **`14473488`** — "CPAP Fit — Dev" (Ipanema, sectionable, **forkado**) |
| Tema antigo | instalação **`14128437`** — "Morelia" (legacy, não publicado; pode ser apagado para liberar a vaga de um rascunho/homolog) |

**Limite da plataforma: 2 instalações de tema por loja.** Hoje: CPAP Fit — Dev (publicada) + Morelia (antiga) = 2/2.

> ⚠️ **Desde 2026-10-14 o `THEME_ID_HOMOLOG` (14473488) É o tema publicado** — publicado a pedido do dono, com a loja
> ainda fora do ar para clientes. Todo `theme push` vai direto para a loja. Antes de abrir para clientes: criar um
> rascunho de homolog (duplicar o tema — precisa apagar a Morelia para caber no limite de 2), apontar
> `THEME_ID_HOMOLOG` para ele e `THEME_ID_PROD` (`.env` e secret do GitHub) para 14473488.

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

> Passo a passo detalhado (de onde vem cada credencial + problemas comuns, ex.: erro do `lightningcss`): [README → "CPAP Fit: clonei o repo"](README.md#cpap-fit-clonei-o-repo-como-faço-push-para-o-homolog).

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

### 4.1. Fork — LIBERADO em 2026-10-14 (instalação homolog 14473488)
> **Atualização:** `nuvemshop theme fork --theme-id 14473488 --yes` funcionou em 2026-10-14. Agora o push grava
> **todos** os arquivos (sections, snippets, static, layouts, translations…), e nada mais é "Skipped".
> Consequências: (1) a instalação **não recebe mais atualizações automáticas do Ipanema** (`theme update` aplica
> manualmente; `theme unfork` volta ao base num rascunho novo); (2) **o `theme/` local precisa estar igual ao remoto**
> antes de cada push — os arquivos do Ipanema foram sincronizados com o `theme pull` logo após o fork (vinham de uma
> versão antiga do kit e teriam sobrescrito o remoto); (3) a estratégia "sem fork" abaixo (CSS/JS injetados no footer,
> componentes em block "code") continua valendo, mas agora dá para migrar aos poucos: CSS crítico no `<head>` (FOUC),
> marca/favoritos no card de produto, campos nativos no formulário de contato etc.
> O texto abaixo descreve a situação até 2026-10-14.

### Situação anterior: fork INDISPONÍVEL
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
- A home CPAP Fit (2026-09-28) usa **seções nativas** para quase tudo (imagens/textos editáveis no Brand Editor) e só **um** componente: `destaques-abas` (abas de Destaques). Os placeholders antigos da Quick foram removidos.
- O YAML aceita âncoras/merge (`<<: *ancora`) para reaproveitar blocos (`compose.mjs` usa `merge: true`).

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
- Telas principais (nodeId): home desktop `0:326` / mobile `0:630`; institucionais — nossas lojas `271:6244` / `271:6399`, fale conosco `271:8536` / `305:5991`, troca e devolução `271:9547` / `305:6364`, quem somos `271:10421` / `305:6755`; catálogo/PLP desktop `24:2370` / mobile `24:2687`; produto/PDP desktop `35:10696` / mobile `66:17596`; header desktop `24:586` / mobile `24:1079`; menu desktop `24:621`; mega-menu `0:1068`.
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
10. **Menu (mobile) — concluído e validado** (390px). Painéis deslizantes nativos, virou **drawer lateral 90% / máx 350px** (página escurecida atrás). **Cabeçalho azul** (`--qd-indigo #2F3295`) com **X, "voltar" (‹), título e ícones brancos** (raiz e aninhados); **botão "voltar" funcional** (entra em categoria → volta à raiz). **"Minha conta" no topo, fundo branco**, ícone dourado + texto inline (Montserrat). Itens em **negrito** + **chevron dourado encorpado** (CSS, igual ao desktop). Touch targets ≥ 44px.
11. **Menu desktop — borda + submenu com banners.** (a) **`border-top: 1px solid #ccc`** no menu (Figma 0:1109). (b) **Submenu (Figma 0:1070):** "Categorias" (subcategorias em 2 colunas) à esquerda + **banners à direita**. Os banners usam o bloco **NATIVO `navigation-banner`** (`theme/blocks/navigation-banner.tpl`, renderizado por `header-navigation.tpl` em `.nav-desktop-banners` > `.nav-banner-item`) — **editável no Brand Editor por categoria** (campos `menu_item`, `image`, `title`, `url`), **sem fork**. Só estilizamos (card, gradiente, rótulo "Linha" e botão "VER LINHA COMPLETA" via CSS). O lojista cadastra os banners no Brand Editor → navegação → bloco "Banner". Ver [PENDENCIAS.md](PENDENCIAS.md).

12. **Home (desktop 0:326 + mobile 0:630) — implementada, aguardando push/validação no homolog.** `design/pages/home.yaml` reescrito; CSS em `frontend/src/css/home.css` (+ `product-card.css`, `icons.css`, importados no `main.css`), escopado por `[data-section-id="<id>"]` (atributo, não ID). Seções:
    - `hero` (slideshow): foto no Brand Editor + **gradiente azul por CSS**; título/texto/CTA dourado + pílula de logo (bloco imagem) + cupom tracejado (bloco label). Mobile: cupom vira linha única com código sublinhado. Altura 540/300.
    - `categorias`, `marcas`, `servicos` (featured-categories, círculos com imagem+nome; título de Categorias só no mobile).
    - `cmp_destaques_abas` (componente) + `destaques_1..6` (product-list): **cada aba mostra uma vitrine nativa** — `frontend/src/js/components/home-tabs.js` alterna por `data-section-id` e dispara `resize` para o Swiper. Sem JS aparece só a 1ª.
    - `linhas` (banners 2 col: Linha Resmed / Philips, gradiente por CSS, CTA + logo), `mais_vendidos` (product-list), `banners_promo` (2 artes), `videos` (seção Personalizada com 4 blocos de vídeo; 9:16 no desktop e 16:9 no mobile via CSS).
    - **Card de produto** restilizado globalmente (vale também para PLP/busca): selo % OFF, preço Pix em destaque, parcelas, botão COMPRAR verde. `promotion_labels_position` → `below` no `settings_data.json`.
    - Verificado com **mock estático** do DOM nativo + CSS real do Ipanema (Playwright, 1440 e 390px, sem scroll horizontal). **Ainda não conferido na loja** (sem credenciais da CLI neste checkout).

13. **Institucionais (2026-10-14).** Todas as páginas de conteúdo usam o template `page` (não há template por página) e o Fale conosco usa o `contact`. `frontend/src/js/components/institucional.js` monta, pelo slug da URL, a coluna lateral (menu **Institucional** ou **Atendimento** com a página atual em pílula dourada; no Atendimento, um clone do bloco de contato do footer; no mobile vira `<select>`) e põe o título na coluna de conteúdo (o `page-header` nativo fica escondido). O conteúdo do admin perde os estilos inline do editor. `design/pages/page.yaml` acrescenta as seções que só servem a uma página, escondidas por CSS fora dela: **Quem somos** (`quem_somos_hero` + `categorias`/`servicos`/`videos`/`marcas` com os mesmos ids da home, herdando `home.css`) e **Nossas lojas** (componente `nossas-lojas`, cards + filtro por UF). **Fale conosco:** formulário nativo em grade com os campos do Figma; motivo/cidade/UF/assunto entram no início da mensagem (o nativo só envia nome/e-mail/telefone/mensagem). CSS em `frontend/src/css/institucional.css`. Links do footer/PDP passaram para os slugs reais (`/quem-e-a-cpap-fit/`, `/trocas-e-devolucoes/`). Pendências de conteúdo em [PENDENCIAS.md](PENDENCIAS.md).

14. **Performance / Lighthouse (2026-10-14, mobile, preview).** Com o fork, o `inject.mjs` passou ao **modo head**: `<link>` do `tailwind.css` e `<script defer>` do `app.js` no `<head>` do `layout.tpl` (CDN da loja, cache de 1 ano) em vez de `<style>/<script>` inline no footer — acabou o flash de estilo e o layout shift. Alpine só é carregado se algum template usar `x-*` (hoje nenhum). Outros ajustes: guarda anti layout shift nos blocos que o JS reorganiza (PDP, PLP, institucionais: invisíveis até `html.qd-*-ready`, com fallback de 3s); hero com imagem mobile de 840px; variantes e "limpar preço" viraram `<button>` (eram `<a>` sem href); cores com texto passaram no WCAG AA (`--qd-gold-solid #887146`, `--qd-teal-strong #00816e`, `--warning #a5651d` — reverter = trocar os tokens); `preconnect` do jsDelivr; `publish-assets.sh` aquece o jsDelivr (commit novo dá 503 até ele buscar cada arquivo).
    | Página | Antes | Depois |
    |---|---|---|
    | Home | 61 / 93 / 79 / 92 | 84–89 / 97 / 79 / 100 |
    | PLP | 69 / 93 / 79 / 92 | 79–87 / 96 / 79 / 100 |
    | PDP | 62 / 91 / 79 / 92 | 78–80 / 96 / 79 / 100 |
    | Quem somos | 57–62 / 93 / 79 / 100 | 78–86 / 96 / 79 / 100 |
    (performance / acessibilidade / boas práticas / SEO.)
    **Loja publicada (mediana de 5 rodadas, Lighthouse mobile local):** home 73, PLP 84, PDP 83, Quem somos 86, Fale conosco 83 — acessibilidade **100**, SEO **100**, CLS ≈ 0 em todas. Depois de publicar: Montserrat carregada **sem bloquear** (antes era `@import` no `style-tokens.tpl`, e só 400/700 — agora 300–700 de verdade) com fallback de métricas iguais ("Montserrat Fallback", Arial ajustada) para a troca de fonte não mexer no layout; classe `page-<slug>` no `<body>` (layout.tpl) para Quem somos sair pronta do servidor; vitrines da home limitadas a 8 produtos. A home fica abaixo das outras porque o HTML tem ~1,6 MB (7 vitrines × ~190 KB — cada card do Ipanema embute o form da compra rápida) e o Swiper inicializa 9 carrosséis; o caminho para subir é carregar as abas escondidas sob demanda. ⚠️ O Twig da plataforma **não aceita** ternário com `replace({...})` dentro do `style-tokens.tpl` — derrubou a loja ~1 min; o fallback de fonte ficou no CSS (`main.css`).
    Limites fora do tema: **TTFB do preview ~1s** (a loja publicada responde em ~0,3s — os números devem subir ao publicar); CSS de fontes da plataforma bloqueando a 1ª pintura (~0,8s); **boas práticas 79** = cookie de terceiros do script da própria plataforma; a acessibilidade só não é 100 por causa da barra "Rascunho" do preview. No **Fale conosco** o Lighthouse simulado (o do PageSpeed) dá ~57 por causa do reCAPTCHA da plataforma; medido com throttling real dá 95.

15. **Abas de Destaques sob demanda (2026-10-14).** As abas 2–6 da home saem do servidor só como placeholder (`theme/sections/product-list.tpl`, `.qd-tab-lazy` com a URL da categoria do `products_source`); `frontend/src/js/components/home-tabs.js` busca a página da categoria quando o visitante vai usar a aba (hover/toque/foco/clique), pega os primeiros cards e monta o carrossel num molde copiado da vitrine da aba 1 antes do Swiper do tema iniciar. Compra rápida (COMPRAR) testada: abre o modal com o produto certo. HTML da home **1,6 MB → 670 KB**, DOM 11,4 mil → 4,5 mil elementos. (Query string não serve para isso: o cache da plataforma a ignora.) As abas 2–6 agora apontam para as categorias reais da loja.
    **Lighthouse da home não mudou (mediana ~72 mobile simulado):** o gargalo não é o HTML. No trace sem throttling o Chrome headless fica ~1–2 s sem apresentar frame nas páginas com slideshow no topo, no mobile (home e Quem somos; PLP/PDP e a home desktop não), e nem sempre (algumas rodadas pintam em 0,9 s → nota 87–90). O Lighthouse simulado (o do PageSpeed) extrapola a partir desse trace. Com throttling real (`--throttling-method=devtools`) a home dá **97**; num navegador de verdade (emulação mobile) a 1ª pintura é em 0,39 s. Descartados: CSS escondendo conteúdo (sem JS a página aparece inteira), imagem mobile do hero, animação dos placeholders e o próprio hero (escondido no mobile, a trava continua — por isso não vale trocar por hero estático). **Pista principal:** uma cópia do mesmo HTML servida em localhost (com `<base>` para a loja) pinta em 0,2–0,3 s, sem trava; os headers da home e da PLP são iguais. Ou seja, depende de algo do ambiente da loja publicada — provavelmente scripts da plataforma (`linkedstore-v2`, NubeSDK: o trace mostra um timer dele a cada ~50 ms até ~2,5 s), fora do tema. Vale reportar à Nuvemshop se a nota de laboratório importar.

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
- [x] **Banners no submenu desktop** — mecanismo (nativo `navigation-banner`) + estilo prontos; falta o **lojista cadastrar** os banners reais no admin (ver [PENDENCIAS.md](PENDENCIAS.md)).
- [ ] **Tablet (768–1199):** hoje usa o padrão mobile completo (esconde "Planos" e conta). Reavaliar se quer um layout híbrido que preserve esses itens no tablet.
- [ ] **Barra de benefícios no mobile:** hoje é um strip de scroll horizontal nativo; avaliar quebrar em 2 linhas.
- [x] **FOUC:** resolvido com o fork (2026-10-14) — CSS do build no `<head>` (inject.mjs, modo head).
- [x] **Home:** estrutura + CSS prontos (2026-09-28). Falta **push no homolog, conferência visual** e o conteúdo no Brand Editor (imagens, categorias das abas, URLs de vídeo) — ver [PENDENCIAS.md](PENDENCIAS.md).
- [ ] **Footer** (Figma 24:806 desktop / 24:948 mobile) — próximo passo.
- [ ] **PLP e PDP** (catálogo e produto), desktop + mobile.
- [ ] **Secrets do CI** (quando for automatizar deploy): `NUVEMSHOP_CLI_TOKEN` (via `scripts/cli-token.sh`), `THEME_ID_HOMOLOG`, e a variable `STORE_URL=https://cpapfit4.lojavirtualnuvem.com.br`.
- [ ] **Go-live:** publicar a instalação Ipanema (substitui a Morelia). Rever estratégia de 2 instalações (homolog/prod) dado o limite da plataforma.

---

## 10. Armadilhas (gotchas)

- **Fork liberado (2026-10-14, homolog 14473488)** → o push grava tudo: **sempre `theme pull` / conferir o diff do `theme/` antes de push**, senão arquivos locais antigos sobrescrevem o remoto. Antes do fork, só `custom/`, `templates/` e `settings_data.json` eram graváveis.
- **`css_code` tem limite de 15.000 chars** → por isso o CSS vai no `<style>` do footer.
- **Block "code" (custom_code) tem limite de 50.000 chars** → o `inject.mjs` quebra o CSS em vários `<style>` (cortes entre regras de nível 0), um block por pedaço (`code`, `code_2`…), e o JS no último. Erro típico no push: `Setting "code" of type "custom_code" exceeds limit: 50000 characters`.
- **Dois tokens** (Admin API ≠ CLI de tema). CLI usa `theme/.nuvem`.
- **Menu/config do admin** pode demorar (cache) a refletir no preview — recarregar.
- **Header nativo:** o form de busca fica com `pointer-events:none` fechado; foi preciso forçar `pointer-events:auto` + handler próprio de submit.
- **Preview perde `theme_installation_id`** ao navegar (ex.: busca) → cai no tema publicado. `header-search.js` re-injeta o parâmetro.
- **CI e imagens:** o workflow `theme-deploy` **não** pode sobrescrever `ASSETS_REPO`/`ASSETS_REF` — as imagens vêm do repo de assets fixado em `design/assets.json` (publicado e aquecido por `scripts/publish-assets.sh`). Até 2026-10-14 o CI apontava para o commit do repo do tema, o que daria imagens quebradas (503 do jsDelivr) no primeiro push de prod.
- **Não usar seletor de ID em CSS** (regra da plataforma; IDs são reservados) — usar classes/`js-*`.
- **Deleção via MCP/CLI** (produto, cliente, webhook) não pede confirmação — cuidado.

---

## 11. Referências

- README do projeto: [README.md](README.md) • Front: [docs/frontend.md](docs/frontend.md) • Design: [design/README.md](design/README.md)
- CLI Nuvemshop: <https://dev.nuvemshop.com.br/docs/developer-tools/cli/overview>
- API: <https://tiendanube.github.io/api-documentation/resources>
- Produção (referência de comportamento): <https://www.cpapfit.com.br>
