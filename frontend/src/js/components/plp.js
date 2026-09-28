/**
 * PLP — categoria / busca (Figma 24:2370 desktop, 24:2687 mobile).
 * Progressive enhancement sobre o main-products-grid NATIVO do Ipanema:
 *  - Cabeçalho da listagem: título + breadcrumb + "Exibindo X–Y de N produtos" + ordenação.
 *    No desktop vai para o topo da coluna de produtos (ao lado dos filtros); no mobile volta
 *    para o page-header (centralizado, acima dos botões Filtrar / Ordenar).
 *  - Paginação numerada (1 2 3 4) a partir do contador nativo "1 / 4" e dos links das setas.
 *  - Grupos de filtro do desktop recolhíveis (chevron), como no Figma.
 *  - Descrição da categoria vira o bloco de "texto SEO" no fim, com "+ ver mais".
 */
const mq = window.matchMedia("(min-width: 768px)");
const PER_PAGE = 60; // paginação "classic" do tema pagina de 60 em 60 (sem fork não dá para mudar)

function buildHead(grid) {
  const header = document.querySelector(".page-header");
  const titleRow = header?.querySelector(".page-header-title-row");
  const productsCol = grid.querySelector(".js-product-table")?.parentElement;
  if (!titleRow || !productsCol || document.querySelector(".qd-plp-head")) return;

  const head = document.createElement("div");
  head.className = "qd-plp-head";

  const titleBox = document.createElement("div");
  titleBox.className = "qd-plp-title";
  const h1 = titleRow.querySelector(".page-header-title");
  const crumbs = titleRow.querySelector(".breadcrumbs");
  if (h1) titleBox.append(h1);
  if (crumbs) titleBox.append(crumbs);
  head.append(titleBox);

  const total = parseInt(titleRow.querySelector(".page-header-count")?.textContent || "", 10);
  const onPage = productsCol.querySelectorAll(".js-product-table > .js-item-product").length;
  if (total && onPage) {
    const current = parseInt(document.querySelector(".pagination-counter span")?.textContent || "1", 10) || 1;
    const start = (current - 1) * PER_PAGE + 1;
    const end = start + onPage - 1;
    const count = document.createElement("p");
    count.className = "qd-plp-count";
    count.innerHTML = `Exibindo ${start}-${end} de <strong>${total} produtos</strong>`;
    head.append(count);
  }

  const sort = productsCol.querySelector(".product-list-sort-by");
  if (sort) head.append(sort);

  const desc = titleRow.querySelector(".page-header-description");
  if (desc && desc.textContent.trim()) buildSeo(grid, desc, h1?.textContent.trim());

  const home = header.querySelector(".container") || header;
  const place = () => (mq.matches ? productsCol.prepend(head) : home.append(head));
  place();
  mq.addEventListener("change", place);
  header.classList.add("qd-plp-header");
}

function buildSeo(grid, desc, title) {
  const box = document.createElement("section");
  box.className = "qd-plp-seo";
  box.innerHTML = `<div class="container"><h2 class="qd-plp-seo-title"></h2><div class="qd-plp-seo-text"></div>
    <button type="button" class="qd-plp-seo-more" aria-expanded="false">+ ver mais</button></div>`;
  box.querySelector(".qd-plp-seo-title").textContent = title || "";
  box.querySelector(".qd-plp-seo-text").append(...desc.childNodes);
  desc.remove();
  grid.after(box);
  const text = box.querySelector(".qd-plp-seo-text");
  const btn = box.querySelector(".qd-plp-seo-more");
  requestAnimationFrame(() => {
    if (text.scrollHeight <= text.clientHeight + 2) btn.hidden = true; // texto curto: sem "ver mais"
  });
  btn.addEventListener("click", () => {
    const open = box.classList.toggle("is-open");
    btn.setAttribute("aria-expanded", String(open));
    btn.textContent = open ? "- ver menos" : "+ ver mais";
  });
}

function buildPagination() {
  const nav = document.querySelector(".pagination-nav");
  if (!nav || nav.dataset.qdDone) return;
  const spans = [...nav.querySelectorAll(".pagination-counter span")].map((s) => parseInt(s.textContent, 10));
  const current = spans[0];
  const total = spans[spans.length - 1];
  const sample = nav.querySelector(".pagination-arrow[href]")?.getAttribute("href");
  if (!current || !total || total < 2 || !sample) return;

  const urlFor = (p) => {
    if (/\/page\/\d+/.test(sample)) return sample.replace(/\/page\/\d+/, `/page/${p}`);
    if (/[?&]page=\d+/.test(sample)) return sample.replace(/([?&]page=)\d+/, `$1${p}`);
    return sample + (sample.includes("?") ? "&" : "?") + `page=${p}`;
  };
  const from = Math.max(1, Math.min(current - 2, total - 4));
  const to = Math.min(total, from + 4);

  const wrap = document.createElement("nav");
  wrap.className = "qd-pagination";
  wrap.setAttribute("aria-label", "Paginação");
  const arrow = (dir, p) => {
    const a = document.createElement(p ? "a" : "span");
    a.className = `qd-page qd-page-arrow qd-page-${dir}` + (p ? "" : " is-disabled");
    if (p) a.href = urlFor(p);
    a.setAttribute("aria-label", dir === "prev" ? "Página anterior" : "Próxima página");
    return a;
  };
  wrap.append(arrow("prev", current > 1 ? current - 1 : 0));
  for (let p = from; p <= to; p++) {
    const el = document.createElement(p === current ? "span" : "a");
    el.className = "qd-page" + (p === current ? " is-current" : "");
    el.textContent = p;
    if (p === current) el.setAttribute("aria-current", "page");
    else el.href = urlFor(p);
    wrap.append(el);
  }
  wrap.append(arrow("next", current < total ? current + 1 : 0));
  nav.after(wrap);
  nav.dataset.qdDone = "1";
}

function setupFilterToggles() {
  const groups = [...document.querySelectorAll(".filters-desktop-content :is(.filters-categories-container, .js-filter-container, .js-price-filter-container)")];
  groups[0]?.classList.add("qd-filter-first");
  // Figma: grupos longos recolhidos. Abertos: categorias, os 2 primeiros filtros e os que têm seleção.
  groups.forEach((g, i) => {
    const keepOpen = i < 3 || g.matches(".filters-categories-container") || g.querySelector("input:checked");
    if (!keepOpen) g.classList.add("is-collapsed");
  });
  document.querySelectorAll(".filters-desktop-content .filters-title").forEach((t) => {
    const group = t.closest(".js-filter-container, .filters-categories-container, .js-price-filter-container");
    if (!group || t.dataset.qdToggle) return;
    t.dataset.qdToggle = "1";
    t.setAttribute("role", "button");
    t.tabIndex = 0;
    const toggle = (e) => {
      e.preventDefault();
      group.classList.toggle("is-collapsed");
    };
    t.addEventListener("click", toggle);
    t.addEventListener("keydown", (e) => (e.key === "Enter" || e.key === " ") && toggle(e));
  });
}

function setupFilterModal() {
  const modal = document.querySelector('[data-component="modal-filters"]');
  if (!modal || modal.dataset.qdDone) return;
  modal.dataset.qdDone = "1";
  const title = modal.querySelector(".modal-title");
  if (title) title.textContent = "Filtros";
  // Os filtros nativos aplicam no clique; FILTRAR só fecha o modal.
  const btn = document.createElement("button");
  btn.type = "button";
  btn.className = "qd-filter-apply";
  btn.textContent = "Filtrar";
  btn.addEventListener("click", () => modal.querySelector(".modal-close")?.click());
  modal.append(btn);
}

export default function initPlp() {
  const run = () => {
    const grid = document.querySelector(".section-main-products-grid");
    if (!grid) return;
    document.documentElement.classList.add("qd-plp");
    buildHead(grid);
    buildPagination();
    setupFilterToggles();
    setupFilterModal();
  };
  if (document.readyState !== "loading") run();
  else document.addEventListener("DOMContentLoaded", run);
}
