{# Code Block - Raw HTML/JS/CSS injection. Only addable inside the Custom section. #}

{% set code = block.settings.code %}
{% set block_width = block.settings.width | default('fill') %}

{% if code %}
	<div class="code-block {% if block_width == 'fill' %}block-fill{% endif %}" {{ block | block_attributes }} data-store="code-block-{{ block.id }}">
		{{ code | raw }}
	</div>
{% endif %}

{% schema %}
{
  "name": "Conteúdo feito pela agência",
  "icon": "CodeIcon",
  "tags": [
    "general"
  ],
  "settings": [
    {
      "type": "paragraph",
      "content": "Código da página. Não altere: peça mudanças à agência."
    },
    {
      "type": "setting",
      "setting_type": "custom_code",
      "id": "code",
      "label": "Código (não altere)",
      "info": "Alterar este campo pode quebrar a seção."
    }
  ]
}
{% endschema %}
