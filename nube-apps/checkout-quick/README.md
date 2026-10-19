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
| **rodape** | `after_main_content` | entrega, pagamento | faixa azul: 12x sem juros · Frete grátis (ver regras → `/politica-de-entrega/`) · cupom se configurado · "Travou em alguma etapa?" com Fale com a gente / WhatsApp · rodapé legal (razão social, endereço, CNPJ) |
| **pos-compra** | `after_order_number` | pedido confirmado | "Pedido confirmado!" · "Cada atualização do seu pedido chega no seu e-mail." · WhatsApp se configurado |

**Sem prometer o que a loja não garante:** o "10% off no Pix" do site fica fora por padrão porque o desconto Pix
está em 0% nos meios de pagamento; a barra de frete grátis fica desligada porque não há valor mínimo cadastrado.
Os textos repetem o que a loja já anuncia e são todos configuráveis.

Cada parte se refaz sozinha quando carrinho, etapa ou frete mudam (`render` com função do estado).

## Configurações do app (portal de parceiros)

Lidas com `nube.getAppSettings()` — o SDK entrega `{ chave: { type, value } }` e só tem os tipos
`string`, `enrichedText`, `image` e `collection` (não há booleano). Mudar configuração **não** exige nova versão.

| Chave | Tipo | Padrão | Sugestão para a CPAP Fit |
|---|---|---|---|
| `whatsapp` | string (com DDI) | sem WhatsApp | `554840421861` |
| `coupon_text` + `coupon_code` | string | sem cupom | `R$ 100 OFF na linha Philips` + `QUERO100` (se o cupom estiver ativo) |
| `footer_benefits` | collection de string | 12x sem juros · Frete grátis (ver regras) | — |
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
- fora do Worker o runtime exige `self.__APP_DATA__.id` (a plataforma injeta).

## Desenvolvimento

```bash
cd nube-apps/checkout-quick
npm install
npm test            # vitest: configurações, regra, cada parte e o App (slots × etapas)
npm run typecheck   # tipos oficiais (@tiendanube/nube-sdk-types)
npm run build       # -> dist/main.min.js (ESM único, ~10 KB)
npm run dev         # watch + http://localhost:8080/main.min.js (CORS)
```

CI: `.github/workflows/nube-apps.yml` roda typecheck, testes e build em PRs que tocam `nube-apps/**`
e publica o `main.min.js` como artefato.

## Publicar uma versão

O script já existe no portal (**Dev01 → Scripts → "Barra de frete grátis"**, id da associação na loja
`10349`: checkout, instalação automática, **Use NubeSDK** ligado). Para cada mudança:

1. `npm run build` (ou baixe o artefato do CI);
2. no portal, edite o script e **carregue o `dist/main.min.js` como nova versão**;
3. **publique** a versão (enquanto está em teste, só roda na loja demo);
4. confira: `GET /scripts` deve mostrar `status: "active"` e o novo `current_version.version`;
5. confira que o app está **instalado na loja da CPAP Fit** (cpapfit4): em 2026-10-19 nenhuma parte aparecia no
   checkout dela — a versão em teste roda só na loja demo;
6. preencha as configurações sugeridas acima (WhatsApp e, se ativo, o cupom) e faça uma compra de teste até a
   etapa de pagamento, no desktop e no celular.

Evento atual: `onload` (a documentação da Nuvemshop pede aprovação para `onload` na loja; no checkout
ele está funcionando). Se algo não carregar, `onfirstinteraction` não depende de aprovação.
