# Pendências de desenvolvimento — CPAP Fit

Backlog vivo. Conforme o projeto avança, anotamos aqui o que ficou pendente para
revisitar depois (não deixar cair no esquecimento). O roadmap mais amplo e o
contexto do projeto estão no [HANDOVER.md](HANDOVER.md#9-pendências--próximos-passos).

Convenção: `[ ]` aberto · `[x]` resolvido (mantém no histórico com a data).

---

## Aberto

- [ ] **Clarity e Trustvox (2026-10-26):** ainda não instalados — dependem dos acessos da CPAP Fit (contas/IDs).
- [x] **add_to_cart no dataLayer (2026-10-26):** a plataforma **já envia** o `add_to_cart` nativo (GTM-KP2VVCPZ,
  Códigos externos) — `{ ecommerce: null }` e depois o evento, no mesmo formato de items do `view_item`, ~1 s depois
  do clique (quando o POST /comprar/ volta). Conferido na loja em: PDP, card da listagem, quick shop (com variante)
  e "+" no carrinho; uma vez por ação. **Não adicionar push próprio** (duplicaria). Se uma tag do GTM não dispara,
  o problema está no container (gatilho "Evento personalizado = add_to_cart", variáveis, consentimento).

- [ ] **Home — LCP de 10 s em parte das rodadas do PageSpeed por causa das tags do GTM (2026-10-27):** a nota da home
  no celular alterna entre dois resultados, sem mudança no tema entre as rodadas (PageSpeed Insights, celular, 27/10):

  | Hora | Nota | LCP | TBT | CLS |
  |---|---|---|---|---|
  | 13:45 | 53 | 10,1 s | 510 ms | 0 |
  | 13:49 | 91 | 2,9 s | 190 ms | 0,035 |
  | 13:52 | 60 | 10,8 s | 370 ms | 0,018 |

  - **A foto não é o problema:** o LCP é sempre a foto do banner (no HTML, `fetchpriority="high"`). Na rodada ruim de
    13:52 ela termina de baixar em ~250 ms (TTFB 30 ms, atraso 190 ms, carga 30 ms) e só aparece **2,1 s depois**
    ("atraso na renderização"); a 1ª pintura da página também atrasa (FCP 2,4 s).
  - **O que ocupa esse tempo:** o container `GTM-KP2VVCPZ` (injetado pela integração GTM da Nuvemshop, não pelo tema)
    e as tags que ele carrega, Google Ads (`gtag/js?id=AW-987…`) e GA4 (`gtag/js?id=G-QK2S6LT9LR`). São 508 KB e
    467 ms de linha de execução principal, o maior terceiro do relatório, e as tarefas mais longas da rodada são
    deles (gtag AW 204 ms, gtag GA4 185 ms, gtm.js 83 + 76 ms). O PageSpeed também aponta
    `popups.rdstation.com.br` no caminho crítico; o RD Station não está no tema, então deve vir pelo container.
  - **Por que só às vezes:** quando esses scripts chegam e rodam antes da 1ª pintura, o Lighthouse soma esse trabalho
    ao tempo da foto e o simula num celular lento, e o LCP vai a ~10 s. Quando a pintura vem antes, o LCP fica em ~3 s.
  - **O tema não resolve:** atrasar o GTM pelo tema mexeria na integração da plataforma e no container, o que está
    fora do escopo combinado ("não tocar no GTM").
  - **Opções para quem administra o container** (cada uma conferida com o PageSpeed antes e depois):
    1. Disparar as tags de Google Ads e GA4 em "Janela carregada" (Window Loaded) em vez de "Visualização de
       página"/"Inicialização". As conversões e o `add_to_cart` seguem pelos eventos do dataLayer, que ficam guardados
       até as tags carregarem.
    2. Ver se o RD Station (popups) precisa rodar em todas as páginas e na carga inicial; se não, restringir a
       página ou atrasar o gatilho.
    3. Revisar tags duplicadas ou sem uso no container: cada `gtag/js` tem ~160–180 KB.

- [ ] **Pós-compra com pedido cancelado (2026-10-26):** o app NubeSDK (`nube-apps/checkout-quick`,
  `features/pos-compra.tsx`, no ar como v5) tem a regra "pedido cancelado não mostra nada", mas a Nuvemshop não envia
  `order.status` para a página de pedido — então num pedido cancelado aparece "Pedido recebido!". O comentário do
  código e o teste descrevem a regra, não o que acontece na loja. Revisitar se o SDK passar a mandar o status do pedido.

- [ ] **QA/UAT do cliente (2026-10-26) — o que depende do admin** (o código está no PR `fix/qa-uat`):
  - **BUG-001 Kits no menu** e **BUG-002 Peças para máscaras no menu:** Loja online › Menus › Menu principal.
    Kits = categoria KITS (id 41699658, 6 subcategorias). Peças para máscaras = subitem de **Máscaras** (são peças
    de máscara; Acessórios é de aparelho). Home: bloco "Categoria" novo em Atalhos em círculo (precisa de imagem).
  - **BUG-007:** vitrine "Kits promocionais" › Produtos › Quais produtos mostrar → categoria KITS.
  - **BUG-009:** cliente escolhe a campanha; o cupom do banner principal (hero) é texto do editor e precisa bater
    com Configurações do tema › Página de produto › Cupom em destaque (que agora alimenta rodapé e produto).
  - **BUG-006/015 (home e Quem somos):** os círculos de Serviços têm o link no editor (aluguel e acompanhamento).
  - **BUG-013:** nenhuma rede social cadastrada no admin (o rodapé mostra 4 links fixos do componente).
  - **BUG-017:** título da home e og:image vêm da plataforma (SEO do admin / logo).

- [ ] **PASSOS (Oxi Saúde) — o que depende do admin (2026-10-23):** faixa do topo e pílula na barra azul já vêm no
  tema (`utm_medium=topo` / `faixa`). Falta no admin: (1) **Serviços** do menu principal é o menu do admin, sem
  "Em breve" no código — trocar "Apoio e Monitoramento de CPAP" pelo link PASSOS (`utm_medium=servicos`) em
  Loja online › Menus; (2) **Rodapé**: criar um menu com os 4 links de Serviços + "Programa PASSOS"
  (`utm_medium=rodape`) e escolher em Personalizar › Rodapé › Menus do rodapé › Coluna 3. Base:
  `https://acompanhamento.oxisaude.com.br/?utm_source=cpapfit&utm_campaign=passos`. Ainda virão `produto` e `pedido`.
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
