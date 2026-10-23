---
name: figma-parity-check
description: Compara uma página da loja CPAP Fit com o frame correspondente no Figma (desktop e mobile), mede espaçamento, tipografia, cores, raios e estados, e reporta as diferenças com severidade. Use para auditoria Figma × loja, revisão visual de uma seção ou antes de fechar uma tarefa de layout.
---

# Paridade Figma × loja

Arquivo: https://www.figma.com/design/1P4JHFz4FEG8UEBkDOB1qm/-Quick--Redesign-CPAP-Fit---Nuvemshop?node-id=0-1&m=dev
(fileKey `1P4JHFz4FEG8UEBkDOB1qm`). Use o MCP do Figma (`.mcp.json`).

## 1. Mapear frame → página

| Figma | Loja |
|---|---|
| Home desktop / mobile | `/` (`templates/pages/home.json`, `design/pages/home.yaml`) |
| Categoria (PLP) | `/cpap-e-bipap/` ou outra categoria com produtos |
| Produto (PDP) | uma página de produto com variação e preço promocional |
| Carrinho | carrinho lateral e `/comprar/` |
| Institucionais | `/quem-e-a-cpap-fit/`, `/contato/`, `/nossas-lojas/`, políticas |
| Header / menu / footer | todas as páginas (`templates/layout/*.json`) |
| Checkout | `checkout.scss.tpl` (frame 367:13649) |

Liste as páginas e os frames do arquivo com o MCP (metadata do nó `0:1` e de cada página) e marque frame sem
página — e página sem frame — como **não mapeado**. Frames já citados no CSS (`Figma 24:661`) ajudam a achar o par.

## 2. Capturar os dois lados

- Figma: screenshot e `get_design_context` / variáveis do frame (valores exatos: px, cores, fontes, raios).
- Loja: navegador em **375** (mobile do Figma 390 → confira também 390), **768** e **1440** (desktop do Figma
  1440/1920). Use `https://cpapfit4.lojavirtualnuvem.com.br/` (ou o preview do rascunho, logado).
- Meça com `getComputedStyle` / `getBoundingClientRect` no navegador, não "no olho".

## 3. O que medir

| Item | Como |
|---|---|
| Espaçamento | padding/margin/gap entre blocos, altura de seção, distância título → conteúdo |
| Tipografia | família, peso, `font-size`, `line-height`, `letter-spacing`, caixa (uppercase) |
| Cores | fundo, texto, borda, ícone — compare hex; use os tokens `--qd-*` |
| Raios e bordas | `border-radius`, espessura e cor da borda |
| Dimensões | largura/altura de botões, inputs, cards, imagens (proporção) |
| Layout | colunas, alinhamento, ordem, quebra de linha, o que some no mobile |
| Estados | hover, foco, ativo, desabilitado, aberto/fechado (acordeão, dropdown), vazio, erro |
| Conteúdo | textos e links — placeholder do Figma (lorem, "Nome do produto") é **reportado**, nunca copiado |

Tolerância: até 2px em medidas e diferença de antialiasing não contam.

## 4. Severidade

- **Alta:** quebra layout, esconde/corta conteúdo, cor ou tipografia de marca errada em área principal,
  componente diferente do Figma, problema só no mobile que atrapalha a compra.
- **Média:** espaçamento/tamanho visivelmente diferente (> 4px) ou estado faltando (hover, foco).
- **Baixa:** diferença pequena (2–4px, peso de fonte em texto secundário), detalhe decorativo.
- Limite da plataforma (sem suporte nativo) → severidade + "limite da plataforma" e caminho possível.

## 5. Relatório

Uma linha por diferença, agrupada por página e largura:

```markdown
## Home — mobile 375 (Figma 0:630)
| # | Elemento | Esperado (Figma) | Atual (loja) | Sev. | Correção proposta |
|---|---|---|---|---|---|
| 1 | Título "Categorias" | 20px/700, #4A4A48 | 24px/700 | média | `home.css`: `font-size: 1.25rem` |
```

Feche com: frames não mapeados, placeholders encontrados e itens que dependem do admin (conteúdo, menus).
Corrija só o que foi combinado (ex.: só as altas) e liste o resto para aprovação.
