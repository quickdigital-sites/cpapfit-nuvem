{# Footer Section - Composable blocks: institutional, menus, newsletter #}

{% set full_width = section.settings.section_width == 'full' %}
{% set page_width = section.settings.section_width == 'page' %}
{% set vertical_padding = section.settings.vertical_padding %}
{% set horizontal_padding = full_width ? section.settings.horizontal_padding : 0 %}
{% set background_color = section.settings.background_color %}
{% set text_color = section.settings.text_color %}
{% set password_page = template == 'password' %}

{# Footer color styles using CSS custom properties for opacity variants #}
{% set footer_styles %}
	{% if vertical_padding %}padding-top: {{ vertical_padding }}px; padding-bottom: {{ vertical_padding }}px;{% endif %}
	{% if horizontal_padding %}padding-left: {{ horizontal_padding }}px; padding-right: {{ horizontal_padding }}px;{% endif %}
	{% if background_color %}--footer-background: {{ background_color }}; background-color: {{ background_color }};{% endif %}
	{% if text_color %}--footer-foreground: {{ text_color }}; color: {{ text_color }}; --footer-foreground-opacity-10: {{ text_color }}1A; --footer-foreground-opacity-20: {{ text_color }}33; --footer-foreground-opacity-40: {{ text_color }}66; --footer-foreground-opacity-60: {{ text_color }}99;{% endif %}
{% endset %}

{# Count blocks for grid layout #}
{% set menu_block_count = 0 %}
{% for block in section.blocks %}
	{% if block.type == 'footer-menu' %}
		{% set menu_block_count = menu_block_count + 1 %}
	{% endif %}
{% endfor %}
{% set has_menus = menu_block_count > 0 %}

{# Check for institutional block #}
{% set has_institutional = false %}
{% for block in section.blocks %}
	{% if block.type == 'footer-institutional' %}
		{% set has_institutional = true %}
	{% endif %}
{% endfor %}

{# Check for newsletter block #}
{% set has_newsletter = false %}
{% for block in section.blocks %}
	{% if block.type == 'footer-newsletter' %}
		{% set has_newsletter = true %}
	{% endif %}
{% endfor %}

{# Footer layout classes #}
{% set footer_main_toggle_classes = section.settings.menus_toggle ? 'footer-main-info-toggle' %}
{% set footer_mobile_toggle_title = has_menus and section.settings.menus_toggle %}
{{ component('nubesdk-slot', { type: "before_footer" }) }}

<div
	class="js-hide-footer-while-scrolling {% if full_width %}footer-content section-full-width{% endif %}"
	data-store="footer"
	data-section-id="{{ section.id }}"
	{% if footer_styles | trim %}style="{{ footer_styles | trim }}"{% endif %}
>
	{% if page_width %}
		<div class="footer-content container">
	{% endif %}
			{% if not password_page %}
				<div class="footer-main-info {{ footer_main_toggle_classes }}">
					{% for block in section.blocks %}
						{% include 'blocks/' ~ block.type ~ '.tpl' with { block: block } %}
					{% endfor %}
				</div>

				{% include 'snippets/footer/footer-country-selector.tpl' %}
			{% endif %}

			{# Secondary footer info (payments, shipping, legal) #}
			<div class="footer-secondary-info">
				{% include 'snippets/footer/footer-legal.tpl' with { password_page: password_page } %}
			</div>
	{% if page_width %}
		</div>
	{% endif %}
</div>

{{ component('nubesdk-slot', { type: "after_footer" }) }}

{% schema %}
{
  "name": "Rodapé",
  "icon": "FooterIcon",
  "wrapper": "footer",
  "class": "section-footer",
  "static": true,
  "limit": 1,
  "blocks": [
    {
      "type": "footer-menu",
      "limit": 3
    }
  ],
  "settings": [
    {
      "type": "setting",
      "setting_type": "toggle",
      "id": "footer_payments_show",
      "label": "Mostrar as formas de pagamento",
      "default": true
    },
    {
      "type": "setting",
      "setting_type": "toggle",
      "id": "footer_shipping_show",
      "label": "Mostrar as formas de envio",
      "default": true
    },
    {
      "type": "setting",
      "setting_type": "image_picker",
      "id": "footer_seal_img",
      "label": "Selo próprio (imagem)",
      "info": "Ex.: selo de site seguro. Recomendado: 200 × 80 px, PNG."
    },
    {
      "type": "setting",
      "setting_type": "url",
      "id": "footer_seal_url",
      "label": "Link do selo",
      "visible_if": "{{ section.settings.footer_seal_img }}"
    },
    {
      "type": "setting",
      "setting_type": "custom_code",
      "id": "footer_custom_seal_code",
      "label": "Código de selo de terceiros",
      "info": "Cole o código fornecido pela empresa do selo (ex.: Reclame Aqui)."
    }
  ],
  "default": {
    "blocks": [
      {
        "type": "footer-menu",
        "settings": {
          "title": "t:defaults.footer.menu_1_title",
          "menu": "navigation"
        }
      },
      {
        "type": "footer-menu",
        "settings": {
          "title": "t:defaults.footer.menu_2_title",
          "menu": "navigation"
        }
      }
    ]
  },
  "enabled_on": {
    "layout_templates": [
      "footer"
    ]
  }
}
{% endschema %}
