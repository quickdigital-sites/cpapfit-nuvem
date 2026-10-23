/**
 * Links para fora da loja abrem em nova aba.
 *
 * Os links que o Twig monta (menus, rodapé, faixa de anúncio, barra de benefícios, blocos com campo
 * de link) já saem com target/rel pelo snippets/qd-link-attrs.tpl. Isto cobre o que o Twig não
 * controla: HTML dos blocks "Código", texto rico, descrição de produto e páginas de conteúdo.
 * Link interno, âncora, mailto:, tel: e link que já tem target ficam como estão.
 */
const bare = (host) => host.replace(/^www\./, "");

function isExternal(a) {
  if (!/^https?:$/.test(a.protocol)) return false;
  return bare(a.hostname) !== bare(window.location.hostname);
}

function mark(a) {
  if (a.hasAttribute("target") || !isExternal(a)) return;
  a.target = "_blank";
  a.rel = "noopener noreferrer";
}

export default function initExternalLinks() {
  const run = () => document.querySelectorAll("a[href]").forEach(mark);
  if (document.readyState !== "loading") run();
  else document.addEventListener("DOMContentLoaded", run);
  // links inseridos depois (JS do tema, apps): marca na hora do clique
  document.addEventListener("click", (e) => {
    const a = e.target.closest && e.target.closest("a[href]");
    if (a) mark(a);
  }, true);
}
