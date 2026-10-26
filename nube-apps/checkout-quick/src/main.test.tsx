import { describe, expect, it, vi } from "vitest";

// Componentes do SDK viram objetos simples para inspecionar a árvore (mesma técnica do template oficial).
vi.mock("@tiendanube/nube-sdk-jsx", () => {
	const make = (type: string) => (props: Record<string, unknown>) => ({ type, props });
	return { Column: make("col"), Row: make("row"), Text: make("txt"), Progress: make("progress"), Link: make("link"), Icon: make("icon"), Box: make("box"), Svg: { Root: make("svg"), Path: make("path") } };
});

import { faixaTopo } from "./features/faixa-topo";
import { freteGratis } from "./features/frete-gratis";
import { posCompra } from "./features/pos-compra";
import { rodape } from "./features/rodape";
import { selosPagamento } from "./features/selos-pagamento";
import { App } from "./main";
import { PHILIPS_COUPON, readSettings } from "./settings";

type Node = { type: unknown; props: Record<string, unknown> };
const expand = (n: Node): unknown => (typeof n.type === "function" ? (n.type as (p: unknown) => unknown)(n.props) : n);

function texts(node: unknown): string[] {
	if (node == null || node === false) return [];
	if (typeof node === "string" || typeof node === "number") return [String(node)];
	if (Array.isArray(node)) return node.flatMap(texts);
	const n = expand(node as Node) as Node;
	return texts(n.props?.children);
}

function findAll(node: unknown, type: string): Node[] {
	if (!node || typeof node !== "object") return [];
	if (Array.isArray(node)) return node.flatMap((c) => findAll(c, type));
	const n = expand(node as Node) as Node;
	return [...(n.type === type ? [n] : []), ...findAll(n.props?.children, type)];
}

const state = (
	step: "start" | "payment" | "success" | null,
	subtotal = 174.9,
	extra: { payment?: unknown; order?: unknown } = { payment: { status: "paid", selected: null } },
) =>
	({
		...extra,
		location: step ? { page: { type: "checkout", data: { step } } } : { page: { type: "home", data: {} } },
		cart: { prices: { subtotal, discount_coupon: 0, discount_promotion: 0, discount_gateway: 0, shipping: 0, total: subtotal, subtotal_without_taxes: subtotal } },
		store: { name: "QuickStart", domain: "quickstart2.lojavirtualnuvem.com.br", currency_details: { code: "BRL", display_short: "R$", display_long: "R$", cents_separator: ",", thousands_separator: "." } },
	}) as never;

const all = (node: unknown) => texts(node).join(" ");
const defaults = readSettings(undefined);
const withWhats = readSettings({ whatsapp: { type: "string", value: "5521999998888" } });
const withThreshold = readSettings({ free_shipping_threshold: { type: "string", value: "299" } });

describe("partes", () => {
	it("faixa-topo: ambiente seguro com cadeado", () => {
		const node = faixaTopo.render(state("start"), defaults);
		expect(all(node)).toBe("Ambiente 100% seguro");
		expect(findAll(node, "icon")[0].props.name).toBe("lock");
	});

	it("faixa-topo: textos próprios substituem os padrões", () => {
		const s = readSettings({ top_bar_messages: { type: "collection", value: ["Entrega expressa"] } });
		expect(all(faixaTopo.render(state("start"), s))).toBe("Entrega expressa");
	});

	it("frete-gratis: desligada sem valor mínimo configurado", () => {
		expect(freteGratis.render(state("start", 174.9), defaults)).toBeNull();
	});

	it("frete-gratis: quanto falta e parabéns, com valor mínimo configurado", () => {
		expect(all(freteGratis.render(state("start", 174.9), withThreshold))).toContain("Faltam R$ 124,10");
		expect(all(freteGratis.render(state("start", 320), withThreshold))).toContain("Parabéns");
		expect(findAll(freteGratis.render(state("start", 174.9), withThreshold), "progress")[0].props.value).toBe(58);
	});

	it("selos-pagamento: segurança + condição configurável", () => {
		const t = all(selosPagamento.render(state("payment"), defaults));
		expect(t).toContain("Pagamento rápido e protegido");
		expect(t).toContain("Até 12x sem juros no cartão de crédito");
	});

	it("rodape: com Pix e cupom desligados, só 12x e frete; regras do frete e créditos", () => {
		const node = rodape.render(state("start"), { ...defaults, pixDiscount: null, coupon: null });
		const t = all(node);
		expect(t.indexOf("12x sem juros")).toBeLessThan(t.indexOf("Frete grátis"));
		expect(t).toContain("no cartão de crédito");
		expect(t).toContain("ver regras");
		expect(t).not.toContain("Travou em alguma etapa?");
		expect(t).toContain("CNPJ: 29.695.217/0001-45");
		expect(t).toContain(`© Todos os direitos reservados - QUICKSTART - ${new Date().getFullYear()}`);
		expect(t).not.toMatch(/pix/i);
		expect(t).not.toContain("QUERO100");
		expect(t).not.toMatch(/copiar/i);
		expect(findAll(node, "svg")).toHaveLength(2);
		expect(findAll(node, "link").map((l) => l.props.href)).toEqual([
			"https://quickstart2.lojavirtualnuvem.com.br/politica-de-entrega/",
			"https://www.nuvemshop.com.br",
			"https://quickdigital.com.br",
		]);
	});

	it("rodape: por padrão os 4 benefícios do Figma, na ordem, sem botão Copiar", () => {
		expect(defaults.pixDiscount).toBe(10);
		expect(defaults.coupon).toEqual(PHILIPS_COUPON);
		const node = rodape.render(state("start"), defaults);
		const t = all(node);
		const order = ["10% OFF", "12x sem juros", "Frete grátis", "R$ 100 OFF"].map((x) => t.indexOf(x));
		expect(order.every((pos, i) => pos >= 0 && (i === 0 || pos > order[i - 1]))).toBe(true);
		expect(t).toContain("no Pix");
		expect(t).toContain("na linha Philips");
		expect(t).toContain("QUERO100");
		expect(t).not.toMatch(/copiar/i);
		expect(findAll(node, "svg")).toHaveLength(4);
		// um separador entre cada benefício + a faixa em degradê
		expect(findAll(node, "box")).toHaveLength(4);
	});

	it("rodape: cupom só se configurado; benefícios próprios substituem os padrões", () => {
		const s = readSettings({
			whatsapp: "5521999998888",
			coupon_text: "R$ 100 OFF na linha Philips",
			coupon_code: "QUERO100",
			footer_benefits: ["Entrega para todo o Brasil"],
		});
		const node = rodape.render(state("start"), s);
		const t = all(node);
		expect(t).toContain("Entrega para todo o Brasil");
		expect(t).not.toContain("12x sem juros");
		expect(t).toContain("QUERO100");
		// o Figma não tem WhatsApp no rodapé
		expect(findAll(node, "link").some((l) => String(l.props.href).startsWith("https://wa.me/"))).toBe(false);
	});

	it("pos-compra: confirmação e próximos passos", () => {
		const t = all(posCompra.render(state("success"), withWhats));
		expect(t).toContain("Pedido confirmado!");
		expect(t).toContain("chega no seu e-mail");
		expect(t).toContain("Chama no WhatsApp");
	});

	it("pos-compra: boleto/Pix em aberto não diz 'confirmado'", () => {
		const t = all(posCompra.render(state("success", 50, { payment: { status: "pending", selected: null } }), defaults));
		expect(t).toContain("Pedido recebido!");
		expect(t).not.toContain("confirmado");
		expect(t).toContain("pagamento for aprovado");
	});

	it("pos-compra: pedido cancelado não mostra nada", () => {
		const s = state("success", 50, { payment: { status: "voided", selected: null }, order: { status: "cancelled" } });
		expect(posCompra.render(s, defaults)).toBeNull();
	});
});

describe("App", () => {
	const setup = (settings: unknown = {}) => {
		const calls = new Map<string, (s: unknown) => unknown>();
		App({ render: (slot: string, fn: (s: unknown) => unknown) => calls.set(slot, fn), getAppSettings: () => settings } as never);
		return calls;
	};

	it("registra uma parte por slot", () => {
		expect([...setup().keys()]).toEqual([
			"after_header",
			"after_line_items_price",
			"before_payment_options",
			"after_main_content",
			"after_order_number",
		]);
	});

	it("cada parte só aparece nas suas etapas", () => {
		const calls = setup();
		expect(all(calls.get("before_payment_options")?.(state("start")))).toBe("");
		expect(all(calls.get("before_payment_options")?.(state("payment")))).toContain("Pagamento rápido");
		expect(all(calls.get("after_order_number")?.(state("payment")))).toBe("");
		expect(all(calls.get("after_order_number")?.(state("success")))).toContain("Pedido confirmado");
		expect(all(calls.get("after_header")?.(state(null)))).toBe("");
	});

	it("disabled_features desliga partes; valor mínimo vem das configurações reais", () => {
		const calls = setup({
			disabled_features: { type: "collection", value: ["rodape", "faixa-topo"] },
			free_shipping_threshold: { type: "string", value: "199" },
		});
		expect(calls.has("after_main_content")).toBe(false);
		expect(calls.has("after_header")).toBe(false);
		expect(all(calls.get("after_line_items_price")?.(state("start", 100)))).toContain("Faltam R$ 99,00");
	});

	it("sem valor mínimo, o slot do frete grátis fica vazio", () => {
		expect(all(setup().get("after_line_items_price")?.(state("start", 100)))).toBe("");
	});
});
