<!DOCTYPE html>
<html lang="{{ html_lang }}">
  <head>
    {# Meta tags component #}
    {{ component('head-tags') }}

    {# CPAP Fit: a Montserrat (a fonte do tema, fixada em --heading-font/--body-font no main.css) vem do repo público
       de assets no jsDelivr (design/assets/fonts, publicado por scripts/publish-assets.sh), pré-carregada aqui no
       topo: um só woff2 variável (300–700, latin, 35KB, cache imutável) pedido junto com o HTML, sem a ida extra ao
       CSS do Google. Assim ele costuma chegar antes da 1ª pintura e o texto não troca de fonte na frente do
       visitante. O @font-face fica no style-tokens.tpl. #}
    {% set qd_font_url = 'https://cdn.jsdelivr.net/gh/quickdigital-sites/quickdigital-sites-cpapfit-assets@d85f7c232dd7cd8dbef4896340334b3b5f73a053/design/assets/fonts/montserrat-latin-v31.woff2' %}
    <link rel="preload" href="{{ qd_font_url }}" as="font" type="font/woff2" crossorigin />

    {# Preload critical assets #}
    {# CPAP Fit: só se o editor tiver outra fonte além da Montserrat ela vem do Google, sem bloquear a 1ª pintura
       (display=swap). Antes era um @import no style-tokens.tpl, que bloqueava a renderização. #}
    {% if 'Montserrat' not in settings.font_headings or 'Montserrat' not in settings.font_rest or additional_fonts | default([]) is not empty %}
      {% set qd_fonts_url = ([settings.font_headings, settings.font_rest] | merge(additional_fonts | default([]))) | google_fonts_url('300,400,500,600,700') %}
      <link rel="preconnect" href="https://fonts.googleapis.com" />
      <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
      <link rel="preload" as="style" href="{{ qd_fonts_url }}" onload="this.onload=null;this.rel='stylesheet'" />
      <noscript><link rel="stylesheet" href="{{ qd_fonts_url }}" /></noscript>
    {% endif %}
    <link rel="preload" href="{{ 'js/libraries-standalone.js' | static_url }}" as="script" />
    <link rel="preload" href="{{ 'css/style-critical.css' | static_url }}" as="style" />
    <link rel="preload" href="{{ 'css/style-utilities.css' | static_url }}" as="style" />

    {# Style Tokens (fonts + CSS custom properties) #}
    <style>
      {% include 'layouts/resources/style-tokens.tpl' %}
    </style>

    {# Critical CSS #}
    {{ 'css/style-critical.css' | static_url | static_inline }}

    {# Utilities CSS #}
    {{ 'css/style-utilities.css' | static_url | static_inline }}

    {# Async CSS loading #}
    <link rel="stylesheet" href="{{ 'css/style-async.css' | static_url }}" media="print" onload="this.media='all'">

    {# Custom CSS from settings #}
    {% if settings.css_code %}
      <style id="custom-theme-css">
        {{ settings.css_code | raw }}
      </style>
    {% endif %}
    {# nuvemshop-dev:start — gerado por frontend/inject.mjs, não edite este trecho #}
    <link rel="preconnect" href="https://cdn.jsdelivr.net">
    <link rel="stylesheet" href="{{ 'css/tailwind.css' | static_url }}">
    <script defer src="{{ 'js/app.js' | static_url }}"></script>
    {# nuvemshop-dev:end #}


    {% set async_js = true %}

    {# Platform head content #}
    {% platform_head_content %}

    {# Structured data #}
    {% include 'snippets/structured-data/structured-data-organization.tpl' %}
    {% include 'snippets/structured-data/structured-data.tpl' %}

  </head>

  {% set cart_favicon_url = settings.cart_favicon ? (settings.cart_favicon | resolve_media).sourceUrl : '' %}

  <body
    class="{% if customer %}customer-logged-in{% endif %} template-{{ template | replace('.', '-') | replace('/', '-') }} {% if template == 'password' %}body-password{% endif %}{% if template == 'page' %} page-{{ page.url | trim('/') | split('/') | last }}{% endif %}"
    {% if settings.ajax_cart %}data-ajax-cart="true"{% endif %}
    {% if settings.inactive_tab_message %}
      data-inactive-tab-msg1="{{ settings.inactive_tab_message_01 | escape }}"
      data-inactive-tab-msg2="{{ settings.inactive_tab_message_02 | escape }}"
    {% endif %}
    {% if cart_favicon_url %}data-cart-favicon="{{ cart_favicon_url | escape }}"{% endif %}
    {# CPAP Fit: cupom da campanha (Configurações do tema › Página de produto › Cupom em destaque) — fonte única
       para a faixa de cupom do rodapé (footer.js) e o "Aproveite também" da página de produto #}
    data-qd-campaign-text="{{ settings.qd_pdp_coupon_text | escape }}"
    data-qd-campaign-code="{{ settings.qd_pdp_coupon_code | escape }}"
    data-preview="{{ params.preview ? 'true' : 'false' }}"
  >
    {{ component('nubesdk-slot', { type: "before_main_content" }) }}

    {# SVG icons sprite #}
    {% include 'layouts/resources/icons-sprite.tpl' %}

    {# Back to admin bar #}
    {{ back_to_admin }}

    {# Header layout template - not shown on password page #}
    {% if template != 'password' %}
      <header class="js-header header">
        {% layout_template 'header' %}
      </header>
      {{ component('nubesdk-slot', { type: "after_header" }) }}
    {% endif %}

    {# Add to cart notification - Outside header for proper fixed positioning #}
    {% if settings.ajax_cart and template != 'password' %}
      {% include 'snippets/notification.tpl' with {
        type: 'add_to_cart',
      } %}
    {% endif %}

    {# Main content #}
    <main id="MainContent" class="main-content main-container" role="main">
      {{ page_template_content }}
    </main>

    {# Footer layout template - adapts automatically for password page #}
    {% layout_template 'footer' %}

    {% if template != 'password' %}
      {# Quick shop modal #}
      {% if settings.quick_shop %}
        {% include 'snippets/modals/quick-shop-modal.tpl' %}
      {% endif %}

      {# Cart modal - Ajax cart panel #}
      {% include 'snippets/cart/cart-modal.tpl' %}

      {# WhatsApp chat button #}
      {% include 'snippets/social/whatsapp-chat.tpl' %}

      {# Promotional modal #}
      {% if settings.promotional_popup_enabled %}
        {% include 'snippets/promotional-modal.tpl' %}
      {% endif %}

      {# Free shipping progress data #}
      <span class="js-ship-free-min hidden" data-pricemin="{{ cart.free_shipping.min_price_free_shipping.min_price_raw|default(0) }}"></span>
      <span class="js-free-shipping-config hidden" data-config="{{ cart.free_shipping.allFreeConfigurations }}"></span>
      <span class="js-cart-subtotal hidden" data-priceraw="{{ cart.subtotal }}"></span>
      <span class="js-cart-discount hidden" data-priceraw="{{ cart.promotional_discount_amount }}"></span>
    {% endif %}

    {# JavaScript - Standalone libraries (Swiper, Lazysizes) - blocking to guarantee availability #}
    {{ 'js/libraries-standalone.js' | static_url | script_tag }}

    {# JavaScript - Non-critical libraries and theme store: loaded after LS.ready #}
    <script>
      LS.ready.then(function() {

        {% include "static/js/libraries.js.tpl" %}

        var script = document.createElement('script');
        script.src = '{{ "js/store.js" | static_url }}';
        document.body.appendChild(script);
      });
    </script>

    {% platform_body_content %}
  </body>
</html>
