# Validação final da loja (2026-10-19)

Loja no ar (tema 14473488), depois do redesign, do editor reorganizado, das melhorias de desempenho e do checkout.

## Responsividade e erros

70 páginas linkadas na home (61 categorias e subcategorias, institucionais, 9 produtos, busca) em 390 e 1440px,
e as principais (home, Máscaras, produto, Quem somos, Fale conosco, Trocas, Nossas lojas, busca) também em
768, 1024, 1200 e 1920px — **202 verificações**:

| Verificação | Resultado |
|---|---|
| Rolagem lateral | nenhuma |
| Erros de JavaScript | nenhum |
| Recursos com erro HTTP (4xx/5xx) | nenhum |
| Páginas 404 | nenhuma |
| Imagens quebradas | nenhuma (2 alertas eram capas de vídeo fora da tela no celular, carregadas só ao arrastar) |

## Fluxo até o checkout

Computador e celular: menu, busca ("mascara", 13 produtos), filtro, adicionar ao carrinho, início do checkout
(Dados de contato / Entrega) — tudo OK, sem erros de JavaScript. O pagamento não foi testado (sem compra).

## Desempenho (loja no ar, mediana de 3 rodadas)

| Página | Formato | Nota antes → agora | LCP | CLS antes → agora | Peso antes → agora |
|---|---|---|---|---|---|
| Home | celular | 81 → 79 | 3.0s → 4.8s¹ | 0.151 → **0.047** | 495KB → 494KB |
| Home | computador | 91 → **95** | 1.7s → **1.2s** | 0.069 → **0.009** | 756KB → **589KB** |
| Categoria | celular | 74 → **79** | 4.9s → **4.2s** | 0.029 → **0.014** | 512KB → 512KB |
| Categoria | computador | 91 → **93** | 1.4s → **1.2s** | 0.066 → **0.002** | 1010KB → **568KB** |
| Produto | celular | 80 → 79 | 4.1s → 4.6s¹ | 0.028 → **0.016** | 449KB → 449KB |
| Produto | computador | 94 → **97** | 1.2s → **1.1s** | 0.045 → **0.004** | 449KB → 449KB |

¹ Variação da medição no celular: a foto do banner termina de baixar no mesmo tempo (~1.0s) antes e depois;
nas rodadas de antes o LCP já ia de 3.0 a 4.8s. No teste controlado (8 rodadas, mesma hora, controle x
teste) a home no celular foi de 80 para 85. Detalhes em [performance.md](performance.md).

## Comparação com o Figma

Home, catálogo, produto, Quem somos, Fale conosco, Trocas, Nossas lojas e checkout (entrega), computador e celular:
estrutura, cores, tipografia e ordem das seções batem. Diferenças que restam:

| Onde | Diferença | Tipo |
|---|---|---|
| Cards de produto | Botão COMPRAR verde-petróleo (Figma: azul-claro) | decisão de contraste já registrada no [gap-report](gap-report.md) |
| Home, "Destaques" e "Os mais vendidos" | Aba "Kits promocionais" mostra produtos sem foto ("Fixador para Cânula", "Filtro para Traqueostomia") | cadastro: falta foto nesses produtos |
| Menu | "Kits Promocionais" do Figma não existe; no lugar está "Saúde respiratória" | cadastro (menu no painel) |
| Home celular, banner | Título em 2 linhas (Figma quebra em 3) | texto do editor; fonte e tamanho iguais |
| Produto | Sem logo da marca no topo; ficha técnica, perguntas e vídeo só aparecem se a descrição/cadastro tiver | cadastro (ver gap-report) |
| Fale conosco | Sem a foto abaixo do título; sem campo de anexo | foto pendente; anexo = plataforma |
| Checkout, rodapé | Computador: 2 benefícios na faixa azul (Figma: 4, com Pix e cupom). Celular: benefícios empilhados com espaços grandes | app do checkout |
