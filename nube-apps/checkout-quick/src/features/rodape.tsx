/**
 * Rodapé da marca no fim do checkout (Figma 367:13649, faixa azul do rodapé): benefícios da loja,
 * cupom (se configurado), ajuda para quem travou e o rodapé legal.
 *
 * Os benefícios repetem o que a loja já anuncia no site; Pix com desconto fica de fora por padrão
 * porque o desconto Pix não está configurado nos meios de pagamento. Tudo é configurável:
 * `footer_benefits`, `coupon_text` + `coupon_code`, `whatsapp`, `company_info`.
 * O botão "Copiar" do site não existe aqui: o app roda num Web Worker, sem acesso à área de transferência.
 */
import { Column, Icon, Link, Row, Text } from "@tiendanube/nube-sdk-jsx";
import type { NubeComponent } from "@tiendanube/nube-sdk-types";
import { GOLD, INDIGO, OFFWHITE } from "../brand";
import { storeUrl, whatsappUrl } from "../checkout";
import type { Feature } from "./types";

type IconName = "credit-card" | "truck" | "tag" | "lock";

function benefit(key: string, icon: IconName | null, text: string, extra: NubeComponent[] = []) {
	return (
		<Row key={key} gap={12} alignItems="center" style={{ flexWrap: "wrap" }}>
			{[
				...(icon ? [<Icon key="icone" name={icon} size={20} color={OFFWHITE} />] : []),
				<Text key="texto" color={OFFWHITE} style={{ fontSize: "13px", fontWeight: 700, textTransform: "uppercase", margin: 0 }}>
					{text}
				</Text>,
				...extra,
			]}
		</Row>
	);
}

export const rodape: Feature = {
	name: "rodape",
	slot: "after_main_content",
	steps: ["start", "payment"],
	render(state, settings) {
		const contact = storeUrl(state, "/contato/");
		const rules = storeUrl(state, "/politica-de-entrega/");

		const benefits = settings.footerBenefits
			? settings.footerBenefits.map((text, i) => benefit(`beneficio-${i}`, null, text))
			: [
					benefit("parcelamento", "credit-card", "12x sem juros no cartão de crédito"),
					benefit(
						"frete",
						"truck",
						"Frete grátis",
						rules
							? [
									<Link key="regras" href={rules} variant="link" style={{ color: OFFWHITE, fontSize: "11px", textTransform: "uppercase" }}>
										ver regras
									</Link>,
								]
							: [],
					),
				];
		const coupon = settings.coupon
			? [
					benefit("cupom", "tag", settings.coupon.text, [
						<Text
							key="codigo"
							color={OFFWHITE}
							style={{ fontSize: "11px", fontWeight: 600, letterSpacing: "4px", textTransform: "uppercase", padding: "5px 12px", border: `1px dashed ${OFFWHITE}`, borderRadius: "50px", margin: 0 }}
						>
							{settings.coupon.code}
						</Text>,
					]),
				]
			: [];

		const links = [
			...(contact
				? [
						<Link key="contato" href={contact} variant="link" style={{ color: OFFWHITE, fontWeight: 700 }}>
							Fale com a gente
						</Link>,
					]
				: []),
			...(settings.whatsapp
				? [
						<Link
							key="whatsapp"
							href={whatsappUrl(settings.whatsapp, "Oi! Preciso de ajuda para finalizar minha compra.")}
							target="_blank"
							variant="link"
							style={{ color: OFFWHITE, fontWeight: 700 }}
						>
							Chamar no WhatsApp
						</Link>,
					]
				: []),
		];

		return (
			<Column key="rodape" gap={24} background={INDIGO} alignItems="stretch" style={{ width: "100%", marginTop: "40px", padding: "32px 24px" }}>
				{[
					<Row key="beneficios" gap={32} justifyContent="center" alignItems="center" style={{ flexWrap: "wrap" }}>
						{[...benefits, ...coupon]}
					</Row>,
					<Column key="ajuda" gap={8} alignItems="center" style={{ paddingTop: "20px", borderTop: "1px solid rgba(255, 255, 255, 0.16)", textAlign: "center" }}>
						{[
							<Text key="texto" color={OFFWHITE} style={{ fontSize: "14px", margin: 0 }}>
								Travou em alguma etapa? A gente resolve rápido.
							</Text>,
							...(links.length ? [<Row key="links" gap={24} justifyContent="center" style={{ flexWrap: "wrap" }}>{links}</Row>] : []),
						]}
					</Column>,
					<Row key="legal" gap={8} justifyContent="center" alignItems="center" style={{ flexWrap: "wrap", textAlign: "center" }}>
						{[
							<Icon key="cadeado" name="lock" size={16} color={GOLD} />,
							<Text key="texto" color={OFFWHITE} style={{ fontSize: "11px", opacity: 0.85, margin: 0 }}>
								{`${settings.companyInfo} · © ${state.store?.name ?? "CPAP FIT"} - ${new Date().getFullYear()}`}
							</Text>,
						]}
					</Row>,
				]}
			</Column>
		);
	},
};
