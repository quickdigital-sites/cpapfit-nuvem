/**
 * Página de acompanhamento do pedido, logo abaixo do número do pedido.
 * A Nuvemshop envia as atualizações do pedido por e-mail — é o que a mensagem promete.
 * O título segue o estado: pago/autorizado = "Pedido confirmado!"; boleto/Pix ainda em aberto =
 * "Pedido recebido!"; pedido cancelado = nada (a Nuvemshop já mostra "Pedido cancelado").
 */
import { Column, Link, Text } from "@tiendanube/nube-sdk-jsx";
import { CREAM, INDIGO, INK } from "../brand";
import { whatsappUrl } from "../checkout";
import type { NubeSDKState } from "@tiendanube/nube-sdk-types";
import type { Feature } from "./types";

const PAGO = ["paid", "authorized"];

/** null = pedido cancelado (não mostra nada). */
export function posCompraTexto(state: Readonly<NubeSDKState>): { titulo: string; proximos: string } | null {
	if (state.order?.status === "cancelled") return null;
	const status = state.payment?.status ?? null;
	if (status && PAGO.includes(status)) {
		return { titulo: "Pedido confirmado!", proximos: "Cada atualização do seu pedido chega no seu e-mail." };
	}
	return {
		titulo: "Pedido recebido!",
		proximos: "Assim que o pagamento for aprovado, a confirmação chega no seu e-mail.",
	};
}

export const posCompra: Feature = {
	name: "pos-compra",
	slot: "after_order_number",
	steps: ["success"],
	render(state, settings) {
		const texto = posCompraTexto(state);
		if (!texto) return null;
		return (
			<Column key="pos-compra" gap={6} padding={16} borderRadius={10} background={CREAM} style={{ marginTop: "12px" }}>
				{[
					<Text key="titulo" color={INDIGO} style={{ fontWeight: 800, fontSize: "16px", margin: 0 }}>
						{texto.titulo}
					</Text>,
					<Text key="proximos" color={INK} style={{ fontSize: "14px", margin: 0 }}>
						{texto.proximos}
					</Text>,
					...(settings.whatsapp
						? [
								<Link key="whatsapp" href={whatsappUrl(settings.whatsapp, "Oi! Tenho uma dúvida sobre o meu pedido.")} target="_blank" variant="link">
									Alguma dúvida? Chama no WhatsApp
								</Link>,
							]
						: []),
				]}
			</Column>
		);
	},
};
