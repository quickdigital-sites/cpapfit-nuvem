{#
  CPAP Fit: menus do rodapé (Atendimento / Institucional / Serviços — Figma 24:806 / 24:948).
  Cada coluna tem um título e, se quiser, um menu do admin (Loja online › Menus). Com menu escolhido,
  os links vêm do admin; sem menu, ficam os links padrão abaixo (os mesmos de antes).
  <details>: acordeão no mobile; no desktop ficam sempre abertos (frontend/src/js/components/footer.js).
#}
{% set default_links = [
	[
		{ name: 'Política de Privacidade', url: '/politica-de-privacidade/' },
		{ name: 'Política de Entrega', url: '/politica-de-entrega/' },
		{ name: 'Fale Conosco', url: '/contato/' },
		{ name: 'Troca, Devolução, Garantia', url: '/trocas-e-devolucoes/' }
	],
	[
		{ name: 'BLOG', url: 'http://blog.cpapfit.com.br/' },
		{ name: 'Seja um representante!', url: 'https://materiais.cpapfit.com.br/seja-um-representante/' },
		{ name: 'Quem somos', url: '/quem-e-a-cpap-fit/' },
		{ name: 'Nossas lojas', url: '/nossas-lojas/' },
		{ name: 'Planos de assinatura', url: '/planos-de-assinatura/' }
	],
	[
		{ name: 'Vendas de equipamentos', url: '/produtos/' },
		{ name: 'Aluguel de CPAP e BIPAP', url: '/servicos/aluguel-de-equipamentos/' },
		{ name: 'Acompanhamento clínico', url: '/servicos/apoio-e-monitoramento-de-cpap1/' },
		{ name: 'Aluguel de ventiladores', url: '/servicos/aluguel-de-equipamentos/' }
	]
] %}

<div class="qd-footer-links" {{ block | block_attributes }}>
	{% for i in 1..3 %}
		{% set title = attribute(block.settings, 'title_' ~ i) %}
		{% set menu_id = attribute(block.settings, 'menu_' ~ i) %}
		{% set links = menu_id and menus[menu_id] ? menus[menu_id] : default_links[i - 1] %}
		{% if title and links %}
			<details class="qd-footer-menu" data-qd-footer-menu>
				<summary>{{ title }}</summary>
				<ul>
					{% for item in links %}
						<li><a href="{{ item.url }}"{% include 'snippets/qd-link-attrs.tpl' with { url: item.url } %}>{{ item.name }}</a></li>
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
