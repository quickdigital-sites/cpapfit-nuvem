# Pendências de desenvolvimento — CPAP Fit

Backlog vivo. Conforme o projeto avança, anotamos aqui o que ficou pendente para
revisitar depois (não deixar cair no esquecimento). O roadmap mais amplo e o
contexto do projeto estão no [HANDOVER.md](HANDOVER.md#9-pendências--próximos-passos).

Convenção: `[ ]` aberto · `[x]` resolvido (mantém no histórico com a data).

---

## Aberto

- [ ] **Banners dentro do submenu (menu desktop).**
  O submenu do designer (Figma `0:1068`) tem, além das "Categorias" à esquerda,
  **2 banners à direita** (ex.: "Linha Resmed" / "Linha Philips Respironics") — cards
  com imagem de fundo, rótulo "Linha", nome da marca, botão dourado "VER LINHA COMPLETA"
  e logo da marca. O menu **nativo** do Ipanema não tem esse conteúdo, então será
  **injetado via JS** dentro de cada `.desktop-dropdown`.
  Depende de definir:
  1. Os banners são **fixos** (mesmos em todas as categorias) ou **variam por categoria**? Se variam, precisamos do mapa `categoria → [banner1, banner2]`.
  2. As **imagens** dos banners (repo é privado → hospedar na CDN da loja via Brand Editor) e os **links** de cada botão.
  Registrado em 2026-09-25.

---

## Resolvido
<!-- mover itens concluídos para cá com a data -->
