{# Products Block - Private block for product-list section #}

{% set format = block.settings.format %}
{% set format_mobile = block.settings.use_different_mobile_format ? block.settings.format_mobile : format %}
{% set columns = block.settings.columns %}
{% set columns_mobile = block.settings.columns_mobile %}

{% set products = block.settings.products_source.products %}
{% set has_block_products = products and (products | length) > 0 %}

{# Placeholder products
   Used in preview (Brand Editor) or when the store has zero
   products, to keep the layout populated. Downstream guards
   on `is_placeholder` live in item.tpl and item-image.tpl. #}
{% if is_preset_preview or (not has_block_products and (is_preview or not has_products)) %}
	{% set products = [] %}
	{% for i in 1..block.settings.max_products %}
		{% set placeholder_num = ((i - 1) % 8) + 1 %}
		{% set products = products | merge([{
			'is_placeholder': true,
			'id': 'placeholder-' ~ i,
			'name': 'product_item.example_name' | t,
			'url': '#',
			'display_price': true,
			'price': 100000,
			'has_stock': true,
			'stock': 1,
			'placeholder_image_url': ('images/placeholders/products/product-' ~ placeholder_num ~ '.webp') | static_url,
			'featured_image': { 'dimensions': { 'width': 440, 'height': 600 }, 'alt': 'product_item.example_name' | t }
		}]) %}
	{% endfor %}
	{% set has_block_products = true %}
{% endif %}

{% set grid_mobile_class = 'grid-' ~ (columns_mobile | default('2')) %}
{% set grid_desktop_class = 'grid-md-' ~ (columns | default('4')) %}

{# Single DOM: slider + grid via responsive flexbox classes #}
{% set use_slider = format_mobile == 'slider' or format == 'slider' %}
{% set slider_both = format_mobile == 'slider' and format == 'slider' %}
{% set slider_mobile_only = format_mobile == 'slider' and format == 'grid' %}
{% set slider_desktop_only = format == 'slider' and format_mobile == 'grid' %}

{% set section_slider_classes =
	slider_both ? 'js-swiper-products-slider swiper-products-slider flex-nowrap' :
	slider_mobile_only ? 'js-swiper-products-slider swiper-mobile-only flex-nowrap flex-md-wrap' :
	slider_desktop_only ? 'js-swiper-products-slider swiper-desktop-only flex-wrap flex-md-nowrap'
%}

{% if slider_mobile_only %}
	{% set section_arrows_visibility_classes = 'd-none' %}
{% endif %}
{% set section_pagination_visibility_classes = slider_both ? '' : slider_mobile_only ? 'd-block d-md-none' : slider_desktop_only ? 'd-none d-md-block' %}

{% if has_block_products %}
	<div class="js-products-list-slider-container products-list-slider" {{ block | block_attributes }}>
		{% if use_slider %}
			<div class="js-products-list-swiper swiper-container">
		{% endif %}
				<div class="{% if use_slider %}swiper-wrapper {{ section_slider_classes }}{% endif %} {% if not slider_both %}grid {{ grid_desktop_class }}{% endif %} {% if format_mobile == 'grid' %}{{ grid_mobile_class }}{% endif %}"
					data-desktop-columns="{{ columns }}"
					data-mobile-columns="{{ columns_mobile }}"
					data-desktop-format="{{ format }}"
					data-mobile-format="{{ format_mobile }}">
					{% for product in products %}
						{% include 'snippets/product-list/product-item/item.tpl' with {
							'slide_item': use_slider,
							'section_name': section.id,
							'image_priority_high': is_priority and loop.index in [1, 2],
						} %}
					{% endfor %}
				</div>
		{% if use_slider %}
				<div class="js-swiper-products-list-pagination swiper-pagination swiper-pagination-bullets swiper-pagination-outside w-100 {{ section_pagination_visibility_classes }}"></div>
			</div>
			<button type="button" class="js-swiper-products-list-prev swiper-button-prev swiper-button-outside {{ section_arrows_visibility_classes }}" aria-label="{{ 'general.previous' | t }}">
				<svg class="slider-arrow slider-arrow-prev icon-inline"><use xlink:href="#arrow-long"/></svg>
			</button>
			<button type="button" class="js-swiper-products-list-next swiper-button-next swiper-button-outside {{ section_arrows_visibility_classes }}" aria-label="{{ 'general.next' | t }}">
				<svg class="slider-arrow icon-inline"><use xlink:href="#arrow-long"/></svg>
			</button>
		{% endif %}
	</div>
{% endif %}

{% schema %}
{
  "name": "Produtos",
  "icon": "ListIcon",
  "deletable": false,
  "limit": 1,
  "settings": [
    {
      "type": "setting",
      "setting_type": "product_list",
      "id": "products_source",
      "label": "Quais produtos mostrar",
      "default": {
        "kind": "collection",
        "id": "primary"
      },
      "info": "Escolha uma categoria (ex.: Máscaras) ou uma lista da loja (ex.: Produtos em destaque, marcados no cadastro do produto)."
    },
    {
      "type": "setting",
      "setting_type": "range",
      "id": "max_products",
      "label": "Quantos produtos",
      "min": 1,
      "max": 20,
      "step": 1,
      "default": 12,
      "info": "Até quantos produtos aparecem na fileira."
    }
  ]
}
{% endschema %}
