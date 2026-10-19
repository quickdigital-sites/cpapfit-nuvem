{# View All Button Block - Private to product-list section. Link autoderived from sibling products block. #}

{% set btn_settings = block.settings %}
{% set block_width = btn_settings.width | default('fit') %}
{% set btn_variant = btn_settings.variant | default('tertiary') %}

{% set btn_size = btn_settings.size %}
{% set btn_style = btn_variant == 'secondary' ? settings.button_secondary_style : (btn_variant == 'tertiary' ? settings.button_tertiary_style : settings.button_primary_style) %}

{# Size classes mapping #}
{% set size_class = btn_size == 'small' ? 'btn-small' : (btn_size == 'medium' ? 'btn-medium' : 'btn-big') %}

{# Resolve custom color overrides based on variant #}
{% if btn_variant == 'secondary' %}
	{% set custom_background = btn_settings.custom_background_color_secondary %}
	{% set custom_foreground = btn_settings.custom_text_color_secondary %}
{% elseif btn_variant == 'tertiary' %}
	{% set custom_background = btn_settings.custom_background_color_tertiary %}
	{% set custom_foreground = btn_settings.custom_text_color_tertiary %}
{% else %}
	{% set custom_background = btn_settings.custom_background_color %}
	{% set custom_foreground = btn_settings.custom_text_color %}
{% endif %}

{# Build inline styles - button color overrides #}
{% set btn_styles %}
	{% if block_width == 'fill' %}text-align: center;{% endif %}
	{% if custom_background and btn_style != 'underlined' %}background-color: {{ custom_background }};{% endif %}
	{% if custom_foreground %}color: {{ custom_foreground }};{% endif %}
	{% if custom_foreground and btn_style == 'outline' %}border-color: {{ custom_foreground }};{% endif %}
{% endset %}

{% if btn_settings.label and view_all_url %}
	<a
		href="{{ view_all_url }}"
		class="btn btn-{{ btn_variant }} {{ size_class }} {% if btn_style == 'underlined' %}btn-underlined{% endif %} {% if block_width == 'fill' %}block-fill{% endif %}"
		{{ block | block_attributes }}
		data-store="view-all-button-{{ block.id }}"
		{% if btn_styles | trim %}style="{{ btn_styles | trim }}"{% endif %}
	>
		{{ btn_settings.label }}
	</a>
{% endif %}

{% schema %}
{
  "name": "Botão \"Ver todos\"",
  "icon": "buttons",
  "limit": 1,
  "duplicatable": false,
  "visible_if": "{{ section.blocks.products.settings.products_source.kind == 'category' }}",
  "settings": [
    {
      "type": "setting",
      "setting_type": "text",
      "id": "label",
      "label": "Texto do botão",
      "default": "t:defaults.view_all_button",
      "info": "Leva para a categoria escolhida em \"Quais produtos mostrar\". Vazio: usa \"Ver todos\"."
    }
  ]
}
{% endschema %}
