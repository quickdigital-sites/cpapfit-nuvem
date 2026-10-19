/**
 * Preço no Pix da página de produto acompanhando a variação escolhida.
 * O tema calcula o primeiro valor (snippets/payments/payment-discount-price.tpl, data-qd-pix-percent),
 * mas ao trocar de variação o JS da plataforma reescreve o preço com o desconto que ela mesma tem —
 * zero, com o Mercado Pago — e esconde a linha. Aqui o preço no Pix é refeito a partir do preço exibido.
 */
const toNumber = (text) => {
  const digits = String(text || "").replace(/[^\d,]/g, "").replace(",", ".");
  const n = parseFloat(digits);
  return Number.isFinite(n) ? n : null;
};
const toMoney = (n) => "R$" + n.toLocaleString("pt-BR", { minimumFractionDigits: 2, maximumFractionDigits: 2 });

export default function initPixPrice() {
  const detail = document.querySelector(".js-product-detail");
  const box = detail?.querySelector(".js-payment-discount-price-product-container[data-qd-pix-percent]");
  const priceEl = detail?.querySelector(".js-price-display");
  if (!box || !priceEl) return;
  const pct = parseFloat(box.dataset.qdPixPercent);
  const target = box.querySelector(".js-payment-discount-price-product");
  if (!(pct > 0) || !target) return;

  let busy = false;
  const sync = () => {
    if (busy) return;
    busy = true;
    const price = toNumber(priceEl.textContent);
    const priceVisible = priceEl.style.display !== "none" && price > 0;
    if (priceVisible) {
      const value = toMoney(Math.round(price * (100 - pct)) / 100);
      if (target.textContent.trim() !== value) target.textContent = value;
      if (box.style.display === "none") box.style.display = "";
    } else if (box.style.display !== "none") {
      box.style.display = "none";
    }
    busy = false;
  };

  const opts = { childList: true, characterData: true, subtree: true, attributes: true, attributeFilter: ["style"] };
  new MutationObserver(sync).observe(priceEl, opts);
  new MutationObserver(sync).observe(box, opts);
  sync();
}
