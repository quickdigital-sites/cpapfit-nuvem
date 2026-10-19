{# Product List Section - Featured products with composable blocks #}

{% set full_width = section.settings.section_width == 'full' %}
{% set page_width = section.settings.section_width == 'page' %}
{% set alignment = section.settings.alignment %}
{% set align_items = alignment == 'center' ? 'center' : (alignment == 'right' ? 'flex-end' : 'flex-start') %}
{% set gap = section.settings.gap %}
{% set vertical_padding = section.settings.vertical_padding %}
{% set horizontal_padding = full_width ? section.settings.horizontal_padding : 0 %}
{% set background_color = section.settings.background_color %}

{# Resolve data-store: first section pointing to a legacy slot claims the legacy name #}
{% set products_block = null %}
{% for block in section.blocks %}
	{% if block.type == 'products' %}
		{% set products_block = block %}
	{% endif %}
{% endfor %}
{% set products_source = products_block ? products_block.settings.products_source : null %}
{% set has_block_products = products_source and products_source.products | length > 0 %}

{# Resolve view-all URL by looking up the selected category id in the global `categories` array. #}
{% set view_all_url = null %}
{% if products_source and products_source.kind == 'category' %}
	{% if products_source.id == '0' %}
		{% set view_all_url = store.products_url %}
	{% else %}
		{% set view_all_url = (categories | flatten_categories_by_id)[products_source.id].url ?? null %}
	{% endif %}
{% endif %}

{% set source_key = products_source and products_source.kind is defined ? products_source.kind ~ ':' ~ products_source.id : '' %}
{% set legacy_data_stores = {
	'collection:primary': 'home-products-featured',
	'collection:new': 'home-products-new',
	'collection:sale': 'home-products-sale'
} %}
{% set legacy_store_name = source_key ? attribute(legacy_data_stores, source_key) : null %}
{% if legacy_store_name and claim_legacy_data_store(legacy_store_name) %}
	{% set data_store_value = legacy_store_name %}
{% else %}
	{% set data_store_value = section.id %}
{% endif %}

{# Section styles #}
{% set section_styles %}
	{% if full_width %}--section-horizontal-padding: {{ horizontal_padding }}px;{% endif %}
	{% if vertical_padding %}padding-top: {{ vertical_padding }}px; padding-bottom: {{ vertical_padding }}px;{% endif %}
	{% if horizontal_padding %}padding-left: {{ horizontal_padding }}px; padding-right: {{ horizontal_padding }}px;{% endif %}
	{% if background_color %}background-color: {{ background_color }};{% endif %}
{% endset %}


{# CPAP Fit: na home, as abas escondidas dos Destaques (destaques_2..6) não são renderizadas — cada vitrine
   pesa ~190KB de HTML. Sai só um placeholder com a URL da categoria escolhida no Brand Editor (view_all_url);
   frontend/src/js/components/home-tabs.js busca essa página quando o visitante vai usar as abas e monta o
   carrossel com os primeiros cards. (Query string não serve: o cache da plataforma a ignora.)
   No Brand Editor (is_preview) renderiza tudo, para dar para editar. #}
{# CPAP Fit: "Nome da aba" (campo da seção) transforma esta vitrine numa aba dos Destaques da home.
   home-tabs.js monta os botões das abas a partir destes marcadores, na ordem da página. #}
{% set qd_tab_label = section.settings.tab_label | default('') | trim %}

{% set qd_lazy_tab = template == 'home' and not is_preview and view_all_url and qd_tab_label and section.id != 'destaques_1' %}

{% if template == 'home' and qd_tab_label %}
	<span hidden data-qd-tab-label="{{ qd_tab_label }}" data-qd-tab-for="{{ section.id }}" data-qd-tab-href="{{ view_all_url | default(store.products_url) }}"></span>
{% endif %}

{# Hide the section when theres nothing to show. Placeholders kick in for preview or when the store has zero active products at all. #}
{% if qd_lazy_tab %}
	<div class="qd-tab-lazy" data-qd-lazy-tab="{{ section.id }}" data-qd-source="{{ view_all_url }}" data-qd-max="{{ products_block.settings.max_products | default(8) }}"></div>
{% elseif has_block_products or is_preview or not has_products %}
	<div
		class="js-products-list-slider section-featured-home {% if full_width %}section-full-width{% endif %}"
		data-store="{{ data_store_value }}"
		data-section-id="{{ section.id }}"
		{% if section_styles | trim %}style="{{ section_styles | trim }}"{% endif %}
	>
		{% if page_width %}
			<div class="container">
		{% endif %}
				{# Pass LCP priority to every block when the section is above the fold; non-visual blocks (heading, text…) ignore it. #}
				{% set is_priority_section = section.index <= (template in ['home', 'product'] ? 1 : 2) %}
				<div class="d-flex flex-column text-{{ alignment }}" style="align-items: {{ align_items }};{% if gap %} gap: {{ gap }}px;{% endif %}">
					{% for block in section.blocks %}
						{% include 'blocks/' ~ block.type ~ '.tpl' with { block: block, is_priority: is_priority_section } %}
					{% endfor %}
				</div>
		{% if page_width %}
			</div>
		{% endif %}
	</div>
{% endif %}


{% schema %}
{
  "name": "Vitrine de produtos",
  "icon": "TagIcon",
  "add_section_order": 5,
  "class": "section section-product-list",
  "blocks": [
    {
      "tags": [
        "general"
      ]
    },
    {
      "type": "products",
      "limit": 1
    },
    {
      "type": "view-all-button",
      "limit": 1
    }
  ],
  "settings": [
    {
      "type": "paragraph",
      "content": "Fileira de produtos que passa para o lado. Escolha os produtos no bloco \"Produtos\"."
    },
    {
      "type": "setting",
      "setting_type": "text",
      "id": "tab_label",
      "label": "Nome da aba (só nos Destaques da página inicial)",
      "info": "Preenchido: esta vitrine vira uma aba de \"Destaques\", na ordem em que aparece na página. Ex.: Máscaras. Vazio: a vitrine aparece sozinha, com o título dela."
    }
  ],
  "presets": [
    {
      "name": "t:names.featured_products",
      "category": "t:categories.products",
      "settings": {
        "gap": 32
      },
      "blocks": [
        {
          "type": "group",
          "settings": {
            "direction": "row",
            "alignment": "start",
            "alignment_vertical": "center",
            "width": "fill"
          },
          "blocks": [
            {
              "type": "heading",
              "settings": {
                "title": "t:defaults.product_list",
                "size": "h4"
              }
            },
            {
              "type": "view-all-button",
              "settings": {
                "label": "t:defaults.view_all_button"
              }
            }
          ]
        },
        {
          "type": "products",
          "settings": {
            "products_source": {
              "kind": "collection",
              "id": "primary"
            },
            "format": "grid",
            "columns": "4",
            "columns_mobile": "2"
          }
        }
      ]
    },
    {
      "name": "t:names.featured_products",
      "category": "t:categories.products",
      "settings": {
        "gap": 32
      },
      "blocks": [
        {
          "type": "group",
          "settings": {
            "direction": "row",
            "alignment": "start",
            "alignment_vertical": "center",
            "width": "fill"
          },
          "blocks": [
            {
              "type": "heading",
              "settings": {
                "title": "t:defaults.product_list",
                "size": "h4"
              }
            },
            {
              "type": "view-all-button",
              "settings": {
                "label": "t:defaults.view_all_button"
              }
            }
          ]
        },
        {
          "type": "products",
          "settings": {
            "products_source": {
              "kind": "category",
              "id": "0"
            },
            "format": "slider",
            "columns": "4",
            "columns_mobile": "2"
          }
        }
      ]
    },
    {
      "name": "t:names.featured_products",
      "category": "t:categories.products",
      "settings": {
        "gap": 32,
        "alignment": "center"
      },
      "blocks": [
        {
          "type": "heading",
          "settings": {
            "title": "t:defaults.product_list",
            "size": "h4",
            "width": "fill"
          }
        },
        {
          "type": "products",
          "settings": {
            "products_source": {
              "kind": "category",
              "id": "0"
            },
            "format": "slider",
            "columns": "5",
            "columns_mobile": "2"
          }
        },
        {
          "type": "view-all-button",
          "settings": {
            "label": "t:defaults.view_all_button"
          }
        }
      ]
    },
    {
      "name": "t:names.featured_products",
      "category": "t:categories.products",
      "settings": {
        "gap": 32,
        "alignment": "center"
      },
      "blocks": [
        {
          "type": "heading",
          "settings": {
            "title": "t:defaults.product_list",
            "size": "h4",
            "width": "fill"
          }
        },
        {
          "type": "products",
          "settings": {
            "products_source": {
              "kind": "collection",
              "id": "primary"
            },
            "format": "grid",
            "columns": "3",
            "columns_mobile": "1"
          }
        },
        {
          "type": "view-all-button",
          "settings": {
            "label": "t:defaults.view_all_button"
          }
        }
      ]
    }
  ]
}
{% endschema %}
