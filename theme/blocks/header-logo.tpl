{# Header Logo - Store logo (image or text fallback) #}

<div class="logo-container {% if transparent_logo %}has-transparent-logo{% endif %}" {{ block | block_attributes }}>
	<div class="logo-default">
		{% if has_logo %}
			{% include 'snippets/logo/logo-img.tpl' %}
		{% else %}
			{% include 'snippets/logo/logo-text.tpl' %}
		{% endif %}
	</div>
	{% if transparent_logo %}
		<div class="logo-transparent">
			<a href="{{ store.url }}">
				{% include 'snippets/image.tpl' with {
					image_src: transparent_logo,
					image_classes: 'logo-img',
					image_alt: store.name,
				} %}
			</a>
		</div>
	{% endif %}
</div>

{% schema %}
{
  "name": "Logo",
  "icon": "FingerprintIcon",
  "limit": 1,
  "settings": [
    {
      "type": "paragraph",
      "content": "A imagem da logo é trocada em Configurações › Informações da loja, no painel."
    }
  ]
}
{% endschema %}
