/**
 * Abas de "Destaques" da home (design/components/destaques-abas.html).
 *
 * Cada aba aponta (data-qd-tab) para o data-section-id de uma seção NATIVA product-list.
 * Mostra só a seção da aba ativa. A 1ª aba cujo alvo existe começa ativa.
 * Abas cujo alvo não existe na página (seção removida no Brand Editor) somem.
 *
 * O carrossel (Swiper) da vitrine inicializa escondido e calcula largura 0; ao mostrar,
 * disparamos "resize" para o Swiper recalcular.
 */
const sectionFor = (id) => document.querySelector(`[data-section-id="${CSS.escape(id)}"]`);

function setup(root) {
  const tabs = [...root.querySelectorAll("[data-qd-tab]")].filter((tab) => {
    const ok = !!sectionFor(tab.dataset.qdTab);
    if (!ok) tab.hidden = true;
    return ok;
  });
  if (!tabs.length) return;

  const activate = (active) => {
    for (const tab of tabs) {
      const on = tab === active;
      tab.classList.toggle("is-active", on);
      tab.setAttribute("aria-selected", on ? "true" : "false");
      const section = sectionFor(tab.dataset.qdTab);
      section.classList.toggle("qd-tab-panel-active", on);
      section.classList.add("qd-tab-panel");
    }
    window.dispatchEvent(new Event("resize"));
  };

  for (const tab of tabs) {
    tab.addEventListener("click", (e) => {
      e.preventDefault(); // sem JS, a aba é um link para a categoria
      activate(tab);
    });
  }
  root.classList.add("qd-tabs-ready");
  activate(tabs[0]);
}

export default function initHomeTabs() {
  const run = () => document.querySelectorAll("[data-qd-tabs]").forEach(setup);
  if (document.readyState !== "loading") run();
  else document.addEventListener("DOMContentLoaded", run);
}
