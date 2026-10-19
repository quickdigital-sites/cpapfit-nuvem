{# Slide Block - Private to slideshow section #}

{% set slide = block.settings %}
{% set has_link = slide.link %}

{# Images #}
{% set has_mobile_image = slide.use_mobile_image and slide.image_mobile %}
{% set has_responsive_images = slide.image and has_mobile_image %}

{# Alignment #}
{% set horizontal_align = slide.alignment | default('center') %}
{% set vertical_align = slide.alignment_vertical | default('center') %}
{% set horizontal_align_class = horizontal_align == 'start' ? 'left' : (horizontal_align == 'end' ? 'right' : 'center') %}
{% set vertical_align_class = vertical_align %}

{% if vertical_align_class == 'center' and horizontal_align_class == 'center' %}
  {% set content_position_class = 'media-content-center' %}
{% else %}
  {% set content_position_class = 'media-content-' ~ vertical_align_class ~ '-' ~ horizontal_align_class %}
{% endif %}

{# Text color #}
{% set text_color = slide.text_color %}

{# Overlay #}
{% set show_overlay = slide.show_overlay %}
{% set overlay_color = slide.overlay_color | default('#000000') %}
{% set overlay_opacity = show_overlay ? ((slide.overlay_opacity | default(30)) / 100) : 0 %}

{# Spacing #}
{% set slide_gap = slide.gap | default(16) %}
{% set slide_vertical_padding = slide.vertical_padding | default(32) %}
{% set slide_horizontal_padding = slide.horizontal_padding | default(32) %}

{% set has_image = slide.image or has_mobile_image %}
{# CPAP Fit: a foto de exemplo da Nuvemshop só aparece no editor; na loja, slide sem foto fica só com o fundo #}
{% set show_placeholder = not has_image and is_preview %}
{% set content_animation = slide_content_animation | default('none') %}

{% set image_alt = slide.image | media_alt | default('accessibility.slide' | t) %}
{% set image_mobile_alt = slide.image_mobile | media_alt | default('accessibility.slide' | t) %}

<div
  class="swiper-slide media {% if slide_auto_height %}media-auto{% endif %}"
  {{ block | block_attributes }}
  data-store="slide-{{ block.id }}"
  style="{{ slide_height_style | default('') }} {% if show_overlay %}--media-overlay-color: {{ overlay_color }}; --media-overlay-opacity: {{ overlay_opacity }};{% endif %} {% if text_color %}color: {{ text_color }};{% endif %}"
>
  <div class="media-visual">
      {# Desktop image: always lazy when mobile variant exists, otherwise follows priority #}
      {# CPAP Fit: no 1º slide com as duas fotos, um <picture> só (ver snippets/qd-hero-picture.tpl) #}
      {% if is_priority and has_responsive_images %}
        {% include 'snippets/qd-hero-picture.tpl' with { hero_desktop: slide.image, hero_mobile: slide.image_mobile, hero_alt: image_mobile_alt } %}
      {% elseif slide.image %}
        {% set desktop_lazy = has_responsive_images or not is_priority %}
        {% include 'snippets/image.tpl' with {
          image_src: slide.image,
          image_alt: image_alt,
          image_classes: (has_responsive_images ? 'd-none d-md-block ') ~ (desktop_lazy ? 'fade-in'),
          image_priority_high: not has_responsive_images and is_priority,
          image_lazy_js: desktop_lazy,
          image_swiper_lazy_class: desktop_lazy,
          image_width: slide.image_width,
          image_height: slide.image_height,
          image_aspect_ratio: slide.image_width and slide.image_height,
        } %}
        {% if desktop_lazy %}
          <div class="placeholder placeholder-fade {{ has_responsive_images ? 'd-none d-md-block' }}"></div>
        {% endif %}
      {% elseif show_placeholder %}
        {# Fallback placeholder only when no image is configured at all. Cycles slide-1/2/3.jpg by position. #}
        {% set placeholder_num = ((slide_index | default(0)) % 3) + 1 %}
        {% set desktop_lazy = not is_priority %}
        {% include 'snippets/image.tpl' with {
          image_src: ('images/placeholders/carrousel/slide-' ~ placeholder_num ~ '.webp') | static_url,
          image_alt: 'accessibility.slide' | t,
          image_classes: desktop_lazy ? 'fade-in',
          image_priority_high: is_priority,
          image_lazy_js: desktop_lazy,
          image_swiper_lazy_class: desktop_lazy,
          image_thumbs: false,
          image_width: 1280,
          image_height: 700,
          image_aspect_ratio: true,
        } %}
        {% if desktop_lazy %}
          <div class="placeholder placeholder-fade"></div>
        {% endif %}
      {% endif %}

      {# Mobile image: prioritized for LCP on first slide of first section #}
      {% if has_mobile_image and not (is_priority and has_responsive_images) %}
        {% include 'snippets/image.tpl' with {
          image_src: slide.image_mobile,
          image_alt: image_mobile_alt,
          image_classes: (has_responsive_images ? 'd-md-none ') ~ (not is_priority ? 'fade-in'),
          image_priority_high: is_priority,
          image_lazy_js: not is_priority,
          image_swiper_lazy_class: not is_priority,
          image_width: slide.image_mobile_width,
          image_height: slide.image_mobile_height,
          image_aspect_ratio: slide.image_mobile_width and slide.image_mobile_height,
        } %}
        {% if not is_priority %}
          <div class="placeholder placeholder-fade {{ has_responsive_images ? 'd-md-none' }}"></div>
        {% endif %}
      {% endif %}

      {# Overlay #}
      {% if show_overlay %}
        <div class="media-overlay"></div>
      {% endif %}
    </div>

  {# Slide link #}
  {% if has_link %}
    <a href="{{ slide.link }}" class="media-link" aria-label="{{ 't:names.slide' | t }}"></a>
  {% endif %}

  {# Content #}
  {% if block.blocks | length > 0 %}
    {% set no_image_align = horizontal_align == 'center' ? 'center' : (horizontal_align == 'end' ? 'end' : 'start') %}
    {% set no_image_classes = 'd-flex flex-column align-items-' ~ no_image_align ~ ' text-' ~ horizontal_align_class %}
    <div class="{% if has_image or show_placeholder %}media-content media-content-floating {{ content_position_class }}{% else %}{{ no_image_classes }}{% endif %} {% if has_link %}media-content-linked{% endif %} {% if content_animation != 'none' %}media-content-animate media-content-animate-{{ content_animation }}{% endif %}" style="gap: {{ slide_gap }}px; padding: {{ slide_vertical_padding }}px {{ slide_horizontal_padding }}px;">
      {% for child_block in block.blocks %}
        {% if child_block and child_block.type is defined %}
          {% include 'blocks/' ~ child_block.type ~ '.tpl' with { block: child_block } %}
        {% endif %}
      {% endfor %}
    </div>
  {% endif %}
</div>

{% schema %}
{
  "name": "Slide (foto do banner)",
  "icon": "pictureIcon",
  "blocks": [
    {
      "tags": [
        "general"
      ]
    }
  ],
  "settings": [
    {
      "type": "setting",
      "setting_type": "image_picker",
      "id": "image",
      "label": "Foto",
      "info": "Computador: 1920 × 540 px. Celular: 840 × 600 px (marque \"Usar outra imagem no celular\"). JPG ou WebP, até 300 KB. Deixe o lado direito com a foto e o esquerdo mais limpo: o texto fica por cima."
    },
    {
      "type": "setting",
      "setting_type": "toggle",
      "id": "use_mobile_image",
      "label": "Usar outra imagem no celular",
      "default": false
    },
    {
      "type": "setting",
      "setting_type": "image_picker",
      "id": "image_mobile",
      "label": "Foto para celular",
      "visible_if": "{{ block.settings.use_mobile_image }}",
      "info": "Recomendado: 840 × 600 px, JPG ou WebP."
    },
    {
      "type": "setting",
      "setting_type": "url",
      "id": "link",
      "label": "Link da foto",
      "info": "Página aberta ao clicar. Use o endereço da loja, ex.: /mascaras/ ou /produtos/?brand=Resmed."
    }
  ],
  "presets": [
    {
      "name": "t:names.slide",
      "settings": {
        "gap": 16,
        "vertical_padding": 32,
        "horizontal_padding": 32
      },
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
{% endschema %}
