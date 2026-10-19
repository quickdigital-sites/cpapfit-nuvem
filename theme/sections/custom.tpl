{# Custom Section - Open container for composing any general blocks. Layout controls mirror group.tpl. #}

{% set section_settings = section.settings %}
{% set full_width = section_settings.section_width == 'full' %}
{% set page_width = section_settings.section_width == 'page' %}

{% set gap = section_settings.gap | default(16) %}
{% set vertical_padding = section_settings.vertical_padding | default(0) %}
{% set horizontal_padding = full_width ? section_settings.horizontal_padding | default(0) : 0 %}

{% set custom_color_style = '' %}
{% if section_settings.custom_background_color %}
	{% set custom_color_style = custom_color_style ~ 'background-color: ' ~ section_settings.custom_background_color ~ ';' %}
{% endif %}
{% if section_settings.custom_text_color %}
	{% set custom_color_style = custom_color_style ~ 'color: ' ~ section_settings.custom_text_color ~ ';' %}
{% endif %}

{# Direction classes #}
{% set mobile_direction = section_settings.mobile_direction_enabled ? section_settings.mobile_direction : section_settings.direction %}
{% if section_settings.mobile_direction_enabled and mobile_direction != section_settings.direction %}
	{% if section_settings.direction == 'row' %}
		{% set direction_class = 'flex-column flex-md-row flex-wrap' %}
	{% else %}
		{% set direction_class = 'flex-row flex-wrap flex-md-column' %}
	{% endif %}
{% else %}
	{% set direction_class = section_settings.direction == 'row' ? 'flex-row flex-wrap' : 'flex-column' %}
{% endif %}

{# Map alignment intent to the right flex axis per direction. Add `-md-` overrides when desktop direction differs from mobile. #}
{% set horizontal_align = section_settings.alignment == 'center' ? 'center' : (section_settings.alignment == 'end' ? 'end' : 'start') %}
{% set vertical_align = (section_settings.alignment_vertical | default('center')) == 'center' ? 'center' : (section_settings.alignment_vertical == 'bottom' ? 'end' : 'start') %}
{% set text_align = section_settings.alignment == 'center' ? 'center' : (section_settings.alignment == 'end' ? 'right' : 'left') %}

{% set horizontal_axis = { 'row': 'justify-content', 'column': 'align-items' } %}
{% set vertical_axis = { 'row': 'align-items', 'column': 'justify-content' } %}

{% set align_class = horizontal_axis[mobile_direction] ~ '-' ~ horizontal_align %}
{% set vertical_align_class = vertical_axis[mobile_direction] ~ '-' ~ vertical_align %}
{% if section_settings.direction != mobile_direction %}
	{% set align_class = align_class ~ ' ' ~ horizontal_axis[section_settings.direction] ~ '-md-' ~ horizontal_align %}
	{% set vertical_align_class = vertical_align_class ~ ' ' ~ vertical_axis[section_settings.direction] ~ '-md-' ~ vertical_align %}
{% endif %}

{% set section_styles %}
	{% if vertical_padding %}padding-top: {{ vertical_padding }}px; padding-bottom: {{ vertical_padding }}px;{% endif %}
	{% if horizontal_padding %}padding-left: {{ horizontal_padding }}px; padding-right: {{ horizontal_padding }}px;{% endif %}
	{{ custom_color_style }}
{% endset %}

<div
	class="section-custom {% if full_width %}section-full-width{% endif %}"
	data-section-id="{{ section.id }}"
	{% if section_styles | trim %}style="{{ section_styles | trim }}"{% endif %}
>
	{% if page_width %}
		<div class="container">
	{% endif %}
			{% if section_settings.direction == 'row' %}
				{% set content_class = mobile_direction == 'row' ? 'group-content-horizontal' : 'group-content-horizontal-md' %}
			{% elseif mobile_direction == 'row' %}
				{% set content_class = 'group-content-horizontal-md ' ~ direction_class %}
			{% else %}
				{% set content_class = 'd-flex ' ~ direction_class %}
			{% endif %}
			<div class="custom-section-content {{ content_class }} {{ align_class }} {{ vertical_align_class }}" style="gap: {{ gap }}px; text-align: {{ text_align }};">
				{% for block in section.blocks %}
					{% if block and block.type is defined %}
						{% include 'blocks/' ~ block.type ~ '.tpl' with { block: block } %}
					{% endif %}
				{% endfor %}
			</div>
	{% if page_width %}
		</div>
	{% endif %}
</div>

{% schema %}
{
  "name": "Bloco montado pela agência",
  "icon": "LayoutIcon",
  "class": "section section-custom-container",
  "blocks": [
    {
      "tags": [
        "general"
      ]
    }
  ],
  "settings": [
    {
      "type": "paragraph",
      "content": "Seção com conteúdo próprio. Textos e imagens ficam nos blocos abaixo."
    }
  ],
  "presets": [
    {
      "name": "t:names.custom",
      "category": "t:categories.layout",
      "blocks": [
        {
          "type": "group",
          "settings": {
            "gap": 8,
            "vertical_padding": 0,
            "horizontal_padding": 0
          },
          "blocks": [
            {
              "type": "heading",
              "settings": {
                "title": "t:defaults.heading",
                "size": "h4"
              }
            },
            {
              "type": "text",
              "settings": {
                "text": "t:defaults.text"
              }
            }
          ]
        },
        {
          "type": "button"
        }
      ]
    }
  ]
}
{% endschema %}
