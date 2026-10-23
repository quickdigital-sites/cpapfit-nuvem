---
name: theme-section
description: Receita para criar ou alterar uma seção, bloco ou snippet do tema Nuvemshop (Ipanema) da CPAP Fit com campos no editor "Personalizar layout", seguindo os padrões do repo. Use ao mexer em theme/sections, theme/blocks, theme/snippets ou nos JSON de templates.
---

# Seção / bloco / snippet com campos no editor

## 1. Antes de criar, procure o que já existe

- O Ipanema tem muita coisa pronta e sem uso (ex.: `sections/announcement-bar.tpl`, `blocks/navigation-banner.tpl`).
  `grep -rn "\"name\"" theme/sections theme/blocks` lista os nomes do editor.
- Prefira **estender** (um setting novo, um modo novo) a criar seção paralela.
- Onde a seção aparece: `theme/templates/pages/<página>.json` ou `theme/templates/layout/{header,footer}.json`.
  Home, rodapé e algumas páginas são **gerados** de `design/pages/*.yaml` (`frontend/compose.mjs`): para eles,
  mude o YAML, não o JSON.

## 2. Estrutura do arquivo

```twig
{# Nome — o que faz (Figma <nó>) #}
{% set item = block.settings %}
… HTML …
{% schema %}
{ "name": "Nome no editor", "icon": "…", "settings": [ … ], "presets": [ … ] }
{% endschema %}
```

- Seção: `section.settings`, `section.blocks`, `{{ block | block_attributes }}` no elemento raiz do bloco.
- Blocos filhos permitidos ficam em `"blocks": [{ "type": "…", "limit": N }]` do schema do pai.
- Snippet: `{% include 'snippets/x.tpl' with { … } %}`, sem schema.

## 3. Campos (settings)

- `id` com prefixo **`qd_`** quando o campo é nosso num arquivo do Ipanema (`qd_enabled`, `qd_pill`).
- Tipos usados no repo: `toggle`, `text`, `richtext`, `inline_richtext`, `url`, `color`, `select`, `radio`,
  `range`, `image_picker`, `menu`, `icon_picker`; e `header` / `paragraph` para organizar.
- `label` e `info` em **português do lojista** ("Mostrar a faixa", "Vazio: a coluna some."). Os textos do Ipanema
  usam `t:…` (traduções em `theme/translations/*.schema.json`); campo nosso pode ter texto direto.
- `visible_if` / `disabled_if` com Twig: `"{{ block.settings.qd_pill }}"`.
- Liga/desliga: toggle com `default: true` e teste `is not same as(false)` no Twig — campo ainda não salvo
  não esconde nada.
- Toda URL de setting/menu num `<a>`: `{% include 'snippets/qd-link-attrs.tpl' with { url: … } %}`.

## 4. Valores padrão

- Padrão do campo no schema (`default`) e na `preset` (quando o lojista adiciona a seção).
- Valor da loja no JSON do template (`templates/…json`) ou no YAML de `design/pages/`.
- Texto e link de negócio vêm do pedido ou do Figma — **não invente**.

## 5. CSS e JS

- CSS em `frontend/src/css/<área>.css`, escopado pela seção (`[data-section-id="…"]` ou classe da seção),
  regra de unidades da skill `css-units`. JS só como melhoria, em `frontend/src/js/components/`, registrado em
  `main.js`.

## 6. Conferir e documentar

```bash
cd frontend && npm run build && npm run lint
cd ../theme && nuvemshop theme diff --theme-id "$THEME_ID_HOMOLOG"   # só suas mudanças?
```

- Push: `scripts/theme-push.sh homolog`. JSON de template novo/alterado de propósito precisa de
  `FORCE_CONTENT=1` (senão o sync traz o JSON do editor por cima).
- Verifique o HTML renderizado (curl na loja ou preview) e o visual em 375 e 1440.
- Registre os campos em `docs/editor-mapa.md` ("Novos" + comportamento quando vazio) e o que depender do admin em
  `PENDENCIAS.md`.
