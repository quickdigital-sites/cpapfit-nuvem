# Gap report — Figma × loja publicada (2026-10-19, antes da implementação)

Figma `1P4JHFz4FEG8UEBkDOB1qm`, página Desktop `0:1`. Loja: tema publicado 14473488 (fork do Ipanema).
Comparação feita em 1920, 1280, 768 e 390 px (390 e 768 com emulação mobile real). Status: **ok** = bate com o
Figma; **parcial** = existe mas diverge; **falta** = não existe; **bug** = quebra layout ou comportamento;
**plataforma** = o tema não consegue mudar.

## Inventário de frames

| Figma | Tela |
|---|---|
| `0:326` / `0:630` | Home desktop / mobile |
| `24:550` (`24:584` header02, `24:689` header-flutuante), `24:1079` | Header desktop, flutuante, mobile |
| `0:1068` | Mega menu |
| `24:1739` | Busca aberta (mobile) |
| `24:804` / `24:947` | Footer desktop / mobile |
| `24:486` / `24:1659` | Card de produto (vitrine) desktop / mobile |
| `24:2370` / `24:2687` / `35:10503` | Catálogo desktop / mobile / gaveta de filtros |
| `35:10696` / `66:17596` | Produto desktop / mobile (com barra de compra fixa `66:17863`) |
| `271:6244` / `271:6399`, `271:3986` | Nossas lojas desktop / mobile, card de loja |
| `271:8536` / `305:5991` | Fale conosco desktop / mobile |
| `271:9547` / `305:6364` | Troca e devolução desktop / mobile |
| `271:10421` / `305:6755` | Quem somos desktop / mobile |
| `363:11206` / `364:11498` / `364:12124` | Minicarrinho desktop / mobile / sobre a página |
| `367:13649` | Checkout, etapa "Entrega" |

## 0. Regressão encontrada

| Onde | Problema | Arquivo |
|---|---|---|
| Home (todas as larguras) | **Categorias, Marcas, Dicas & Vídeos e Serviços estão escondidas.** A regra que esconde as seções da Quem somos nas outras páginas também pega a home (mesmos ids). | `frontend/src/css/institucional.css:23` |

## 1. Componentes globais

| Figma | BP | Arquivos | Status | O que diverge |
|---|---|---|---|---|
| Header `24:584` | ≥1200 | `main.css`, `header-plans.js`, `header-search.js`, `settings_data.json` | parcial | Logo ~105×30 (Figma ~185×50); falta o ícone de localização; carrinho é sacola índigo (Figma: carrinho dourado com contador); ícone da pílula Planos diferente; busca larga demais (~935 vs ~500 px); linha 1 com 80 px (Figma ~110); chevrons pequenos e colados. |
| Barra de benefícios | todos | barra nativa `.navigation-bar` | parcial | 31 px, `#000066`, 2 itens. Figma: 64 px, `#2F3295`, 4 itens com ícones, cupom e botão COPIAR (já existe igual em `footer-topo.html`). No mobile o Figma não tem a barra no header. |
| Header flutuante `24:689` | ≥1200 | `main.css` × `store.js` | **bug** | Ao rolar, o `store.js` sobe o header 31 px achando que a barra está em cima; como a barra foi para baixo, corta o topo da logo/busca e a barra continua visível. Figma: linhas 1 e 2 com sombra. |
| Header mobile `24:1079` | <1200 | `main.css` | parcial | Barra de benefícios aparece; hambúrguer escuro (Figma claro sobre dourado); carrinho sem contador; placeholder "Buscar" (Figma "O que você procura hoje?"); logo pequena. |
| Mega menu `0:1068` | ≥1200 | `main.css`, bloco nativo `navigation-banner` | parcial | Sem banners cadastrados, as colunas se espalham pela tela (2ª coluna em x≈984). Mostra 3 níveis em negrito; Figma mostra lista simples 15 px. |
| Busca aberta `24:1739` | 390 | sugestão nativa, `header-search.js` | parcial | Sugere produtos (Figma: lista de termos com o trecho em negrito — **plataforma**, não há API de termos). Falta botão limpar (X); o botão de buscar some ao digitar. |
| Footer `24:804` / `24:947` | todos | `footer.yaml`, `footer-*.html`, `footer.css`, `footer.js` | ok | Colunas desktop ~40–80 px deslocadas para a direita. |
| Card `24:486` / `24:1659` | todos | `product-card.css`, snippets `product/item*` | parcial | Falta marca acima do nome (dado existe: `product.brand`), preço Pix, linha de parcelas do Figma, borda azul no hover; coração de favoritos (**plataforma**: não há lista de desejos no tema). Botão COMPRAR teal `#00816e` (Figma ciano — escolha de contraste, ver decisões). |
| Minicarrinho `363:11206` etc. | todos | nenhum (`mini-cart.js` é um resto sem uso) | **falta** | O `#modal-cart` nativo está sem estilo. Configuração contra o Figma: `cart_open_type: show_notification` (Figma abre a gaveta) e `show_cart_shipping: false` (Figma tem "Calcular frete"). |

## 2. Home

| Figma | BP | Seção (`home.yaml`) | Status | O que diverge |
|---|---|---|---|---|
| Hero `0:329` / `0:654` | todos | `hero` | parcial | 1 slide só (Figma: setas e 4 pontos — depende de conteúdo); título grande demais em 768. |
| Categorias `0:351` / `0:668` | todos | `categorias` | **escondida** (item 0) | Em 1280 o 7º item corta e as setas ficam fora da tela; mobile com rótulos em 2 linhas e espaçamento maior. |
| Destaques `0:367` / `0:691` | todos | `cmp_destaques_abas`, `destaques_1..6`, `home-tabs.js` | parcial | **1280: setas a -32 px geram rolagem lateral.** 768: 5 colunas, COMPRAR corta. Mobile: sem "espiar" o 3º card; 8 pontos (Figma 3). Aba "Kits promocionais" sem categoria. |
| Linhas (marcas em destaque) `0:393` / `0:765` | todos | `linhas` | ok ≥1280 e 390; **bug** 768 | Em 768 texto e pílula da logo cortados. |
| Mais vendidos `0:414` / `0:786` | todos | `mais_vendidos` | parcial | Mesmos problemas de setas; **mostra os mesmos produtos da aba 1 de Destaques** (as duas usam a coleção padrão). |
| Marcas `0:427` / `0:848` | todos | `marcas` | **escondida** (item 0) | ~150 px de espaço sobrando em cima; mobile sem borda nos círculos e sem pontos. |
| Banners promo `0:459` / `0:878` | todos | `banners_promo` | ok | Mobile: 40 px entre banners (Figma 12). |
| Dicas & Vídeos `0:462` / `0:881` | todos | `videos` | **escondida** (item 0) | Sem ícone de play (só aparece com URL de vídeo); 4 cards com a mesma capa e legenda. |
| Serviços `0:478` / `0:907` | todos | `servicos` | **escondida** (item 0) | Mobile: 4º item corta. |

## 3. Catálogo

| Figma | BP | Arquivos | Status | O que diverge |
|---|---|---|---|---|
| Cabeçalho (título, breadcrumb, contagem, ordenação) | ≥1280 | `plp.js`, `plp.css` | ok | Em 1280 o título quebra em 2 linhas. |
| Layout | 768–1023 | `plp.css` | **bug** | Coluna de filtros 324 px + 4 colunas: rolagem lateral, cards de ~75 px. |
| Filtros laterais (categorias, atributos, chips aplicados) | desktop | `property-filters.tpl`, `category-filters.tpl`, `remove-filters.tpl` | ok | Dados reais. Valores bagunçados vêm do cadastro ("Unico/único", "Ref. …", "Brx504s18"). |
| Faixa de preço `35:10301` | todos | `price-filter.tpl` | **falta** | Dois campos + botão; Figma é slider. Viável no tema (grava `min_price`/`max_price`). |
| Grade 4 col / 2 col | desktop / 390 | `category.yaml` | ok | |
| Paginação | todos | `pagination.tpl`, `plp.js` | parcial | Números montados em JS; **60 por página** (Figma 24). Viável no tema: `paginate by` em `main-products-grid.tpl`. |
| Gaveta de filtros `35:10503` | 390 | `filters-modals.tpl`, `plp.js` | parcial | Tela cheia (Figma painel de 338 px); linha de preço cortada à direita; falta divisória no topo. |
| Texto SEO + "ver mais" | todos | `plp.js` | código ok, **sem conteúdo** | Nenhuma categoria tem descrição. |

## 4. Produto

| Figma | BP | Arquivos | Status | O que diverge |
|---|---|---|---|---|
| Layout | 768–1400 | `pdp.css` | **bug** | Em 768 a coluna de compra fica com 40 px e sai da tela; em 1280 o cupom vaza ~200 px. |
| Breadcrumb | todos | `pdp.js` | ok | |
| Topo (logo da marca, nome, código, coração) | todos | `pdp.js` | parcial | Sem logo da marca; mostra SKU da variante em vez do código; coração = **plataforma**. |
| Galeria + miniaturas | todos | `product-media` nativo, `pdp.css` | parcial | Sem ícone de zoom; setas das miniaturas invisíveis; sem miniatura de vídeo. |
| Preço De/Por + % OFF | todos | `pdp.css` | não verificável | Nenhum produto tem preço promocional. |
| Preço Pix + selo | todos | `payment-discount-price.tpl` | **configuração** | O desconto Pix está em 0% nos meios de pagamento (admin); por isso o bloco some. |
| Parcelas + selo | todos | `pdp.js` | parcial | Sem selo de desconto no cartão; barra do topo diz "6x" e a página "12x". |
| Variantes | todos | `pdp.css` | parcial | Grupo de valor único ("Cor: Unico") aparece; rótulo "Tamanho:" (Figma "Selecione o tamanho"); valores com "Ref." (cadastro). |
| Comprar / WhatsApp / cupom | todos | `pdp.js`, `pdp.css` | ok (fixos no código) | WhatsApp e cupom fixos em `pdp.js`; dá para usar `store.whatsapp` e configurações. |
| Calcular frete | todos | `pdp.js` | ok | |
| Detalhes do produto | todos | `pdp.js` | parcial | Despeja a descrição inteira (~3.570 px), títulos com 40 px justificados (estilos inline do admin vencem o CSS). |
| Ficha técnica + manual | todos | — | **falta** | A tabela já está na descrição (h2 "Ficha Técnica, Manual e Garantia"); não há link de manual. |
| Perguntas frequentes (sanfona) | todos | — | **falta** | As perguntas já estão na descrição (h2 "Perguntas frequentes"). |
| Vídeo do produto | todos | — | **falta** | Campo nativo `product.video_url` existe; vazio nos produtos testados. |
| Veja também | todos | `alternative_products` nativo | parcial | Setas e pontos ok; cards com as mesmas lacunas do card global. |
| Barra de compra fixa `66:17863` | 390 | — | **falta** | |

## 5. Institucionais e atendimento

| Figma | BP | Arquivos | Status | O que diverge |
|---|---|---|---|---|
| Nossas lojas `271:6244` | 1920 | `nossas-lojas.html`, `institucional.js/.css` | ok | 1 loja cadastrada (Figma 4 — conteúdo). |
| Nossas lojas mobile `271:6399` | 390 | idem | parcial | Não usa a variante mobile do card (sem subtítulo, "Contato:"). |
| Fale conosco `271:8536` / `305:5991` | todos | `main-contact.tpl`, `contact.json`, `institucional.js` | parcial | Falta a foto abaixo do título; no mobile o bloco de contato fica escondido; reCAPTCHA desalinhado. Caixa de anexo = **plataforma** (o formulário nativo não envia arquivo). |
| Troca e devolução `271:9547` / `305:6364` | todos | `institucional.js/.css` | parcial | Figma é sanfona de perguntas + "Ainda continua com dúvida?" e botão FALE CONOSCO; hoje é texto corrido. Falta divisória sob o título no mobile; texto 16 px (Figma ~14). |
| Quem somos `271:10421` / `305:6755` | todos | `page.yaml`, `home.css`, `institucional.css` | parcial | **768–1240: rolagem lateral** (linha de vídeos); título "Categorias" escondido no desktop; marcadores da lista fora da coluna; margem mobile 36 px (Figma 20). Negritos soltos no texto (conteúdo). |
| Políticas, Planos (sem frame) | todos | `page.json` | ok | Em Planos o "Assinar agora" é link simples, não botão. |

## 6. Checkout

| Figma | Status | Motivo |
|---|---|---|
| `367:13649` Entrega | **plataforma** | O checkout é da Nuvemshop; o tema não tem templates dele (só cores/logo no admin). A camada `filtros-marcados` nesse frame está oculta e é sobra de outro arquivo. |
