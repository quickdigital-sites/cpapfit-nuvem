{#
  CPAP Fit: menus do rodapé (Atendimento / Institucional / Serviços — Figma 24:806 / 24:948).
  Cada coluna tem um título e, se quiser, um menu do admin (Loja online › Menus). Com menu escolhido,
  os links vêm do admin; sem menu, ficam os links padrão abaixo (os mesmos de antes).
  <details>: acordeão no mobile; no desktop ficam sempre abertos (frontend/src/js/components/footer.js).
#}
{# Serviços: os mesmos links do menu (Configurações do tema › Links de serviços; aluguel vazio = WhatsApp da loja) #}
{% set qd_link_acomp = settings.qd_link_acompanhamento | default('/acompanhamento-passos/') %}
{% set qd_link_aluguel = settings.qd_link_aluguel | default(store.whatsapp) | default('/servicos/aluguel-de-equipamentos/') %}
{% set default_links = [
	[
		{ name: 'Política de Privacidade', url: '/politica-de-privacidade/' },
		{ name: 'Política de Entrega', url: '/politica-de-entrega/' },
		{ name: 'Fale Conosco', url: '/contato/' },
		{ name: 'Troca, Devolução, Garantia', url: '/trocas-e-devolucoes/' }
	],
	[
		{ name: 'BLOG', url: 'https://blog.cpapfit.com.br/' },
		{ name: 'Seja um representante!', url: 'https://materiais.cpapfit.com.br/seja-um-representante/' },
		{ name: 'Quem somos', url: '/quem-e-a-cpap-fit/' },
		{ name: '', url: '', qd_passos: true },
		{ name: 'Nossas lojas', url: '/nossas-lojas/' },
		{ name: 'Planos de assinatura', url: '/planos-de-assinatura/' }
	],
	[
		{ name: 'Vendas de equipamentos', url: '/produtos/' },
		{ name: 'Aluguel de CPAP e BIPAP', url: qd_link_aluguel },
		{ name: 'Acompanhamento clínico', url: qd_link_acomp },
		{ name: 'Aluguel de ventiladores', url: qd_link_aluguel }
	]
] %}

{# Link "Programa PASSOS" (campos da Coluna 2): entra depois de "Quem somos" nos links padrão; com menu do admin, no fim da coluna #}
{% set passos_on = block.settings.qd_passos_enabled is not same as(false) %}
{% set passos_link = {
	name: block.settings.qd_passos_label | default('Programa PASSOS'),
	url: block.settings.qd_passos_url | default('https://acompanhamento.oxisaude.com.br/?utm_source=cpapfit&utm_campaign=passos&utm_medium=rodape')
} %}

<div class="qd-footer-links" {{ block | block_attributes }}>
	{% for i in 1..3 %}
		{% set title = attribute(block.settings, 'title_' ~ i) %}
		{% set menu_id = attribute(block.settings, 'menu_' ~ i) %}
		{% set from_menu = menu_id and menus[menu_id] %}
		{% set links = from_menu ? menus[menu_id] : default_links[i - 1] %}
		{% if i == 2 and from_menu and passos_on %}
			{% set links = links | merge([passos_link]) %}
		{% endif %}
		{% if title and links %}
			<details class="qd-footer-menu" data-qd-footer-menu>
				<summary>{{ title }}</summary>
				<ul>
					{% for item in links %}
						{% set link = item.qd_passos is defined and item.qd_passos ? (passos_on ? passos_link : null) : item %}
						{% if link %}
							<li><a href="{{ link.url }}"{% include 'snippets/qd-link-attrs.tpl' with { url: link.url } %}>{{ link.name }}</a></li>
						{% endif %}
					{% endfor %}
				</ul>
			</details>
		{% endif %}
	{% endfor %}
</div>

{% schema %}
{
  "name": "Menus do rodapé",
  "icon": "MenuIcon",
  "limit": 1,
  "settings": [
    {
      "type": "paragraph",
      "content": "Três colunas de links. Para mudar os links de uma coluna, crie um menu em Loja online › Menus e escolha-o aqui. Sem menu escolhido, a coluna mostra os links padrão. Links para outros sites abrem em nova aba."
    },
    {
      "type": "header",
      "content": "Coluna 1"
    },
    {
      "type": "setting",
      "setting_type": "text",
      "id": "title_1",
      "label": "Título",
      "info": "Vazio: a coluna some.",
      "default": "Atendimento"
    },
    {
      "type": "setting",
      "setting_type": "menu",
      "id": "menu_1",
      "label": "Menu com os links"
    },
    {
      "type": "header",
      "content": "Coluna 2"
    },
    {
      "type": "setting",
      "setting_type": "text",
      "id": "title_2",
      "label": "Título",
      "info": "Vazio: a coluna some.",
      "default": "Institucional"
    },
    {
      "type": "setting",
      "setting_type": "menu",
      "id": "menu_2",
      "label": "Menu com os links"
    },
    {
      "type": "setting",
      "setting_type": "toggle",
      "id": "qd_passos_enabled",
      "label": "Mostrar o link do Programa PASSOS",
      "info": "Fica depois de \"Quem somos\". Com um menu escolhido acima, entra no fim da coluna.",
      "default": true
    },
    {
      "type": "setting",
      "setting_type": "text",
      "id": "qd_passos_label",
      "label": "Texto do link PASSOS",
      "default": "Programa PASSOS",
      "visible_if": "{{ block.settings.qd_passos_enabled }}"
    },
    {
      "type": "setting",
      "setting_type": "url",
      "id": "qd_passos_url",
      "label": "Link PASSOS",
      "default": "https://acompanhamento.oxisaude.com.br/?utm_source=cpapfit&utm_campaign=passos&utm_medium=rodape",
      "visible_if": "{{ block.settings.qd_passos_enabled }}"
    },
    {
      "type": "header",
      "content": "Coluna 3"
    },
    {
      "type": "setting",
      "setting_type": "text",
      "id": "title_3",
      "label": "Título",
      "info": "Vazio: a coluna some.",
      "default": "Serviços"
    },
    {
      "type": "setting",
      "setting_type": "menu",
      "id": "menu_3",
      "label": "Menu com os links"
    }
  ],
  "disabled_on": {
    "templates": ["password"]
  }
}
{% endschema %}
