# design/

Fonte do layout da loja. O `frontend/compose.mjs` transforma isto em `theme/templates/pages/*.json`
(roda no `npm run build`, no Docker em watch e no CI). Para ir do Figma até aqui, use a skill
`figma-to-theme`.

```
design/
├── pages/        uma página por arquivo: home.yaml -> theme/templates/pages/home.json
├── components/   componentes custom: HTML + Tailwind (tw:) + Alpine
└── assets/       imagens usadas como asset:<caminho> (servidas pelo jsDelivr)
```

## Páginas (`pages/<pagina>.yaml`)

A lista `sections` é a ordem na loja. Cada item é **nativo** ou **componente**:

```yaml
sections:
  - native: slideshow              # seção do Ipanema que já existe no JSON
    blocks:
      slide_1:
        settings:
          image: "asset:home/slide-1.webp"
  - component: beneficios          # design/components/beneficios.html
    settings: { vertical_padding: 32 }
  - native: vitrine                # seção nativa nova: precisa de type
    type: product-list
    settings: { title: "Novidades" }
unlisted: keep                     # keep (padrão) | remove
```

| | Seção nativa (`native`) | Componente (`component`) |
|---|---|---|
| O que é | seção do Ipanema (`theme/sections/<type>.tpl`) | HTML próprio numa seção "Personalizada" (`cmp_<nome>`) |
| Dados da loja (produtos, preços, categorias) | ✅ | ❌ sem Twig |
| Editável no Brand Editor | ✅ | ❌ muda só pelo repo |
| Settings válidas | as do `{% schema %}` do `.tpl` | as da seção `custom` (padding, largura…) |

**Quem manda em quê:**

- **Nativas**: o Brand Editor manda. O YAML só sobrescreve as chaves que declarar; o resto vem do JSON
  atual (traga com `theme pull` — skill `brand-editor-sync`).
- **Componentes**: o repo manda. Edição do block "Código" pelo Brand Editor é desfeita no próximo build.
- **Seções fora do YAML** (ex.: adicionadas no Brand Editor) ficam no fim, com aviso. `unlisted: remove` tira.
- **Apagar uma chave do YAML não desfaz o valor**: o JSON já guardou o valor anterior e passa a ser a base.
  Para voltar ao padrão, apague a chave também em `theme/templates/pages/<pagina>.json` (ou mude pelo Brand Editor).

## Componentes (`components/<nome>.html`)

- Classes Tailwind **sempre com `tw:`** — variantes depois do prefixo: `tw:md:grid-cols-3`, `tw:hover:underline`.
- Cores e fontes do Brand Editor: `tw:bg-brand`, `tw:text-brand-accent`, `tw:bg-brand-bg`,
  `tw:text-brand-text`, `tw:font-display`, `tw:font-sans`.
- Imagens: URL absoluta da loja (`src="https://dcdn.mitiendanube.com/…"`) — ver [Assets](#assets).
  (`src="asset:home/banner.webp"` só se o repo for público; não é o caso aqui.)
- Interação com Alpine; componentes JS em `frontend/src/js/components/`.
- Sem Twig, sem id em CSS. Comentários HTML são removidos no build.

## Assets

> **Neste projeto (cpapfit-nuvem) as imagens são hospedadas na loja, não no jsDelivr.**
> O repositório é **privado** e o jsDelivr só serve repositórios públicos — `asset:` daria 404.
> Por isso, aqui as imagens vêm da própria Nuvemshop e são referenciadas por **URL absoluta**
> (`https://…`), que o `compose.mjs` passa intacta (só reescreve strings com prefixo `asset:`).

Como cada imagem chega na loja:

- **Seções nativas** (slideshow, banners, produtos em destaque): suba pelo campo de imagem do
  **Brand Editor**. A Nuvemshop guarda a URL da CDN dela (`dcdn.mitiendanube.com/…`) no JSON; traga
  de volta com `theme pull` (fluxo `brand-editor-sync`). Não hardcode a URL no YAML.
- **Componentes custom** (`components/*.html`, sem Twig): precisam de URL absoluta. Sem fork,
  `static/images/` não chega na loja, então use uma URL da CDN da loja (ex.: reaproveitando a de uma
  imagem já subida pelo Brand Editor). Com a instalação **forkada**, referencie `static/images/…`
  servido pela loja.

### jsDelivr (só para repositório público)

O `compose.mjs` também suporta o modo jsDelivr: `asset:home/x.webp` vira
`https://cdn.jsdelivr.net/gh/<repo>@<commit>/design/assets/home/x.webp` (repo = `ASSETS_REPO`,
commit = `ASSETS_REF`, padrão `HEAD`). Isso **só funciona com o repositório público** e não é usado
aqui. Se um dia o repo virar público (ou os assets forem para um repo público separado via
`ASSETS_REPO`), volte a usar `asset:` — commite e dê push antes de olhar o preview.

## Quando o fork for liberado

Cada `components/<nome>.html` pode virar `theme/sections/<nome>.tpl` com `{% schema %}` — ganha Twig,
dados da loja e campos editáveis no Brand Editor, sem refazer o HTML.
