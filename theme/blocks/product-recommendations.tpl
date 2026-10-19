{# Product Recommendations Block #}
{% set columns = block.settings.columns | default('4') %}
{% set columns_mobile = block.settings.columns_mobile | default('2') %}

<div
	class="products-list-slider"
	{{ block | block_attributes }}
	data-columns-desktop="{{ columns }}"
	data-columns-mobile="{{ columns_mobile }}"
	data-store="product-recommendations-{{ block.id }}"
>
	{% include 'snippets/product-list/products-section.tpl' with {
		id: section_id,
		data_component: data_component,
		products_amount: section_products | length,
		products_array: section_products,
		product_template_path: 'snippets/product-list/product-item/item.tpl',
		product_template_params: {'slide_item': true},
		slider_controls_position: 'bottom',
		slider_pagination: true,
		section_classes: {
			section: js_class ~ ' position-relative',
			container: 'position-relative',
			slider_container: swiper_class ~ ' js-recommendations-swiper swiper-container',
			slider_wrapper: 'swiper-wrapper swiper-products-slider ' ~ (columns_mobile == '1' ? 'grid-1'),
			slider_control_pagination: swiper_class ~ '-pagination swiper-pagination swiper-pagination-bullets swiper-pagination-outside w-100',
			slider_control_prev_container: swiper_class ~ '-prev swiper-button-prev swiper-button-outside',
			slider_control_next_container: swiper_class ~ '-next swiper-button-next swiper-button-outside',
		},
	} %}
</div>

{% schema %}
{
  "name": "Produtos",
  "icon": "ListIcon",
  "limit": 1,
  "deletable": false,
  "settings": [
    {
      "type": "paragraph",
      "content": "Os produtos são escolhidos pela loja automaticamente."
    }
  ]
}
{% endschema %}
