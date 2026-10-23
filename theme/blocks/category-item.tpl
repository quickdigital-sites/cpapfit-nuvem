{# Category Item Block - Individual category in featured categories section #}

{% set item_text = block.settings.text | default('') %}
{% set item_link = block.settings.link %}
{% set item_image = block.settings.image %}

<div class="category-item" {{ block | block_attributes }}>
	{% if item_link %}
		<a href="{{ item_link }}"{% include 'snippets/qd-link-attrs.tpl' with { url: item_link } %} class="category-item-link">
	{% else %}
		<span class="category-item-link">
	{% endif %}

	{% if is_image_thumbnail %}
		<div class="category-item-image">
			{% if item_image %}
				{% set image_alt = item_image | media_alt | default('accessibility.category_image' | t) %}
				{% include 'snippets/image.tpl' with {
					image_src: item_image,
					image_alt: image_alt,
					image_classes: 'fade-in',
					image_lazy_js: true,
					image_width: image_size,
				} %}
			{% else %}
				{% set placeholder_num = ((category_index | default(0)) % 15) + 1 %}
				{% include 'snippets/image.tpl' with {
					image_src: ('images/placeholders/categories/category-' ~ placeholder_num ~ '.webp') | static_url,
					image_alt: 'accessibility.category_image' | t,
					image_classes: 'fade-in',
					image_lazy_js: true,
					image_width: image_size,
				} %}
			{% endif %}
		</div>
	{% endif %}

	{% if item_text %}
		<span class="category-item-text text-{{ items_text_alignment | default('left') }}">{{ item_text | raw }}</span>
	{% endif %}

	{% if item_link %}
		</a>
	{% else %}
		</span>
	{% endif %}
</div>

{% schema %}
{
  "name": "Categoria",
  "icon": "link",
  "settings": [
    {
      "type": "setting",
      "setting_type": "image_picker",
      "id": "image",
      "label": "Imagem",
      "info": "Quadrada, 400 × 400 px, JPG, WebP ou PNG. Categorias e serviços: foto do produto em fundo branco. Marcas: logo em PNG com fundo transparente. A imagem é recortada em círculo."
    },
    {
      "type": "setting",
      "setting_type": "richtext",
      "id": "text",
      "label": "Nome",
      "info": "Texto abaixo da imagem. Curto, ex.: Máscaras."
    },
    {
      "type": "setting",
      "setting_type": "url",
      "id": "link",
      "label": "Link",
      "info": "Página aberta ao clicar. Use o endereço da loja, ex.: /mascaras/ ou /produtos/?brand=Resmed."
    }
  ]
}
{% endschema %}
