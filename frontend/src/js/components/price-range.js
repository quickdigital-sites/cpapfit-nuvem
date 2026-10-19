/**
 * Faixa de preço com dois controles (Figma 35:10301) — snippets/product-list/filters/price-filter.tpl.
 *
 * Os campos nativos min_price/max_price continuam no form (escondidos por CSS): o slider só escreve
 * neles e, ao soltar, aciona o botão "Aplicar" nativo, que monta a URL do filtro como sempre. Assim
 * filtros + ordenação + paginação seguem combinando pela URL da plataforma.
 */
const money = new Intl.NumberFormat("pt-BR", { style: "currency", currency: "BRL", maximumFractionDigits: 0 });

function setup(range) {
  if (range.dataset.ready) return;
  range.dataset.ready = "1";
  const form = range.closest("form");
  const lo = Number(range.dataset.min);
  const hi = Number(range.dataset.max);
  const [minInput, maxInput] = ["min", "max"].map((b) => range.querySelector(`[data-bound="${b}"]`));
  const field = (name) => form.querySelector(`input[name="${name}"]`);
  const label = (b) => range.querySelector(`[data-label="${b}"]`);
  const fill = range.querySelector(".qd-price-range-fill");
  range.closest(".js-price-filter-container")?.classList.add("qd-has-price-range");

  for (const input of [minInput, maxInput]) {
    input.min = lo;
    input.max = hi;
  }
  minInput.value = Number(field("min_price")?.value) || lo;
  maxInput.value = Number(field("max_price")?.value) || hi;

  const paint = () => {
    const a = Number(minInput.value);
    const b = Number(maxInput.value);
    const span = hi - lo || 1;
    fill.style.left = `${((a - lo) / span) * 100}%`;
    fill.style.right = `${100 - ((b - lo) / span) * 100}%`;
    label("min").textContent = money.format(a);
    label("max").textContent = money.format(b);
  };
  const clamp = (e) => {
    if (Number(minInput.value) > Number(maxInput.value)) {
      if (e.target === minInput) minInput.value = maxInput.value;
      else maxInput.value = minInput.value;
    }
    paint();
  };
  const apply = () => {
    const write = (name, value, edge) => {
      const f = field(name);
      if (!f) return;
      f.value = Number(value) === edge ? "" : value; // na ponta, sem limite (como o filtro nativo vazio)
      f.dispatchEvent(new Event("input", { bubbles: true }));
      f.dispatchEvent(new Event("keyup", { bubbles: true }));
    };
    write("min_price", minInput.value, lo);
    write("max_price", maxInput.value, hi);
    const btn = form.querySelector(".js-price-filter-btn");
    if (btn) {
      btn.disabled = false;
      btn.classList.remove("disabled");
      btn.click();
    } else form.requestSubmit();
  };
  minInput.addEventListener("input", clamp);
  maxInput.addEventListener("input", clamp);
  minInput.addEventListener("change", apply);
  maxInput.addEventListener("change", apply);
  paint();
}

export default function initPriceRange() {
  const run = () => document.querySelectorAll(".js-qd-price-range").forEach(setup);
  if (document.readyState !== "loading") run();
  else document.addEventListener("DOMContentLoaded", run);
  // o modal de filtros do mobile pode ser montado depois
  document.addEventListener("click", () => setTimeout(run, 50), { passive: true });
}
