{# CPAP Fit — Nossas lojas (Figma 271:6244 / 271:6399): cards das lojas físicas, um bloco "Loja" por loja.
   Só aparece na página /nossas-lojas/ (institucional.css); institucional.js move a lista para a coluna de
   conteúdo e monta o filtro por estado a partir do campo "Estado" de cada loja. #}
<div class="qd-stores" data-qd-stores>
	<div class="qd-stores-filters" role="group" aria-label="Filtrar lojas por estado" data-qd-stores-filters></div>
	<div class="qd-stores-grid">
		{% for block in section.blocks %}
			{% include 'blocks/' ~ block.type ~ '.tpl' with { block: block } %}
		{% endfor %}
	</div>
</div>

{% schema %}
{
  "name": "Lojas físicas",
  "icon": "StoreIcon",
  "class": "section section-qd-stores",
  "enabled_on": { "page_templates": ["page"] },
  "blocks": [ { "type": "qd-store" } ],
  "settings": [
    { "type": "paragraph", "content": "Cards das lojas físicas na página Nossas lojas. Cada loja é um bloco \"Loja\": use \"Adicionar bloco\" para incluir outra." }
  ],
  "presets": [ { "name": "Lojas físicas", "blocks": [ { "type": "qd-store" } ] } ]
}
{% endschema %}
