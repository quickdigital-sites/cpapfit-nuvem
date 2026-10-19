/**
 * Páginas institucionais (Figma: Nossas lojas 271:6244, Fale conosco 271:8536, Troca e devolução
 * 271:9547, Quem somos 271:10421 — mobile 271:6399 / 305:5991 / 305:6364 / 305:6755).
 * Progressive enhancement sobre os templates NATIVOS page (main-page) e contact (main-contact):
 *  - Coluna lateral com o menu do grupo (Institucional ou Atendimento) e a página atual em pílula
 *    dourada; no Atendimento, o bloco de contato do footer embaixo. No mobile vira um <select>.
 *  - Título da página no topo da coluna de conteúdo (o page-header nativo é escondido).
 *  - Conteúdo do admin: tira os estilos inline do editor (fonte/tamanho/cor) para seguir o tema.
 *  - Quem somos: sem coluna lateral; faixa + vitrines da home (seções do page.json, CSS).
 *  - Nossas lojas: cards do componente nossas-lojas + filtro por estado.
 *  - Fale conosco: campos do Figma (motivo, cidade, estado, assunto). O formulário nativo só envia
 *    nome/e-mail/telefone/mensagem, então os campos extras vão no começo da mensagem.
 */
const ATENDIMENTO = {
  title: "Atendimento",
  contact: true,
  items: [
    { label: "Política de Privacidade", paths: ["/politica-de-privacidade/"] },
    { label: "Política de Entrega", paths: ["/politica-de-entrega/"] },
    { label: "Fale conosco", paths: ["/contato/"] },
    { label: "Troca, Devolução, Garantia", paths: ["/trocas-e-devolucoes/", "/troca-devolucao-garantia/"] },
  ],
};
const INSTITUCIONAL = {
  title: "Institucional",
  items: [
    { label: "BLOG", href: "http://blog.cpapfit.com.br/", external: true },
    { label: "Seja um representante!", href: "https://materiais.cpapfit.com.br/seja-um-representante/", external: true },
    { label: "Quem somos", paths: ["/quem-e-a-cpap-fit/", "/quem-somos/"] },
    { label: "Nossas lojas", paths: ["/nossas-lojas/", "/lojas-fisicas/"] },
    { label: "Planos de assinatura", paths: ["/planos-de-assinatura/"] },
  ],
};

const MOTIVOS = [
  "Dúvida sobre produto", "Orçamento", "Pedido em andamento", "Troca, devolução ou garantia",
  "Aluguel de equipamentos", "Outro",
];
const UFS = "AC AL AP AM BA CE DF ES GO MA MT MS MG PA PB PR PE PI RJ RN RS RO RR SC SP SE TO".split(" ");
const MSG_SEPARATOR = "\n— Mensagem —\n";

const slash = (p) => (p.endsWith("/") ? p : `${p}/`);
// Cada seção nativa imprime data-section-id no <section> e no <div> de dentro: pega o de fora.
const sectionOf = (n) => n?.closest("section[data-section-id]") ?? n?.closest("[data-section-id]");

// No preview do rascunho, os links internos precisam levar o theme_installation_id junto.
function withPreview(href) {
  const tid = new URLSearchParams(location.search).get("theme_installation_id");
  if (!tid || /^https?:/.test(href)) return href;
  const url = new URL(href, location.origin);
  url.searchParams.set("theme_installation_id", tid);
  return url.pathname + url.search;
}

function el(tag, className, html) {
  const node = document.createElement(tag);
  if (className) node.className = className;
  if (html != null) node.innerHTML = html;
  return node;
}

function buildAside(group, current) {
  const aside = el("aside", "qd-inst-aside");
  aside.append(el("p", "qd-inst-aside-title", group.title));

  const list = el("ul", "qd-inst-menu");
  const select = el("select", "qd-inst-select");
  select.setAttribute("aria-label", group.title);
  for (const item of group.items) {
    const href = item.href ?? item.paths[0];
    const active = item === current;
    const li = el("li", active ? "is-active" : "");
    const a = el("a", "", item.label);
    a.href = active ? location.pathname + location.search : withPreview(href);
    if (item.external) Object.assign(a, { target: "_blank", rel: "noopener" });
    if (active) a.setAttribute("aria-current", "page");
    li.append(a);
    list.append(li);
    select.append(new Option(item.label, a.href, active, active));
  }
  if (!current) select.prepend(new Option(group.title, "", true, true));
  select.addEventListener("change", () => select.value && (location.href = select.value));

  const pick = el("div", "qd-inst-pick");
  pick.append(select);
  aside.append(pick, list);

  const contact = group.contact && document.querySelector(".qd-footer-contact");
  if (contact) aside.append(contact.cloneNode(true));
  return aside;
}

// Conteúdo do admin vem do editor com font/size/cor inline (ex.: Arial 12px): deixa o tema mandar.
// Mantém só list-style (o texto atual é uma <ul> sem marcadores, um <li> por parágrafo).
function cleanContent(root) {
  root.querySelectorAll("[style]").forEach((n) => {
    const listStyle = n.style.listStyle;
    n.removeAttribute("style");
    if (listStyle) n.style.listStyle = listStyle;
  });
  root.querySelectorAll("font").forEach((f) => f.replaceWith(...f.childNodes));
}

function buildAccordion(content, main) {
  const heads = [...content.querySelectorAll(":scope > :is(h2, h3)")];
  if (!heads.length) return;
  const list = el("div", "qd-accordion");
  heads.forEach((h, i) => {
    const item = el("details", "qd-accordion-item");
    if (i === 0) item.open = true;
    const summary = el("summary", "", "");
    summary.textContent = h.textContent.trim();
    const body = el("div", "qd-accordion-body");
    for (let n = h.nextElementSibling; n && !/^H[23]$/.test(n.tagName); ) {
      const next = n.nextElementSibling;
      body.append(n);
      n = next;
    }
    item.append(summary, body);
    h.replaceWith(item);
    list.append(item);
  });
  // os cartões ficam juntos no fim do texto (o que vem antes do 1º título segue como introdução)
  content.append(list);
  const cta = el("div", "qd-inst-cta", `<p>Ainda continua com dúvida?</p>`);
  const link = el("a", "qd-inst-cta-btn", "Fale conosco");
  link.href = withPreview("/contato/");
  cta.append(link);
  main.append(cta);
}

function initStores(main) {
  const stores = document.querySelector("[data-qd-stores]");
  if (!stores) return;
  main.append(stores);
  const filters = stores.querySelector("[data-qd-stores-filters]");
  const cards = [...stores.querySelectorAll(".qd-store")];
  const ufs = [...new Set(cards.map((c) => c.dataset.uf).filter(Boolean))].sort();
  const pills = [["", "Todas as lojas"], ...ufs.map((uf) => [uf, uf])].map(([uf, label]) => {
    const b = el("button", "qd-stores-chip", label);
    b.type = "button";
    b.setAttribute("aria-pressed", String(!uf));
    b.addEventListener("click", () => {
      pills.forEach((p) => p.setAttribute("aria-pressed", String(p === b)));
      cards.forEach((c) => (c.hidden = !!uf && c.dataset.uf !== uf));
    });
    return b;
  });
  filters.append(...pills);
}

function fieldGroup(label, control) {
  const group = el("div", "form-group qd-contact-extra");
  const lab = el("label", "form-label", label);
  lab.htmlFor = control.id;
  group.append(lab, control);
  return group;
}

function selectControl(id, placeholder, options) {
  const s = el("select", "form-control form-select");
  s.id = id;
  s.required = true;
  s.append(new Option(placeholder, "", true, true));
  s.options[0].disabled = true;
  options.forEach((o) => s.append(new Option(o, o)));
  return s;
}

function inputControl(id, placeholder) {
  const i = el("input", "form-control");
  Object.assign(i, { id, type: "text", placeholder, required: true });
  return i;
}

function initContactForm(main) {
  const form = document.querySelector("#contact-form");
  if (!form || form.dataset.qdContact) return;
  form.dataset.qdContact = "1";
  form.classList.add("qd-contact-form"); // CSS não usa seletor de ID (regra da plataforma)
  const section = form.closest(".contact-form-section");
  main.append(...[...section.querySelectorAll(".alert")], el("h2", "qd-contact-subtitle", "Envie sua mensagem"), form);

  const field = (name) => form.querySelector(`[name="${name}"]`);
  const set = (name, label, placeholder) => {
    const input = field(name);
    if (!input) return;
    input.required = true;
    input.placeholder = placeholder;
    const lab = input.closest(".form-group")?.querySelector(".form-label");
    if (lab) lab.textContent = label;
  };
  set("name", "Nome completo*", "Digite o nome completo");
  set("email", "Email para contato*", "Digite o seu email");
  set("phone", "Telefone celular ou Whatsapp*", "(00) 00000-0000");
  set("message", "Mensagem*", "Digite sua mensagem");

  const motivo = selectControl("qd-contact-motivo", "Selecione o motivo", MOTIVOS);
  const cidade = inputControl("qd-contact-cidade", "Digite a cidade");
  const estado = selectControl("qd-contact-estado", "Selecione o estado", UFS);
  const assunto = inputControl("qd-contact-assunto", "Digite o assunto");
  const phoneGroup = field("phone")?.closest(".form-group");
  const messageGroup = field("message")?.closest(".form-group");
  const extras = [
    fieldGroup("Motivo*", motivo),
    fieldGroup("Cidade*", cidade),
    fieldGroup("Estado*", estado),
    fieldGroup("Assunto*", assunto),
  ];
  extras[3].classList.add("qd-contact-full");
  messageGroup?.classList.add("qd-contact-full");
  if (phoneGroup) phoneGroup.after(...extras);
  else messageGroup?.before(...extras);

  const submit = form.querySelector('button[type="submit"]');
  if (submit?.firstChild) submit.firstChild.textContent = "Enviar mensagem";

  // Captura (antes dos handlers do tema): junta os campos extras no início da mensagem.
  const message = field("message");
  form.addEventListener("submit", () => {
    if (!message) return;
    const body = message.value.split(MSG_SEPARATOR).pop();
    const head = [
      `Motivo: ${motivo.value}`,
      `Cidade: ${cidade.value} - ${estado.value}`,
      `Assunto: ${assunto.value}`,
    ].join("\n");
    message.value = head + MSG_SEPARATOR + body;
  }, true);
}

export default function initInstitucional() {
  // qd-inst-ready libera o <main> que o CSS esconde até aqui (evita layout shift — ver institucional.css)
  const run = () => {
    try {
      enhance();
    } finally {
      document.documentElement.classList.add("qd-inst-ready");
    }
  };
  const enhance = () => {
    const body = document.body;
    const isContact = body.classList.contains("template-contact");
    if (!(isContact || body.classList.contains("template-page")) || body.dataset.qdInst) return;
    body.dataset.qdInst = "1";

    const path = slash(location.pathname);
    let group = INSTITUCIONAL;
    let current = null;
    for (const g of [ATENDIMENTO, INSTITUCIONAL]) {
      const hit = g.items.find((i) => i.paths?.includes(path));
      if (hit) [group, current] = [g, hit];
    }
    const page = current?.label === "Quem somos" ? "quem-somos" : current?.label === "Nossas lojas" ? "nossas-lojas" : "";
    document.documentElement.classList.add("qd-inst-page");
    if (page) document.documentElement.classList.add(`qd-page-${page}`);

    const header = document.querySelector('[data-section-id="heading"]');
    const title = header?.querySelector(".page-header-title")?.textContent.trim() || current?.label || "";
    const content = document.querySelector(".page-content.user-content");

    // Quem somos: nada a fazer — faixa e vitrines são seções do page.json e o texto é formatado
    // pelo CSS a partir da classe page-<slug> que o layout.tpl põe no <body>. Mexer no DOM aqui
    // (ex.: limpar os estilos inline) mudaria o layout depois da 1ª pintura (CLS).
    if (page === "quem-somos") return;
    if (content) cleanContent(content);

    const anchor = sectionOf(content ?? document.querySelector(".contact-form-section"));
    if (!anchor) return;
    const layout = el("div", "container qd-inst");
    const main = el("div", "qd-inst-main");
    main.append(el("h1", "qd-inst-title", isContact ? "Fale conosco" : title));
    layout.append(buildAside(group, current), main);
    anchor.before(layout);
    anchor.classList.add("qd-inst-source");

    if (isContact) {
      main.classList.add("qd-contact");
      initContactForm(main);
      return;
    }
    if (content && content.textContent.trim()) {
      content.classList.add("qd-inst-content");
      main.append(content);
      // Troca, Devolução, Garantia (Figma 271:9547): cada título h2/h3 vira um cartão em sanfona
      if (current?.paths?.includes("/trocas-e-devolucoes/")) buildAccordion(content, main);
    }
    if (page === "nossas-lojas") initStores(main);
  };
  if (document.readyState !== "loading") run();
  else document.addEventListener("DOMContentLoaded", run);
}
