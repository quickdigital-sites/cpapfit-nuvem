/**
 * Entrypoint do JS do tema.
 *
 * Princípio: o HTML vem renderizado do servidor (Twig). O JS aqui é
 * progressive enhancement — melhora o que já funciona, nunca assume o DOM.
 *
 * O Alpine NÃO é importado: sem fork, este bundle vai inline num block "code"
 * do footer (frontend/inject.mjs) e o Alpine + collapse vêm do CDN, na versão
 * do package-lock. Aqui só registramos os componentes no alpine:init, que o
 * Alpine dispara antes de iniciar.
 */
import miniCart from "./components/mini-cart.js";
import productGallery from "./components/product-gallery.js";
import initHeaderPlans from "./components/header-plans.js";
import initHeaderSearch from "./components/header-search.js";
import initHomeTabs from "./components/home-tabs.js";
import initFooter from "./components/footer.js";
import initPlp from "./components/plp.js";
import initPdp from "./components/pdp.js";

document.addEventListener("alpine:init", () => {
  // Componentes ficam disponíveis nos templates como x-data="miniCart()"
  window.Alpine.data("miniCart", miniCart);
  window.Alpine.data("productGallery", productGallery);
});

// Enhancements do header nativo
initHeaderPlans();  // injeta a pílula "Planos de Assinatura"
initHeaderSearch(); // garante submit da busca (Enter/clique) + preserva o preview
initHomeTabs();     // abas de "Destaques" da home (troca a vitrine nativa visível)
initPlp();          // PLP: cabeçalho da listagem, paginação numerada, filtros recolhíveis, texto SEO
initPdp();          // PDP: card do topo, preços + cupom, botão WhatsApp
initFooter();       // footer: copiar cupom, menus (acordeão no mobile), "Seu nome" na newsletter

// Overlay escuro atrás do submenu do menu desktop (mostrado por CSS :has no hover)
(() => {
  const add = () => {
    if (document.querySelector(".qd-menu-overlay")) return;
    const o = document.createElement("div");
    o.className = "qd-menu-overlay";
    document.body.appendChild(o);
  };
  if (document.readyState !== "loading") add();
  else document.addEventListener("DOMContentLoaded", add);
})();
