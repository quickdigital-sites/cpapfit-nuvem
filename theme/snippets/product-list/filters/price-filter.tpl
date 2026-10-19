{#
  Price Filter
  Min/max price range filter for product grid.
#}
<div class="js-price-filter-container {{ accordion ? 'price-filter-container filter-accordion' : 'price-filter-container' }}" data-store="filters-group" data-component="list.filter-price">
	<form>
		<div class="{{ accordion ? 'price-filter-label' : 'filters-title' }}">{{ 'filters.price.label' | t }}</div>
		{# CPAP Fit (Figma 35:10301): faixa de preço com dois controles deslizantes. Grava nos campos
		   nativos min_price/max_price abaixo (que ficam escondidos) e aplica ao soltar — mesmo contrato
		   de URL do filtro nativo. Script: frontend/src/js/components/price-range.js #}
		{% set qd_range = product_filter.custom_data.price_range %}
		{% if qd_range and qd_range['max_price'] and qd_range['max_price'] > qd_range['min_price'] %}
			<div class="js-qd-price-range qd-price-range" data-min="{{ qd_range['min_price'] | round(0, 'floor') }}" data-max="{{ qd_range['max_price'] | round(0, 'ceil') }}">
				<div class="qd-price-range-track"><span class="qd-price-range-fill"></span></div>
				<input type="range" class="qd-price-range-input" data-bound="min" aria-label="{{ 'filters.price.from' | t }}" step="1">
				<input type="range" class="qd-price-range-input" data-bound="max" aria-label="{{ 'filters.price.to' | t }}" step="1">
				<div class="qd-price-range-labels"><span data-label="min"></span><span data-label="max"></span></div>
			</div>
		{% endif %}
		<div class="form-group">
			<span class="js-filter-input-price-container filter-input-price-container">
				<label class="form-label">{{ 'filters.price.from' | t }}</label>
				<input
					type="number"
					name="min_price"
					step="1" min="0"
					pattern="\d*"
					oninput="validity.valid||(value='');"
					class="js-price-filter-input form-control filter-input-price"
					data-component="list.filter-price.min"
					value="{{ params['min_price'] }}"
					placeholder="{{ product_filter.custom_data.price_range['min_price'] }}"
				>
				<button type="button" class="js-price-filter-empty input-clear-content" style="display:none" aria-label="{{ 'general.clear' | t }}">
						<svg class="icon-inline"><use xlink:href="#times"/></svg>
				</button>  
			</span>
			<span class="js-filter-input-price-container filter-input-price-container">
				<label class="form-label">{{ 'filters.price.to' | t }}</label>
				<input
					type="number"
					name="max_price"
					step="1" min="0"
					pattern="\d*"
					oninput="validity.valid||(value='');"
					class="js-price-filter-input form-control filter-input-price"
					data-component="list.filter-price.max"
					value="{{ params['max_price'] }}"
					placeholder="{{ product_filter.custom_data.price_range['max_price'] }}"
				>
				<button type="button" class="js-price-filter-empty input-clear-content" style="display:none" aria-label="{{ 'general.clear' | t }}">
						<svg class="icon-inline"><use xlink:href="#times"/></svg>
				</button>
			</span>
			<button type="submit" class="js-price-filter-btn btn btn-inline price-filter-btn disabled" disabled data-component="list.filter-price.submit">
				{{ 'filters.price.apply' | t }}
				{% if not accordion %}
					<svg class="price-filter-btn-icon icon-inline"><use xlink:href="#chevron"/></svg>
				{% endif %}
			</button>
		</div>
	</form>
</div>
