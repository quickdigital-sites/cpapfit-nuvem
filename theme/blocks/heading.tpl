{# Heading Block - Public, can be used anywhere #}
{#
   SEO Note: This block always renders as <p> with visual heading classes.
   This prevents multiple H1 tags on a page. Real semantic headings (H1)
   should be defined in page templates (product, category, contact, etc.)
#}

{% set heading_settings = block.settings %}
{% set block_width = heading_settings.width | default('fill') %}
{% set heading_size = heading_settings.size %}
{% set heading_mobile = heading_settings.mobile_font_size %}
{% set is_custom = heading_size == 'custom' %}

{% set fill_class = block_width == 'fill' ? ' block-fill' %}

{% if is_custom %}
	{% set custom_font = heading_settings.custom_font | default(settings.font_headings) %}
	{% set custom_size = heading_settings.custom_font_size | default((settings.headings_size * 0.583) | round) %}
	{% set heading_style = '--block-font: ' ~ custom_font ~ '; --block-font-size: ' ~ custom_size ~ 'px;' %}
	{% if heading_mobile and heading_settings.custom_mobile_font_size %}
		{% set heading_style = heading_style ~ ' --block-mobile-font-size: ' ~ heading_settings.custom_mobile_font_size ~ 'px;' %}
	{% endif %}
	{% set heading_class = 'heading-block heading-custom' ~ fill_class %}
{% else %}
	{% set heading_class = 'heading-block ' ~ heading_size %}
	{% if heading_mobile %}
		{% set heading_class = heading_class ~ '-md ' ~ heading_settings.mobile_size %}
	{% endif %}
	{% set heading_class = heading_class ~ fill_class %}
{% endif %}

{% if heading_settings.title %}
	<div
		class="{{ heading_class }}"
		{{ block | block_attributes }}
		data-store="heading-block-{{ block.id }}"
		{% if heading_style %}style="{{ heading_style }}"{% endif %}
	>
		{{ heading_settings.title | raw }}
	</div>
{% endif %}

{% schema %}
{
  "name": "Título",
  "tags": [
    "general"
  ],
  "category": "basic",
  "icon": "TextSizeIcon",
  "settings": [
    {
      "type": "setting",
      "setting_type": "richtext",
      "id": "title",
      "label": "Texto do título",
      "default": "t:defaults.heading",
      "info": "Vazio: o título não aparece."
    }
  ],
  "presets": [
    {
      "name": "t:names.heading",
      "category": "t:categories.basic",
      "settings": {
        "title": "t:defaults.heading"
      }
    }
  ]
}
{% endschema %}
