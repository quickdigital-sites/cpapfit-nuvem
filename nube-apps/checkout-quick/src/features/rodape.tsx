/**
 * Rodapé da marca no fim do checkout (Figma 363:9230, rodapé azul de 367:13649): benefícios da loja,
 * rodapé legal com os créditos e a faixa em degradê. O tema (theme/static/checkout.scss.tpl) estica o
 * slot para a largura da tela, que o app sozinho não consegue.
 *
 * Ordem dos benefícios do Figma: Pix · 12x · frete grátis · cupom. Pix e cupom só aparecem quando
 * ligados em DEFAULTS (settings.ts): o checkout não informa o desconto Pix e o cupom depende da loja.
 * Os ícones são os mesmos do tema (design/components/footer-topo.html), desenhados com Svg do SDK.
 * O botão "Copiar" do site não existe aqui: o app roda num Web Worker, sem acesso à área de transferência.
 */
import { Box, Column, Link, Row, Svg, Text } from "@tiendanube/nube-sdk-jsx";
import type { NubeComponent } from "@tiendanube/nube-sdk-types";
import { GOLD, INDIGO, OFFWHITE } from "../brand";
import { storeUrl } from "../checkout";
import type { Feature } from "./types";

// caminhos 20x20 dos ícones do tema (mesmos do Figma)
const ICONS = {
	pix: "M12.06 1.45L18.54 7.94C19.68 9.08 19.68 10.92 18.54 12.06L12.06 18.54C10.92 19.68 9.07 19.68 7.94 18.54L1.45 12.06C0.32 10.92 0.32 9.08 1.45 7.94L7.94 1.45C9.07 0.32 10.92 0.32 12.06 1.45ZM10 12.36L7.94 14.42C7.62 14.73 7.25 14.96 6.85 15.1L9.11 17.36C9.6 17.85 10.39 17.85 10.88 17.36L13.14 15.1C12.75 14.96 12.38 14.73 12.06 14.42L10 12.36ZM4.99 6.76L2.63 9.11C2.14 9.6 2.14 10.39 2.63 10.88L4.99 13.24C5.48 13.73 6.27 13.73 6.76 13.24L8.82 11.18C9.47 10.53 10.53 10.53 11.18 11.18L13.24 13.24C13.73 13.73 14.52 13.73 15.01 13.24L17.36 10.88C17.85 10.39 17.85 9.6 17.36 9.11L15.01 6.76C14.52 6.27 13.73 6.27 13.24 6.76L11.18 8.82C10.53 9.47 9.47 9.47 8.82 8.82L6.76 6.76C6.27 6.27 5.48 6.27 4.99 6.76ZM9.11 2.63L6.85 4.89C7.25 5.03 7.62 5.26 7.94 5.58L10 7.64L12.06 5.58C12.38 5.26 12.75 5.03 13.14 4.89L10.88 2.63C10.39 2.14 9.6 2.14 9.11 2.63Z",
	card: "M2.5 2.5H17.5C17.96 2.5 18.34 2.87 18.34 3.33V16.67C18.34 17.13 17.96 17.5 17.5 17.5H2.5C2.04 17.5 1.67 17.13 1.67 16.67V3.33C1.67 2.87 2.04 2.5 2.5 2.5ZM16.67 9.17H3.34V15.83H16.67V9.17ZM16.67 7.5V4.17H3.34V7.5H16.67ZM11.67 12.5H15V14.17H11.67V12.5Z",
	frete: "M16.67 2.5L18.33 5.83V16.67C18.33 17.13 17.96 17.5 17.5 17.5H2.5C2.04 17.5 1.67 17.13 1.67 16.67V5.84L3.33 2.5H16.67ZM16.67 7.5H3.33V15.83H16.67V7.5ZM10 8.33L13.33 11.67H10.83V15H9.17V11.67H6.67L10 8.33ZM15.64 4.17H4.36L3.53 5.83H16.47L15.64 4.17Z",
	cupom: "M9.09 1.75L17.34 2.93L18.51 11.18L10.85 18.84C10.53 19.16 10 19.16 9.68 18.84L1.43 10.59C1.1 10.26 1.1 9.74 1.43 9.41L9.09 1.75ZM9.68 3.52L3.19 10L10.27 17.07L16.75 10.59L15.86 4.4L9.68 3.52ZM11.44 8.82C10.79 8.17 10.79 7.12 11.44 6.46C12.09 5.81 13.15 5.81 13.8 6.46C14.45 7.12 14.45 8.17 13.8 8.82C13.15 9.47 12.09 9.47 11.44 8.82Z",
} as const;

const FONT = { fontSize: "13px", lineHeight: "15px", textTransform: "uppercase", margin: 0 } as const;

function icon(name: keyof typeof ICONS) {
	return (
		<Svg.Root key="icone" width={20} height={20} viewBox="0 0 20 20" fill={OFFWHITE}>
			<Svg.Path d={ICONS[name]} />
		</Svg.Root>
	);
}

/** ícone + "NEGRITO normal" + extras, como nos itens do Figma */
function benefit(key: string, iconName: keyof typeof ICONS | null, strong: string, rest = "", extra: NubeComponent[] = []) {
	return (
		<Row key={key} gap={16} alignItems="center" style={{ flexWrap: "wrap" }}>
			{[
				...(iconName ? [icon(iconName)] : []),
				<Row key="texto" gap={4} alignItems="center">
					{[
						<Text key="forte" color={OFFWHITE} style={{ ...FONT, fontWeight: 700 }}>
							{strong}
						</Text>,
						...(rest
							? [
									<Text key="resto" color={OFFWHITE} style={{ ...FONT, fontWeight: 400 }}>
										{rest}
									</Text>,
								]
							: []),
					]}
				</Row>,
				...extra,
			]}
		</Row>
	);
}

const separator = (key: string) => (
	<Box key={key} style={{ width: "1px", height: "8px", background: GOLD }} />
);

export const rodape: Feature = {
	name: "rodape",
	slot: "after_main_content",
	steps: ["start", "payment"],
	render(state, settings) {
		const rules = storeUrl(state, "/politica-de-entrega/");

		const coupon = settings.coupon;
		const base = settings.footerBenefits
			? settings.footerBenefits.map((text, i) => benefit(`beneficio-${i}`, null, text))
			: [
					...(settings.pixDiscount ? [benefit("pix", "pix", `${settings.pixDiscount}% OFF`, "no Pix")] : []),
					benefit("parcelamento", "card", "12x sem juros", "no cartão de crédito"),
					benefit(
						"frete",
						"frete",
						"Frete grátis",
						"",
						rules
							? [
									<Link
										key="regras"
										href={rules}
										variant="link"
										style={{ color: OFFWHITE, fontSize: "11px", lineHeight: "15px", textTransform: "uppercase", textDecoration: "underline" }}
									>
										ver regras
									</Link>,
								]
							: [],
					),
				];
		const items = [
			...base,
			...(coupon
				? [
						benefit("cupom", "cupom", coupon.text, coupon.detail ?? "", [
							<Text
								key="codigo"
								color={OFFWHITE}
								style={{
									fontSize: "11px",
									lineHeight: "16.5px",
									fontWeight: 600,
									letterSpacing: "10px",
									textTransform: "uppercase",
									padding: "6px 5px 6px 15px",
									border: `1px dashed ${GOLD}`,
									borderRadius: "50px",
									margin: 0,
								}}
							>
								{coupon.code}
							</Text>,
						]),
					]
				: []),
		];
		const benefits = items.flatMap((item, i) => (i ? [separator(`separador-${i}`), item] : [item]));

		const credit = (key: string, label: string, href: string) => (
			<Link
				key={key}
				href={href}
				target="_blank"
				variant="link"
				style={{ color: OFFWHITE, fontSize: "13px", lineHeight: "16px", fontWeight: 600, textDecoration: "underline" }}
			>
				{label}
			</Link>
		);

		// medidas do Figma (363:9230); no celular o tema (checkout.scss.tpl) reduz as margens e tira os separadores
		return (
			<Column key="rodape" gap={60} background={INDIGO} alignItems="center" style={{ width: "100%" }}>
				{[
					<Column key="conteudo" gap={20} alignItems="stretch" style={{ width: "100%", maxWidth: "1920px", padding: "60px 80px 0" }}>
						{[
							<Row
								key="beneficios"
								justifyContent="center"
								alignItems="center"
								style={{ minHeight: "120px", borderBottom: "1px solid rgba(255, 255, 255, 0.3)" }}
							>
								<Row
									key="lista"
									gap={66}
									justifyContent="center"
									alignItems="center"
									style={{ flexWrap: "wrap", width: "100%", maxWidth: "1600px", padding: "0 12px" }}
								>
									{benefits}
								</Row>
							</Row>,
							<Row
								key="legal"
								gap={24}
								justifyContent="space-between"
								alignItems="center"
								style={{ flexWrap: "wrap", minHeight: "69px", margin: "0 60px", borderTop: "1px solid rgba(255, 255, 255, 0.04)" }}
							>
								{[
									<Text key="texto" color={OFFWHITE} style={{ fontSize: "12px", lineHeight: "16px", whiteSpace: "pre-line", margin: 0 }}>
										{`${settings.companyInfo} | © Todos os direitos reservados - ${(state.store?.name ?? "CPAP FIT").toUpperCase()} - ${new Date().getFullYear()}`}
									</Text>,
									<Row key="creditos" gap={20} alignItems="center">
										{[credit("nuvemshop", "Nuvemshop", "https://www.nuvemshop.com.br"), credit("quick", "Quick Digital", "https://quickdigital.com.br")]}
									</Row>,
								]}
							</Row>,
						]}
					</Column>,
					<Box
						key="degrade"
						style={{ width: "100%", height: "10px", background: "linear-gradient(90deg, #2F3295 0%, #2091B7 50.481%, #23B9A3 100%)" }}
					/>,
				]}
			</Column>
		);
	},
};
