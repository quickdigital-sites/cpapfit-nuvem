---
name: css-units
description: Regra de unidades do CSS do tema CPAP Fit (rem, em, %, clamp; quando px é permitido). Use ao escrever ou revisar CSS em frontend/src/css, ao converter px e quando o Stylelint acusar unit-disallowed-list.
---

# Unidades no CSS

Vale para `frontend/src/css/*.css` (o `npm run lint` confere). Não vale para o CSS do Ipanema
(`theme/static/css/style-*.css`) nem para arquivos gerados.

## A regra

| O quê | Unidade | Exemplo |
|---|---|---|
| `font-size`, `line-height` com unidade, `letter-spacing` | `rem` | `13px` → `0.8125rem` |
| margin, padding, gap, `top/left/…` de componente | `rem` | `24px` → `1.5rem` |
| `border-radius` | `rem` (pílula: `999px` vira `62.5rem`, ou use `50%` em círculo) | `20px` → `1.25rem` |
| largura/altura de componente (ícone, botão, input) | `rem` | `width: 52px` → `3.25rem` |
| largura de layout / container | `%`, `max-width` em `rem`, `clamp()` se o Figma for fluido | `max-width: 80rem` |
| media query | `em` | `@media (min-width: 768px)` → `48em` |

Conversão: `px / 16`, no máximo 4 casas decimais, sem zero à direita (`0.8125rem`, `0.6875rem`, `1.0313rem`).
Raiz = 16px: **não mude o `font-size` de `html`**.
`line-height` sem unidade (`1.4`) continua sem unidade. `0` fica `0`.

Media queries: `max-width: 1199.98px` → `74.9988em`; `767.98px` → `47.9988em`.
Em `em` dentro de media query, 1em = 16px (font-size inicial do navegador), não o do elemento.

## Onde `px` é permitido

1. Bordas e hairlines de **1px/2px**: `border: 1px solid …`, `border-top-width: 2px`, `outline: 2px …`,
   `outline-offset: 2px`. O lint libera `px` nas propriedades `border*` de largura/forma curta e `outline*`
   (não em `border-radius`).
2. Offsets/blur de sombra: `box-shadow`, `text-shadow`, `filter: drop-shadow(…)`.
3. Hairline feita com tamanho (`height: 1px` de um divisor) e valores impostos pela plataforma/terceiros
   (ex.: o Ipanema define `width: 52px` inline e só um `px` igual sobrepõe sem quebrar). Nesses casos,
   desligue o lint **só na linha**, com motivo:

```css
/* stylelint-disable-next-line unit-disallowed-list -- hairline de 1px do Figma */
.qd-divider { height: 1px; }
```

Nunca `stylelint-disable` no arquivo inteiro.

## Converter sem mudar o visual

- É troca de unidade, não redesign: o valor calculado tem que ser o mesmo (`13px` = `0.8125rem` a 16px).
- Arredondamento em 4 casas dá diferença < 0,01px — aceitável.
- Valores em `calc()` também: `calc(100% - 32px)` → `calc(100% - 2rem)`.
- Variáveis `--qd-*` com tamanho também convertem.
- Confira antes/depois em 375, 768 e 1440 de largura (skill `figma-parity-check`, seção de captura).
