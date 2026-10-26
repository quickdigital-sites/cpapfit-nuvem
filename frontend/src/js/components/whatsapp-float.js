/**
 * Botão flutuante do WhatsApp (snippets/social/whatsapp-chat.tpl) × botões de compra (BUG-004).
 *
 * No celular o botão fica menor (main.css) e, enquanto estiver por cima de um botão de compra
 * (COMPRAR do card ou da página de produto, WhatsApp do produto, barra de compra fixa), some —
 * volta assim que a rolagem tira o botão de baixo dele. O WhatsApp continua acessível pelos botões
 * da própria página de produto e pela barra fixa.
 */
const MOBILE = window.matchMedia("(max-width: 47.9988em)");
const BUY = ".js-addtocart, .js-prod-submit-form, .qd-pdp-whatsapp, .qd-pdp-sticky.is-visible, .qd-pdp-sticky-buy, .qd-pdp-sticky-wa";

function overBuyButton(btn) {
  const r = btn.getBoundingClientRect();
  const pad = 4;
  const points = [
    [r.left + r.width / 2, r.top + r.height / 2],
    [r.left - pad, r.top - pad],
    [r.right + pad, r.top - pad],
    [r.left - pad, r.bottom + pad],
    [r.right + pad, r.bottom + pad],
  ];
  return points.some(([x, y]) =>
    document.elementsFromPoint(x, y).some((el) => el !== btn && !btn.contains(el) && el.closest(BUY))
  );
}

export default function initWhatsappFloat() {
  const run = () => {
    const btn = document.querySelector(".btn-whatsapp");
    if (!btn) return;
    // no máximo uma checagem a cada 50ms durante a rolagem
    let timer = 0;
    const update = () => {
      timer = 0;
      btn.classList.toggle("qd-wa-hidden", MOBILE.matches && overBuyButton(btn));
    };
    const schedule = () => {
      if (!timer) timer = setTimeout(update, 50);
    };
    window.addEventListener("scroll", schedule, { passive: true });
    window.addEventListener("resize", schedule);
    MOBILE.addEventListener("change", schedule);
    // a barra fixa da página de produto aparece/some sem rolagem de layout: observa a classe dela
    new MutationObserver(schedule).observe(document.body, { subtree: true, attributes: true, attributeFilter: ["class"] });
    schedule();
  };
  if (document.readyState !== "loading") run();
  else document.addEventListener("DOMContentLoaded", run);
}
