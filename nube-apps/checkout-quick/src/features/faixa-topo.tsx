/**
 * Linha logo abaixo do cabeçalho do checkout: "Ambiente 100% seguro" com cadeado (Figma 367:13762 —
 * no Figma fica à direita, dentro do cabeçalho; o cabeçalho é da Nuvemshop, então entra logo abaixo,
 * alinhado à direita). Textos próprios: configuração `top_bar_messages`.
 */
import { Column, Icon, Row, Text } from "@tiendanube/nube-sdk-jsx";
import { GOLD, INK, LINE, OFFWHITE } from "../brand";
import type { Feature } from "./types";

export const faixaTopo: Feature = {
	name: "faixa-topo",
	slot: "after_header",
	steps: ["start", "payment"],
	render(_state, settings) {
		const messages = settings.topBarMessages ?? ["Ambiente 100% seguro"];
		return (
			// alinhado à direita: Row não tem justify "end", então a coluna externa empurra a linha
			<Column key="faixa-topo" alignItems="end" background={OFFWHITE} style={{ width: "100%", padding: "10px 16px", borderBottom: `1px solid ${LINE}` }}>
			<Row key="mensagens" gap={24} alignItems="center" style={{ flexWrap: "wrap" }}>
				{messages.map((message, i) => (
					<Row key={`faixa-${i}`} gap={10} alignItems="center">
						{[
							<Text key="texto" color={INK} style={{ fontSize: "13px", fontWeight: 600, letterSpacing: "0.3px", textTransform: "uppercase", margin: 0 }}>
								{message}
							</Text>,
							...(i === 0 ? [<Icon key="cadeado" name="lock" size={24} color={GOLD} />] : []),
						]}
					</Row>
				))}
			</Row>
			</Column>
		);
	},
};
