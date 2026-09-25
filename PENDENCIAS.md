# Pendências de desenvolvimento — CPAP Fit

Backlog vivo. Conforme o projeto avança, anotamos aqui o que ficou pendente para
revisitar depois (não deixar cair no esquecimento). O roadmap mais amplo e o
contexto do projeto estão no [HANDOVER.md](HANDOVER.md#9-pendências--próximos-passos).

Convenção: `[ ]` aberto · `[x]` resolvido (mantém no histórico com a data).

---

## Aberto

- [ ] **Cadastrar os banners reais de cada categoria** (conteúdo, no admin).
  O suporte já está pronto (ver "Resolvido"). Falta o lojista **adicionar os blocos
  de banner no Brand Editor** para cada categoria, com a **foto**, o **nome da marca**
  e o **link**. Depende das artes/fotos e dos links de cada linha.

---

## Resolvido

- [x] **Banners do submenu — mecanismo nativo + estilo (2026-09-25).**
  Descoberto que o Ipanema tem o bloco nativo **`navigation-banner`** (`theme/blocks/navigation-banner.tpl`),
  renderizado no dropdown desktop por `theme/blocks/header-navigation.tpl` (`.nav-desktop-banners` >
  `.nav-banner-item`). Ele tem campo **`menu_item`** (a categoria), **`image`**, **`title`** e **`url`**,
  todos **editáveis no Brand Editor (navegação), por categoria — sem fork**. Estilizamos o submenu
  (`main.css`) conforme o Figma 0:1070: "Categorias" (subcategorias em 2 colunas) à esquerda + cards de
  banner à direita (imagem + gradiente + rótulo "Linha" e botão "VER LINHA COMPLETA" adicionados via CSS).
  **Como o lojista cadastra:** Brand Editor → navegação (menu) → adicionar bloco **"Banner"** → escolher o
  **item de menu** (categoria), a **imagem** (foto), o **título** (nome da marca, ex.: "Resmed") e o **link**.
  O rótulo "Linha" e o botão são do CSS — usar imagem só com a foto (sem texto embutido).
