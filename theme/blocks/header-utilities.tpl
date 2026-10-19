{# Header Utilities — menu, search, language, account, cart #}
{# All are located positioned with CSS depending on logo position #}

{% set cart_icon = block.settings.cart_icon | default('bag') %}
{% set show_account_mobile = block.settings.show_account_mobile %}
{% set show_languages_header = block.settings.show_languages_header %}
{% set block_id = block.id %}
{% set block_type = block.type %}

{# Menu toggle — mobile only #}
<div class="menu-container d-md-none" data-block-id="{{ block_id }}" data-block-type="{{ block_type }}">
	<button class="js-modal-open-private header-icon" data-target="#nav-hamburger" data-modal-url="#nav-hamburger" aria-label="{{ 'accessibility.open_menu' | t }}">
		<svg class="utility-icon icon-inline"><use xlink:href="#menu"/></svg>
	</button>
</div>

{# Search #}
<div class="js-search-container search-container" data-block-id="{{ block_id }}" data-block-type="{{ block_type }}">
	<button class="js-search-trigger search-trigger header-icon header-utility"
		aria-label="{{ 'search.placeholder' | t }}" aria-expanded="false">
		{% include 'snippets/icon.tpl' with { name: 'search', class: 'utility-icon' } %}
		{% if show_text %}
			<span class="utility-text search-text d-none d-md-inline">{{ 'search.placeholder' | t }}</span>
		{% endif %}
	</button>
	<div class="js-search-expand-form search-floating-container" aria-hidden="true">
		{% include 'snippets/header/search-form.tpl' %}
	</div>
</div>

{# Language selector — desktop only, icons mode #}
{% if languages | length > 1 and not show_text and show_languages_header %}
	<span class="utilities-language-desktop d-none d-md-inline-block" data-block-id="{{ block_id }}" data-block-type="{{ block_type }}">
		{% include 'snippets/header/header-language.tpl' %}
	</span>
{% endif %}

{# CPAP Fit: pílula "Planos de assinatura" e atalho para as lojas físicas (Figma 24:594 / 24:603).
   Textos e links editáveis no Brand Editor (bloco Utilitários). Só aparecem no desktop (CSS). #}
{% if block.settings.plans_url %}
	<a href="{{ block.settings.plans_url }}" class="qd-plans-pill" data-block-id="{{ block_id }}" data-block-type="{{ block_type }}">
		<span class="qd-plans-pill__icon"><svg class="icon-inline" aria-hidden="true"><use xlink:href="#qd-bookmark"/></svg></span>
		<span class="qd-plans-pill__text">
			<span class="qd-plans-pill__title">{{ block.settings.plans_title }}</span>
			{% if block.settings.plans_subtitle %}<span class="qd-plans-pill__sub">{{ block.settings.plans_subtitle }}</span>{% endif %}
		</span>
		<span class="qd-plans-pill__arrow"><svg class="icon-inline" aria-hidden="true"><use xlink:href="#qd-arrow-right"/></svg></span>
	</a>
{% endif %}
{% if block.settings.stores_url %}
	<a href="{{ block.settings.stores_url }}" class="qd-stores-link header-icon" aria-label="{{ block.settings.stores_label | default('Nossas lojas') }}" data-block-id="{{ block_id }}" data-block-type="{{ block_type }}">
		<svg class="utility-icon icon-inline" aria-hidden="true"><use xlink:href="#qd-pin"/></svg>
	</a>
{% endif %}

{# Account #}
<span class="js-header-dropdown header-account header-utility nav-dropdown {% if not show_account_mobile %}d-none d-md-grid{% endif %}" data-block-id="{{ block_id }}" data-block-type="{{ block_type }}">
	<a href="{{ customer ? store.customer_home_url : store.customer_login_url }}" class="header-icon" aria-label="{{ 'general.my_account' | t }}">
		<svg class="utility-icon icon-inline"><use xlink:href="#qd-user"/></svg>
	</a>
	{% if show_text %}
		<span class="utility-text header-account-label d-none d-md-inline">
			{{ 'general.my_account' | t }}
			<svg class="nav-dropdown-icon icon-inline"><use xlink:href="#chevron"/></svg>
		</span>
	{% endif %}
	{# Desktop dropdown — hidden on mobile via CSS #}
	{% set account_short_name = customer ? (customer.name | split(' ') | first) %}
	<div class="js-header-dropdown-content nav-dropdown-content desktop-dropdown desktop-dropdown-small">
		{% if customer %}
			<a href="{{ store.customer_home_url }}" class="header-dropdown-link header-dropdown-link-featured">{{ 'general.greeting' | t | replace('{1}', account_short_name) }}</a>
			<a href="{{ store.customer_logout_url }}" class="header-dropdown-link">{{ 'general.logout' | t }}</a>
		{% else %}
			{% set register_href = store_has_passwordless_login
				? store.customer_login_url
				: store.customer_register_url %}
			<a href="{{ store.customer_login_url }}" class="header-dropdown-link header-dropdown-link-featured">{{ 'general.login' | t }}</a>
			<a href="{{ register_href }}" class="header-dropdown-link">{{ 'general.register' | t }}</a>
		{% endif %}
	</div>
</span>

{# Cart #}
{% set use_ajax_cart = settings.ajax_cart and template != 'cart' %}

{% set cart_content %}
	<span class="header-icon">
		<svg class="utility-icon icon-inline"><use xlink:href="#{{ cart_icon == 'cart' ? 'qd-cart' : cart_icon }}"/></svg>
		<span class="js-cart-widget-amount badge {% if cart_icon == 'bag' %}badge-bottom{% endif %}" {% if cart.items_count == 0 %}style="display: none;"{% endif %}>{{ cart.items_count }}</span>
	</span>
	{% if show_text %}
		<div class="utility-text header-cart-text">
			<span class="js-cart-widget-total" data-priceraw="{{ cart.total }}">{{ cart.total | money }}</span>
		</div>
	{% endif %}
{% endset %}

<span id="ajax-cart" class="js-cart-container header-cart header-utility" data-component="cart-button" data-block-id="{{ block_id }}" data-block-type="{{ block_type }}">
	{% if use_ajax_cart %}
		<button class="js-modal-open-private header-utility" data-target="#modal-cart" aria-label="{{ 'general.shopping_cart' | t }}">
			{{ cart_content }}
		</button>
	{% else %}
		<a href="{{ store.cart_url }}" class="header-utility" aria-label="{{ 'general.shopping_cart' | t }}">
			{{ cart_content }}
		</a>
	{% endif %}
</span>

{% schema %}
{
  "name": "Busca, Planos, lojas, conta e carrinho",
  "icon": "SearchIcon",
  "limit": 1,
  "settings": [
    {
      "type": "setting",
      "setting_type": "text",
      "id": "plans_title",
      "label": "Título da pílula de Planos",
      "default": "Planos de assinatura",
      "info": "Ex.: Planos de assinatura."
    },
    {
      "type": "setting",
      "setting_type": "text",
      "id": "plans_subtitle",
      "label": "Subtítulo da pílula de Planos",
      "info": "Ex.: Descontos e benefícios exclusivos!"
    },
    {
      "type": "setting",
      "setting_type": "url",
      "id": "plans_url",
      "label": "Link da pílula de Planos",
      "info": "Página dos planos, ex.: /planos-de-assinatura/. Vazio: a pílula some."
    },
    {
      "type": "setting",
      "setting_type": "url",
      "id": "stores_url",
      "label": "Link do ícone de localização",
      "info": "Página das lojas físicas, ex.: /nossas-lojas/. Vazio: o ícone some."
    }
  ]
}
{% endschema %}
