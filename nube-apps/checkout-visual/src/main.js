/*
 * Checkout CPAP Fit — script clássico (sem NubeSDK) que deixa o checkout v3 igual ao Figma
 * 367:13649. Roda na página do checkout com acesso ao DOM: injeta o CSS (checkout.css), troca o
 * logo, põe o selo "Ambiente 100% seguro" no cabeçalho, ajusta rótulos e nomes dos produtos e
 * desenha o rodapé. O checkout é React (Next.js) e redesenha partes da página a cada etapa, então
 * os ajustes rodam de novo a cada mudança (MutationObserver). Não mexe em preço, frete nem pagamento.
 *
 * __CSS__ e __LOGO__ são preenchidos pelo build.mjs.
 */
(function () {
	if (window.__qdCheckout || !/\/checkout\//.test(location.pathname)) return;
	window.__qdCheckout = true;

	// Igual ao app NubeSDK (settings.ts): só anuncia o que a loja garante.
	var PIX_DISCOUNT = null; // ex.: 10 quando o desconto Pix estiver ativo nos meios de pagamento
	var COUPON = null; // ex.: { text: "R$ 100 OFF", detail: "na linha Philips", code: "QUERO100" }

	var LOGO = "__LOGO__";
	var ICON = {
		lock: '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" aria-hidden="true"><path d="M6 8V7C6 3.68629 8.68629 1 12 1C15.3137 1 18 3.68629 18 7V8H20C20.5523 8 21 8.44772 21 9V21C21 21.5523 20.5523 22 20 22H4C3.44772 22 3 21.5523 3 21V9C3 8.44772 3.44772 8 4 8H6ZM19 10H5V20H19V10ZM11 15.7324C10.4022 15.3866 10 14.7403 10 14C10 12.8954 10.8954 12 12 12C13.1046 12 14 12.8954 14 14C14 14.7403 13.5978 15.3866 13 15.7324V18H11V15.7324ZM8 8H16V7C16 4.79086 14.2091 3 12 3C9.79086 3 8 4.79086 8 7V8Z" fill="#AD9361"/></svg>',
		pix: '<svg width="20" height="20" viewBox="0 0 20 20" fill="#FEFDFC" aria-hidden="true"><path d="M12.06 1.45L18.54 7.94C19.68 9.08 19.68 10.92 18.54 12.06L12.06 18.54C10.92 19.68 9.07 19.68 7.94 18.54L1.45 12.06C0.32 10.92 0.32 9.08 1.45 7.94L7.94 1.45C9.07 0.32 10.92 0.32 12.06 1.45ZM10 12.36L7.94 14.42C7.62 14.73 7.25 14.96 6.85 15.1L9.11 17.36C9.6 17.85 10.39 17.85 10.88 17.36L13.14 15.1C12.75 14.96 12.38 14.73 12.06 14.42L10 12.36ZM4.99 6.76L2.63 9.11C2.14 9.6 2.14 10.39 2.63 10.88L4.99 13.24C5.48 13.73 6.27 13.73 6.76 13.24L8.82 11.18C9.47 10.53 10.53 10.53 11.18 11.18L13.24 13.24C13.73 13.73 14.52 13.73 15.01 13.24L17.36 10.88C17.85 10.39 17.85 9.6 17.36 9.11L15.01 6.76C14.52 6.27 13.73 6.27 13.24 6.76L11.18 8.82C10.53 9.47 9.47 9.47 8.82 8.82L6.76 6.76C6.27 6.27 5.48 6.27 4.99 6.76ZM9.11 2.63L6.85 4.89C7.25 5.03 7.62 5.26 7.94 5.58L10 7.64L12.06 5.58C12.38 5.26 12.75 5.03 13.14 4.89L10.88 2.63C10.39 2.14 9.6 2.14 9.11 2.63Z"/></svg>',
		card: '<svg width="20" height="20" viewBox="0 0 20 20" fill="#FEFDFC" aria-hidden="true"><path d="M2.50407 2.49983H17.5041C17.9643 2.49983 18.3374 2.87292 18.3374 3.33316V16.6665C18.3374 17.1268 17.9643 17.4998 17.5041 17.4998H2.50407C2.04383 17.4998 1.67073 17.1268 1.67073 16.6665V3.33316C1.67073 2.87292 2.04383 2.49983 2.50407 2.49983ZM16.6708 9.1665H3.3374V15.8332H16.6708V9.1665ZM16.6708 7.49983V4.16649H3.3374V7.49983H16.6708ZM11.6708 12.4998H15.0041V14.1665H11.6708V12.4998Z"/></svg>',
		frete: '<svg width="20" height="20" viewBox="0 0 20 20" fill="#FEFDFC" aria-hidden="true"><path d="M16.6667 2.5L18.3333 5.83333V16.6667C18.3333 17.1269 17.9602 17.5 17.5 17.5H2.5C2.03977 17.5 1.66667 17.1269 1.66667 16.6667V5.83627L3.33333 2.5H16.6667ZM16.6667 7.5H3.33333V15.8333H16.6667V7.5ZM10 8.33333L13.3333 11.6667H10.8333V15H9.16667V11.6667H6.66667L10 8.33333ZM15.6367 4.16667H4.36333L3.53083 5.83333H16.47L15.6367 4.16667Z"/></svg>',
		tag: '<svg width="20" height="20" viewBox="0 0 20 20" fill="#FEFDFC" aria-hidden="true"><path d="M9.08683 1.75021L17.3364 2.92872L18.5149 11.1783L10.8546 18.8386C10.5292 19.1641 10.0016 19.1641 9.67608 18.8386L1.42653 10.5891C1.10109 10.2636 1.10109 9.736 1.42653 9.4105L9.08683 1.75021ZM9.67608 3.51798L3.1943 9.99975L10.2653 17.0708L16.7472 10.5891L15.8633 4.40186L9.67608 3.51798ZM11.4439 8.82125C10.793 8.1704 10.793 7.11513 11.4439 6.46425C12.0948 5.81338 13.15 5.81338 13.8009 6.46425C14.4518 7.11513 14.4518 8.1704 13.8009 8.82125C13.15 9.47217 12.0948 9.47217 11.4439 8.82125Z"/></svg>',
	};

	document.documentElement.classList.add("qd-ck");

	function addHead() {
		if (document.getElementById("qd-ck-style")) return;
		var style = document.createElement("style");
		style.id = "qd-ck-style";
		style.textContent = "__CSS__";
		document.head.appendChild(style);
		// Inter só nos rótulos do resumo e nos nomes das opções (o resto é Montserrat, já carregada)
		var font = document.createElement("link");
		font.rel = "stylesheet";
		font.href = "https://fonts.googleapis.com/css2?family=Inter:wght@500;600&display=swap";
		document.head.appendChild(font);
	}

	function header() {
		var logo = document.querySelector(".headbar-logo-img");
		if (logo && logo.getAttribute("src") !== LOGO) logo.setAttribute("src", LOGO);
		var right = document.getElementById("headbar-right");
		if (right && !right.querySelector(".qd-secure")) {
			var badge = document.createElement("span");
			badge.className = "qd-secure";
			badge.innerHTML = "<span>Ambiente <b>100% seguro</b></span>" + ICON.lock;
			right.appendChild(badge);
		}
	}

	// textos do checkout -> textos do Figma (só o rótulo; o campo continua o mesmo)
	var TEXT = {
		"Dados para entrega": "Dados para a entrega",
		"Telefone com DDD": "Telefone",
		"Apto, Bloco, Referência, etc. (opcional)": "Complemento (opcional)",
		"CPF ou CNPJ": "CPF",
		"Custo de frete": "Frete",
	};
	var PLACEHOLDER = {
		"shippingAddress.phone": "(00) 00000-0000",
		"shippingAddress.floor": "Apto, Bloco, Referência, etc.",
		// o campo aceita CNPJ também; o placeholder avisa
		"billingAddress.id_number": "CPF ou CNPJ",
	};

	function texts() {
		var nodes = document.querySelectorAll("#main-column .panel-header, #main-column .input-label, .table-subtotal td");
		for (var i = 0; i < nodes.length; i++) {
			var node = nodes[i].firstChild;
			if (node && node.nodeType === 3 && TEXT[node.nodeValue.trim()]) node.nodeValue = TEXT[node.nodeValue.trim()];
		}
		for (var name in PLACEHOLDER) {
			var input = document.getElementById(name);
			if (input && input.getAttribute("placeholder") !== PLACEHOLDER[name]) input.setAttribute("placeholder", PLACEHOLDER[name]);
		}
	}

	// Figma: só a opção de frete escolhida (ou a primeira) e o link "Mais opções" para ver as outras
	var CHEVRON =
		'<svg width="24" height="24" viewBox="0 0 24 24" aria-hidden="true"><path d="M11.9999 13.1714L16.9497 8.22168L18.3639 9.63589L11.9999 15.9999L5.63599 9.63589L7.0502 8.22168L11.9999 13.1714Z" fill="#2C4372"/></svg>';
	var shippingOpen = false;

	function shipping() {
		var box = document.querySelector(".shipping-options");
		if (!box) return;
		var options = box.querySelectorAll(".shipping-option");
		var more = box.parentNode.querySelector(".qd-more");
		if (options.length < 2) {
			box.classList.remove("qd-ship-collapsed");
			if (more) more.remove();
			return;
		}
		var shown = box.querySelector(".shipping-option.active") || options[0];
		for (var i = 0; i < options.length; i++) {
			var on = options[i] === shown;
			if (options[i].classList.contains("qd-ship-shown") !== on) options[i].classList.toggle("qd-ship-shown", on);
		}
		if (box.classList.contains("qd-ship-collapsed") === shippingOpen) box.classList.toggle("qd-ship-collapsed", !shippingOpen);
		if (!more) {
			more = document.createElement("button");
			more.type = "button";
			more.className = "qd-more";
			more.addEventListener("click", function () {
				shippingOpen = !shippingOpen;
				shipping();
			});
			box.parentNode.insertBefore(more, box.nextSibling);
		}
		var label = shippingOpen ? "Menos opções" : "Mais opções";
		if (more.getAttribute("aria-expanded") !== String(shippingOpen) || !more.firstChild) {
			more.setAttribute("aria-expanded", String(shippingOpen));
			more.innerHTML = "<span>" + label + "</span>" + CHEVRON;
		}
	}

	function fields() {
		var labels = document.querySelectorAll(".has-float-label > label");
		for (var i = 0; i < labels.length; i++) {
			var label = labels[i];
			var text = (label.textContent || "").replace(/\*$/, "").trim();
			var required = !/opcional/i.test(text);
			if (label.classList.contains("qd-req") !== required) label.classList.toggle("qd-req", required);
			var input = label.parentNode.querySelector("input, textarea");
			// o checkout usa placeholder " " para o rótulo flutuante; o Figma mostra o nome do campo
			if (input && (!input.getAttribute("placeholder") || input.getAttribute("placeholder") === " ")) {
				input.setAttribute("placeholder", input.name && /phone|telefone/i.test(input.name) ? "(00) 00000-0000" : text);
			}
		}
	}

	// "Nome - Marca (variação) × 1" -> marca acima do nome, sem o "× 1"
	function products() {
		var cells = document.querySelectorAll("td.table-product-name");
		for (var i = 0; i < cells.length; i++) {
			var cell = cells[i];
			var node = cell.firstChild;
			if (node && node.nodeType === 3 && / × 1$/.test(node.nodeValue)) node.nodeValue = node.nodeValue.replace(/ × 1$/, "");
			var name = (cell.textContent || "").replace(/ × \d+$/, "").replace(/\s*\([^)]*\)\s*$/, "");
			var dash = name.lastIndexOf(" - ");
			var brand = dash > 0 ? name.slice(dash + 3).trim() : "";
			if (brand && cell.getAttribute("data-qd-brand") !== brand) cell.setAttribute("data-qd-brand", brand);
		}
		// a miniatura vem com 100px; o cartão do Figma mostra 116px
		var imgs = document.querySelectorAll("td.summary-img-wrap img");
		for (var j = 0; j < imgs.length; j++) {
			var src = imgs[j].getAttribute("src") || "";
			if (/-100-0\./.test(src)) imgs[j].setAttribute("src", src.replace(/-100-0\./, "-240-0."));
		}
	}

	function storeName() {
		var logo = document.querySelector(".headbar-logo-img");
		return (logo && logo.getAttribute("alt")) || "CPAP FIT";
	}

	function benefit(icon, html, extra) {
		return '<li class="qd-ft-item">' + icon + '<p class="qd-ft-text">' + html + "</p>" + (extra || "") + "</li>";
	}

	function footer() {
		if (document.querySelector(".qd-ft")) return;
		var items = [];
		if (PIX_DISCOUNT) items.push(benefit(ICON.pix, "<b>" + PIX_DISCOUNT + "% OFF</b> no Pix"));
		items.push(benefit(ICON.card, "<b>12x sem juros</b> no cartão de crédito"));
		items.push(benefit(ICON.frete, "<b>Frete grátis</b>", '<a class="qd-ft-rules" href="/politica-de-entrega/" target="_blank" rel="noopener">ver regras</a>'));
		if (COUPON) {
			items.push(
				benefit(
					ICON.tag,
					"<b>" + COUPON.text + "</b> " + (COUPON.detail || ""),
					'<span class="qd-ft-code">' + COUPON.code + '</span><button type="button" class="qd-ft-copy" data-code="' + COUPON.code + '">Copiar</button>',
				),
			);
		}
		var ft = document.createElement("footer");
		ft.className = "qd-ft";
		ft.innerHTML =
			'<div class="qd-ft-in">' +
			'<div class="qd-ft-benefits"><ul class="qd-ft-list">' +
			items.join('<li class="qd-ft-sep" aria-hidden="true"></li>') +
			"</ul></div>" +
			'<div class="qd-ft-legal-wrap"><div class="qd-ft-legal">' +
			"<p>DSP Equipamentos, Rua Emílio Blum - 131 - Sala 206 Torre A - Centro - 88020-010 - Florianópolis - SC<br>" +
			"CNPJ: 29.695.217/0001-45 | © Todos os direitos reservados - " + storeName().toUpperCase() + " - " + new Date().getFullYear() + "</p>" +
			'<p class="qd-ft-credits"><a href="https://www.nuvemshop.com.br" target="_blank" rel="noopener">Nuvemshop</a>' +
			'<a href="https://quickdigital.com.br" target="_blank" rel="noopener">Quick Digital</a></p>' +
			"</div></div></div>" +
			'<div class="qd-ft-grad" aria-hidden="true"></div>';
		ft.addEventListener("click", function (e) {
			var btn = e.target.closest && e.target.closest(".qd-ft-copy");
			if (!btn || !navigator.clipboard) return;
			navigator.clipboard.writeText(btn.getAttribute("data-code")).then(function () {
				btn.textContent = "Copiado";
				setTimeout(function () {
					btn.textContent = "Copiar";
				}, 2000);
			});
		});
		// fora do #__next: o React do checkout não redesenha o que está fora da raiz dele
		document.body.appendChild(ft);
	}

	function apply() {
		addHead();
		header();
		texts();
		fields();
		shipping();
		products();
		footer();
	}

	var queued = false;
	function schedule() {
		if (queued) return;
		queued = true;
		requestAnimationFrame(function () {
			queued = false;
			apply();
		});
	}

	function start() {
		apply();
		new MutationObserver(schedule).observe(document.body, { childList: true, subtree: true });
	}

	addHead();
	if (document.body) start();
	else document.addEventListener("DOMContentLoaded", start);
})();
