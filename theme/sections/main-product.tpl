{# Main Product Section - Product Detail Page #}

{% set full_width = section.settings.section_width == 'full' %}
{% set page_width = section.settings.section_width == 'page' %}
{% set vertical_padding = section.settings.vertical_padding %}
{% set horizontal_padding = full_width ? section.settings.horizontal_padding : 0 %}
{% set column_gap = section.settings.column_gap | default(24) %}
{% set background_color = section.settings.background_color %}
{% set section_styles %}
	{% if vertical_padding %}padding-top: {{ vertical_padding }}px; padding-bottom: {{ vertical_padding }}px;{% endif %}
	{% if horizontal_padding %}padding-left: {{ horizontal_padding }}px; padding-right: {{ horizontal_padding }}px;{% endif %}
	{% if background_color %}background-color: {{ background_color }};{% endif %}
{% endset %}


<section id="single-product" class="js-product-detail js-product-container js-has-new-shipping js-shipping-calculator-container {% if full_width %}section-full-width{% endif %}" data-variants="{{ product.variants_object | json_encode }}" data-section-id="{{ section.id }}" data-store="product-detail" data-qd-whatsapp="{{ store.whatsapp }}" data-qd-coupon-text="{{ settings.qd_pdp_coupon_text }}" data-qd-coupon-code="{{ settings.qd_pdp_coupon_code }}" {% if section_styles | trim %}style="{{ section_styles | trim }}"{% endif %}>
	{% if page_width %}
		<div class="container">
	{% endif %}
		<div class="product-columns" {% if column_gap %}style="column-gap: {{ column_gap }}px;"{% endif %}>
			{% for block in section.blocks %}
				{% if block.type == 'product-media' %}
					{% include 'blocks/product-media.tpl' with { block: block } %}
				{% elseif block.type == 'product-info' %}
					{% include 'blocks/product-info.tpl' with { block: block } %}
				{% endif %}
			{% endfor %}
		</div>
	{% if page_width %}
		</div>
	{% endif %}
</section>


{% schema %}
{
  "name": "Informações do produto",
  "icon": "TagIcon",
  "class": "section section-main-product section-margin",
  "limit": 1,
  "presets": [
    {
      "name": "t:names.product_info",
      "blocks": [
        {
          "type": "product-media"
        },
        {
          "type": "product-info"
        }
      ]
    }
  ],
  "deletable": false,
  "hideable": false,
  "locked_blocks": true,
  "settings": [
    {
      "type": "paragraph",
      "content": "Fotos, preço, compra e descrição. Os dados vêm de Produtos, no painel da loja."
    }
  ],
  "blocks": [
    {
      "type": "product-media",
      "static": true
    },
    {
      "type": "product-info",
      "static": true
    }
  ],
  "enabled_on": {
    "page_templates": [
      "product"
    ]
  }
}
{% endschema %}
