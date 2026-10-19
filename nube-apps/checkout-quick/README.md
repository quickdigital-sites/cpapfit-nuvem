# checkout-quick — checkout da CPAP Fit (app NubeSDK)

O checkout da Nuvemshop é hospedado — nenhum tema altera o HTML dele. O caminho oficial para colocar UI lá
é um app **NubeSDK**: o script roda isolado num Web Worker e desenha componentes em *slots* predefinidos.
Cada parte do layout é um módulo em `src/features/`, nas cores da CPAP Fit (`src/brand.ts`, os mesmos tokens
do tema da loja). Referência visual: Figma `1P4JHFz4FEG8UEBkDOB1qm`, frame `367:13649` (etapa Entrega, desktop —
é a única tela de checkout do arquivo; pagamento e mobile seguem o mesmo estilo).

## As partes

| Parte | Slot | Etapas | O que mostra (padrão) |
|---|---|---|---|
| **faixa-topo** | `after_header` | entrega, pagamento | "AMBIENTE 100% SEGURO" + cadeado dourado, alinhado à direita (no Figma fica dentro do cabeçalho, que é da Nuvemshop) |
| **frete-gratis** | `after_line_items_price` | entrega, pagamento | **desligada** até `free_shipping_threshold` ser configurado; aí mostra quanto falta + barra |
| **selos-pagamento** | `before_payment_options` | pagamento | cadeado · "Pagamento rápido e protegido" · texto de segurança · "Até 12x sem juros no cartão de crédito" |
| **rodape** | `after_main_content` | entrega, pagamento | rodapé azul do Figma (`363:9230`), ícones do tema: [10% OFF no Pix] · 12x sem juros no cartão de crédito · Frete grátis (ver regras → `/politica-de-entrega/`) · [R$ 100 OFF na linha Philips + QUERO100] · endereço, CNPJ e "© Todos os direitos reservados - loja - ano" com os créditos Nuvemshop e Quick Digital · faixa em degradê. Entre colchetes: desligado por padrão |
| **pos-compra** | `after_order_number` | pedido confirmado | "Pedido confirmado!" · "Cada atualização do seu pedido chega no seu e-mail." · WhatsApp se configurado |

**Sem prometer o que a loja não garante:** o "10% OFF no Pix" fica desligado porque o desconto Pix está em 0% nos
meios de pagamento, e o estado do checkout não informa descontos por meio de pagamento antes de o cliente escolher
(só `prices.discount_gateway`, depois de escolhido). O cupom QUERO100 também fica desligado até estar ativo na loja.
A barra de frete grátis fica desligada porque não há valor mínimo cadastrado.

**Padrões no código:** o app em produção (QuickDevTool) não tem tela de configurações, então `getAppSettings()` volta
vazio e vale `DEFAULTS` em `src/settings.ts`. Para ligar o Pix: `pixDiscount: 10`; o cupom: `coupon: PHILIPS_COUPON`;
o WhatsApp: `whatsapp: "554840421861"`. Depois, nova versão (ver "Publicar uma versão").

Cada parte se refaz sozinha quando carrinho, etapa ou frete mudam (`render` com função do estado).

## Configurações do app (se um dia existirem)

Hoje o app não tem configurações no portal. Se forem criadas, são lidas com `nube.getAppSettings()` e têm prioridade
sobre `DEFAULTS` — o SDK entrega `{ chave: { type, value } }` e só tem os tipos `string`, `enrichedText`, `image` e
`collection` (não há booleano).

| Chave | Tipo | Padrão | Sugestão para a CPAP Fit |
|---|---|---|---|
| `whatsapp` | string (com DDI) | `DEFAULTS.whatsapp` (sem WhatsApp) | `554840421861` |
| `coupon_text` + `coupon_code` | string | `DEFAULTS.coupon` (sem cupom) | `R$ 100 OFF na linha Philips` + `QUERO100` (se o cupom estiver ativo) |
| `footer_benefits` | collection de string | Pix (se ligado) · 12x sem juros · Frete grátis (ver regras); o cupom vem depois | — |
| `top_bar_messages` | collection de string | `Ambiente 100% seguro` | — |
| `payment_note` | string | `Até 12x sem juros no cartão de crédito` | — |
| `free_shipping_threshold` | string | vazio = barra desligada | o mesmo valor da regra de frete grátis do admin, quando existir |
| `company_info` | string | razão social, endereço e CNPJ | — |
| `disabled_features` | collection de string | nenhuma | ex.: `["pos-compra"]` |

## O que o app NÃO consegue (limite da plataforma)

O NubeSDK só **acrescenta** componentes; não esconde, move nem reestiliza o que é da Nuvemshop. Ficam como estão:
cabeçalho (logo vem do admin), indicador de etapas (Carrinho › Entrega › Pagamento), títulos, rótulos e campos
dos formulários, cartões das opções de frete e do endereço, botão "Continuar para pagamento", lista de itens do
resumo (sem a marca acima do nome), subtotal/frete/total, preço no Pix (só aparece se o desconto Pix estiver
configurado), link de cupom e as formas de pagamento. Cor principal, logo e fonte do checkout vêm das
configurações de checkout no admin. O botão "Copiar" do cupom também não existe: o Worker não acessa a área de
transferência.

**O resto do visual vem do tema:** o bloco "CPAP Fit" no fim de `theme/static/checkout.scss.tpl` (tema com fork)
vira o CSS do checkout: cabeçalho com o logo "10 anos" e o selo, etapas, campos, frete, endereço, resumo e o
rodapé deste app na largura da tela (com as margens do celular). Script de checkout é sempre NubeSDK, então não
há como fazer isso com JavaScript. Seguem nativos: textos de exemplo dentro dos campos, marca acima do nome do
produto e o "× 1" do resumo.

## Estrutura

```
src/
  main.tsx              App(nube): registra cada parte no seu slot, filtrando por etapa
  settings.ts           leitura das configurações (formato { type, value } do SDK)
  checkout.ts           etapa atual, URL da loja, link de WhatsApp
  free-shipping.ts      regra da barra (quanto falta, progresso, moeda da loja)
  brand.ts              cores da CPAP Fit
  features/             uma parte por arquivo + index.ts com a ordem
```

Nova parte: crie `src/features/<nome>.tsx` exportando um `Feature` (`name`, `slot`, `steps`,
`render`), adicione em `features/index.ts` e o nome em `FEATURE_NAMES` (`settings.ts`). Slots
disponíveis: [Checkout Slots](https://dev.nuvemshop.com.br/en/docs/applications/nube-sdk/slots/checkout-slots).

Cuidados do SDK:
- não aceita `false` como filho (`{cond && <X/>}` do React não compila) — use listas;
- `Row` não tem `justifyContent="end"`: para alinhar à direita, envolva numa `Column alignItems="end"`;
- não dá para esconder/mover campos nativos nem trocar o cabeçalho da Nuvemshop, só acrescentar;
- ícones fora da lista do `Icon` são desenhados com `Svg.Root` + `Svg.Path` (ex.: os do rodapé);
- fora do Worker o runtime exige `self.__APP_DATA__.id` (a plataforma injeta).

## Desenvolvimento

```bash
cd nube-apps/checkout-quick
npm install
npm test            # vitest: configurações, regra, cada parte e o App (slots × etapas)
npm run typecheck   # tipos oficiais (@tiendanube/nube-sdk-types)
npm run build       # -> dist/main.min.js (ESM único, ~18 KB)
npm run dev         # watch + http://localhost:8080/main.min.js (CORS)
```

CI: `.github/workflows/nube-apps.yml` roda typecheck, testes e build em PRs que tocam `nube-apps/**`
e publica o `main.min.js` como artefato.

## Publicar uma versão

O script fica no app de parceiro **QuickDevTool (#42989)** → script **"Checkout CPAP Fit" (#11515)**: checkout,
evento `onload`, **Use NubeSDK** ligado, instalação automática. Está instalado na loja da CPAP Fit (`cpapfit4`).
Antes de publicar, a versão é testada na loja demo **#8398577** (`demo501.lojavirtualnuvem.com.br`), que tem o app
instalado e um produto de teste. Para cada mudança:

1. `npm run build` (ou baixe o artefato do CI);
2. no portal, abra o script #11515 e clique em **Adicionar versão**; escolha o `dist/main.min.js` no seletor de
   arquivos do navegador;
3. **Instalar na loja demo**;
4. teste em `demo501.lojavirtualnuvem.com.br`: compra até a etapa de pagamento (sem pagar), no desktop e no
   celular, sem erros no console;
5. **Instalar nas Lojas** — a versão passa a rodar na `cpapfit4`; confira lá também.

Evento atual: `onload` (a documentação da Nuvemshop pede aprovação para `onload` na loja; no checkout
ele está funcionando). Se algo não carregar, `onfirstinteraction` não depende de aprovação.
