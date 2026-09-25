/**
 * Pílula "Planos de Assinatura" no header (Figma 24:594).
 *
 * O header é seção NATIVA do Ipanema (não editável sem fork). Este é o caminho
 * progressive-enhancement: injeta o elemento no .head-row nativo por JS.
 * Estilo em frontend/src/css/main.css (.qd-plans-pill*).
 *
 * TODO: trocar PLANS_URL pela URL real da página de planos de assinatura.
 */
const PLANS_URL = "#";

const ICON = `<svg viewBox="0 0 24 24" width="22" height="22" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M4 7a2 2 0 0 1 2-2h12a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2z"/><path d="M4 10h16"/><path d="M8 15h4"/></svg>`;
const ARROW = `<svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M5 12h14"/><path d="M13 6l6 6-6 6"/></svg>`;

const INNER =
  `<span class="qd-plans-pill__icon">${ICON}</span>` +
  `<span class="qd-plans-pill__text">` +
    `<span class="qd-plans-pill__title">Planos de Assinatura</span>` +
    `<span class="qd-plans-pill__sub">Descontos e benefícios exclusivos!</span>` +
  `</span>` +
  `<span class="qd-plans-pill__arrow">${ARROW}</span>`;

function inject() {
  document.querySelectorAll(".head-row").forEach((row) => {
    if (row.querySelector(".qd-plans-pill")) return;
    const pill = document.createElement("a");
    pill.className = "qd-plans-pill";
    pill.href = PLANS_URL;
    pill.setAttribute("aria-label", "Planos de Assinatura — descontos e benefícios exclusivos");
    pill.innerHTML = INNER;
    const account = row.querySelector(".header-account");
    if (account) row.insertBefore(pill, account);
    else row.appendChild(pill);
  });
}

export default function initHeaderPlans() {
  const start = () => {
    inject();
    // o Ipanema clona o header para o modo "sticky" — reinjeta se aparecer outro .head-row
    const header = document.querySelector("header.js-header") || document.body;
    new MutationObserver(inject).observe(header, { childList: true, subtree: true });
  };
  if (document.readyState !== "loading") start();
  else document.addEventListener("DOMContentLoaded", start);
}
