# Desempenho da loja — antes e depois (2026-10-19)

Medições com Lighthouse 12.8 local (a API do PageSpeed estava sem cota), mediana de 3 rodadas por página/formato
(8 rodadas em home e categoria no celular). Páginas: home, categoria **Máscaras**, produto **CPAP Básico AirSense S10**.
INP não existe em teste de laboratório; o equivalente é o TBT.

## 1. Linha de base (loja no ar, antes de qualquer mudança)

| Página | Formato | Nota | LCP | CLS | TBT | Peso |
|---|---|---|---|---|---|---|
| Home | celular | 81 | 3.0s | **0.151** | 4ms | 495KB |
| Home | computador | 91 | 1.7s | 0.069 | 0ms | 756KB |
| Categoria | celular | 74 | 4.9s | 0.029 | 138ms | 512KB |
| Categoria | computador | 91 | 1.4s | 0.066 | 0ms | **1010KB** |
| Produto | celular | 80 | 4.1s | 0.028 | 0ms | 449KB |
| Produto | computador | 94 | 1.2s | 0.045 (0.11 em 1 de 3) | 0ms | 449KB |

## 2. Antes x depois

Comparação justa: duas cópias do tema no modo de pré-visualização, rodadas alternadas —
**controle** (cópia intacta da loja no ar) x **teste** (com as mudanças). A pré-visualização tem a barra de
rascunho e o servidor responde mais devagar, então os números absolutos diferem um pouco da loja no ar;
o que vale é a diferença entre as duas colunas.

| Página | Formato | Nota | LCP | CLS | Peso |
|---|---|---|---|---|---|
| Home | celular | 80 → **85** | 4.1s → **3.4s** | 0.042 → 0.039 | 554KB → 554KB |
| Home | computador | 91 → 87¹ | 1.6s → 1.8s¹ | 0.045 → **0.003** | 815KB → **646KB** |
| Categoria | celular | 75 → 75 | 4.9s → 4.9s | 0.028 → **0.011** | 571KB → 571KB |
| Categoria | computador | 90 → 91 | 1.5s → 1.4s | 0.063 → **0.001** | 988KB → **560KB** |
| Produto | celular | 81 → 81 | 4.3s → 4.0s | 0.026 → **0.008** | 509KB → 509KB |
| Produto | computador | 94 → **96** | 1.3s → 1.2s | 0.040 → **0.004** | 509KB → 509KB |

¹ Home no computador: nas rodadas do teste o servidor respondeu mais devagar (TTFB 1.2–1.6s x 0.9–1.4s).
O que depende do tema melhorou: a foto do banner começa a carregar na hora (atraso 0ms) e o tempo de pintura
depois dela caiu de 150–200ms para 18–34ms. A nota oscila com o tempo de resposta do servidor.

Teste de fumaça nas duas cópias, computador e celular: menu, busca ("mascara", 13 produtos), filtro, adicionar
ao carrinho e início do checkout — tudo OK, sem erros de JavaScript.

## 3. O que mudou

| Commit | Mudança | Efeito |
|---|---|---|
| `c37d048` + `c80543d` | Logo com a altura reservada no CSS (48px celular / 74px computador) | Sem ela o header crescia 16px quando a logo chegava e empurrava a página (era 0.12 do CLS de 0.15 da home no celular). A logo segue com lazy-load: sem ele ela disputava banda com as fotos dos produtos e a categoria no celular piorava |
| `9710e18` | Altura do menu do computador reservada desde o início | O Ipanema imprime o menu com altura 0 e o JS só depois o mostra: a página descia 60px (CLS ~0.11 no produto). O menu continua invisível até o JS |
| `a401aa5` | 1ª foto do banner principal num `<picture>` com `fetchpriority=high` | A foto do computador vinha pelo lazy-load do carrossel (só depois do JS) e o computador baixava também a do celular. Agora cada tela baixa só a sua, na hora |
| `d13c0d7` | `sizes` das fotos dos cards: 300px no computador (era 50vw) | O computador baixava a foto de 1024px para cards de 220–250px. Categoria: −430KB; home: −170KB |

Nada visual mudou: altura das páginas idêntica ao controle em 1440/1200/1024/390px e capturas de tela do
topo da home idênticas pixel a pixel.

### Avaliado e não feito

- **CSS crítico inline / remover CSS sem uso.** Os 3 arquivos que bloqueiam a pintura (2 do Ipanema + o nosso)
  chegam juntos, num só ida-e-volta ao CDN da plataforma. Colocar o CSS crítico no HTML exigiria um recorte
  por tipo de página (banner na home, grade na categoria, galeria no produto); um recorte errado mostra a página
  sem estilo por um instante e ela pula. O CSS sem uso é quase todo do Ipanema (regras de outras páginas e
  recursos desligados) — tirá-lo é refatorar o tema base.
- **Pré-carregar a fonte** — feito depois (2026-10-27): a Montserrat passou a vir do repo público de assets
  (jsDelivr, URL fixa por commit, cache imutável), pré-carregada no topo do `layout.tpl`, sem o CSS do Google.
  Motivo: com `display=swap`, nos ~50ms entre o CSS do Google chegar e o woff2 terminar, o Chrome desenhava o
  texto numa 3ª largura e linhas no limite quebravam diferente (CLS ~0,1 em Política de entrega). A fonte reserva
  (`Montserrat Fallback`) ganhou uma face por peso no mesmo período. Ver o PR para os números.
- **Foto do banner no computador (137KB).** É um arquivo único de 1920px no jsDelivr, que não gera tamanhos
  menores. Para economizar ~70KB, subir a foto pelo editor (a Nuvemshop gera os tamanhos) ou publicar uma
  versão de 1280px.

## 4. Gargalos fora do nosso controle

| Gargalo | Peso | Sugestão |
|---|---|---|
| **Tempo de resposta do servidor da Nuvemshop** (TTFB) | 1.1–1.9s no celular, 0.65–1.8s no computador — a maior parte do LCP | Nada a fazer no tema. Vale abrir chamado com a Nuvemshop se o TTFB real (Search Console / CrUX) também for alto |
| **HTML grande** (cards do Ipanema; home ~700KB sem compressão, categoria com 60 produtos por página) | 470–680ms de CPU só para ler a página no celular; a foto do 1º produto da categoria começa ~1.3–2.3s depois | Reduzir o HTML dos cards é mexer no tema base; a plataforma ignora outro número de produtos por página |
| `linkedstore-v2.js` (plataforma) | 58KB de JS sem uso | Da plataforma, não muda pelo tema |
| JS base do Ipanema (`store.js`, `libraries-standalone.js`) | ~20KB sem uso, cache curto | Cache definido pela plataforma |
| Cloudflare (`email-decode`, beacon) | pequeno | Da plataforma |

**Terceiros:** praticamente nada — só Google Fonts (35KB). Não apareceu GA4, GTM, pixel nem script de app
no HTML ou na rede da home. Se a loja deveria ter rastreamento ativo, vale conferir: pode estar só depois
do consentimento de cookies, ou não estar instalado.

## Achado à parte (corrigido)

A página de produto no celular tinha rolagem lateral (448px numa tela de 390px, por causa de uma tabela com
`width: 984px` colada na descrição) e home, categoria e produto ficavam com 1220px numa tela de 1200px (menu
com 8 itens não cabia entre 1200 e 1239px; cartões de vídeo da home até ~1270px). Corrigido no commit seguinte:
sem rolagem lateral em 390/768/1024/1200/1220/1240/1280/1440px nas três páginas.
