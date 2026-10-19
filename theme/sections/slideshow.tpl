{# Slideshow Section #}
{# Settings: layout only. Slides come from blocks #}

{% set full_width = section.settings.section_width == 'full' %}
{% set page_width = section.settings.section_width == 'page' %}
{% set auto_height = section.settings.auto_height %}

{# Height: px when page, vh when full #}
{% set height_pixels = section.settings.height %}
{% set height_percentage = section.settings.height_full %}

{# Padding: horizontal disabled when page width (container handles constraint) #}
{% set vertical_padding = section.settings.vertical_padding %}
{% set horizontal_padding = full_width ? section.settings.horizontal_padding : 0 %}

{# Autoplay #}
{% set autoplay_enabled = is_preview ? false : section.settings.autoplay %}
{% set autoplay_speed = section.settings.autoplay_speed %}

{# Height style #}
{% if auto_height %}
  {% set height_style = '' %}
{% elseif full_width %}
  {% set height_style = 'min-height: ' ~ height_percentage ~ 'vh;' %}
{% else %}
  {% set height_style = 'min-height: ' ~ height_pixels ~ 'px;' %}
{% endif %}

{% set has_slides = section.blocks | length > 0 %}
{% set content_animation = section.settings.content_animation | default('none') %}

{# Data store: first section gets legacy home-slider, others get dynamic #}
{% set slideshow_data_store = claim_legacy_data_store('home-slider') ? 'home-slider' : section.id %}


<div
  class="js-slideshow-container position-relative {% if full_width %}section-full-width{% endif %}"
  data-store="{{ slideshow_data_store }}"
  data-section-id="{{ section.id }}"
  style="{{ height_style }} padding: {{ vertical_padding }}px {{ horizontal_padding }}px;"
>
  {% if page_width %}
    <div class="container">
  {% endif %}
  {% if has_slides %}
      {# On pages with page-header (category, search), prioritize sections 1 and 2 since page-header occupies one slot but rarely contains images #}
      {% set is_priority_section = section.index <= (template in ['home', 'product'] ? 1 : 2) %}
    <div class="js-slideshow swiper-container"
      data-autoplay="{{ autoplay_enabled ? 'true' : 'false' }}"
      data-speed="{{ autoplay_speed * 1000 }}"
      data-priority="{{ is_priority_section ? 'true' : 'false' }}">
      <div class="swiper-wrapper">
        {% for block in section.blocks %}
          {% if block.type == 'slide' %}
            {% include 'blocks/slide.tpl' with { block: block, is_priority: is_priority_section and loop.first, slide_height_style: height_style, slide_auto_height: auto_height, slide_index: loop.index0, slide_content_animation: content_animation } %}
          {% endif %}
        {% endfor %}
      </div>

      {% if section.blocks | length > 1 %}
        {# Navigation arrows - visible on desktop only #}
        <button type="button" class="js-swiper-slideshow-prev swiper-button-prev" aria-label="{{ 'general.previous' | t }}">
          <svg class="slider-arrow slider-arrow-prev icon-inline"><use xlink:href="#arrow-long"/></svg>
        </button>
        <button type="button" class="js-swiper-slideshow-next swiper-button-next" aria-label="{{ 'general.next' | t }}">
          <svg class="slider-arrow icon-inline"><use xlink:href="#arrow-long"/></svg>
        </button>

        {# Pagination fraction (top) - updated by JS #}
        <div class="js-swiper-slideshow-pagination swiper-fractions"><span class="swiper-pagination-current">1</span> / <span class="swiper-pagination-total">{{ section.blocks | length }}</span></div>
      {% endif %}
    </div>
    {% if has_slides and section.blocks | length > 1 %}
      {# Pagination bullets below slider - mobile and desktop #}
      <div class="js-swiper-slideshow-pagination-bullets swiper-pagination swiper-pagination-bullets swiper-pagination-outside"></div>
    {% endif %}
  {% endif %}
  {% if page_width %}
    </div>
  {% endif %}
</div>


{% schema %}
{
  "name": "Banner principal (fotos que passam sozinhas)",
  "icon": "SlideshowIcon",
  "add_section_order": 2,
  "class": "section section-slideshow",
  "max_blocks": 10,
  "blocks": [
    {
      "type": "slide"
    }
  ],
  "settings": [
    {
      "type": "paragraph",
      "content": "Faixa grande de fotos no topo da página. Cada foto é um \"Slide\": edite-os na lista de blocos abaixo."
    },
    {
      "type": "setting",
      "setting_type": "toggle",
      "id": "autoplay",
      "label": "Passar as fotos sozinho",
      "default": true,
      "info": "Com mais de uma foto, troca automaticamente."
    },
    {
      "type": "setting",
      "setting_type": "range",
      "id": "autoplay_speed",
      "label": "Tempo de cada foto",
      "min": 3,
      "max": 10,
      "step": 1,
      "unit": "s",
      "default": 5,
      "disabled_if": "{{ section.settings.autoplay == false }}",
      "info": "Em segundos."
    }
  ],
  "presets": [
    {
      "name": "t:names.carousel",
      "category": "t:categories.media",
      "blocks": [
        {
          "type": "slide",
          "blocks": [
            {
              "type": "heading",
              "settings": {
                "title": "t:defaults.slide.heading",
                "size": "h1"
              }
            },
            {
              "type": "text",
              "settings": {
                "text": "t:defaults.slide.description"
              }
            },
            {
              "type": "button",
              "settings": {
                "label": "t:defaults.slide.button"
              }
            }
          ]
        },
        {
          "type": "slide",
          "blocks": [
            {
              "type": "heading",
              "settings": {
                "title": "t:defaults.slide.heading",
                "size": "h1"
              }
            },
            {
              "type": "text",
              "settings": {
                "text": "t:defaults.slide.description"
              }
            },
            {
              "type": "button",
              "settings": {
                "label": "t:defaults.slide.button"
              }
            }
          ]
        },
        {
          "type": "slide",
          "blocks": [
            {
              "type": "heading",
              "settings": {
                "title": "t:defaults.slide.heading",
                "size": "h1"
              }
            },
            {
              "type": "text",
              "settings": {
                "text": "t:defaults.slide.description"
              }
            },
            {
              "type": "button",
              "settings": {
                "label": "t:defaults.slide.button"
              }
            }
          ]
        }
      ]
    }
  ]
}
{% endschema %}
