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
 * | whatsapp                 | string (só números)   | sem link de WhatsApp |
 * | footer_benefits          | collection de string  | parcelamento · frete grátis (ver regras) |
 * | coupon_text, coupon_code | string                | sem cupom no rodapé |
 * | company_info             | string                | razão social, endereço e CNPJ da CPAP Fit |
 *
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
	/** cupom divulgado no rodapé (texto + código); null = sem cupom */
	coupon: { text: string; code: string } | null;
	companyInfo: string;
};

export const DEFAULTS = {
	// o mesmo parcelamento que a loja mostra na página de produto ("12 x de ... sem juros")
	paymentNote: "Até 12x sem juros no cartão de crédito",
	// rodapé legal do tema (design/components/footer-base.html)
	companyInfo:
		"DSP Equipamentos, Rua Emílio Blum - 131 - Sala 206 Torre A - Centro - 88020-010 - Florianópolis - SC · CNPJ: 29.695.217/0001-45",
} as const;

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
		whatsapp: digits.length >= 10 ? digits : null,
		footerBenefits: benefits.length ? benefits : null,
		coupon: couponCode ? { code: couponCode, text: toText(get("coupon_text")) ?? "Cupom de desconto" } : null,
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
