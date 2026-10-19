/**
 * PDP — página de produto (Figma 35:10696 desktop, 66:17596 mobile).
 * Progressive enhancement sobre o main-product NATIVO:
 *  - Card do topo: breadcrumb + nome + código (SKU) saem da coluna de compra e vão para um card
 *    de largura total acima da galeria (como no Figma).
 *  - Preços + "Aproveite também" (cupom com COPIAR) lado a lado.
 *  - Botão "Comprar pelo WhatsApp" ao lado do COMPRAR (mensagem com o nome e o link do produto).
 *  - Descrição dividida nas seções do Figma: "Detalhes do produto", "Ficha técnica" (tabela + manual)
 *    e "Perguntas frequentes" (sanfona), a partir dos títulos h2 que o lojista já usa na descrição.
 *  - "Vídeo do produto" quando o produto tem vídeo cadastrado; barra de compra fixa no mobile.
 */
// número e cupom vêm do tema (sections/main-product.tpl): WhatsApp do admin da loja e cupom das
// configurações do tema (Formulário de produto → "CPAP Fit — cupom"). Estes são só o plano B.
const FALLBACK_WHATSAPP = "554840421861";

const escapeHtml = (t) => String(t ?? "").replace(/[&<>"']/g, (c) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" })[c]);
// "R$ 100 OFF na linha Philips" → valor em negrito, como no Figma
const couponHtml = (text) => escapeHtml(text).replace(/^(R\$\s?[\d.,]+\s?OFF|\d+%\s?OFF)/i, "<strong>$1</strong>");

export default function initPdp() {
  // qd-pdp-ready libera o que o CSS esconde até aqui (evita layout shift — ver pdp.css)
  const ready = () => document.documentElement.classList.add("qd-pdp-ready");
  const run = () => {
    try {
      enhance();
    } finally {
      ready();
    }
  };
  const enhance = () => {
    const detail = document.querySelector("#single-product.js-product-detail, .js-product-detail");
    const columns = detail?.querySelector(".product-columns");
    if (!detail || !columns || detail.dataset.qdPdp) return;
    detail.dataset.qdPdp = "1";
    document.documentElement.classList.add("qd-pdp");
    const whatsapp = (detail.dataset.qdWhatsapp || "").replace(/\D/g, "") || FALLBACK_WHATSAPP;
    const coupon = { text: (detail.dataset.qdCouponText || "").trim(), code: (detail.dataset.qdCouponCode || "").trim() };

    // 1) card do topo
    const info = detail.querySelector(".product-info");
    const crumbs = info?.querySelector(".breadcrumbs");
    const name = info?.querySelector("h1.product-name");
    const sku = info?.querySelector(".product-sku");
    const top = document.createElement("div");
    top.className = "qd-pdp-top";
    const titles = document.createElement("div");
    titles.className = "qd-pdp-titles";
    if (name) titles.append(name);
    if (sku) titles.append(sku);
    top.append(titles);
    if (crumbs) columns.before(crumbs);
    columns.before(top);

    // 2) preços + cupom
    const price = info?.querySelector(".js-price-container");
    if (price && !info.querySelector(".qd-pdp-coupon") && coupon.code) {
      const row = document.createElement("div");
      row.className = "qd-pdp-price-row";
      price.before(row);
      row.append(price);
      const couponEl = document.createElement("div");
      couponEl.className = "qd-pdp-coupon";
      couponEl.innerHTML = `<p class="qd-pdp-coupon-title">Aproveite também:</p>
        <div class="qd-pdp-coupon-box">
          <span class="qd-pdp-coupon-icon" aria-hidden="true"></span>
          <span class="qd-pdp-coupon-text">${couponHtml(coupon.text)}</span>
          <span class="qd-coupon-code">${escapeHtml(coupon.code)}</span>
          <button type="button" class="qd-coupon-copy" data-qd-copy="${escapeHtml(coupon.code)}">Copiar</button>
        </div>`;
      row.append(couponEl);
    }

    // 2b) parcelas + "ver parcelamento" dentro da coluna de preço (Figma)
    const payments = info?.querySelector(".js-product-payments-container");
    if (price && payments) price.append(payments);
    const payLink = payments?.querySelector(".product-payments-link");
    if (payLink) payLink.textContent = "ver parcelamento";

    // 3) WhatsApp ao lado do COMPRAR
    const buy = info?.querySelector(".buy-button-container");
    if (buy && !info.querySelector(".qd-pdp-whatsapp")) {
      const title = name?.textContent.trim() || document.title;
      const msg = encodeURIComponent(`Olá! Quero comprar: ${title} — ${location.origin + location.pathname}`);
      const wa = document.createElement("a");
      wa.className = "qd-pdp-whatsapp";
      wa.href = `https://wa.me/${whatsapp}?text=${msg}`;
      wa.target = "_blank";
      wa.rel = "noopener";
      wa.innerHTML = `<span class="qd-pdp-wa-icon" aria-hidden="true"></span>Comprar pelo WhatsApp`;
      buy.after(wa);
      buy.parentElement.classList.add("qd-pdp-actions");
    }

    // 4) frete: textos do Figma
    const shipLabel = info?.querySelector(".js-shipping-calculator-form .form-label");
    if (shipLabel) shipLabel.textContent = "Calcule Frete e Prazo";
    const shipInput = info?.querySelector(".js-shipping-input");
    if (shipInput) shipInput.placeholder = "Digite o seu CEP";
    const shipBtn = info?.querySelector(".js-calculate-shipping-wording");
    if (shipBtn) shipBtn.textContent = "OK";

    // 5) "Detalhes do produto": descrição completa abaixo das colunas (no card fica o resumo)
    const desc = info?.querySelector(".js-product-description");
    if (desc && desc.textContent.trim() && !detail.querySelector(".qd-pdp-details")) {
      const details = document.createElement("div");
      details.className = "qd-pdp-details";
      details.id = "detalhes-do-produto";
      details.innerHTML = `<h2 class="qd-pdp-section-title">Detalhes do produto</h2><div class="qd-pdp-details-body user-content"></div>`;
      details.lastElementChild.innerHTML = desc.innerHTML;
      columns.after(details);
      const sections = splitDescription(details.lastElementChild);
      details.after(...sections);
    }

    // 6) vídeo do produto (o mesmo cadastrado no admin, que já aparece na galeria)
    const videoUrl = detail.querySelector("[data-video-url]")?.dataset.videoUrl;
    const youtube = videoUrl && youtubeId(videoUrl);
    if (youtube && !detail.querySelector(".qd-pdp-video")) {
      const video = section("qd-pdp-video", "Vídeo do produto");
      const box = document.createElement("button");
      box.type = "button";
      box.className = "qd-pdp-video-box";
      box.setAttribute("aria-label", "Assistir ao vídeo do produto");
      box.innerHTML = `<img src="https://img.youtube.com/vi/${youtube}/hqdefault.jpg" alt="" loading="lazy"><span class="qd-pdp-video-play" aria-hidden="true"></span>`;
      box.addEventListener("click", () => {
        box.outerHTML = `<div class="qd-pdp-video-box"><iframe src="https://www.youtube-nocookie.com/embed/${youtube}?autoplay=1" title="Vídeo do produto" allow="autoplay; encrypted-media; picture-in-picture" allowfullscreen></iframe></div>`;
      });
      video.lastElementChild.append(box);
      const last = detail.querySelector(".qd-pdp-faq, .qd-pdp-specs, .qd-pdp-details") || columns;
      last.after(video);
    }

    // 7) grupos de variante com uma opção só ("Cor: Unico") não ajudam a escolher: escondidos
    info?.querySelectorAll(".js-product-variants-group").forEach((g) => {
      // cada grupo tem os botões e um <select> escondido com as mesmas opções: conta só um dos dois
      const n = g.querySelectorAll(".btn-variant").length || g.querySelectorAll("option").length;
      if (n <= 1) g.classList.add("qd-pdp-single-variant");
    });

    // 8) barra de compra fixa no mobile (Figma 66:17863): COMPRAR + WhatsApp, aparece quando o botão some
    const buyBtn = info?.querySelector(".js-addtocart");
    if (buyBtn && !document.querySelector(".qd-pdp-sticky")) {
      const bar = document.createElement("div");
      bar.className = "qd-pdp-sticky";
      bar.setAttribute("aria-hidden", "true");
      const title = name?.textContent.trim() || document.title;
      const msg = encodeURIComponent(`Olá! Quero comprar: ${title} — ${location.origin + location.pathname}`);
      bar.innerHTML = `<button type="button" class="qd-pdp-sticky-buy" tabindex="-1">Comprar</button>
        <a class="qd-pdp-sticky-wa" href="https://wa.me/${whatsapp}?text=${msg}" target="_blank" rel="noopener" tabindex="-1" aria-label="Comprar pelo WhatsApp"></a>`;
      // o tema troca o botão depois de carregar: sempre busca o atual (um IntersectionObserver ficaria preso no antigo)
      const currentBuy = () => [...detail.querySelectorAll(".product-info .js-addtocart")].find((b) => b.offsetParent !== null);
      bar.querySelector(".qd-pdp-sticky-buy").addEventListener("click", () => {
        const b = currentBuy();
        if (!b) return;
        b.scrollIntoView({ behavior: "smooth", block: "center" });
        b.click();
      });
      document.body.append(bar);
      let shown = false;
      let ticking = false;
      const update = () => {
        ticking = false;
        const b = currentBuy();
        const show = !!b && b.getBoundingClientRect().bottom < 0;
        if (show === shown) return;
        shown = show;
        bar.classList.toggle("is-visible", show);
        bar.setAttribute("aria-hidden", show ? "false" : "true");
        bar.querySelectorAll("button, a").forEach((el) => (show ? el.removeAttribute("tabindex") : el.setAttribute("tabindex", "-1")));
      };
      window.addEventListener("scroll", () => {
        if (!ticking) requestAnimationFrame(update);
        ticking = true;
      }, { passive: true });
    }
  };
  if (document.readyState !== "loading") run();
  else document.addEventListener("DOMContentLoaded", run);
}

function section(cls, title) {
  const el = document.createElement("section");
  el.className = `qd-pdp-section ${cls}`;
  el.innerHTML = `<h2 class="qd-pdp-section-title">${title}</h2><div class="qd-pdp-section-body"></div>`;
  return el;
}

function youtubeId(url) {
  const m = url.match(/(?:youtu\.be\/|v=|embed\/|shorts\/)([\w-]{11})/);
  return m && m[1];
}

// Separa os blocos que começam num h2 cujo texto casa com `re` (até o próximo h2) e os tira do corpo.
function takeBlock(body, re) {
  const h2 = [...body.querySelectorAll(":scope > h2")].find((h) => re.test(h.textContent));
  if (!h2) return null;
  const nodes = [];
  for (let n = h2.nextElementSibling; n && n.tagName !== "H2"; n = n.nextElementSibling) nodes.push(n);
  h2.remove();
  nodes.forEach((n) => n.remove());
  return nodes;
}

const textOf = (el) => (el?.textContent || "").replace(/\s+/g, " ").trim();

function splitDescription(body) {
  const out = [];

  // Ficha técnica: a tabela de 2 colunas vira a lista do Figma; link para PDF vira "Download manual"
  const specNodes = takeBlock(body, /ficha t[ée]cnica/i);
  if (specNodes) {
    const table = specNodes.find((n) => n.tagName === "TABLE") || specNodes.map((n) => n.querySelector?.("table")).find(Boolean);
    const rows = table ? [...table.querySelectorAll("tr")].map((tr) => [...tr.children].map(textOf)).filter((r) => r.length >= 2 && (r[0] || r[1])) : [];
    const pdf = specNodes.flatMap((n) => [...(n.querySelectorAll?.("a[href]") || [])]).find((a) => /\.pdf($|\?)|manual/i.test(a.href + a.textContent));
    if (rows.length || pdf) {
      const specs = section("qd-pdp-specs", "Ficha técnica");
      const box = specs.lastElementChild;
      if (pdf) {
        const a = document.createElement("a");
        a.className = "qd-pdp-manual";
        a.href = pdf.href;
        a.target = "_blank";
        a.rel = "noopener";
        a.textContent = textOf(pdf) || "Download do manual";
        box.append(a);
      }
      const dl = document.createElement("dl");
      dl.className = "qd-pdp-spec-list";
      for (const [k, v] of rows) dl.insertAdjacentHTML("beforeend", `<div><dt>${escapeHtml(k)}</dt><dd>${escapeHtml(v)}</dd></div>`);
      box.append(dl);
      out.push(specs);
    } else body.append(...specNodes); // não deu para ler: devolve o conteúdo ao corpo
  }

  // Perguntas frequentes: parágrafo que termina em "?" é pergunta; os seguintes, a resposta
  const faqNodes = takeBlock(body, /perguntas frequentes|d[úu]vidas frequentes|faq/i);
  if (faqNodes) {
    const items = [];
    for (const n of faqNodes) {
      const t = textOf(n);
      if (!t) continue;
      const isQuestion = /\?$/.test(t) && t.length < 200 && !n.querySelector?.("table, ul, ol");
      if (isQuestion) items.push({ q: t, a: [] });
      else if (items.length) items[items.length - 1].a.push(n);
    }
    if (items.length) {
      const faq = section("qd-pdp-faq", "Perguntas frequentes");
      items.forEach((it, i) => {
        const d = document.createElement("details");
        d.className = "qd-pdp-faq-item";
        if (i < 3) d.open = true; // Figma: as primeiras abertas
        d.innerHTML = `<summary>${escapeHtml(it.q)}</summary><div class="qd-pdp-faq-answer user-content"></div>`;
        d.lastElementChild.append(...it.a);
        faq.lastElementChild.append(d);
      });
      out.push(faq);
    } else body.append(...faqNodes);
  }

  // sobras vazias no fim do corpo (parágrafos em branco)
  [...body.querySelectorAll(":scope > p")].forEach((p) => !textOf(p) && !p.querySelector("img, iframe") && p.remove());
  return out;
}
