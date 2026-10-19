{# Banners Section #}
{# Supports both group blocks (flexible) and banner blocks (simplified) #}

{% set has_banners = section.blocks | length > 0 %}
{% set full_width = section.settings.section_width == 'full' %}
{% set page_width = section.settings.section_width == 'page' %}
{% set columns = section.settings.columns %}
{% set columns_mobile = section.settings.columns_mobile %}
{% set format = section.settings.format %}
{% set format_mobile = section.settings.use_different_mobile_format ? section.settings.format_mobile : format %}
{% set gap = section.settings.gap %}
{% set vertical_padding = section.settings.vertical_padding %}
{% set horizontal_padding = full_width ? section.settings.horizontal_padding : 0 %}
{% set background_color = section.settings.background_color %}

{# Data store: first section gets legacy home-banner-categories, others get dynamic #}
{% set banners_data_store = claim_legacy_data_store('home-banner-categories') ? 'home-banner-categories' : section.id %}

{# Single DOM: slider + grid via responsive flexbox classes #}
{% set use_slider = format_mobile == 'slider' or format == 'slider' %}
{% set slider_both = format_mobile == 'slider' and format == 'slider' %}
{% set slider_mobile_only = format_mobile == 'slider' and format == 'grid' %}
{% set slider_desktop_only = format == 'slider' and format_mobile == 'grid' %}

{% set section_wrapper_classes = 
	slider_both ? 'swiper-wrapper flex-nowrap' : 
	slider_mobile_only ? 'swiper-wrapper swiper-mobile-only flex-grid flex-nowrap flex-md-wrap' : 
	slider_desktop_only ? 'swiper-wrapper swiper-desktop-only flex-grid flex-wrap flex-md-nowrap' :
	'flex-grid'
%}

{% if slider_mobile_only %}
	{% set section_arrows_visibility = 'd-none' %}
{% endif %}

{% set section_pagination_visibility = slider_both ? '' : slider_mobile_only ? 'd-block d-md-none' : slider_desktop_only ? 'd-none d-md-block' %}

{# Section styles #}
{% set section_styles %}
	{% if full_width %}--section-horizontal-padding: {{ horizontal_padding }}px;{% endif %}
	{% if vertical_padding %}padding-top: {{ vertical_padding }}px; padding-bottom: {{ vertical_padding }}px;{% endif %}
	{% if horizontal_padding %}padding-left: {{ horizontal_padding }}px; padding-right: {{ horizontal_padding }}px;{% endif %}
	{% if background_color %}background-color: {{ background_color }};{% endif %}
{% endset %}


<div 
	class="banners-section {% if full_width %}banners-section-full-width section-full-width{% endif %}"
	data-store="{{ banners_data_store }}"
	data-section-id="{{ section.id }}"
	{% if section_styles | trim %}style="{{ section_styles | trim }}"{% endif %}
>
	{% if page_width %}
		<div class="container">
	{% endif %}
		{% if has_banners %}
			{% if use_slider %}
				<div class="js-banners-slider-container position-relative banners-slider-wrapper" data-columns-desktop="{{ columns }}" data-columns-mobile="{{ columns_mobile }}" data-gap-horizontal="{{ gap }}" data-desktop-format="{{ format }}" data-mobile-format="{{ format_mobile }}">
					<div class="js-banners-slider swiper-container">
			{% endif %}
						<div class="{{ section_wrapper_classes }}"
							style="--cols: {{ columns_mobile }}; --cols-md: {{ columns }}; --grid-gap: {{ gap }}px; row-gap: {{ gap }}px;">
							{# On pages with page-header (category, search), prioritize sections 1 and 2 since page-header occupies one slot but rarely contains images #}
							{% set is_priority_section = section.index <= (template in ['home', 'product'] ? 1 : 2) %}
							{% for block in section.blocks %}
								{# CPAP Fit: banner sem imagem some da loja (a imagem de exemplo só aparece no editor) #}
								{% if block.type == 'banner' and (block.settings.image or block.settings.image_mobile or is_preview) %}
									<div class="{% if use_slider %}swiper-slide{% endif %} banner-item">
										{% include 'blocks/banner.tpl' with {
											block: block,
											is_priority: is_priority_section and loop.first,
											block_index: loop.index0,
											banner_aspect_ratio: section.settings.banner_aspect_ratio | default('original'),
											banner_aspect_ratio_height: section.settings.banner_aspect_ratio_height | default(100),
											banner_aspect_ratio_mobile: section.settings.use_different_mobile_aspect_ratio ? section.settings.banner_aspect_ratio_mobile | default('original') : null,
											banner_aspect_ratio_mobile_height: section.settings.use_different_mobile_aspect_ratio ? section.settings.banner_aspect_ratio_mobile_height | default(100) : null
										} %}
									</div>
								{% endif %}
							{% endfor %}
						</div>
			{% if use_slider %}
					</div>
					{% if section.blocks | length > 1 %}
						<button type="button" class="js-swiper-banners-prev swiper-button-prev swiper-button-outside {{ section_arrows_visibility }}" aria-label="{{ 'general.previous' | t }}">
							<svg class="slider-arrow slider-arrow-prev icon-inline"><use xlink:href="#arrow-long"/></svg>
						</button>
						<button type="button" class="js-swiper-banners-next swiper-button-next swiper-button-outside {{ section_arrows_visibility }}" aria-label="{{ 'general.next' | t }}">
							<svg class="slider-arrow icon-inline"><use xlink:href="#arrow-long"/></svg>
						</button>
					{% endif %}
					{% if section.blocks | length > 1 %}
						<div class="js-swiper-banners-pagination swiper-pagination swiper-pagination-bullets swiper-pagination-outside {{ section_pagination_visibility }}"></div>
					{% endif %}
				</div>
			{% endif %}
		{% endif %}
	{% if page_width %}
		</div>
	{% endif %}
</div>


{% schema %}
{
  "name": "Banners de imagem",
  "add_section_order": 3,
  "class": "section section-banners",
  "blocks": [
    {
      "type": "banner"
    }
  ],
  "settings": [
    {
      "type": "paragraph",
      "content": "Imagens com link. Edite cada banner na lista de blocos."
    }
  ],
  "enabled_on": {
    "page_templates": "all",
    "layout_templates": [
      "footer"
    ]
  },
  "presets": [
    {
      "name": "t:names.banners",
      "category": "t:categories.media",
      "settings": {
        "format": "grid",
        "columns": "2",
        "columns_mobile": "1",
        "gap": 0,
        "vertical_padding": 0,
        "horizontal_padding": 0,
        "section_width": "full",
        "banner_aspect_ratio": "square"
      },
      "blocks": [
        {
          "type": "banner",
          "settings": {
            "gap": 16,
            "vertical_padding": 32,
            "horizontal_padding": 32,
            "alignment": "center",
            "alignment_vertical": "center"
          },
          "blocks": [
            {
              "type": "heading",
              "settings": {
                "title": "t:defaults.banner.heading",
                "size": "h1"
              }
            },
            {
              "type": "text",
              "settings": {
                "text": "t:defaults.banner.description"
              }
            },
            {
              "type": "button",
              "settings": {
                "label": "t:defaults.banner.button",
                "size": "medium"
              }
            }
          ]
        },
        {
          "type": "banner",
          "settings": {
            "gap": 16,
            "vertical_padding": 32,
            "horizontal_padding": 32,
            "alignment": "center",
            "alignment_vertical": "center"
          },
          "blocks": [
            {
              "type": "heading",
              "settings": {
                "title": "t:defaults.banner.heading",
                "size": "h1"
              }
            },
            {
              "type": "text",
              "settings": {
                "text": "t:defaults.banner.description"
              }
            },
            {
              "type": "button",
              "settings": {
                "label": "t:defaults.banner.button",
                "size": "medium"
              }
            }
          ]
        }
      ]
    },
    {
      "name": "t:names.banners",
      "category": "t:categories.media",
      "settings": {
        "format": "grid",
        "columns": "2",
        "columns_mobile": "1",
        "gap": 16,
        "vertical_padding": 64,
        "horizontal_padding": 0,
        "section_width": "page",
        "banner_aspect_ratio": "horizontal"
      },
      "blocks": [
        {
          "type": "banner",
          "settings": {
            "gap": 8,
            "vertical_padding": 24,
            "horizontal_padding": 0,
            "alignment": "center",
            "alignment_vertical": "center",
            "text_outside": true
          },
          "blocks": [
            {
              "type": "heading",
              "settings": {
                "title": "t:defaults.banner.heading",
                "size": "h2"
              }
            },
            {
              "type": "text",
              "settings": {
                "text": "t:defaults.banner.description"
              }
            }
          ]
        },
        {
          "type": "banner",
          "settings": {
            "gap": 8,
            "vertical_padding": 24,
            "horizontal_padding": 0,
            "alignment": "center",
            "alignment_vertical": "center",
            "text_outside": true
          },
          "blocks": [
            {
              "type": "heading",
              "settings": {
                "title": "t:defaults.banner.heading",
                "size": "h2"
              }
            },
            {
              "type": "text",
              "settings": {
                "text": "t:defaults.banner.description"
              }
            }
          ]
        }
      ]
    },
    {
      "name": "t:names.banners",
      "category": "t:categories.media",
      "settings": {
        "format": "grid",
        "columns": "3",
        "columns_mobile": "1",
        "gap": 16,
        "vertical_padding": 40,
        "banner_aspect_ratio": "square"
      },
      "blocks": [
        {
          "type": "banner",
          "settings": {
            "gap": 16,
            "vertical_padding": 24,
            "horizontal_padding": 24,
            "alignment": "center",
            "text_outside": true
          },
          "blocks": [
            {
              "type": "heading",
              "settings": {
                "title": "t:defaults.banner.heading",
                "size": "h3"
              }
            }
          ]
        },
        {
          "type": "banner",
          "settings": {
            "gap": 16,
            "vertical_padding": 24,
            "horizontal_padding": 24,
            "alignment": "center",
            "text_outside": true
          },
          "blocks": [
            {
              "type": "heading",
              "settings": {
                "title": "t:defaults.banner.heading",
                "size": "h3"
              }
            }
          ]
        },
        {
          "type": "banner",
          "settings": {
            "gap": 16,
            "vertical_padding": 24,
            "horizontal_padding": 24,
            "alignment": "center",
            "text_outside": true
          },
          "blocks": [
            {
              "type": "heading",
              "settings": {
                "title": "t:defaults.banner.heading",
                "size": "h3"
              }
            }
          ]
        }
      ]
    },
    {
      "name": "t:names.banners",
      "category": "t:categories.media",
      "settings": {
        "format": "grid",
        "columns": "3",
        "columns_mobile": "1",
        "gap": 0,
        "vertical_padding": 0,
        "horizontal_padding": 0,
        "section_width": "full",
        "banner_aspect_ratio": "vertical"
      },
      "blocks": [
        {
          "type": "banner",
          "settings": {
            "gap": 8,
            "vertical_padding": 24,
            "horizontal_padding": 24
          },
          "blocks": [
            {
              "type": "text",
              "settings": {
                "text": "t:defaults.banner.description",
                "size": "paragraph_small"
              }
            },
            {
              "type": "heading",
              "settings": {
                "title": "t:defaults.banner.heading",
                "size": "h2"
              }
            }
          ]
        },
        {
          "type": "banner",
          "settings": {
            "gap": 8,
            "vertical_padding": 24,
            "horizontal_padding": 24
          },
          "blocks": [
            {
              "type": "text",
              "settings": {
                "text": "t:defaults.banner.description",
                "size": "paragraph_small"
              }
            },
            {
              "type": "heading",
              "settings": {
                "title": "t:defaults.banner.heading",
                "size": "h2"
              }
            }
          ]
        },
        {
          "type": "banner",
          "settings": {
            "gap": 8,
            "vertical_padding": 24,
            "horizontal_padding": 24
          },
          "blocks": [
            {
              "type": "text",
              "settings": {
                "text": "t:defaults.banner.description",
                "size": "paragraph_small"
              }
            },
            {
              "type": "heading",
              "settings": {
                "title": "t:defaults.banner.heading",
                "size": "h2"
              }
            }
          ]
        }
      ]
    },
    {
      "name": "t:names.banners",
      "category": "t:categories.media",
      "settings": {
        "format": "grid",
        "columns": "4",
        "columns_mobile": "1",
        "gap": 0,
        "vertical_padding": 0,
        "horizontal_padding": 0,
        "section_width": "full",
        "banner_aspect_ratio": "square"
      },
      "blocks": [
        {
          "type": "banner",
          "settings": {
            "gap": 16,
            "vertical_padding": 24,
            "horizontal_padding": 24,
            "alignment": "center",
            "alignment_vertical": "center"
          },
          "blocks": [
            {
              "type": "heading",
              "settings": {
                "title": "t:defaults.banner.heading",
                "size": "h3"
              }
            }
          ]
        },
        {
          "type": "banner",
          "settings": {
            "gap": 16,
            "vertical_padding": 24,
            "horizontal_padding": 24,
            "alignment": "center",
            "alignment_vertical": "center"
          },
          "blocks": [
            {
              "type": "heading",
              "settings": {
                "title": "t:defaults.banner.heading",
                "size": "h3"
              }
            }
          ]
        },
        {
          "type": "banner",
          "settings": {
            "gap": 16,
            "vertical_padding": 24,
            "horizontal_padding": 24,
            "alignment": "center",
            "alignment_vertical": "center"
          },
          "blocks": [
            {
              "type": "heading",
              "settings": {
                "title": "t:defaults.banner.heading",
                "size": "h3"
              }
            }
          ]
        },
        {
          "type": "banner",
          "settings": {
            "gap": 16,
            "vertical_padding": 24,
            "horizontal_padding": 24,
            "alignment": "center",
            "alignment_vertical": "center"
          },
          "blocks": [
            {
              "type": "heading",
              "settings": {
                "title": "t:defaults.banner.heading",
                "size": "h3"
              }
            }
          ]
        }
      ]
    },
    {
      "name": "t:names.banners",
      "category": "t:categories.media",
      "settings": {
        "format": "grid",
        "columns": "4",
        "columns_mobile": "1",
        "gap": 16,
        "vertical_padding": 24,
        "horizontal_padding": 24,
        "section_width": "full",
        "banner_aspect_ratio": "vertical"
      },
      "blocks": [
        {
          "type": "banner",
          "settings": {
            "gap": 16,
            "vertical_padding": 16,
            "horizontal_padding": 12,
            "alignment": "start",
            "alignment_vertical": "bottom",
            "text_outside": true
          },
          "blocks": [
            {
              "type": "heading",
              "settings": {
                "title": "t:defaults.banner.heading",
                "size": "h3"
              }
            },
            {
              "type": "text",
              "settings": {
                "text": "t:defaults.banner.description"
              }
            },
            {
              "type": "button",
              "settings": {
                "label": "t:defaults.banner.button",
                "variant": "tertiary",
                "size": "medium"
              }
            }
          ]
        },
        {
          "type": "banner",
          "settings": {
            "gap": 16,
            "vertical_padding": 16,
            "horizontal_padding": 12,
            "alignment": "start",
            "alignment_vertical": "bottom",
            "text_outside": true
          },
          "blocks": [
            {
              "type": "heading",
              "settings": {
                "title": "t:defaults.banner.heading",
                "size": "h3"
              }
            },
            {
              "type": "text",
              "settings": {
                "text": "t:defaults.banner.description"
              }
            },
            {
              "type": "button",
              "settings": {
                "label": "t:defaults.banner.button",
                "variant": "tertiary",
                "size": "medium"
              }
            }
          ]
        },
        {
          "type": "banner",
          "settings": {
            "gap": 16,
            "vertical_padding": 16,
            "horizontal_padding": 12,
            "alignment": "start",
            "alignment_vertical": "bottom",
            "text_outside": true
          },
          "blocks": [
            {
              "type": "heading",
              "settings": {
                "title": "t:defaults.banner.heading",
                "size": "h3"
              }
            },
            {
              "type": "text",
              "settings": {
                "text": "t:defaults.banner.description"
              }
            },
            {
              "type": "button",
              "settings": {
                "label": "t:defaults.banner.button",
                "variant": "tertiary",
                "size": "medium"
              }
            }
          ]
        },
        {
          "type": "banner",
          "settings": {
            "gap": 16,
            "vertical_padding": 16,
            "horizontal_padding": 12,
            "alignment": "start",
            "alignment_vertical": "bottom",
            "text_outside": true
          },
          "blocks": [
            {
              "type": "heading",
              "settings": {
                "title": "t:defaults.banner.heading",
                "size": "h3"
              }
            },
            {
              "type": "text",
              "settings": {
                "text": "t:defaults.banner.description"
              }
            },
            {
              "type": "button",
              "settings": {
                "label": "t:defaults.banner.button",
                "variant": "tertiary",
                "size": "medium"
              }
            }
          ]
        }
      ]
    },
    {
      "name": "t:names.banners",
      "category": "t:categories.media",
      "settings": {
        "format": "grid",
        "columns": "1",
        "columns_mobile": "1",
        "gap": 16,
        "vertical_padding": 40,
        "horizontal_padding": 40,
        "section_width": "page",
        "banner_aspect_ratio": "custom",
        "banner_aspect_ratio_height": 25,
        "use_different_mobile_aspect_ratio": true,
        "banner_aspect_ratio_mobile": "horizontal"
      },
      "blocks": [
        {
          "type": "banner",
          "settings": {
            "gap": 16,
            "vertical_padding": 32,
            "horizontal_padding": 32,
            "alignment": "start",
            "alignment_vertical": "center"
          },
          "blocks": [
            {
              "type": "group",
              "settings": {
                "direction": "row",
                "alignment_vertical": "center",
                "gap": 16,
                "vertical_padding": 0,
                "horizontal_padding": 0
              },
              "blocks": [
                {
                  "type": "group",
                  "settings": {
                    "gap": 8
                  },
                  "blocks": [
                    {
                      "type": "heading",
                      "settings": {
                        "title": "t:defaults.heading",
                        "size": "h1"
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
                  "type": "button",
                  "settings": {
                    "size": "medium"
                  }
                }
              ]
            }
          ]
        }
      ]
    },
    {
      "name": "t:names.banners",
      "category": "t:categories.media",
      "settings": {
        "format": "grid",
        "columns": "1",
        "columns_mobile": "1",
        "gap": 16,
        "vertical_padding": 0,
        "horizontal_padding": 0,
        "section_width": "full",
        "banner_aspect_ratio": "custom",
        "banner_aspect_ratio_height": 25,
        "use_different_mobile_aspect_ratio": true,
        "banner_aspect_ratio_mobile": "horizontal"
      },
      "blocks": [
        {
          "type": "banner",
          "settings": {
            "gap": 16,
            "vertical_padding": 32,
            "horizontal_padding": 32,
            "alignment": "center",
            "alignment_vertical": "center"
          },
          "blocks": [
            {
              "type": "heading",
              "settings": {
                "title": "t:defaults.banner.heading",
                "size": "h1"
              }
            },
            {
              "type": "group",
              "settings": {
                "direction": "row",
                "alignment": "center",
                "gap": 8,
                "vertical_padding": 0,
                "horizontal_padding": 0
              },
              "blocks": [
                {
                  "type": "button",
                  "settings": {
                    "label": "t:defaults.banner.button",
                    "size": "medium"
                  }
                },
                {
                  "type": "button",
                  "settings": {
                    "label": "t:defaults.banner.button",
                    "size": "medium"
                  }
                }
              ]
            }
          ]
        }
      ]
    }
  ]
}
{% endschema %}
