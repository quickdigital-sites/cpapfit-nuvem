/**
 * Barra de benefícios do header (seção nativa navigation-bar, Figma 24:661 / 0:649).
 *
 * No desktop os 4 itens ficam lado a lado. Abaixo de 1200px o CSS mostra um item por vez
 * (rolagem horizontal com scroll-snap) e aqui passamos para o próximo a cada 4,5s.
 * Pausa enquanto o visitante toca ou passa o mouse, e não anima com "reduzir movimento".
 */
const MOBILE = window.matchMedia("(max-width: 1199.98px)");
const REDUCED = window.matchMedia("(prefers-reduced-motion: reduce)");
const INTERVAL = 4500;

function setup(track) {
  if (track.dataset.qdRotate) return;
  track.dataset.qdRotate = "1";
  let paused = false;
  const pause = () => (paused = true);
  const resume = () => (paused = false);
  track.addEventListener("pointerenter", pause);
  track.addEventListener("pointerleave", resume);
  track.addEventListener("touchstart", pause, { passive: true });
  track.addEventListener("touchend", () => setTimeout(resume, INTERVAL), { passive: true });
  track.addEventListener("focusin", pause);
  track.addEventListener("focusout", resume);

  setInterval(() => {
    if (paused || !MOBILE.matches || REDUCED.matches || document.hidden) return;
    const width = track.clientWidth;
    if (!width || track.scrollWidth <= width + 1) return;
    const atEnd = track.scrollLeft + width >= track.scrollWidth - 2;
    track.scrollTo({ left: atEnd ? 0 : track.scrollLeft + width, behavior: "smooth" });
  }, INTERVAL);
}

export default function initHeaderBar() {
  const run = () =>
    document
      .querySelectorAll(".js-navigation-bar .navigation-bar-group > div")
      .forEach((track) => track.querySelectorAll(".navigation-bar-item").length > 1 && setup(track));
  if (document.readyState !== "loading") run();
  else document.addEventListener("DOMContentLoaded", run);
}
