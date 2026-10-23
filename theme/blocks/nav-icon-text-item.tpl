{# Nav Icon Text Item Block — Icon with description for the navigation bar #}

{%- set item = block.settings | default({}) -%}
{% set use_custom_image = item.icon_source == 'custom' and item.custom_image %}
{% set is_mobile_menu = type == 'mobile_menu' %}

{# CPAP Fit: "Destacar como botão" (qd_pill) vira a pílula colorida, ex.: Acompanhamento PASSOS #}
{% set is_pill = item.qd_pill and not is_mobile_menu %}
{% set wrapper_class = is_mobile_menu ? 'secondary-menu-link secondary-menu-link-icon' : 'navigation-bar-item' ~ (is_pill ? ' qd-nav-pill') %}
{# CPAP Fit: com "texto do link" o item não vira link inteiro; o link aparece como "ver regras" ao lado #}
{% set separate_link = item.link and item.link_label %}
{% set wrap_link = item.link and not separate_link %}

{# "Mostrar este benefício" desligado: o item some sem perder o que foi preenchido #}
{% if item.qd_enabled is not same as(false) %}

{% if is_mobile_menu %}
	<li class="secondary-menu-item">
{% endif %}

  {% if wrap_link %}
    <a href="{{ item.link }}" class="{{ wrapper_class }}"{% include 'snippets/qd-link-attrs.tpl' with { url: item.link } %} {% if not is_mobile_menu %}{{ block | block_attributes }}{% endif %}>
  {% elseif is_mobile_menu %}
    <span class="{{ wrapper_class }}">
  {% else %}
    <div class="{{ wrapper_class }}" {{ block | block_attributes }}>
  {% endif %}

    {% if is_pill %}
      {# pílula: só o texto, na cor escolhida #}
    {% elseif use_custom_image and not is_mobile_menu %}
      {% include 'snippets/image.tpl' with {
        image_src: item.custom_image,
        image_alt: '',
        image_lazy_js: true,
        image_classes: 'fade-in',
      } %}
    {% else %}
      {% include 'snippets/icon.tpl' with { name: item.icon | default('shipping'), class: 'icon-inline' } %}
    {% endif %}

    {% if item.description %}
      <span{% if is_pill and item.qd_pill_color %} style="background-color: {{ item.qd_pill_color }};"{% endif %}>{{ item.description | raw }}</span>
    {% endif %}

    {% if separate_link %}
      <a href="{{ item.link }}" class="qd-nav-item-link"{% include 'snippets/qd-link-attrs.tpl' with { url: item.link } %}>{{ item.link_label }}</a>
    {% endif %}

    {% if item.coupon_code and not is_mobile_menu %}
      <span class="qd-nav-coupon">
        <span class="qd-coupon-code">{{ item.coupon_code }}</span>
        <button type="button" class="qd-coupon-copy" data-qd-copy="{{ item.coupon_code }}">Copiar</button>
      </span>
    {% endif %}

  {% if wrap_link %}
    </a>
  {% elseif is_mobile_menu %}
    </span>
  {% else %}
    </div>
  {% endif %}

{% if is_mobile_menu %}
	</li>
{% endif %}

{% endif %}

{% schema %}
{
  "name": "Benefício",
  "icon": "HeartIcon",
  "settings": [
    {
      "type": "setting",
      "setting_type": "toggle",
      "id": "qd_enabled",
      "label": "Mostrar este benefício",
      "info": "Desligado: o benefício some da barra, mas o que foi preenchido fica guardado.",
      "default": true
    },
    {
      "type": "setting",
      "setting_type": "icon_picker",
      "id": "icon",
      "label": "Ícone",
      "options": [
        {
          "value": "shipping",
          "label": "t:options.icon_shipping",
          "sprite_id": "truck"
        },
        {
          "value": "card",
          "label": "t:options.icon_credit_card",
          "sprite_id": "credit-card"
        },
        {
          "value": "security",
          "label": "t:options.icon_security"
        },
        {
          "value": "returns",
          "label": "t:options.icon_returns"
        },
        {
          "value": "cash",
          "label": "t:options.icon_cash"
        },
        {
          "value": "promotions",
          "label": "t:options.icon_promotions"
        },
        {
          "value": "bag",
          "label": "t:options.icon_bag"
        },
        {
          "value": "cart",
          "label": "t:options.icon_cart"
        },
        {
          "value": "store",
          "label": "t:options.icon_store"
        },
        {
          "value": "gift",
          "label": "t:options.icon_gift"
        },
        {
          "value": "heart",
          "label": "t:options.icon_heart"
        },
        {
          "value": "star",
          "label": "t:options.icon_star"
        },
        {
          "value": "phone",
          "label": "t:options.icon_phone"
        },
        {
          "value": "email",
          "label": "t:options.icon_email"
        },
        {
          "value": "location",
          "label": "t:options.icon_location"
        },
        {
          "value": "world",
          "label": "t:options.icon_world"
        },
        {
          "value": "calendar",
          "label": "t:options.icon_calendar"
        },
        {
          "value": "check",
          "label": "t:options.icon_check"
        },
        {
          "value": "whatsapp",
          "label": "WhatsApp",
          "sprite_id": "whatsapp-alt"
        },
        {
          "value": "qd-pix",
          "label": "Pix",
          "sprite_id": "qd-pix"
        },
        {
          "value": "qd-card",
          "label": "Cartão (CPAP Fit)",
          "sprite_id": "qd-card"
        },
        {
          "value": "qd-box",
          "label": "Caixa (CPAP Fit)",
          "sprite_id": "qd-box"
        },
        {
          "value": "qd-tag",
          "label": "Etiqueta (CPAP Fit)",
          "sprite_id": "qd-tag"
        }
      ],
      "default": "shipping"
    },
    {
      "type": "setting",
      "setting_type": "richtext",
      "id": "description",
      "label": "Texto",
      "default": "t:defaults.icon_text.item_1_description",
      "info": "Use negrito para o destaque, ex.: **10% off** no pix."
    },
    {
      "type": "setting",
      "setting_type": "url",
      "id": "link",
      "label": "Link",
      "info": "Página aberta ao clicar. Use o endereço da loja, ex.: /mascaras/ ou /produtos/?brand=Resmed."
    },
    {
      "type": "setting",
      "setting_type": "text",
      "id": "link_label",
      "label": "Texto do link",
      "info": "Ex.: ver regras. Vazio: o benefício inteiro vira o link."
    },
    {
      "type": "setting",
      "setting_type": "text",
      "id": "coupon_code",
      "label": "Cupom",
      "info": "Ex.: QUERO100. Aparece com o botão Copiar. Vazio: sem cupom."
    },
    {
      "type": "setting",
      "setting_type": "toggle",
      "id": "qd_pill",
      "label": "Destacar como botão",
      "info": "Mostra o texto dentro de um botão colorido, sem ícone. Ex.: Acompanhamento PASSOS.",
      "default": false
    },
    {
      "type": "setting",
      "setting_type": "color",
      "id": "qd_pill_color",
      "label": "Cor do botão",
      "default": "#8E2C8A",
      "visible_if": "{{ block.settings.qd_pill }}"
    }
  ]
}
{% endschema %}
