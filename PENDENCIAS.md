# Pendências de desenvolvimento — CPAP Fit

Backlog vivo. Conforme o projeto avança, anotamos aqui o que ficou pendente para
revisitar depois (não deixar cair no esquecimento). O roadmap mais amplo e o
contexto do projeto estão no [HANDOVER.md](HANDOVER.md#9-pendências--próximos-passos).

Convenção: `[ ]` aberto · `[x]` resolvido (mantém no histórico com a data).

---

## Aberto

- [ ] **Checkout (2026-10-19):** visual do Figma `367:13649` no ar pelo tema (bloco "CPAP Fit" no fim de
  `theme/static/checkout.scss.tpl`; script de checkout é sempre NubeSDK, então JS no checkout não serve). O rodapé
  azul vem do app NubeSDK `nube-apps/checkout-quick`. **Falta (Denis):** subir o `dist/main.min.js` atual como v.3
  do script #11515 (QuickDevTool #42989), testar no demo501 e instalar nas lojas — até lá o rodapé fica no layout da
  v.2. **Falta conferir:** etapa de pagamento e pedido confirmado com o CSS novo. Não usar `static_url` no
  checkout.scss.tpl: no primeiro envio o checkout perdeu o CSS do tema (revertido em minutos).
- [x] **Tema publicado mudou (2026-10-19):** a loja tinha passado a usar o **14688507 "CPAP Fit — Dev (1.4.2)"**
  (criado e publicado fora da sessão). O **14473488** foi publicado de novo a pedido do Denis; o 14688507 ficou como
  rascunho (base Ipanema 1.4.2, sem o trabalho de 2026-10-19). Se um dia for preciso atualizar a base do Ipanema, as
  mudanças do fork terão de ser levadas para o tema novo.
- [ ] **Itens da auditoria Figma × loja (2026-10-19):** lista do que a loja precisa preencher e do que é limite da
  plataforma em [docs/gap-report.md](docs/gap-report.md) ("Não feito" e "O que a loja precisa preencher").
- [x] **PLP — 24 por página (2026-10-19):** testado no tema com fork — a plataforma ignora o valor do `paginate`
  (continua 60). O slider de preço foi feito (campos nativos min/max por baixo).

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
- [x] **Links do site conferidos (2026-10-14):** rastreados home, PLP, PDP e institucionais (82 links internos).
  Corrigidos 13: categorias reais (`/cpap-e-bipap/...`), marcas pelo filtro `/produtos/?brand=<Marca>` (a loja não
  tem página de marca; `/resmed/` era a subcategoria de CPAP automático), serviços em `/servicos/...`, Dreamstation e
  Kits por busca (não há categoria), pílula "Planos" → `/planos-de-assinatura/`. As 5 páginas que
  faltavam foram criadas/publicadas no admin (ver item abaixo). Rastreio final: **0 links quebrados**.
- [ ] **Páginas de conteúdo criadas no admin (2026-10-14)** — Política de Privacidade, Política de Entrega e Troca,
  Devolução, Garantia com os textos de cpapfit.com.br (limpos: sem fontes inline, seções viraram títulos);
  Nossas lojas com uma frase de introdução. Conferir/ajustar:
  - [x] **Planos de assinatura** (2026-10-14): texto provisório trocado pelo conteúdo real da página
    `cpapfit.com.br/pages/clube-de-assinatura-cpap-fit` (planos Sono Bom 06/12/24 — R$ 399/349/289 por mês —,
    benefícios e condições, copiados sem alterar). Os botões "Assinar agora" do site antigo iam para o checkout da
    **Vindi, que hoje dá 404**; na página nova vão para o WhatsApp (48) 4042-1861 com o nome do plano.
    **Cliente:** confirmar se preços/condições continuam valendo e se há um novo link de contratação (Vindi).
  - [x] **E-mail do DPO na Política de Privacidade** (2026-10-14): padronizado em `laura@cpapfit.com.br`.
    Motivo: `cpapfit.com` não tem registro MX (não recebe e-mail); `cpapfit.com.br` tem (Google/Zoho) e todos os
    outros endereços da loja e do site antigo usam `.com.br`. O `laura@cpapfit.com` era erro de digitação do texto
    original.
  - "Trocas e Devoluções" tinha só uma imagem sem relação ("Tratamento individualizado", WhatsApp de 28/07); foi trocada
    pelo texto da política. A imagem continua no CDN da loja se for útil em outro lugar.
  - Publicação no admin: página só publica marcando "Criar um link para esta página no menu…". Foi criado o menu
    **"Institucional (páginas de conteúdo)"** com as 5 páginas — **não apagar** (o tema não o exibe; o header usa o Menu
    principal e o footer/coluna lateral têm links próprios).
- [x] **Home — abas de Destaques (2026-10-14):** abas 2–6 ligadas às categorias reais (Máscaras, CPAP e BiPAP,
  Concentradores de oxigênio, Acessórios para polissonografia, Acessórios para CPAP e BiPAP — `products_source` em
  `design/pages/home.yaml`) e carregadas sob demanda. **Falta:** a aba 1 "Kits promocionais" não tem categoria na loja
  (usa a coleção padrão; o link `/kits-promocionais/` dá 404) — criar a categoria ou trocar a aba.
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

- [ ] **Institucionais — páginas que faltam no admin (2026-10-14).** O menu lateral e o footer apontam para
  `/nossas-lojas/`, `/politica-de-privacidade/`, `/politica-de-entrega/` e `/planos-de-assinatura/`, que **não
  existem** na loja (só `quem-e-a-cpap-fit` e `contato` respondem 200). Criar em Admin → Páginas com esses slugs
  (Nossas lojas pode ficar com o conteúdo vazio: os cards vêm do componente). **`/trocas-e-devolucoes/`** está no
  sitemap mas dá **404** (provavelmente não publicada) — publicar no admin.
- [ ] **Institucionais — conteúdo do admin** (Quem somos, Troca): o texto veio do editor antigo (lista `<ul>` com
  um `<li>` por parágrafo, Arial 12px inline). O JS remove os estilos inline, mas a estrutura do Figma
  (parágrafos, subtítulos "Como funciona?", "Termo de Garantia", "Nossos Produtos e Serviços") só aparece se o
  conteúdo for reescrito no admin com parágrafos e títulos (H2/H3).
- [ ] **Nossas lojas — dados das lojas:** só a loja de Florianópolis é conhecida (o Figma repete o mesmo card
  4×, com telefones diferentes no desktop e no mobile). Confirmar a lista real, telefone/e-mail/horário de cada
  loja e uma foto por loja (`design/components/nossas-lojas.html`; a foto atual é a do Figma, 290px).
- [ ] **Fale conosco — opções de "Motivo"** são palpite (`MOTIVOS` em `frontend/src/js/components/institucional.js`).
  O formulário nativo só envia nome/e-mail/telefone/mensagem: motivo, cidade/UF e assunto vão no início da
  mensagem. Confirmar com a loja se o e-mail que chega atende.
- [ ] **Quem somos — CPAP Dreamstation** aponta para `/cpap-e-bipap/` (não há categoria própria na loja).

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

- [x] **Menu principal com 2 itens a mais (2026-10-14):** ao publicar as páginas de conteúdo (caixa "Criar um link
  para esta página no menu…"), o admin acrescentou **"Trocas e Devoluções"** e **"Planos de assinatura"** ao Menu
  principal. **Removidos** com aval do Denis (Admin → Menus → lixeira → **Salvar** no fim da página — sem o Salvar
  a exclusão não persiste). As 5 páginas continuam publicadas pelo menu "Institucional (páginas de conteúdo)" (200).
