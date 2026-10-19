{# Text Block - Public, can be used anywhere #}

{% set text_settings = block.settings %}
{% set block_width = text_settings.width | default('fill') %}
{% set text_size_class = text_settings.size == 'paragraph_small' ? 'font-small' : text_settings.size == 'paragraph_big' ? 'font-big' %}
{% set text_align_class = text_settings.text_alignment ? 'text-' ~ text_settings.text_alignment : '' %}

<div class="text-block {% if block_width == 'fill' %}block-fill{% endif %}" {{ block | block_attributes }} data-store="text-block-{{ block.id }}">
	{% if text_settings.text %}
		<div class="text-content user-content {{ text_size_class }} {{ text_align_class }}">
			{{ text_settings.text | raw }}
		</div>
	{% endif %}
</div>

{% schema %}
{
  "name": "Texto",
  "tags": [
    "general"
  ],
  "category": "basic",
  "icon": "AlignLeftIcon",
  "settings": [
    {
      "type": "setting",
      "setting_type": "richtext",
      "id": "text",
      "label": "Texto",
      "default": "t:defaults.text",
      "info": "Vazio: o texto não aparece."
    }
  ],
  "presets": [
    {
      "name": "t:names.text",
      "category": "t:categories.basic",
      "settings": {
        "text": "t:defaults.text"
      }
    }
  ]
}
{% endschema %}
