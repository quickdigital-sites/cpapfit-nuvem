{#
  404 Section
  Error page for non-existent URLs with breadcrumbs and message.
#}
{# Layout settings #}
{% set page_width = section.settings.section_width == 'page' %}
{% set vertical_padding = section.settings.vertical_padding %}
{% set horizontal_padding = page_width ? 0 : section.settings.horizontal_padding %}


<div
  id="page-error"
  class="error-page-container"
  style="padding: {{ vertical_padding }}px {{ horizontal_padding }}px;"
>
  {% if page_width %}
    <div class="container">
  {% endif %}
  <section class="error-page-header page-header" data-store="page-title">
    {% include 'snippets/breadcrumbs.tpl' %}
    <h1 class="error-page-title">{{ 'general.error' | t }} - 404</h1>
  </section>
  
  <h2 class="error-page-subtitle">{{ 'general.page_not_found' | t }}</h2>

  {# CPAP Fit (BUG-016): busca e categorias para o cliente seguir navegando #}
  <form class="qd-404-search" action="{{ store.search_url }}" method="get" role="search">
    <label class="qd-404-label" for="qd-404-q">Buscar na loja</label>
    <div class="qd-404-search-row">
      <input id="qd-404-q" class="form-control" type="search" name="q" placeholder="{{ 'search.placeholder' | t }}" />
      <input type="hidden" name="sort_by" value="best-selling" />
      <button type="submit" class="btn btn-primary">{{ 'search.value' | t }}</button>
    </div>
  </form>
  {% if categories | length > 0 %}
    <nav class="qd-404-categories" aria-label="Categorias">
      <p class="qd-404-label">Categorias</p>
      <ul class="list-unstyled">
        {% for category in categories | slice(0, 10) %}
          <li><a class="btn btn-secondary" href="{{ category.url }}">{{ category.name }}</a></li>
        {% endfor %}
      </ul>
    </nav>
  {% endif %}
  {% if page_width %}
    </div>
  {% endif %}
</div>


{# O <title> vem da plataforma (platform_head_content) e chega vazio no 404 #}
<script>if (!document.title.trim()) document.title = {{ ('Página não encontrada - ' ~ store.name) | json_encode | raw }};</script>

{% schema %}
{
  "name": "t:names.main_404",
  "class": "section section-main-404",
  "static": true,
  "limit": 1,
  "presets": [{"name": "t:names.main_404"}],
  "settings": [
    {
      "type": "header",
      "content": "t:names.design"
    },
    {
      "type": "setting",
      "setting_type": "radio",
      "id": "section_width",
      "label": "t:settings.section_width",
      "options": [
        { "value": "page", "label": "t:options.page" },
        { "value": "full", "label": "t:options.full" }
      ],
      "default": "page"
    },
    {
      "type": "setting",
      "setting_type": "range",
      "id": "vertical_padding",
      "label": "t:settings.vertical_padding",
      "min": 0,
      "max": 120,
      "step": 4,
      "unit": "px",
      "default": 0,
      "icon": "vertical_padding"
    },
    {
      "type": "setting",
      "setting_type": "range",
      "id": "horizontal_padding",
      "label": "t:settings.horizontal_padding",
      "min": 0,
      "max": 120,
      "step": 4,
      "unit": "px",
      "default": 32,
      "icon": "horizontal_padding",
      "disabled_if": "{{ section.settings.section_width == 'page' }}"
    }
  ],
  "enabled_on": {
    "page_templates": ["404"]
  }
}
{% endschema %}
