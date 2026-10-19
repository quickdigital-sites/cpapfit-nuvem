{# Nav Icon Text Group Block — group of icon-text items for the navigation bar #}

{% set alignment = block.settings.alignment | default('center') %}
{% set justify_class = alignment == 'center' ? 'justify-content-center' : (alignment == 'right' ? 'justify-content-end' : 'justify-content-start') %}
{% set block_gap = block.settings.gap | default(16) %}
{% set item_count = block.blocks | length %}
{% set has_items = item_count > 0 %}
{% set is_mobile_menu = type == 'mobile_menu' %}

{% if has_items %}
	{% if is_mobile_menu %}
		<ul class="list-unstyled">
			{% for child_block in block.blocks %}
				{% if child_block and child_block.type == 'nav-icon-text-item' %}
					{% include 'blocks/nav-icon-text-item.tpl' with { block: child_block, type: 'mobile_menu' } %}
				{% endif %}
			{% endfor %}
		</ul>
	{% else %}
		<div class="navigation-bar-block {{ justify_class }}" style="gap: {{ block_gap }}px" {{ block | block_attributes }}>
			{% for child_block in block.blocks %}
				{% if child_block and child_block.type == 'nav-icon-text-item' %}
					{% include 'blocks/nav-icon-text-item.tpl' with { block: child_block } %}
				{% endif %}
			{% endfor %}
		</div>
	{% endif %}
{% endif %}

{% schema %}
{
  "name": "Ícones com texto",
  "icon": "FolderIcon",
  "blocks": [
    {
      "type": "nav-icon-text-item",
      "limit": 4
    }
  ],
  "settings": [
    {
      "type": "paragraph",
      "content": "Cada benefício é um item abaixo. Até 4 cabem numa linha no computador; no celular aparece um por vez."
    }
  ],
  "presets": [
    {
      "name": "t:names.navbar_icons",
      "settings": {
        "alignment": "center",
        "gap": 16
      },
      "blocks": [
        {
          "type": "nav-icon-text-item",
          "settings": {
            "icon_source": "design",
            "icon": "shipping",
            "description": "t:defaults.icon_text.item_1_description"
          }
        },
        {
          "type": "nav-icon-text-item",
          "settings": {
            "icon_source": "design",
            "icon": "card",
            "description": "t:defaults.icon_text.item_2_description"
          }
        }
      ]
    }
  ]
}
{% endschema %}
