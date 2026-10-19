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
import initHeaderSearch from "./components/header-search.js";
import initHeaderBar from "./components/header-bar.js";
import initHomeTabs from "./components/home-tabs.js";
import initFooter from "./components/footer.js";
import initPlp from "./components/plp.js";
import initPriceRange from "./components/price-range.js";
import initPdp from "./components/pdp.js";
import initInstitucional from "./components/institucional.js";

document.addEventListener("alpine:init", () => {
  // Componentes ficam disponíveis nos templates como x-data="miniCart()"
  window.Alpine.data("miniCart", miniCart);
  window.Alpine.data("productGallery", productGallery);
});

// Enhancements do header nativo
initHeaderBar();    // barra de benefícios: um item por vez no mobile
initHeaderSearch(); // garante submit da busca (Enter/clique) + preserva o preview
initHomeTabs();     // abas de "Destaques" da home (troca a vitrine nativa visível)
initPriceRange();   // faixa de preço com slider (filtro da listagem)
initPlp();          // PLP: cabeçalho da listagem, paginação numerada, filtros recolhíveis, texto SEO
initPdp();          // PDP: card do topo, preços + cupom, botão WhatsApp
initInstitucional(); // páginas institucionais + Fale conosco: menu lateral, lojas, campos do formulário
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
