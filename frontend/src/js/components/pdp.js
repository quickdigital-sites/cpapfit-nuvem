/**
 * PDP — página de produto (Figma 35:10696 desktop, 66:17596 mobile).
 * Progressive enhancement sobre o main-product NATIVO:
 *  - Card do topo: breadcrumb + nome + código (SKU) saem da coluna de compra e vão para um card
 *    de largura total acima da galeria (como no Figma).
 *  - Preços + "Aproveite também" (cupom com COPIAR) lado a lado.
 *  - Botão "Comprar pelo WhatsApp" ao lado do COMPRAR (mensagem com o nome e o link do produto).
 */
const WHATSAPP = "554840421861";
const COUPON = { text: "<strong>R$ 100 OFF</strong> na linha Philips", code: "QUERO100" };

export default function initPdp() {
  const run = () => {
    const detail = document.querySelector("#single-product.js-product-detail, .js-product-detail");
    const columns = detail?.querySelector(".product-columns");
    if (!detail || !columns || detail.dataset.qdPdp) return;
    detail.dataset.qdPdp = "1";
    document.documentElement.classList.add("qd-pdp");

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
    if (price && !info.querySelector(".qd-pdp-coupon")) {
      const row = document.createElement("div");
      row.className = "qd-pdp-price-row";
      price.before(row);
      row.append(price);
      const coupon = document.createElement("div");
      coupon.className = "qd-pdp-coupon";
      coupon.innerHTML = `<p class="qd-pdp-coupon-title">Aproveite também:</p>
        <div class="qd-pdp-coupon-box">
          <span class="qd-pdp-coupon-icon" aria-hidden="true"></span>
          <span class="qd-pdp-coupon-text">${COUPON.text}</span>
          <span class="qd-coupon-code">${COUPON.code}</span>
          <button type="button" class="qd-coupon-copy" data-qd-copy="${COUPON.code}">Copiar</button>
        </div>`;
      row.append(coupon);
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
      wa.href = `https://wa.me/${WHATSAPP}?text=${msg}`;
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
    }
  };
  if (document.readyState !== "loading") run();
  else document.addEventListener("DOMContentLoaded", run);
}
