{% if not cart_page %}

	{# Gift progress bar #}
	{% include "snippets/promotions/gift-promotion-progress.tpl" with {container_class: 'cart-summary-gift-promotion-bar'} %}

	{# Free shipping progress bar: no carrinho lateral fica no topo (snippets/cart/cart-panel.tpl, Figma 363:11409) #}

	{# Cart shipping and pickup #}

	{{ component('nubesdk-slot', { type: "before_cart_shipping_options" }) }}

	{% include "snippets/cart/cart-fulfillment.tpl" %}

	{{ component('nubesdk-slot', { type: "after_cart_shipping_options" }) }}

{% endif %}

{# Coupon input #}

{% if settings.cart_coupon %}
	<div class="js-visible-on-cart-filled" {% if cart.items_count == 0 %}style="display:none;"{% endif %}>
		{% include "snippets/promotions/coupon-input.tpl" %}
	</div>
{% endif %}

{% if cart_page %}

	<div id="cart-sticky-summary" class="position-sticky-md cart-page-totals">

		{# Gift progress bar #}
		{% include "snippets/promotions/gift-promotion-progress.tpl" with {container_class: 'cart-page-gift-promotion-bar d-none d-md-block'} %}

		{# Free shipping progress bar #}
		<div class="d-none d-md-block">
			<div class="js-visible-on-cart-filled" {% if cart.items_count == 0 %}style="display:none;"{% endif %}>
				{% include "snippets/shipping/shipping-free-rest.tpl" with {bar_classes: 'cart-page-free-shipping-bar'} %}
			</div>
		</div>

{% endif %}

		{# Cart totals #}

		{% if cart_page %}
			{% include "snippets/cart/cart-totals.tpl" %}
			{% include "snippets/cart/cart-button.tpl" with {cart_page: true} %}
		{% else %}
			{# Carrinho lateral (Figma 363:11206): subtotal no corpo; total, Pix e botão no rodapé fixo #}
			{% include "snippets/cart/cart-totals.tpl" with {qd_part: 'subtotals'} %}
			<div class="qd-cart-footer">
				{% include "snippets/cart/cart-totals.tpl" with {qd_part: 'total'} %}
				{% include "snippets/cart/cart-button.tpl" with {cart_page: false} %}
			</div>
		{% endif %}

{% if cart_page %}
	{# End of sticky module #}
	</div>
{% endif %}
