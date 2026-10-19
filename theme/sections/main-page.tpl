{#
  Page Content Section
  Renders static page content from the CMS.
#}

{# Layout settings #}
{% set page_width = section.settings.section_width == 'page' %}
{% set vertical_padding = section.settings.vertical_padding %}
{% set horizontal_padding = page_width ? 0 : section.settings.horizontal_padding %}


<div
  class="page-content-section"
  style="padding: {{ vertical_padding }}px {{ horizontal_padding }}px;"
>
  {% if page_width %}
    <div class="container">
  {% endif %}
    <div class="page-content user-content">
      {{ page.content }}
    </div>
  {% if page_width %}
    </div>
  {% endif %}
</div>


{% schema %}
{
  "name": "Texto da página",
  "class": "section section-main-page",
  "static": true,
  "limit": 1,
  "presets": [
    {
      "name": "t:names.page_content"
    }
  ],
  "settings": [
    {
      "type": "paragraph",
      "content": "O texto é editado em Loja online › Páginas, no painel da loja."
    }
  ],
  "blocks": [],
  "enabled_on": {
    "page_templates": [
      "page"
    ]
  }
}
{% endschema %}
