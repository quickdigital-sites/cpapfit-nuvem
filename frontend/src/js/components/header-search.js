/**
 * Busca do header (enhancement).
 *
 * A busca é o form NATIVO do Ipanema (action="/search/", GET, name="q"), que
 * forçamos visível como pílula via CSS (sem fork). O store.js do tema intercepta
 * o Enter no input (para as sugestões) e acaba bloqueando o submit nativo — daí
 * "o input fica sem ação". Aqui garantimos a navegação no Enter e no clique do
 * botão, e preservamos o theme_installation_id para o preview do rascunho não
 * cair no tema publicado.
 */
function go(form) {
  const input = form.querySelector(".js-search-input");
  const q = (input && input.value || "").trim();
  if (!q) {
    if (input) input.focus();
    return;
  }
  const url = new URL(form.getAttribute("action") || "/search/", location.origin);
  url.searchParams.set("q", q);
  const tid = new URLSearchParams(location.search).get("theme_installation_id");
  if (tid) url.searchParams.set("theme_installation_id", tid);
  window.location.assign(url.toString());
}

function bind() {
  document.querySelectorAll(".search-container form.js-search-form").forEach((form) => {
    if (form.dataset.qdSearch) return;
    form.dataset.qdSearch = "1";
    const input = form.querySelector(".js-search-input");
    // capture: roda antes do handler do tema, que faz preventDefault no Enter
    if (input) {
      input.addEventListener(
        "keydown",
        (e) => {
          if (e.key === "Enter") {
            e.preventDefault();
            e.stopPropagation();
            go(form);
          }
        },
        true
      );
    }
    const btn = form.querySelector(".search-submit-btn, .js-search-input-submit");
    if (btn) {
      btn.addEventListener(
        "click",
        (e) => {
          e.preventDefault();
          e.stopPropagation();
          go(form);
        },
        true
      );
    }
  });
}

export default function initHeaderSearch() {
  const start = () => {
    bind();
    const header = document.querySelector("header.js-header") || document.body;
    new MutationObserver(bind).observe(header, { childList: true, subtree: true });
  };
  if (document.readyState !== "loading") start();
  else document.addEventListener("DOMContentLoaded", start);
}
