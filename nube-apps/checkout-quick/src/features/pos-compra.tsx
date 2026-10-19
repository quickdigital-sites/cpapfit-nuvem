/**
 * Página de pedido confirmado, logo abaixo do número do pedido.
 * A Nuvemshop envia as atualizações do pedido por e-mail — é o que a mensagem promete.
 */
import { Column, Link, Text } from "@tiendanube/nube-sdk-jsx";
import { CREAM, INDIGO, INK } from "../brand";
import { whatsappUrl } from "../checkout";
import type { Feature } from "./types";

export const posCompra: Feature = {
	name: "pos-compra",
	slot: "after_order_number",
	steps: ["success"],
	render(_state, settings) {
		return (
			<Column key="pos-compra" gap={6} padding={16} borderRadius={10} background={CREAM} style={{ marginTop: "12px" }}>
				{[
					<Text key="titulo" color={INDIGO} style={{ fontWeight: 800, fontSize: "16px", margin: 0 }}>
						Pedido confirmado!
					</Text>,
					<Text key="proximos" color={INK} style={{ fontSize: "14px", margin: 0 }}>
						Cada atualização do seu pedido chega no seu e-mail.
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
