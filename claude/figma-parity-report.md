# Paridade Figma × loja — CPAP Fit (2026-10-23)

- **Figma:** cópia `QOFUK135D5y7jq7aWyKMth` ("[Quick] Redesign CPAP Fit - Nuvemshop (Copy)"), usada porque a conta
  conectada ao MCP não tem acesso de edição ao original `1P4JHFz4FEG8UEBkDOB1qm`. Os ids de nó são os mesmos do
  original (os comentários do CSS continuam valendo).
- **Loja:** `https://cpapfit4.lojavirtualnuvem.com.br`, tema 14473488 publicado. O CSS no ar ainda é o de antes da
  Fase 2 (px); a conversão para rem foi medida sem diferença visual, então vale a mesma comparação.
- **Larguras:** 1920 (largura dos frames desktop) e 390 (mobile), com medidas no navegador (`getBoundingClientRect` /
  `getComputedStyle`). Tolerância: até 2px não conta. Método: skill `.claude/skills/figma-parity-check`.
- **Severidade:** alta = quebra layout, esconde/corta conteúdo ou componente diferente em área principal;
  média = diferença visível (> 4px) ou estado faltando; baixa = detalhe.

## 1. Mapa de frames → loja

Página **Desktop** (`0:1`) é a fonte: tem os frames desktop *e* mobile.

| Frame (Figma) | Tela na loja | Template / origem | Comparado |
|---|---|---|---|
| `0:326` home-CPAP-desktop / `0:630` home-cpap-mobile | `/` | `templates/pages/home.json` ← `design/pages/home.yaml` | sim (1920 / 390) |
| `24:550` header (+ `24:1165`), `24:1079` header-mobile | todas | `templates/layout/header.json` | sim (dentro das páginas) |
| `24:804` Footer / `24:947` footer-mobile | todas | `templates/layout/footer.json` ← `design/pages/footer.yaml` | sim |
| `0:1068` desktop-menu (mega menu) | hover no menu principal | `blocks/header-navigation.tpl` + bloco `navigation-banner` | sim (1920) |
| `24:1739` busca-aberta | busca no mobile | `snippets/header/search-form.tpl` | sim (390) |
| `24:486` vitrine / `24:1659` vitrine-mobile | card de produto | `snippets/product-list/product-item/item.tpl` | sim (nas vitrines) |
| `24:2370` catalogo-CPAP-desktop / `24:2687` catalogo-CPAP-mobile | `/cpap-e-bipap/` | `templates/pages/category.json` | sim |
| `35:10503` mobile-filtros | gaveta "Filtrar" | `snippets/product-list/filters/filters-modals.tpl` | sim (390) |
| `35:10696` produto-CPAP-desktop / `66:17596` produto-CPAP-mobile | `/produtos/airsense-11-…/` | `templates/pages/product.json` | sim |
| `271:6244` nossas-lojas / `271:6399` mobile, `271:3986` Store Card | `/nossas-lojas/` | `templates/pages/page.json` + seção `qd-stores` | sim |
| `271:8536` fale-conosco / `305:5991` mobile | `/contato/` | `templates/pages/contact.json` | sim |
| `271:9547` troca-e-devolucao / `305:6364` mobile | `/trocas-e-devolucoes/` | `templates/pages/page.json` + `institucional.js` | sim |
| `271:10421` quem-somos / `305:6755` mobile | `/quem-e-a-cpap-fit/` | `templates/pages/page.json` ← `design/pages/page.yaml` | sim |
| `363:11206` / `364:11498` / `364:12124` minicart (desktop / mobile / sobre a página) | gaveta do carrinho | `snippets/cart/cart-panel.tpl` etc. | sim (1920) |
| `367:13649` entrega (checkout) | checkout, etapa Entrega | `static/checkout.scss.tpl` (só estilo) | **não** nesta rodada (precisa de pedido em andamento) |

**Sem tela correspondente (sinalizados):**

| Nó | O que é |
|---|---|
| Página `1:953` Capa | capa do arquivo |
| Página `1:482` Mobile (`1:483`, `35:9345`, `35:10502`, `66:17105`) | cópias antigas dos frames mobile da página Desktop (ex.: home `1:483` tem 4510px de altura × 4428 no `0:630`) |
| Página `209:2909` Page 4 (9 frames) | cópia de trabalho dos frames de home, menu, busca, catálogo e produto |
| `0:596` Novidades, `24:1659` / `24:486` vitrine, `271:3986` Store Card | componentes (cobertos pelas telas acima) |
| `24:482`, `269:2927`, `363:8096` | faixas-título das seções do arquivo (não são telas) |
| `209:7647` image 28 | imagem solta no canvas |

## 2. Diferenças

### Alta — corrigida nesta fase

| # | Tela | Elemento | Esperado (Figma) | Atual (antes) | Correção |
|---|---|---|---|---|---|
| A1 | Produto 1920 e 390 (`35:10696` / `66:17596`) | Resumo "Descrição" no card de compra | 4 linhas de texto (~88px) | banner da descrição (imagem ~400px) dentro do resumo: bloco de 465px empurrando frete e garantia para baixo | `pdp.css`: as imagens do editor do admin vêm com `display: inline-block` inline, que vencia o `display: none` do resumo → `!important` (e `picture`, `figure`) só no resumo. Medido depois: 88px, 0 imagens visíveis, nas duas larguras. A descrição completa continua com as imagens em "Detalhes do produto". |

### Média — para aprovação

| # | Tela | Elemento | Esperado (Figma) | Atual | Correção proposta |
|---|---|---|---|---|---|
| M1 | Home 1920 (`0:383`, `0:417`), Produto "Veja também" | Carrossel de produtos | trilho 228–1688 (1460px), cards ~290px, setas fora (x≈182 e ≈1738) | trilho 176–1744 (1568px), cards 301px, setas em 128–172 | `home.css`: limitar o trilho a 91,25rem centralizado e posicionar as setas fora dele |
| M2 | Home / catálogo 390 (`24:1659`) | Altura do card de produto | 324px | 380px (largura 154 ✓): linha a mais "ou R$ preço cheio" + ~45px vazios acima do COMPRAR | `product-card.css`: tirar o espaço vazio antes do botão; decidir se a linha "ou R$ …" sai no mobile (Figma junta em "ou R$ 310,00 em 10x de R$ 31,00") |
| M3 | Header (`24:550`, `24:1079`) | Logo | logo comemorativo "10 anos" | logo padrão | **admin/asset:** confirmar com o cliente qual logo vale e subir no editor |
| M4 | Mega menu (`0:1068`) | Banners "Linha Resmed / Philips" | 2 cards à direita | só a lista de categorias | **admin:** cadastrar os blocos "Banner" por item do menu (o tema já suporta) |
| M5 | Home 1920 e 390 (`0:462`, `0:881`) | Capas dos vídeos | botão play sobre a capa | sem play (só aparece com URL de vídeo) | **admin:** preencher a URL do YouTube de cada vídeo |
| M6 | Home (`0:329`, `0:654`) | Hero | setas + 4 pontos (4 slides) | 1 slide, sem setas/pontos | **admin:** cadastrar os outros slides |
| M7 | Header / menu (`24:550`) | Item "Kits Promocionais" | no menu e na 1ª aba de Destaques | ausente no menu; aba aponta para a coleção padrão | **admin:** criar a categoria (já em PENDENCIAS) |

### Baixa — para aprovação

| # | Tela | Elemento | Esperado (Figma) | Atual | Correção proposta |
|---|---|---|---|---|---|
| B1 | Home 1920 | Recuo do conteúdo | conteúdo a partir de x=160 | x=176 (container 160–1760 ✓ + 16px de respiro) | ajustar o padding do container nas seções da home (afeta várias seções — validar antes) |
| B2 | Home 1920 (`0:393`, `0:459`) | Banners Linhas / promo | 164–950 e 188–940 | 176–950 e 176–940 | ajustar junto com B1 |
| B3 | Home (`0:459`, `0:878`) | Imagens dos banners promo | nítidas | arquivo de 595px exibido em 764px (fica borrado em tela retina) | **asset:** exportar em 2× (1528px) |
| B4 | Home 390 (`0:654`) | Título do hero | 3 linhas | 2 linhas (caixa de texto mais larga) | `home.css`: `max-width` do título no mobile |
| B5 | Home 390 (`0:668`) | Nomes das categorias | "BIPAPs", "CPAPs", "Portátil" (curtos) | nomes das categorias ("BIPAPs \| VPAPs", "CPAP Automático") | **conteúdo:** nomes curtos nos blocos do editor, se o cliente quiser |
| B6 | Produto 390 (`66:17596`) | Breadcrumb | não aparece no mobile | aparece (≈60px antes do título) | `pdp.css`: esconder abaixo de 48em |
| B7 | Produto 390 | Resumo da descrição | ~9 linhas | 4 linhas | aumentar o clamp no mobile |
| B8 | Footer 390 (`24:947`) | Ícones + / − do acordeão | dourados | brancos | `footer.css`: cor `--qd-gold` |
| B9 | Catálogo 1920 | Altura das linhas da grade | cards iguais | 516 / 594 / 625px conforme o conteúdo ("Última peça!", sem estoque sem botão) | aceitar (estado sem estoque não existe no Figma) |
| B10 | Gaveta de filtros (`35:10503`) | Grupos | 1º e 2º abertos | todos fechados | `plp.js`: abrir o 1º grupo |
| B11 | Trocas 390 (`305:6364`) | Texto do topo | ~14px | 16px | `institucional.css` |
| B12 | Trocas (`271:9547`) | Título da página | "Troca, Devolução, Garantia" | "Trocas e Devoluções" | **admin:** título da página |
| B13 | Quem somos (`271:10421`) | Texto | subtítulo "Nossos Produtos e Serviços" + divisória | negritos soltos e subtítulo em linha (conteúdo do editor) | **admin:** reescrever com H2/parágrafos (já em PENDENCIAS) |
| B14 | Cards (`24:486`) | Preço Pix | "no PIX" | "com Pix" (texto nativo) | já em PENDENCIAS |

### Decisões já registradas / limites da plataforma (sem ação)

- Botões COMPRAR em teal `#00816E` (Figma ciano): decisão de contraste WCAG (docs/gap-report.md).
- Coração de favoritos, sugestão de *termos* na busca, anexo no Fale conosco, 24 produtos por página: plataforma.
- Selos "% OFF" e preço De/Por: dependem de preço promocional cadastrado.
- Barra "faltam R$ X para frete grátis" no carrinho: depende do frete grátis mínimo no admin.
- Os 4 frames de produto/catálogo usam a mesma máscara DreamWear de exemplo; a loja mostra o catálogo real.

## 3. Placeholders do Figma (não copiar)

- Trocas (`271:9547` / `305:6364`): texto Lorem Ipsum e 10 itens "Garantia" repetidos.
- Catálogo e gaveta de filtros: "Filtro 1 exemplo", "Categoria", "Filtro 2", "Filtro 3", R$ 20,00–100,00.
- Nossas lojas: o mesmo card 4× com subtítulo "SC / Balneário Camboriú" e telefones diferentes no desktop e no mobile.
- Produto: "Fabricante: Philips Respironics" 5× na ficha técnica; perguntas repetidas no FAQ; "Cod. do Produto: 139".
- Minicarrinho: o mesmo item 2×, "Mandaê: Econômico" 2×, CEP 22222-222; contador "09" no carrinho do header.

## 4. Como foi medido (e o que não vale como evidência)

- Screenshots do Figma por frame (MCP) lado a lado com a loja, depois medida no navegador de cada diferença.
- **Capturas headless da loja não servem para mobile nem para carrossel:** o Chrome headless tem largura mínima
  (~500px) e, com viewport muito alta, o Swiper calcula outro layout e o lazy-load não dispara. Toda diferença
  vista nelas foi conferida no navegador real em 1920×1080 e 390×844 antes de entrar aqui; várias eram artefato
  (cards de lojas "sumindo", acordeão de Trocas, contato do Fale conosco, imagens não carregadas).
- Checkout (`367:13649`) ficou fora desta rodada: precisa de um pedido em andamento; a última conferência está em
  PENDENCIAS.md (2026-10-19).
