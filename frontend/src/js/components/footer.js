/**
 * Footer CPAP Fit (design/pages/footer.yaml).
 *  - [data-qd-copy]: copia o cupom e mostra "Copiado!" por 2s.
 *  - [data-qd-footer-menu] (<details>): sempre aberto no desktop (≥768px), acordeão no mobile.
 *  - Newsletter nativa: adiciona o campo "Seu nome" (o form nativo manda um nome fixo em
 *    input hidden name="name"; aqui o que o cliente digita vai para esse campo).
 */
const mq = window.matchMedia("(min-width: 768px)");

function syncMenus() {
  document.querySelectorAll("[data-qd-footer-menu]").forEach((d) => {
    if (mq.matches) d.setAttribute("open", "");
    else if (!d.dataset.qdTouched) d.removeAttribute("open");
  });
}

function setupCopy() {
  document.addEventListener("click", async (e) => {
    const btn = e.target.closest("[data-qd-copy]");
    if (!btn) return;
    const code = btn.dataset.qdCopy;
    try {
      await navigator.clipboard.writeText(code);
    } catch {
      const t = document.createElement("textarea");
      t.value = code;
      document.body.appendChild(t);
      t.select();
      document.execCommand("copy");
      t.remove();
    }
    const label = btn.textContent;
    btn.textContent = "Copiado!";
    btn.classList.add("is-copied");
    setTimeout(() => {
      btn.textContent = label;
      btn.classList.remove("is-copied");
    }, 2000);
  });
}

function setupNewsletterName() {
  document.querySelectorAll(".footer-newsletter-form").forEach((form) => {
    if (form.querySelector(".qd-newsletter-name")) return;
    const hidden = form.querySelector('input[type="hidden"][name="name"]');
    const wrap = form.querySelector(".newsletter-form-wrapper");
    if (!hidden || !wrap) return;
    const fallback = hidden.value;
    const input = document.createElement("input");
    input.type = "text";
    input.className = "qd-newsletter-name form-control";
    input.placeholder = "Seu nome";
    input.setAttribute("aria-label", "Seu nome");
    input.autocomplete = "name";
    input.addEventListener("input", () => {
      hidden.value = input.value.trim() || fallback;
    });
    form.insertBefore(input, wrap);
    const email = form.querySelector('input[name="email"]');
    if (email) email.placeholder = "Seu e-mail";
    const submit = form.querySelector('input[type="submit"]');
    if (submit) submit.value = "OK";
  });
}

export default function initFooter() {
  const run = () => {
    syncMenus();
    setupNewsletterName();
    document.querySelectorAll("[data-qd-footer-menu] > summary").forEach((s) =>
      s.addEventListener("click", (e) => {
        if (mq.matches) e.preventDefault(); // no desktop não fecha
        else s.parentElement.dataset.qdTouched = "1";
      })
    );
  };
  setupCopy();
  mq.addEventListener("change", syncMenus);
  if (document.readyState !== "loading") run();
  else document.addEventListener("DOMContentLoaded", run);
}
