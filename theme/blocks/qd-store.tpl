{# CPAP Fit — Loja física (card da página Nossas lojas, Figma 271:3986). Campos editáveis no editor. #}
{%- set s = block.settings -%}
{%- set uf = s.uf | default('') | upper | trim -%}
{#- o Twig da plataforma não aceita replace com mapa: um replace por caractere -#}
{%- set phone_digits = s.phone | default('') | replace('(', '') | replace(')', '') | replace(' ', '') | replace('-', '') | replace('.', '') -%}
{%- set wa_digits = s.whatsapp | default('') | replace('(', '') | replace(')', '') | replace(' ', '') | replace('-', '') | replace('.', '') | replace('+', '') -%}
{%- set map_query = (s.address ~ ' ' ~ s.address_2) | e('url') -%}
{% if s.name %}
<article class="qd-store" data-uf="{{ uf }}" {{ block | block_attributes }}>
	{% if s.image %}
		{% include 'snippets/image.tpl' with {
			image_src: s.image,
			image_alt: s.name,
			image_classes: 'qd-store-img',
			image_lazy_js: true,
		} %}
	{% endif %}
	<div class="qd-store-title">
		<h3>{{ s.name }}</h3>
		{% if s.subtitle %}<p>{{ s.subtitle }}</p>{% endif %}
	</div>
	<div class="qd-store-details">
		{% if s.address or s.address_2 %}
			<p class="qd-store-address">{{ s.address }}{% if s.address and s.address_2 %}<br>{% endif %}{{ s.address_2 }}</p>
		{% endif %}
		{% if s.hours %}
			<div>
				<p class="qd-store-label">Horário de Funcionamento:</p>
				<div class="qd-store-value">{{ s.hours | raw }}</div>
			</div>
		{% endif %}
		{% if s.phone or s.email %}
			<div>
				{% if s.phone %}
					<p class="qd-store-label">Telefone:</p>
					<p class="qd-store-value"><a href="tel:{{ phone_digits }}">{{ s.phone }}</a></p>
				{% endif %}
				{% if s.email %}
					<p class="qd-store-email"><a href="mailto:{{ s.email }}">{{ s.email }}</a></p>
				{% endif %}
			</div>
		{% endif %}
	</div>
	{% if wa_digits or s.address %}
		<div class="qd-store-actions">
			{% if wa_digits %}
				<a class="qd-store-btn" href="https://wa.me/{{ wa_digits }}" target="_blank" rel="noopener">
					<svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M7.25 18.49L7.98 18.92C9.19 19.62 10.57 20 12 20C16.42 20 20 16.42 20 12C20 7.58 16.42 4 12 4C7.58 4 4 7.58 4 12C4 13.44 4.38 14.81 5.08 16.02L5.51 16.75L4.85 19.15L7.25 18.49ZM2.01 22L3.36 17.03C2.49 15.55 2 13.83 2 12C2 6.48 6.48 2 12 2C17.52 2 22 6.48 22 12C22 17.52 17.52 22 12 22C10.17 22 8.45 21.51 6.97 20.64L2.01 22ZM8.39 7.31C8.53 7.3 8.66 7.3 8.79 7.3C8.85 7.31 8.9 7.31 8.96 7.32C9.12 7.34 9.29 7.44 9.35 7.57C9.65 8.25 9.94 8.93 10.22 9.61C10.28 9.76 10.24 9.96 10.13 10.15C10.07 10.24 9.97 10.38 9.86 10.52C9.75 10.66 9.51 10.93 9.51 10.93C9.51 10.93 9.41 11.05 9.44 11.19C9.46 11.25 9.51 11.33 9.55 11.4C9.57 11.44 9.59 11.47 9.61 11.49C9.86 11.92 10.21 12.35 10.63 12.76C10.75 12.88 10.86 13 10.99 13.11C11.46 13.52 11.99 13.86 12.56 14.11C12.65 14.15 12.69 14.17 12.82 14.22C12.88 14.25 12.94 14.27 13.01 14.29C13.03 14.29 13.06 14.3 13.08 14.3C13.24 14.31 13.34 14.2 13.37 14.16C14.1 13.28 14.16 13.22 14.17 13.22C14.26 13.12 14.41 13.09 14.55 13.1C14.61 13.1 14.67 13.11 14.72 13.14C15.26 13.38 16.13 13.76 16.13 13.76L16.71 14.02C16.8 14.07 16.89 14.18 16.9 14.29C16.9 14.35 16.91 14.46 16.88 14.66C16.85 14.92 16.77 15.23 16.7 15.39C16.64 15.51 16.57 15.61 16.49 15.69C16.37 15.81 16.29 15.88 16.16 15.98C16.07 16.04 16.03 16.07 16.03 16.07C15.89 16.16 15.81 16.2 15.65 16.29C15.39 16.43 15.11 16.51 14.82 16.52C14.63 16.53 14.44 16.54 14.26 16.53C14.25 16.53 13.69 16.45 13.69 16.45C12.27 16.07 10.95 15.37 9.85 14.4C9.62 14.2 9.42 13.99 9.2 13.78C8.31 12.89 7.64 11.94 7.23 11.03C7.03 10.59 6.9 10.11 6.9 9.62C6.9 9.01 7.1 8.42 7.47 7.94C7.54 7.85 7.61 7.75 7.73 7.64C7.85 7.52 7.93 7.45 8.02 7.41C8.14 7.35 8.26 7.32 8.39 7.31Z"/></svg>
					Fale com a loja
				</a>
			{% endif %}
			{% if s.address %}
				<a class="qd-store-btn qd-store-btn--map" href="{{ s.map_url | default('https://www.google.com/maps/search/?api=1&query=' ~ map_query) }}" target="_blank" rel="noopener">
					<svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M20.38 21.13c-.2 0-.39-.08-.53-.22l-6.38-6.38a.75.75 0 0 1 0-1.06l7.73-7.73a.75.75 0 0 1 1.26.36c.19.85.29 1.8.29 2.9v6c0 2.77-.58 4.64-1.84 5.91-.14.14-.35.17-.53.22ZM15.06 14l5.26 5.26c.63-.97.93-2.35.93-4.26V9c0-.41-.01-.79-.04-1.15L15.06 14Z"/><path d="M6.27 22.48c-.06 0-.11-.01-.17-.02C2.79 21.7 1.25 19.33 1.25 15V9c0-5.43 2.32-7.75 7.75-7.75h6c4.33 0 6.7 1.54 7.46 4.85.06.25-.02.52-.2.7L6.8 22.26a.75.75 0 0 1-.53.22ZM9 2.75C4.39 2.75 2.75 4.39 2.75 9v6c0 3.47.96 5.21 3.29 5.9L20.89 6.05c-.68-2.33-2.43-3.29-5.9-3.29H9v-.01Z"/><path d="M15 22.75H9c-1.1 0-2.04-.09-2.9-.29a.75.75 0 0 1-.36-1.26l7.73-7.73a.75.75 0 0 1 1.06 0l6.38 6.38a.75.75 0 0 1 0 1.06c-1.27 1.26-3.14 1.84-5.91 1.84Zm-7.15-1.54c.36.03.74.04 1.15.04h6c1.92 0 3.29-.3 4.26-.93L14 15.06l-6.15 6.15Z"/><path d="M9.12 13.31c-.63 0-1.26-.23-1.76-.7-1.59-1.51-2.23-3.17-1.85-4.79.38-1.66 1.83-2.78 3.61-2.78 1.78 0 3.23 1.12 3.61 2.78.37 1.63-.27 3.28-1.86 4.79-.49.46-1.12.7-1.75.7Zm-2.15-5.16c-.32 1.36.6 2.58 1.43 3.37.41.39 1.04.39 1.44 0 .82-.78 1.74-2 1.43-3.37-.27-1.19-1.33-1.62-2.15-1.62-.82 0-1.87.43-2.15 1.62Z"/><path d="M9.15 9.49c-.55 0-1-.45-1-1s.44-1 1-1h.01c.55 0 1 .45 1 1s-.46 1-1.01 1Z"/></svg>
					Como chegar
				</a>
			{% endif %}
		</div>
	{% endif %}
</article>
{% endif %}

{% schema %}
{
  "name": "Loja",
  "icon": "StoreIcon",
  "settings": [
    { "type": "paragraph", "content": "Uma loja física. Sem nome, o card não aparece." },
    { "type": "setting", "setting_type": "text", "id": "name", "label": "Nome da loja", "info": "Título do card. Ex.: Florianópolis - SC." },
    { "type": "setting", "setting_type": "text", "id": "uf", "label": "Estado (sigla)", "info": "Duas letras, ex.: SC. Cria o filtro por estado no topo da página." },
    { "type": "setting", "setting_type": "image_picker", "id": "image", "label": "Foto da loja", "info": "Horizontal, 900 × 440 px, JPG ou WebP. Vazio: o card fica sem foto." },
    { "type": "setting", "setting_type": "text", "id": "subtitle", "label": "Subtítulo", "info": "Linha cinza abaixo do nome (opcional). No celular não aparece." },
    { "type": "setting", "setting_type": "text", "id": "address", "label": "Endereço (linha 1)", "info": "Rua, número e complemento." },
    { "type": "setting", "setting_type": "text", "id": "address_2", "label": "Endereço (linha 2)", "info": "Bairro, cidade, estado e CEP." },
    { "type": "setting", "setting_type": "richtext", "id": "hours", "label": "Horário de funcionamento", "info": "Uma linha por período. Ex.: Seg. a Sex. das 09h às 18h." },
    { "type": "setting", "setting_type": "text", "id": "phone", "label": "Telefone", "info": "Como deve aparecer, ex.: (48) 4042-1861." },
    { "type": "setting", "setting_type": "text", "id": "email", "label": "E-mail" },
    { "type": "setting", "setting_type": "text", "id": "whatsapp", "label": "WhatsApp", "info": "Com DDI e DDD, ex.: 55 48 4042-1861. Cria o botão \"Fale com a loja\". Vazio: sem botão." },
    { "type": "setting", "setting_type": "url", "id": "map_url", "label": "Link do mapa (opcional)", "info": "Vazio: o botão \"Como chegar\" abre o Google Maps com o endereço." }
  ]
}
{% endschema %}
