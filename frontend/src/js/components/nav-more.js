/**
 * Menu principal no desktop: o que não couber na linha vai para um item "Mais" no fim.
 *
 * Primeiro o CSS aperta o menu quando há 9+ itens (main.css, :has(nth-child(9))). Se ainda sobrar
 * item, este script tira itens do fim (nunca o 1º, "Menu") e lista cada um no submenu do "Mais",
 * com o mesmo visual dos outros submenus (abre no hover, pelo CSS nativo). Recalcula ao carregar,
 * quando as fontes chegam e ao redimensionar. Abaixo de 1200px o menu é o do hambúrguer: nada muda.
 */
const DESKTOP = window.matchMedia("(min-width: 75em)");

export default function initNavMore() {
  const run = () => {
    const list = document.querySelector(".js-nav-desktop-list");
    if (!list || list.dataset.qdNavMore) return;
    list.dataset.qdNavMore = "1";

    const more = document.createElement("li");
    more.className = "nav-item nav-main-item nav-dropdown qd-nav-more";
    // o painel copia a moldura de um submenu existente (mesmas classes/estilos inline do tema)
    const panel = list.querySelector(".nav-main-item.nav-dropdown .js-desktop-dropdown")?.cloneNode(false)
      || Object.assign(document.createElement("div"), { className: "js-desktop-dropdown nav-dropdown-content desktop-dropdown" });
    const box = list.querySelector(".nav-main-item.nav-dropdown .desktop-dropdown-container")?.cloneNode(false)
      || Object.assign(document.createElement("div"), { className: "desktop-dropdown-container" });
    const ul = document.createElement("ul");
    ul.className = "desktop-list-subitems list-unstyled qd-nav-more-list";
    box.append(ul);
    panel.append(box);
    const label = document.createElement("a");
    label.href = "#";
    label.className = "nav-list-link";
    label.setAttribute("aria-haspopup", "true");
    label.textContent = "Mais";
    label.addEventListener("click", (e) => e.preventDefault());
    more.append(label, panel);

    const items = () => [...list.children].filter((li) => li !== more && li.classList.contains("nav-main-item"));
    const overflows = () => list.scrollWidth > list.clientWidth + 1;

    const fit = () => {
      items().forEach((li) => (li.hidden = false));
      ul.replaceChildren();
      more.remove();
      if (!DESKTOP.matches || !overflows()) return;
      list.append(more);
      const movable = items().slice(1); // o 1º ("Menu") fica sempre
      for (let i = movable.length - 1; i >= 0 && overflows(); i--) {
        const li = movable[i];
        const a = li.querySelector(":scope > a");
        if (!a) continue;
        li.hidden = true;
        const link = a.cloneNode(true); // mantém href, target/rel e o texto
        link.className = "nav-list-link nav-list-link-heading";
        link.querySelectorAll("svg").forEach((svg) => svg.remove());
        const item = document.createElement("li");
        item.className = "nav-item";
        item.append(link);
        ul.prepend(item);
      }
    };

    let timer = 0;
    const schedule = () => {
      clearTimeout(timer);
      timer = setTimeout(fit, 100);
    };
    fit();
    document.fonts?.ready.then(fit);
    window.addEventListener("resize", schedule);
    DESKTOP.addEventListener("change", schedule);
  };
  if (document.readyState !== "loading") run();
  else document.addEventListener("DOMContentLoaded", run);
}
