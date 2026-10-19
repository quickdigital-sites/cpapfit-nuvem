/**
 * Abas de "Destaques" da home (design/components/destaques-abas.html).
 *
 * Cada aba aponta (data-qd-tab) para o data-section-id de uma seção NATIVA product-list.
 * Mostra só a seção da aba ativa. A 1ª aba cujo alvo existe começa ativa.
 * Abas cujo alvo não existe na página (seção removida no Brand Editor) somem.
 *
 * Carregamento sob demanda: cada vitrine pesa ~190KB de HTML, então as abas 2–6 saem do servidor só
 * como placeholder (theme/sections/product-list.tpl: .qd-tab-lazy com data-qd-source = URL da categoria).
 * Quando o visitante vai usar a aba (hover, toque ou foco) buscamos a página da categoria, pegamos os
 * primeiros cards e montamos o carrossel num molde copiado da vitrine da 1ª aba — copiado ANTES do
 * Swiper do tema inicializar (este script é defer; o store.js do tema roda depois). Os cards são o mesmo
 * snippet do tema, então a compra rápida (COMPRAR) funciona: o tema escuta cliques por delegação.
 *
 * O carrossel (Swiper) da vitrine inicializa escondido e calcula largura 0; ao mostrar,
 * disparamos "resize" para o Swiper recalcular.
 */
const sectionFor = (id) =>
  document.querySelector(`section[data-section-id="${CSS.escape(id)}"]`) ??
  document.querySelector(`[data-section-id="${CSS.escape(id)}"]`);

// Molde: seção de uma vitrine renderizada, ainda sem Swiper (ver comentário do topo).
let mold = null;
const loads = new Map(); // id da seção -> Promise

function makeMold(sections) {
  const source = sections.find((s) => s.querySelector(".js-swiper-products-slider > .swiper-slide"));
  if (!source) return null;
  const copy = source.cloneNode(true);
  const slides = copy.querySelectorAll(".js-swiper-products-slider > .swiper-slide");
  const slideClass = slides[0].className;
  slides.forEach((s) => s.remove());
  return { copy, slideClass };
}

// Mesmos parâmetros do initProductSliderByElement do store.js (fork: 2.2 no mobile, 3 no tablet).
function initSwiper(section) {
  const wrapper = section.querySelector(".js-swiper-products-slider");
  const slider = wrapper?.closest(".js-products-list-swiper");
  if (!slider || slider.swiper || typeof window.createSwiper !== "function") return;
  const desktop = parseInt(wrapper.dataset.desktopColumns, 10) || 5;
  const mobile = parseInt(wrapper.dataset.mobileColumns, 10) || 2;
  const parent = slider.closest(".js-products-list-slider-container");
  const isMobile = window.innerWidth < 768;
  const tablet = Math.min(3, desktop);
  window.createSwiper(slider, {
    lazy: true,
    slidesPerView: mobile === 2 ? 2.2 : mobile,
    slidesPerGroup: mobile === 2 ? 2 : 1,
    spaceBetween: 16,
    loop: !isMobile && slider.querySelectorAll(".swiper-slide").length > desktop,
    watchOverflow: true,
    watchSlidesVisibility: true,
    slideVisibleClass: "js-swiper-slide-visible",
    navigation: {
      nextEl: parent?.querySelector(".js-swiper-products-list-next") ?? null,
      prevEl: parent?.querySelector(".js-swiper-products-list-prev") ?? null,
    },
    pagination: { el: slider.querySelector(".js-swiper-products-list-pagination"), clickable: true },
    breakpoints: {
      768: { slidesPerView: tablet, slidesPerGroup: tablet },
      1200: { slidesPerView: desktop, slidesPerGroup: desktop },
    },
  });
  window.LS?.productItemSlider?.({ pagination_type: "fraction" }); // fotos dentro dos cards
}

function withPreview(url) {
  const tid = new URLSearchParams(location.search).get("theme_installation_id");
  if (!tid) return url;
  const u = new URL(url, location.origin);
  u.searchParams.set("theme_installation_id", tid);
  return u.toString();
}

// Busca a categoria e troca o placeholder pela vitrine. Resolve com a nova seção (ou null).
function loadTab(id) {
  if (loads.has(id)) return loads.get(id);
  const section = sectionFor(id);
  const lazy = section?.querySelector("[data-qd-lazy-tab]");
  if (!lazy || !mold) return Promise.resolve(section);
  const max = parseInt(lazy.dataset.qdMax, 10) || 8;
  const promise = fetch(withPreview(lazy.dataset.qdSource), { credentials: "same-origin" })
    .then((r) => (r.ok ? r.text() : Promise.reject(new Error(`HTTP ${r.status}`))))
    .then((html) => {
      const doc = new DOMParser().parseFromString(html, "text/html");
      const cards = [...doc.querySelectorAll(".js-product-table .js-item-product, .js-item-product")].slice(0, max);
      if (!cards.length) throw new Error("categoria sem produtos");
      const fresh = mold.copy.cloneNode(true);
      // a seção nativa imprime data-section-id no <section> e no <div> de dentro
      [fresh, ...fresh.querySelectorAll("[data-section-id]")].forEach((n) => {
        if (n.dataset.sectionId) n.dataset.sectionId = id;
        if (n.id?.startsWith("ns-section-")) n.id = `ns-section-${id}`;
      });
      const track = fresh.querySelector(".js-swiper-products-slider");
      for (const card of cards) {
        const node = document.importNode(card, true);
        node.className = mold.slideClass;
        // card de carrossel: o store.js trata a compra rápida de slides por esta classe
        node.querySelectorAll(".js-quickshop-modal-open").forEach((b) => b.classList.add("js-quickshop-slide"));
        track.append(node);
      }
      fresh.classList.add("qd-tab-panel");
      section.replaceWith(fresh);
      initSwiper(fresh);
      return fresh;
    })
    .catch((err) => {
      // sem a vitrine, a aba volta a ser link para a categoria
      loads.delete(id);
      lazy.classList.add("is-error");
      lazy.innerHTML = `<a class="qd-tab-lazy-link" href="${lazy.dataset.qdSource}">Ver produtos</a>`;
      console.warn(`home-tabs: não deu para carregar ${id}`, err);
      return sectionFor(id);
    });
  loads.set(id, promise);
  return promise;
}

// Botões das abas: um por vitrine com "Nome da aba" (marcadores impressos por product-list.tpl), na ordem da página.
function buildTabs(root) {
  const list = root.querySelector("[data-qd-tabs-list]");
  if (!list || list.children.length) return;
  for (const m of document.querySelectorAll("[data-qd-tab-label]")) {
    const a = document.createElement("a");
    a.className = "qd-chip";
    a.setAttribute("role", "tab");
    a.href = withPreview(m.dataset.qdTabHref || "/produtos/");
    a.dataset.qdTab = m.dataset.qdTabFor;
    a.textContent = m.dataset.qdTabLabel;
    list.append(a);
  }
}

function setup(root) {
  buildTabs(root);
  const tabs = [...root.querySelectorAll("[data-qd-tab]")].filter((tab) => {
    const ok = !!sectionFor(tab.dataset.qdTab);
    if (!ok) tab.hidden = true;
    return ok;
  });
  if (!tabs.length) return;
  mold = mold ?? makeMold(tabs.map((t) => sectionFor(t.dataset.qdTab)).filter(Boolean));

  let current = null;
  const show = (active) => {
    for (const tab of tabs) {
      const on = tab === active;
      tab.classList.toggle("is-active", on);
      tab.setAttribute("aria-selected", on ? "true" : "false");
      const section = sectionFor(tab.dataset.qdTab);
      section?.classList.add("qd-tab-panel");
      section?.classList.toggle("qd-tab-panel-active", on);
    }
    window.dispatchEvent(new Event("resize"));
  };
  const activate = (tab) => {
    current = tab;
    show(tab);
    const id = tab.dataset.qdTab;
    if (!sectionFor(id)?.querySelector("[data-qd-lazy-tab]")) return;
    sectionFor(id).classList.add("is-loading");
    loadTab(id).then(() => {
      if (current === tab) show(tab); // a seção foi trocada: reaplica as classes
    });
  };

  for (const tab of tabs) {
    const prefetch = () => loadTab(tab.dataset.qdTab);
    tab.addEventListener("pointerenter", prefetch, { once: true });
    tab.addEventListener("touchstart", prefetch, { once: true, passive: true });
    tab.addEventListener("focus", prefetch, { once: true });
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
