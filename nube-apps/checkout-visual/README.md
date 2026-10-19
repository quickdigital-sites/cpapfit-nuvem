# checkout-visual — checkout da CPAP Fit igual ao Figma (script clássico)

> **Não funciona como script do portal (2026-10-19).** A documentação de Scripts diz que, com local
> *checkout*, "Uses Nube SDK" é obrigatório e fica travado: o arquivo roda no Web Worker, sem `document`.
> Publicado como script #11529 (LayoutCheck), não estilizou nada e o checkout ficou sem os blocos do app
> #11515. O CSS (`src/checkout.css`) continua válido se um dia entrar pelo `theme/static/checkout.scss.tpl`
> do tema (exige tema forkado) — sem os ajustes que dependem de JS (textos, marca do produto, "× 1").

O app NubeSDK (`../checkout-quick`) só acrescenta blocos em slots: roda num Web Worker, sem acesso à página.
Para o checkout ficar igual ao Figma (`1P4JHFz4FEG8UEBkDOB1qm`, frame `367:13649`) este é um **script clássico**
(sem NubeSDK), que roda na própria página do checkout e:

- injeta o CSS do Figma (`src/checkout.css`): cabeçalho 110px com o logo "10 anos" e o selo "Ambiente 100% seguro",
  etapas CARRINHO — ENTREGA — PAGAMENTO com sublinhado dourado, grade 780 + 100 + 390, rótulos em cima dos campos,
  campos de 50px com cantos de 10px, opções de frete e endereço em cartões creme com rádio dourado, botão verde
  arredondado, resumo com cartões dos produtos (marca acima do nome), totais e botão de cupom;
- troca textos pelos do Figma ("Dados para a entrega", "Telefone", "Complemento (opcional)", "CPF", "Frete");
- mostra só a opção de frete escolhida (ou a primeira) com o link **Mais opções**;
- desenha o rodapé azul na largura da tela (benefícios, endereço/CNPJ, créditos Nuvemshop e Quick Digital,
  faixa em degradê) e esconde a faixa do topo e o rodapé do app NubeSDK, que ficam no lugar dele.

Não mexe em preço, frete, pagamento nem validação: só aparência e textos. Sem o script, o checkout volta ao nativo
(tudo fica sob `html.qd-ck`).

## Arquivos

```
src/main.js            ajustes no DOM + MutationObserver (o checkout é React e redesenha a cada etapa)
src/checkout.css       estilos do Figma, comentados com os ids dos nós
src/logo-10-anos.png   logo do Figma (200x60), embutido no script
build.mjs              junta tudo em dist/checkout-cpapfit.js (sem dependências)
```

```bash
cd nube-apps/checkout-visual
node build.mjs         # -> dist/checkout-cpapfit.js
```

`PIX_DISCOUNT` e `COUPON` no topo de `src/main.js` ligam "10% OFF no Pix" e o cupom QUERO100 (com botão Copiar,
que aqui funciona). Ficam desligados enquanto o desconto Pix estiver em 0% e o cupom não estiver ativo na loja.

## Publicar

No portal de parceiros, app **QuickDevTool (#42989)**:

1. crie um script novo (ex.: "Checkout CPAP Fit — visual"), local **checkout**, evento `onload`,
   **Use NubeSDK desligado**, instalação automática;
2. **Adicionar versão** com o `dist/checkout-cpapfit.js`;
3. **Instalar na loja demo** e teste em `demo501.lojavirtualnuvem.com.br`: compra até a etapa de pagamento,
   no computador e no celular;
4. **Instalar nas Lojas**.

O script #11515 (NubeSDK) continua instalado: ele cuida da nota antes das formas de pagamento e da mensagem do
pedido confirmado. A faixa do topo e o rodapé dele ficam escondidos quando este script roda.

## Cuidados

- Depende das classes do HTML do checkout v3 (`.headbar`, `.breadcrumb-timeline`, `.has-float-label`,
  `.shipping-option`, `#address-form-section`, `.table-subtotal`...). Se a Nuvemshop mudar o checkout, partes
  podem voltar ao visual nativo; o fluxo de compra continua funcionando.
- A marca acima do nome do produto vem do próprio nome ("Produto - Marca (variação)"): sem " - " no nome, não
  aparece marca.
- O Figma só tem a etapa Entrega no computador. Celular e etapa de pagamento seguem o mesmo estilo.
