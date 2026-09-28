# Pendências de desenvolvimento — CPAP Fit

Backlog vivo. Conforme o projeto avança, anotamos aqui o que ficou pendente para
revisitar depois (não deixar cair no esquecimento). O roadmap mais amplo e o
contexto do projeto estão no [HANDOVER.md](HANDOVER.md#9-pendências--próximos-passos).

Convenção: `[ ]` aberto · `[x]` resolvido (mantém no histórico com a data).

---

## Aberto

- [ ] **Cadastrar os banners reais de cada categoria** (conteúdo, no admin).
  O suporte já está pronto (ver "Resolvido"). Falta o lojista **adicionar os blocos
  de banner no Brand Editor** para cada categoria, com a **foto**, o **nome da marca**
  e o **link**. Depende das artes/fotos e dos links de cada linha.

- [ ] **Home — fazer push e conferir no homolog** (2026-09-28). O build foi gerado, mas este checkout
  não tem `.env`/`theme/.nuvem` (credenciais da CLI). Rodar `cd frontend && npm run build` e
  `cd theme && nuvemshop theme push --theme-id "$THEME_ID_HOMOLOG" -y`, depois abrir o preview logado e
  conferir desktop/mobile contra o Figma (0:326 / 0:630). Ajustar o que a renderização real mostrar.
- [x] **Home — imagens do Figma** (2026-09-28): exportadas para `design/assets/home/` (26 arquivos) e
  referenciadas no YAML como `asset:home/…`. Servidas pelo jsDelivr a partir do repo **público**
  `quickdigital-sites/quickdigital-sites-cpapfit-assets` (commit fixado em `design/assets.json`, gravado
  por `scripts/publish-assets.sh`). Trocar imagem = substituir o arquivo, rodar o script, build e push.
  Faltam só as URLs de vídeo (YouTube). Categorias receberam fundo branco quadrado; Serviços, recorte redondo.
- [ ] **Home — links de categoria presumidos** (`/mascaras/`, `/bipaps/`, `/cpaps/cpap-automatico/`,
  `/marcas/...`, serviços etc. em `design/pages/home.yaml` e `design/components/destaques-abas.html`).
  Conferir com as categorias/páginas reais da loja e corrigir.
- [ ] **Home — abas de Destaques:** escolher no Brand Editor a **categoria** de cada vitrine
  `destaques_1..6` (Kits promocionais, Máscaras, Tops CPAPs, Concentradores, Acessórios p/ Polissonografia,
  Acessórios). Hoje todas usam a coleção padrão. Depois dar `theme pull` para não sobrescrever no push.
- [ ] **Home — Dicas & Vídeos:** preencher a URL (YouTube) e a legenda dos 4 vídeos no Brand Editor.
- [ ] **Home — cupom do hero:** confirmar texto/código ("R$ 200 OFF na Resmed" / `QUERO200`) e o link
  do botão "Ver linha completa".
- [ ] **Card de produto — itens sem suporte nativo:** a **marca** acima do nome ("PHILIPS RESPIRONICS")
  e o **coração de favoritos** do Figma não existem no card do Ipanema (precisa de fork ou app).
  O preço Pix aparece com o texto nativo "com Pix" (Figma: "no PIX").
- [ ] **Ícones:** as setas/etiqueta/carrinho/play foram desenhados em CSS (máscara SVG) porque o
  ambiente não conseguiu baixar os SVGs do Figma. Trocar pelos originais se houver diferença visível.

- [ ] **PLP — limites do nativo (2026-09-28):** paginação clássica do tema é de 60 produtos por página
  (Figma mostra 24) e o filtro de preço é por dois campos (Figma mostra slider). Sem fork não dá para mudar.
- [ ] **PDP — seções do Figma sem suporte nativo:** "Ficha técnica" (com download do manual), "Perguntas
  frequentes" e "Vídeo do produto" dependem de conteúdo por produto que o tema não tem (caminhos: fork +
  campos personalizados, ou app). "Detalhes do produto"
  foi feito com a **descrição completa** do produto (o card de compra mostra só as 4 primeiras linhas).
  Também não há: logo da marca no card do título, coração (favoritos) e ícone de zoom. O **seletor de
  quantidade** foi escondido (não existe no Figma) — a quantidade se ajusta no carrinho.
- [ ] **PDP — cupom "Aproveite também"** (R$ 100 OFF na linha Philips / QUERO100) e WhatsApp estão fixos em
  `frontend/src/js/components/pdp.js` — confirmar e ajustar quando a campanha mudar.

---

## Resolvido

- [x] **Banners do submenu — mecanismo nativo + estilo (2026-09-25).**
  Descoberto que o Ipanema tem o bloco nativo **`navigation-banner`** (`theme/blocks/navigation-banner.tpl`),
  renderizado no dropdown desktop por `theme/blocks/header-navigation.tpl` (`.nav-desktop-banners` >
  `.nav-banner-item`). Ele tem campo **`menu_item`** (a categoria), **`image`**, **`title`** e **`url`**,
  todos **editáveis no Brand Editor (navegação), por categoria — sem fork**. Estilizamos o submenu
  (`main.css`) conforme o Figma 0:1070: "Categorias" (subcategorias em 2 colunas) à esquerda + cards de
  banner à direita (imagem + gradiente + rótulo "Linha" e botão "VER LINHA COMPLETA" adicionados via CSS).
  **Como o lojista cadastra:** Brand Editor → navegação (menu) → adicionar bloco **"Banner"** → escolher o
  **item de menu** (categoria), a **imagem** (foto), o **título** (nome da marca, ex.: "Resmed") e o **link**.
  O rótulo "Linha" e o botão são do CSS — usar imagem só com a foto (sem texto embutido).
