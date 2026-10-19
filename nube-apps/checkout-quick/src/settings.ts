/**
 * Configurações do app (portal de parceiros), lidas com `nube.getAppSettings()`.
 *
 * O SDK entrega `{ chave: { type, value } }` (AppSettingsValues) — só existem os tipos
 * string, enrichedText, image e collection. Por isso não há booleano: partes são
 * desligadas listando o nome em `disabled_features`.
 *
 * | chave                    | tipo                  | padrão |
 * |--------------------------|-----------------------|--------|
 * | free_shipping_threshold  | string ("299,90")     | sem valor = barra de frete grátis desligada |
 * | disabled_features        | collection de string  | nenhuma (ex.: ["rodape", "pos-compra"]) |
 * | top_bar_messages         | collection de string  | "Ambiente 100% seguro" |
 * | payment_note             | string                | "Até 12x sem juros no cartão de crédito" |
 * | whatsapp                 | string (só números)   | DEFAULTS.whatsapp (sem link de WhatsApp) |
 * | footer_benefits          | collection de string  | Pix (se ligado) · 12x · frete grátis · cupom (se ligado) |
 * | coupon_text, coupon_code | string                | DEFAULTS.coupon (sem cupom no rodapé) |
 * | company_info             | string                | razão social, endereço e CNPJ da CPAP Fit |
 *
 * O app em produção (QuickDevTool) não tem tela de configurações: getAppSettings() volta vazio e
 * vale o que está em DEFAULTS. Se um dia houver configurações, elas continuam tendo prioridade.
 * Também aceita valores "soltos" (sem { type, value }), para testes e compatibilidade.
 */
export const FEATURE_NAMES = ["faixa-topo", "frete-gratis", "selos-pagamento", "rodape", "pos-compra"] as const;
export type FeatureName = (typeof FEATURE_NAMES)[number];

export type Settings = {
	/** null = a loja não informou o valor mínimo: a barra de frete grátis não aparece */
	freeShippingThreshold: number | null;
	disabled: Set<string>;
	/** null = usar os textos padrão da faixa */
	topBarMessages: string[] | null;
	paymentNote: string;
	/** Só dígitos, com DDI (ex.: 5521999999999); null = sem WhatsApp */
	whatsapp: string | null;
	/** null = usar os benefícios padrão do rodapé */
	footerBenefits: string[] | null;
	/** cupom divulgado no rodapé; null = sem cupom */
	coupon: Coupon | null;
	/** % de desconto no Pix anunciado no rodapé; null = não anuncia */
	pixDiscount: number | null;
	/** endereço e CNPJ; "\n" quebra a linha */
	companyInfo: string;
};

/** text em negrito, detail em peso normal (Figma: "R$ 100 OFF" + "na linha Philips") */
export type Coupon = { text: string; detail?: string; code: string };

/** Cupom do Figma (rodapé 363:9230). Para mostrar no checkout: DEFAULTS.coupon = PHILIPS_COUPON. */
export const PHILIPS_COUPON: Coupon = { text: "R$ 100 OFF", detail: "na linha Philips", code: "QUERO100" };

export const DEFAULTS: {
	paymentNote: string;
	companyInfo: string;
	pixDiscount: number | null;
	coupon: Coupon | null;
	whatsapp: string | null;
} = {
	// o mesmo parcelamento que a loja mostra na página de produto ("12 x de ... sem juros")
	paymentNote: "Até 12x sem juros no cartão de crédito",
	// rodapé legal do tema (design/components/footer-base.html)
	companyInfo:
		"DSP Equipamentos, Rua Emílio Blum - 131 - Sala 206 Torre A - Centro - 88020-010 - Florianópolis - SC\nCNPJ: 29.695.217/0001-45",
	// O estado do checkout não informa descontos por meio de pagamento antes de o cliente escolher
	// (só prices.discount_gateway, depois). Por isso o "10% OFF no Pix" fica no código: ligue com 10
	// quando o desconto Pix estiver ativo em Configurações > Meios de pagamento (hoje está 0%).
	pixDiscount: null,
	// desligado: ligar só com o cupom ativo na loja (PHILIPS_COUPON)
	coupon: null,
	// só dígitos com DDI, ex.: "554840421861"; null = sem link de WhatsApp
	whatsapp: null,
};

export function readSettings(raw: unknown): Settings {
	const settings = (raw && typeof raw === "object" ? raw : {}) as Record<string, unknown>;
	const get = (key: string) => unwrap(settings[key]);

	const threshold = toNumber(get("free_shipping_threshold"));
	const messages = toList(get("top_bar_messages"));
	const note = toText(get("payment_note"));
	const digits = (toText(get("whatsapp")) ?? "").replace(/\D/g, "");
	const benefits = toList(get("footer_benefits"));
	const couponCode = toText(get("coupon_code"));

	return {
		freeShippingThreshold: threshold !== null && threshold > 0 ? threshold : null,
		disabled: new Set(toList(get("disabled_features")).map((s) => s.toLowerCase())),
		topBarMessages: messages.length ? messages : null,
		paymentNote: note ?? DEFAULTS.paymentNote,
		whatsapp: digits.length >= 10 ? digits : DEFAULTS.whatsapp,
		footerBenefits: benefits.length ? benefits : null,
		coupon: couponCode ? { code: couponCode, text: toText(get("coupon_text")) ?? "Cupom de desconto" } : DEFAULTS.coupon,
		pixDiscount: DEFAULTS.pixDiscount,
		companyInfo: toText(get("company_info")) ?? DEFAULTS.companyInfo,
	};
}

function unwrap(v: unknown): unknown {
	if (v && typeof v === "object" && !Array.isArray(v) && "value" in v) {
		return (v as { value: unknown }).value;
	}
	return v;
}

function toText(v: unknown): string | null {
	if (typeof v === "number") return String(v);
	if (typeof v !== "string") return null;
	const t = v.trim();
	return t ? t : null;
}

function toNumber(v: unknown): number | null {
	if (typeof v === "number") return Number.isFinite(v) ? v : null;
	const t = toText(v);
	if (!t) return null;
	const n = Number(t.replace(/[^\d,.-]/g, "").replace(/\.(?=\d{3}(\D|$))/g, "").replace(",", "."));
	return Number.isFinite(n) ? n : null;
}

/** collection -> string[]; string -> separado por quebra de linha, "|" ou "," */
function toList(v: unknown): string[] {
	if (Array.isArray(v)) {
		return v.map((x) => toText(unwrap(x))).filter((x): x is string => Boolean(x));
	}
	const t = toText(v);
	return t ? t.split(/\r?\n|\||,/).map((s) => s.trim()).filter(Boolean) : [];
}
