{# Header Desktop Navigation #}

{# Navigation settings from block #}
{% set nav_uppercase = block.settings.nav_uppercase %}
{% set show_categories_link = block.settings.show_categories_link %}
{% set show_featured_link = block.settings.show_featured_link %}
{% set featured_link_item = show_featured_link ? block.settings.featured_link_item %}
{% set featured_link_color = block.settings.featured_link_color %}
{% set show_secondary_menu = block.settings.show_secondary_menu %}
{% set secondary_menu_id = block.settings.menu %}

{# CPAP Fit: troca um subitem do menu (ex.: Serviços › Apoio e Monitoramento de CPAP) pelo Acompanhamento PASSOS.
   Campos "PASSOS no menu" deste bloco; o mesmo vale no menu do celular (snippets/navigation/navigation-list-hamburger.tpl).
   A categoria do admin não muda: só o link mostrado no menu. #}
{% set qd_swap_on = block.settings.qd_passos_enabled is not same as(false) %}
{% set qd_swap_match = block.settings.qd_passos_match | default('/servicos/apoio-e-monitoramento-de-cpap/') %}
{% set qd_swap_label = block.settings.qd_passos_label | default('Acompanhamento PASSOS') %}
{% set qd_swap_url = block.settings.qd_passos_url | default('https://acompanhamento.oxisaude.com.br/?utm_source=cpapfit&utm_campaign=passos&utm_medium=servicos') %}

{# Derived layout classes #}
{% set secondary_menu_links = secondary_menu_id ? menus[secondary_menu_id] | default([]) : [] %}
{% set has_secondary_menu = show_secondary_menu and secondary_menu_links | length > 0 %}
{% set has_languages = languages | length > 1 %}
{% set utilities_languages_secondary_nav = has_languages and show_text %}
{% set nav_secondary_col = has_secondary_menu or utilities_languages_secondary_nav %}
{% set nav_alignment_desktop = block.settings.nav_alignment_desktop | default('left') %}
{% set nav_desktop_grid_class = 'nav-desktop-grid' ~ (nav_alignment_desktop == 'center' ? ' nav-desktop-grid-center') %}
{% set nav_desktop_text_class = nav_uppercase ? 'nav-desktop-uppercase' %}

{# Section-level layout (accessed via inherited scope) #}
{% set full_width = section.settings.section_width == 'full' %}
{% set page_width = section.settings.section_width == 'page' %}
{% set horizontal_padding = full_width ? section.settings.horizontal_padding : 0 %}

{# Reusable inline padding for full-width dropdowns #}
{% set horizontal_padding_style = full_width and horizontal_padding ? 'padding-left: ' ~ horizontal_padding ~ 'px; padding-right: ' ~ horizontal_padding ~ 'px;' : '' %}

<div class="nav-desktop-container d-none d-md-block" {{ block | block_attributes }}>
	<div class="js-nav-desktop-container {{ nav_desktop_grid_class }} {% if page_width %}container{% endif %}" style="visibility:hidden; height:0; {{ horizontal_padding_style }}">

		{# Categories column #}
		{% if show_categories_link %}
			<div class="js-desktop-main-categories-col nav-desktop-grid-categories nav-desktop-list {{ nav_desktop_text_class }}">
				<nav class="nav-desktop position-relative">
					<ul class="nav-desktop-list list-unstyled">
						<li class="nav-item nav-main-item nav-dropdown">
							<a href="{{ store.categories_url }}" class="nav-list-link nav-list-link-heading">
								{{ 'general.categories' | t }}
								<svg class="nav-list-link-icon icon-inline"><use xlink:href="#chevron"/></svg>
							</a>
							<div class="js-desktop-dropdown nav-dropdown-content desktop-dropdown">
								<div class="{% if page_width %}container{% endif %} desktop-dropdown-container" {% if horizontal_padding_style %}style="{{ horizontal_padding_style }}"{% endif %}>
						<ul class="desktop-list-subitems list-unstyled">
									{% for category in categories %}
										<li class="nav-item">
											<a href="{{ category.url }}" class="nav-list-link nav-list-link-heading">{{ category.name }}</a>
											{% set subcategories = category.subcategories(false) %}
											{% if subcategories %}
												<ul class="list-subitems list-unstyled">
													{% for subcategory in subcategories %}
														<li class="nav-item">
															<a href="{{ subcategory.url }}" class="nav-list-link">{{ subcategory.name }}</a>
														</li>
													{% endfor %}
												</ul>
											{% endif %}
										</li>
									{% endfor %}
								</ul>
							</div>
							</div>
						</li>
					</ul>
				</nav>
			</div>
		{% endif %}

		{# Main navigation column #}
		<div class="js-desktop-nav-col nav-desktop-grid-main {{ nav_desktop_text_class }}">
			<nav class="nav-desktop position-relative">
				<button type="button" class="js-nav-desktop-list-arrow js-nav-desktop-list-arrow-left nav-desktop-list-arrow nav-desktop-list-arrow-left disable" aria-label="{{ 'general.previous' | t }}" style="display: none">
					<svg class="nav-arrow-icon icon-flip-horizontal icon-inline"><use xlink:href="#chevron"/></svg>
				</button>
				<ul class="js-nav-desktop-list nav-desktop-list list-unstyled">
				{% for item in navigation %}
					{% set is_featured = featured_link_item and item.name == featured_link_item %}
					{# Collect banner blocks assigned to this item or to all items #}
					{% set matched_banners = [] %}
					{% for child_block in block.blocks %}
						{% set is_banner = child_block.type == 'navigation-banner' and child_block.settings.image %}
						{% set matches_item = child_block.settings.menu_item == item.name or child_block.settings.menu_item == '_all' %}
						{% if is_banner and matches_item %}
							{% set matched_banners = matched_banners | merge([child_block]) %}
						{% endif %}
					{% endfor %}
					{% set banner_count = matched_banners | length %}
					{% set has_dropdown = item.subitems or banner_count > 0 %}

					<li class="nav-item nav-main-item {% if has_dropdown %}nav-dropdown{% endif %}">
						<a href="{{ item.url }}"{% include 'snippets/qd-link-attrs.tpl' with { url: item.url } %} class="nav-list-link {% if is_featured %}nav-list-link-featured{% endif %} {% if is_featured and featured_link_color %}nav-list-link-featured-color{% endif %}" {% if is_featured and featured_link_color %}style="color: {{ featured_link_color }} !important;"{% endif %}>
							{{ item.name }}
							{% if has_dropdown %}
								<svg class="nav-list-link-icon icon-inline" {% if is_featured and featured_link_color %}style="fill: {{ featured_link_color }} !important;"{% endif %}><use xlink:href="#chevron"/></svg>
							{% endif %}
						</a>
							{% if has_dropdown %}
								{# Links span remaining columns; 5+ banners stack on a second row #}
								{% set col_count = (banner_count == 0 or banner_count >= 5) ? 5 : max(1, 5 - banner_count) %}

								<div class="js-desktop-dropdown nav-dropdown-content desktop-dropdown">
									<div class="{% if page_width %}container{% endif %} desktop-dropdown-container" {% if horizontal_padding_style %}style="{{ horizontal_padding_style }}"{% endif %}>
										{% if item.subitems %}
											<ul class="desktop-list-subitems list-unstyled" {% if banner_count > 0 %}style="grid-column: span {{ col_count }}; column-count: {{ col_count }};"{% endif %}>
												{% for subitem in item.subitems %}
													{% set qd_is_swap = qd_swap_on and qd_swap_match and qd_swap_match in subitem.url %}
													{% set subitem_url = qd_is_swap ? qd_swap_url : subitem.url %}
													<li class="nav-item">
														<a href="{{ subitem_url }}"{% include 'snippets/qd-link-attrs.tpl' with { url: subitem_url } %} class="nav-list-link nav-list-link-heading">{{ qd_is_swap ? qd_swap_label : subitem.name }}</a>
														{% if subitem.subitems %}
															<ul class="list-subitems list-unstyled">
																{% for subsubitem in subitem.subitems %}
																	<li class="nav-item">
																		<a href="{{ subsubitem.url }}"{% include 'snippets/qd-link-attrs.tpl' with { url: subsubitem.url } %} class="nav-list-link">{{ subsubitem.name }}</a>
																	</li>
																{% endfor %}
															</ul>
														{% endif %}
													</li>
												{% endfor %}
											</ul>
										{% endif %}
										{% if banner_count > 0 %}
											<div class="nav-desktop-banners">
												{% for child_block in matched_banners %}
													{% include 'blocks/navigation-banner.tpl' with { block: child_block, } %}
												{% endfor %}
											</div>
										{% endif %}
									</div>
								</div>
							{% endif %}
						</li>
					{% endfor %}
				</ul>
				<button type="button" class="js-nav-desktop-list-arrow js-nav-desktop-list-arrow-right nav-desktop-list-arrow nav-desktop-list-arrow-right" aria-label="{{ 'general.next' | t }}" style="display: none">
					<svg class="nav-arrow-icon icon-inline"><use xlink:href="#chevron"/></svg>
				</button>
			</nav>
		</div>

		{# Secondary navigation column #}
		{% if has_secondary_menu %}
			<div class="js-desktop-secondary-nav-col nav-desktop-secondary">
				<ul class="list-unstyled nav-desktop-secondary-list">
					{% for item in secondary_menu_links %}
						<li class="secondary-menu-item">
							<a class="secondary-menu-link nav-list-link" href="{{ item.url }}" {% if item.url | is_external %}target="_blank" rel="noopener noreferrer"{% endif %}>{{ item.name }}</a>
						</li>
					{% endfor %}
				</ul>
				{% if languages | length > 1 and show_text and show_languages_header %}
					{% include 'snippets/header/header-language.tpl' with {secondary_nav: true} %}
				{% endif %}
			</div>
		{% elseif languages | length > 1 and show_text and show_languages_header %}
			<div class="js-desktop-secondary-nav-col nav-desktop-secondary">
				{% include 'snippets/header/header-language.tpl' with {secondary_nav: true} %}
			</div>
		{% endif %}

	</div>
</div>

{% schema %}
{
  "name": "Menu",
  "icon": "MenuIcon",
  "limit": 1,
  "blocks": [
    {
      "type": "navigation-banner"
    }
  ],
  "settings": [
    {
      "type": "setting",
      "setting_type": "menu",
      "id": "menu",
      "label": "Menu principal",
      "info": "Os itens do menu são editados em Loja online › Menus, no painel da loja."
    },
    {
      "type": "header",
      "content": "PASSOS no menu"
    },
    {
      "type": "setting",
      "setting_type": "toggle",
      "id": "qd_passos_enabled",
      "label": "Trocar um item do menu pelo Acompanhamento PASSOS",
      "info": "Desligado: o menu volta a mostrar o item original do admin.",
      "default": true
    },
    {
      "type": "setting",
      "setting_type": "text",
      "id": "qd_passos_match",
      "label": "Endereço do item que será trocado",
      "info": "Parte do link do item no menu, ex.: /servicos/apoio-e-monitoramento-de-cpap/",
      "default": "/servicos/apoio-e-monitoramento-de-cpap/",
      "visible_if": "{{ block.settings.qd_passos_enabled }}"
    },
    {
      "type": "setting",
      "setting_type": "text",
      "id": "qd_passos_label",
      "label": "Texto no menu",
      "default": "Acompanhamento PASSOS",
      "visible_if": "{{ block.settings.qd_passos_enabled }}"
    },
    {
      "type": "setting",
      "setting_type": "url",
      "id": "qd_passos_url",
      "label": "Link",
      "default": "https://acompanhamento.oxisaude.com.br/?utm_source=cpapfit&utm_campaign=passos&utm_medium=servicos",
      "visible_if": "{{ block.settings.qd_passos_enabled }}"
    }
  ]
}
{% endschema %}
