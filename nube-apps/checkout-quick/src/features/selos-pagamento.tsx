/**
 * Acima das formas de pagamento: segurança + condição de pagamento (configuração `payment_note`).
 * Não promete desconto nem prazo — só o que vale para qualquer compra na loja.
 */
import { Column, Icon, Row, Text } from "@tiendanube/nube-sdk-jsx";
import { CREAM, GOLD, INK, TEAL } from "../brand";
import type { Feature } from "./types";

export const selosPagamento: Feature = {
	name: "selos-pagamento",
	slot: "before_payment_options",
	steps: ["payment"],
	render(_state, settings) {
		return (
			<Column key="selos-pagamento" gap={6} padding={16} borderRadius={10} background={CREAM} style={{ marginBottom: "12px" }}>
				{[
					<Row key="titulo" gap={10} alignItems="center">
						{[
							<Icon key="cadeado" name="lock" size={24} color={GOLD} />,
							<Text key="texto" color={INK} style={{ fontWeight: 700, fontSize: "14px", margin: 0 }}>
								Pagamento rápido e protegido
							</Text>,
						]}
					</Row>,
					<Text key="seguranca" color={INK} style={{ fontSize: "13px", margin: 0 }}>
						Ambiente seguro, com seus dados enviados de forma criptografada. É só escolher como pagar e finalizar.
					</Text>,
					...(settings.paymentNote
						? [
								<Row key="condicao" gap={8} alignItems="center">
									{[
										<Icon key="cartao" name="credit-card" size={18} color={TEAL} />,
										<Text key="texto" color={TEAL} style={{ fontWeight: 700, fontSize: "13px", margin: 0 }}>
											{settings.paymentNote}
										</Text>,
									]}
								</Row>,
							]
						: []),
				]}
			</Column>
		);
	},
};
