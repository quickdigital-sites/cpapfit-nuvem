{# Label Block - Public, can be used anywhere #}

{% set label_settings = block.settings %}
{% set label_variant = label_settings.variant | default('primary') %}

{# Resolve custom color overrides based on variant #}
{% if label_variant == 'secondary' %}
	{% set custom_background = label_settings.custom_background_color_secondary %}
	{% set custom_foreground = label_settings.custom_text_color_secondary %}
	{% set label_style = settings.label_shipping_style %}
{% else %}
	{% set custom_background = label_settings.custom_background_color %}
	{% set custom_foreground = label_settings.custom_text_color %}
	{% set label_style = settings.label_style %}
{% endif %}

{# Build inline styles - label color overrides #}
{% set label_styles %}
	{% if custom_background and label_style != 'outline' %}background-color: {{ custom_background }};{% endif %}
	{% if custom_foreground %}color: {{ custom_foreground }};{% endif %}
	{% if custom_foreground and label_style == 'outline' %}border-color: {{ custom_foreground }};{% endif %}
{% endset %}

{% if label_settings.text %}
	<span
		class="label-block label {% if label_variant == 'primary' %}label-primary{% else %}label-secondary{% endif %}"
		{{ block | block_attributes }}
		data-store="label-block-{{ block.id }}"
		{% if label_styles | trim %}style="{{ label_styles | trim }}"{% endif %}
	>
		{{ label_settings.text }}
	</span>
{% endif %}

{% schema %}
{
  "name": "Etiqueta",
  "tags": [
    "general"
  ],
  "category": "basic",
  "icon": "FlagIcon",
  "settings": [
    {
      "type": "setting",
      "setting_type": "text",
      "id": "text",
      "label": "Texto da etiqueta",
      "default": "t:defaults.label",
      "info": "No banner principal é o código do cupom (ex.: QUERO200). Vazio: não aparece."
    }
  ],
  "presets": [
    {
      "name": "t:names.label",
      "category": "t:categories.basic",
      "settings": {
        "text": "t:defaults.label"
      }
    }
  ]
}
{% endschema %}
