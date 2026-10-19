{% if store.allows_checkout_styling %}

{#/*============================================================================
checkout.scss.tpl

    -This file contains all the theme styles related to the checkout based on settings defined by user from config/settings.txt
    -Rest of styling can be found in:
        -static/css/style-async.css --> For non critical styles witch will be loaded asynchronously
        -static/css/style-critical.css --> For critical CSS rendered inline before the rest of the site

==============================================================================*/#}

{#/*============================================================================
  Global
==============================================================================*/#}

:root {

  {#/*============================================================================
    # Checkout tokens
  ==============================================================================*/#}

  {#### Colors settings #}

  {# Main colors #}

  {% set main_background = settings.checkout_main_background | default(settings.background_color) %}
  {% set main_foreground = settings.checkout_main_foreground | default(settings.text_color) %}
  {% set accent_color = settings.checkout_accent_color | default(settings.accent_color) %}

  {% set button_background = settings.checkout_button_background | default(settings.button_primary_background_color) %}
  {% set button_foreground = settings.checkout_button_foreground | default(settings.button_primary_foreground_color) %}
  {% set button_style = settings.button_primary_style | default('filled') %}

  {% set label_background = settings.label_background_color %}
  {% set label_foreground = settings.label_foreground_color %}
  {% set label_border_radius = settings.label_border_radius | default(4) %}
  {% set label_style = settings.label_style | default('filled') %}

  {% set header_background = settings.checkout_header_background | default(settings.background_color) %}
  {% set header_foreground = settings.checkout_header_foreground | default(settings.text_color) %}

  {#### Color tokens #}

  {# Auxiliar opacity hex levels #}
  {% set opacity_05 = '0D' %}
  {% set opacity_10 = '1A' %}
  {% set opacity_15 = '26' %}
  {% set opacity_20 = '33' %}
  {% set opacity_30 = '4D' %}
  {% set opacity_50 = '80' %}
  {% set opacity_60 = '99' %}
  {% set opacity_80 = 'CC' %}

  {# Accent color #}
  --accent-color: {{ accent_color }};
  --accent-color-opacity-05: {{ accent_color }}{{ opacity_05 }};
  --accent-color-opacity-10: {{ accent_color }}{{ opacity_10 }};
  --accent-color-opacity-15: {{ accent_color }}{{ opacity_15 }};
  --accent-color-opacity-20: {{ accent_color }}{{ opacity_20 }};
  --accent-color-opacity-30: {{ accent_color }}{{ opacity_30 }};
  --accent-color-opacity-50: {{ accent_color }}{{ opacity_50 }};
  --accent-color-opacity-60: {{ accent_color }}{{ opacity_60 }};
  --accent-color-opacity-80: {{ accent_color }}{{ opacity_80 }};

  {# Foreground color #}
  --main-foreground: {{ main_foreground }};
  --main-foreground-opacity-05: {{ main_foreground }}{{ opacity_05 }};
  --main-foreground-opacity-10: {{ main_foreground }}{{ opacity_10 }};
  --main-foreground-opacity-15: {{ main_foreground }}{{ opacity_15 }};
  --main-foreground-opacity-20: {{ main_foreground }}{{ opacity_20 }};
  --main-foreground-opacity-30: {{ main_foreground }}{{ opacity_30 }};
  --main-foreground-opacity-50: {{ main_foreground }}{{ opacity_50 }};
  --main-foreground-opacity-60: {{ main_foreground }}{{ opacity_60 }};
  --main-foreground-opacity-80: {{ main_foreground }}{{ opacity_80 }};

  {# Background color #}
  --main-background: {{ main_background }};
  --main-background-opacity-05: {{ main_background }}{{ opacity_05 }};
  --main-background-opacity-10: {{ main_background }}{{ opacity_10 }};
  --main-background-opacity-15: {{ main_background }}{{ opacity_15 }};
  --main-background-opacity-20: {{ main_background }}{{ opacity_20 }};
  --main-background-opacity-30: {{ main_background }}{{ opacity_30 }};
  --main-background-opacity-50: {{ main_background }}{{ opacity_50 }};
  --main-background-opacity-60: {{ main_background }}{{ opacity_60 }};
  --main-background-opacity-80: {{ main_background }}{{ opacity_80 }};

  {#### Component tokens #}

  {# General #}
  --border-radius: 4px;
  --box-border-radius: var(--border-radius);
  --border-color: var(--main-foreground-opacity-50);
  --box-border-color: var(--main-foreground-opacity-10);

  {# Buttons #}
  --button-foreground: {{ button_foreground }};
  --button-background: {{ button_background }};
  --button-border-color: {{ button_style == 'outline' ? 'var(--button-foreground)' : 'var(--button-background)' }};
  --button-border-radius: var(--border-radius);

  {# Labels #}
  --label-foreground: {{ label_foreground }};
  --label-background: {{ label_background }};

  --label-primary-background: var(--label-background);
  --label-primary-border-color: {{ label_style == 'outline' ? 'var(--label-foreground)' : 'var(--label-background)' }};
  --label-primary-foreground: var(--label-foreground);
  --label-primary-border-radius: {{ label_border_radius }}px;

  {# Header #}
  --header-foreground: {{ header_foreground }};
  --header-background: {{ header_background }};
  --header-logo-max-width: 100%;
  --header-logo-max-height: 40px;

  {# Footer #}
  --footer-foreground: {{ main_foreground }};
  --footer-background: {{ main_background }};

  {#### Typography #}

  {# Headings #}
  --heading-font: {{ settings.font_headings | default('Lexend') | raw }};
  --heading-font-weight: 400;
  --heading-text-transform: uppercase;
  --heading-letter-spacing: normal;

  {# Header #}
  --header-logo-font: var(--heading-font);
  --header-logo-font-size: 20px;
  --header-logo-font-weight: 700;
  --header-logo-text-transform: none;
  --header-logo-letter-spacing: normal;

  {# Body #}
  --body-font: {{ settings.font_rest | default('Lexend') | raw }};

  {#### Misc tokens #}

  {# Font sizes #}
  --font-base: 1rem;
  --font-medium: 0.875rem;
  --font-small: 0.75rem;
  --font-smallest: 0.625rem;

  {# Danger #}
  --danger: #c13a3a;
}

{# /* // Mixins */ #}

@mixin prefix($property, $value, $prefixes: ()) {
    @each $prefix in $prefixes {
        #{'-' + $prefix + '-' + $property}: $value;
    }
    #{$property}: $value;
}

{#/*============================================================================
  React
==============================================================================*/#}


$xs: 0;
$sm: 576px;
$md: 768px;
$lg: 992px;
$xl: 1200px;

body {
  font-family: var(--body-font);
  color: var(--main-foreground);
  background-color: var(--main-background);
  font-size: var(--font-medium);
}
a {
  color: var(--main-foreground);
  text-decoration: none;
  &:hover, &:focus {
    color: var(--main-foreground-opacity-60);

    svg {
      fill: var(--main-foreground);
    }
  }

  svg {
    fill: var(--accent-color);
  }
}

{# /* // Text */ #}

.title {
  color: var(--main-foreground);
}

.heading-small {
  font-size: var(--font-medium);
  font-weight: normal;
}

.text-small {
  font-size: var(--font-small);
}

{# /* // Header */ #}

.header {
  background-color: var(--main-background);
  border-color: var(--accent-color);
}

.security-seal {
  color: var(--header-foreground);
}

{# /* // Headbar */ #}

.headbar {
  padding: 0;
  background: var(--header-background);
  box-shadow: none;

  .container {
    max-width: 100%;
    width: 100%;
    padding: 0 15px;
    border: 0;

    .row {
      -ms-flex-align: center;
      align-items: center;

      {% if settings.logo_position_desktop == 'center' %}
        -ms-flex-pack: center!important;
        justify-content: center!important;

        > .text-left {
          text-align: center !important;
          -ms-flex: 0 0 50%;
          flex: 0 0 50%;
          max-width: 50%;
          margin-left: 25%;
        }
      {% endif %}
    }
  }
}

.headbar-logo-img {
  max-width: 100%;
  max-height: 40px;
}

.headbar-logo-text {
  float: none;
  color: var(--header-foreground);
  font-weight: 700;

  &:hover {
    color: var(--header-foreground);
    opacity: .8;
  }

  &:focus {
    color: var(--main-background);
  }
}

.headbar-continue {
  margin: 0 !important;
  font-weight: 400;
  color: var(--header-foreground);
  &:hover,
  &:focus {
    color: var(--header-foreground);
    opacity: .8;

    .headbar-continue-icon {
      fill: var(--header-foreground);
    }
  }
  &-icon {
    margin-left: 5px;
    fill: var(--header-foreground);
  }
}

{# /* // Form */ #}

.form-group {
  margin-bottom: 15px;
}
.form-control {
  background: var(--main-background);
  border-color: var(--border-color);
  color: var(--main-foreground);
  font-family: var(--body-font);
  border-radius: var(--border-radius);

  &:focus {
    border-color: var(--main-foreground);
    outline: none;
  }
}
.form-group.form-group-error .form-control {
  border-radius: var(--border-radius);
}
.form-options-content {
  font-size: var(--font-small);
  line-height: 16px;
  color: var(--main-foreground-opacity-60);
  border: 0;
}
.form-group input[type="radio"] + .form-options-content .unchecked {
  fill: var(--main-foreground-opacity-10);
}
.form-group input[type="radio"] + .form-options-content .checked {
  fill: var(--accent-color);
}
.form-group input[type="radio"]:checked + .form-options-content {
  border: 1px solid var(--accent-color);
  border-color: var(--main-foreground-opacity-10);

  + .form-options-accordion {
    border-color: var(--main-foreground-opacity-10);
  }

  .checked {
    fill: var(--accent-color);
  }
}
.form-group input[type="checkbox"]:checked + .form-options-content .checked {
  fill: var(--main-foreground);
}
.form-group input[disabled] + .form-options-content {
  border-color: var(--main-foreground-opacity-10) !important;

  .form-options-label {
    color: var(--main-foreground) !important;
  }
  .checked {
    fill: var(--main-foreground) !important;
  }
}
.form-group input[type="checkbox"] + .form-options-content .form-group-icon {
  border-radius: 2px;
  overflow: hidden;
}
.form-group input[type="checkbox"] + .form-options-content svg {
  width: 13px;
  height: 13px;
}
.form-group input[type="checkbox"] + .form-options-content .unchecked {
  width: 13px;
  fill: var(--main-foreground);
}

{# /* // Input */ #}

.has-float-label>span,
.has-float-label label {
  padding: 1px 0 0 7px;
  font-weight: 400;
}

.has-float-label .form-control-help {
  z-index: 1;
}

.input-label {
  color: var(--main-foreground);
}

.select-icon {
  fill: var(--main-foreground);
  svg {
    width: 10px;
  }
}

{# /* // Buttons */ #}

.btn {
  border-radius: var(--border-radius);
}
.btn-primary {
  padding: 15px;
  color: var(--button-foreground);
  background: var(--button-background);
  border-radius: var(--border-radius);
  font-size: var(--font-medium);
  line-height: 18px;
  text-transform: none !important;
  {% if button_style == 'outline' %}
  border: 1px solid var(--button-border-color);
  {% endif %}

  &:hover,
  &:focus,
  &:active {
    color: var(--button-foreground);
    background: var(--button-background);
    opacity: 0.9;
  }
}
.btn-secondary {
  min-width: auto;
  padding: 0;
  color: var(--main-foreground);
  font-size: var(--font-small);
  line-height: 10px;
  border: 0;
  border-radius: var(--border-radius);
  background: var(--main-background);
  text-decoration: underline;

  &:hover,
  &:focus,
  &:active,
  &:active:focus {
    background: var(--main-background);
    color: var(--main-foreground);
    opacity: .8;

    .btn-icon-right {
      fill: var(--button-background);
    }
  }
  .btn-icon-right {
    fill: var(--accent-color);
  }
}
.btn-transparent {
  color: var(--main-foreground);

  &:hover {
    color: var(--main-foreground);
    opacity: .6;

    .btn-icon-right {
      fill: var(--main-foreground);
    }
  }

  .btn-icon-right {
    width: 10px;
    fill: var(--main-foreground);
  }
}

.btn-link {
  color: var(--main-foreground);
  font-size: var(--font-small);
  font-weight: normal;
  text-transform: initial;
  &:hover {
    color: var(--main-foreground-opacity-60);

    svg {
      fill: var(--main-foreground-opacity-60);
    }
  }
}

.btn:active {
  box-shadow: none;
}

.btn-picker {
  border-color: var(--border-color);
  border-radius: var(--border-radius);
}

.login-info {
  margin: 10px 0 0;
  font-size: var(--font-small);
  text-align: left;
}

{# /* // Breadcrumb */ #}

.breadcrumb {
  max-width: 100%;

  li .breadcrumb-step {
    margin: 0;
    font-size: var(--font-small);
    color: var(--main-foreground-opacity-60);
    background: none;
    text-transform: none;

    &.active {
      color: var(--main-foreground);
      background: none;

      &:before,
      &:after {
        position: relative;
        margin: 0 5px;
        border: 0;
        content: ">";
        opacity: .6;
      }
    }

    &.visited {
      color: var(--main-foreground-opacity-60);
      background: none;
    }
  }
  li:first-child .breadcrumb-step,
  li:last-child .breadcrumb-step {
    padding: 0;
  }
}

{# /* // Accordion */ #}

.accordion {
  color: var(--main-foreground);
  background-color: var(--main-background);
  border-radius: var(--border-radius);
  box-shadow: 0 1px 3px -1px var(--main-foreground-opacity-10);
  border-color: var(--main-foreground-opacity-15);
}

.accordion-section-header-icon {
  fill: var(--main-foreground);
}

.accordion-rotate-icon {
  fill: var(--main-foreground);
}

{# /* // Summary */ #}

.summary {
  top: 0;
}
.summary-img {
  &-thumb {
    left: 0;
    border-radius: 0;
    background: none;
  }
  img {
    max-height: fit-content;
  }
}

.mobile-discount-coupon_btn {
  border-radius: var(--border-radius);
  border-color: var(--main-foreground-opacity-10);
  color: var(--main-foreground-opacity-80);

  .icon {
    color: var(--main-foreground-opacity-80);
  }
}

.panel.summary-details {
  background: var(--main-background);
  overflow: hidden;
}
.summary-container {
  padding: 10px 15px;
  background: var(--main-background);
  border-top: 1px solid var(--main-foreground-opacity-20);
  border-bottom: 1px solid var(--main-foreground-opacity-20);
  box-shadow: none;
}
.summary-total {
  font-size: var(--font-base);
  font-weight: 700;
  color: var(--main-foreground);
  background: none;
}

.summary-arrow-rounded {
  width: auto;
  background: none;
  .summary-arrow-icon {
    fill: var(--main-foreground);
  }
}

.summary-title {
  color: var(--main-foreground);
  font-size: var(--font-small);
  text-decoration: underline;
}

.summary-coupon {
  padding: 0;
  &+.breadcrumb {
    margin: 0;
  }
}

{# /* // Radio */ #}

.radio-group {

  &.radio-group-accordion {
    border: none;
    overflow: hidden;

    .radio {
      padding: 10px 0;
      border: 0;
      &.active {
        .description {
          color: var(--main-background);
        }
        .payment-item-discount {
          color: var(--main-background);
        }
      }
      .description {
        width: calc(100% - 35px);
        margin-left: 35px;
        font-weight: 400;
      }
    }
  }
}

.radio input:checked + .selector:before {
  background-image: none;
  border-color: var(--main-foreground);
  border-radius: var(--border-radius);
}
.radio input:disabled:checked + .selector:before {
  background-image: radial-gradient(circle, rgba(0, 0, 0, 0.5) 0%, rgba(0, 0, 0, 0.5) 50%, transparent 50%, transparent 100%);
}
.radio input:checked + .selector:after {
  position: absolute;
  left: 4px;
  bottom: 4px;
  width: 7px;
  height: 7px;
  background: var(--main-foreground);
  content: '';
}
.radio .selector {
  position: relative;

  &:before {
    width: 15px;
    height: 15px;
    margin: 1px 15px 0 0;
    background-color: var(--main-background);
    border-color: var(--main-foreground);
    border-radius: var(--border-radius);
  }
}

.radio-content {
  margin-bottom: 20px;
  padding: 10px 0 0;
  background: var(--main-background);
  border: 0;
  box-shadow: none;

  .text-center {
    text-align: left !important;
  }
  .p-all {
    padding-top: 0 !important;
  }
}

.shipping-option {
  position: relative;
  padding: 15px;
  background: var(--main-foreground-opacity-05);
  border-radius: 0;
  border: 0;

  &.active {
    border: none;
  }

  .selector {
    position: absolute;
    top: 5px;
    left: 15px;
    width: 15px;
    margin: 0;
    text-align: center;
    &:before {
      margin: 10px 0 0 0;
    }
  }
}

{# /* // Panel */ #}

.panel {
  padding: 0;
  color: var(--main-foreground);
  background-color: var(--main-background);
  box-shadow: none;
  border: 0;
  border-radius: 0;
  &.panel-with-header {
    padding-top: 5px;
    p {
      margin-top: 0;
    }
  }
  &.text-center {
    text-align: left !important;
  }
  .shipping-address-container .panel-subheader:before {
    display: none;
  }
}
.panel-header {
  margin: 0 !important;
  font-size: var(--font-base);
  color: var(--main-foreground);
  text-align: left;
  border: 0;
  text-shadow: none;
}
.panel-header-tooltip {
  padding: 0 5px;
}
.panel-header-sticky {
  background-color: var(--main-background);
}
.panel-header-button {
  position: absolute;
  top: 13px;
  right: 0;
  z-index: 2;
  width: auto;
}
.panel-subheader {
  margin: 5px 0 10px 0;
  font-size: var(--font-small);
  font-weight: normal;
}
.panel-footer {
  background: var(--main-foreground-opacity-05);
  &-wa {
    border-color: var(--main-foreground-opacity-05);
  }
}
.panel-footer-form {
  input {
    border-color: var(--main-foreground);
  }
  .input-group-addon {
    background: var(--main-background);
    border-color: var(--main-foreground);
  }
  .disabled {
    background: var(--main-foreground-opacity-10) !important;
  }
}

{# /* // Table */ #}

.table.table-scrollable td {
    padding: 10px 15px;
}

.table-footer {
  font-size: var(--font-base);
  color: var(--main-foreground);
  border: 0;
}

.table-subtotal {
  margin: 0;
  padding: 10px 0;
  border: 0;
  td {
    padding: 5px 15px;
  }
  .text-semi-bold {
    font-weight: 400;
  }
}

.table .table-discount-coupon,
.table .table-discount-promotion {
  color: var(--accent-color);
  border: 0;
}

{# /* // Shipping Options */ #}

.shipping-options {
  color: var(--main-foreground-opacity-80);

  .radio-group {
    border-radius: var(--border-radius);
    box-shadow: 0 1px 3px -1px var(--main-foreground-opacity-10);
    overflow: hidden;
  }

  .btn {
    margin: 0;
    background: var(--main-background);
  }

}

.new-shipping-flow .shipping-options .radio-group {
  box-shadow: none;
  overflow: inherit;
}

.new-shipping-flow .shipping-options .btn {
  padding-top: 15px;
  border: 0;
}

.shipping-method-item {
  margin-left: 25px;
  > span {
    width: 100%;
  }
}

.shipping-method-item-desc,
.shipping-method-item-name {
  max-width: 70%;
  color: var(--main-foreground);
  font-size: var(--font-small);
  font-weight: normal;
}

.shipping-method-item-desc {
  opacity: .6 !important;
}

.shipping-method-item-price {
  float: right;
  font-weight: normal;
  color: var(--main-foreground);
  text-align: right;
}

.price-striked {
  display: block;
  margin: 5px 0 0 !important;
  font-size: var(--font-smallest);
  color: var(--main-foreground-opacity-60);
}

{# /* // Discount Coupon */ #}

.box-discount-coupon {
  margin-top: -1px;
  button {
    color: var(--main-foreground);
    background: none;

    &:hover {
      opacity: .6;
      background: none;
    }
    svg {
      fill: var(--main-foreground);
    }
  }
}
.box-discount-coupon-applied {
  padding: 10px 15px;
  color: var(--main-foreground);
  background: none;
  border-radius: 0;
  font-size: 8px;
  line-height: 20px;
  letter-spacing: 1px;
  text-transform: uppercase;

  .btn-link {
    padding-top: 3px;
    color: var(--main-foreground);
    &:hover {
      color: var(--main-foreground-opacity-60);
    }
  }
  .coupon-icon {
    display: none;
  }
}


{# /* // Support */ #}

.support {
  margin: 0;
  padding: 20px 0;
  svg {
    width: 14px;
    vertical-align: middle;
    fill: var(--main-foreground);
  }
  .btn-secondary {
    margin: 0 0 15px 0 !important;
  }
}

{# /* // User Detail */ #}

.user-detail {
  margin: 0 !important;
  padding: 15px 15px 15px 0;
  background: var(--main-background);
  border-radius: var(--border-radius);
  &-icon {
    width: 40px;
    svg {
      left: initial;
      width: 15px;
      height: 16px;
      fill: var(--main-foreground);
    }
  }
  &-content {
    width: calc(100% - 50px);
    .text-semi-bold {
      font-size: var(--font-smallest);
      font-weight: 400;
      letter-spacing: 1px;
    }
  }
}


{# /* // History */ #}

.history-item-done .history-item-title {
  color: var(--accent-color);
}
.history-item-failure .history-item-title {
  color: var(--danger);
}
.history-item-progress-icon svg {
  width: 20px;
  fill: var(--main-foreground-opacity-30);
}
.history-item-progress-icon:after {
  top: 20px;
  margin-left: -11px;
  fill: var(--main-foreground-opacity-30);
  border-left: 2px solid var(--main-foreground-opacity-30);
}
.history-item-progress-icon-failure svg {
  fill: var(--danger);
}
.history-item-progress-icon-success svg {
  fill: var(--accent-color);
}
.history-item-progress-icon-success:after {
  border-color: var(--accent-color);
}

{# /* // History Canceled */ #}

.history-canceled {
  border-top-right-radius: var(--border-radius);
  border-top-left-radius: var(--border-radius);
}
.history-canceled-header {
  border-color: var(--border-color);
  border-top-left-radius: var(--border-radius);
  border-top-right-radius: var(--border-radius);
}
.history-canceled-icon svg {
  fill: var(--main-foreground-opacity-50);
}

{# /* // Offline Payment */ #}

.ticket-coupon {
  background: var(--main-foreground-opacity-05);
  border-color: var(--border-color);
}

{# /* // Buy fast */ #}
.panel-buy-fast {
  color: var(--main-foreground);
  fill: var(--main-foreground);
  background: var(--main-background);
  border: 1px solid var(--main-foreground-opacity-15);
  border-radius: var(--border-radius);
  box-shadow: none;
}

{# /* // Status, Destination & Sign Up */ #}

.success-order-id {
  padding-top: 52px;
  font-size: var(--font-small);
  text-transform: uppercase;
  .opacity-50 {
    opacity: 1 !important;
  }
}

.status,
.destination,
.signup {
  padding: 15px 0 !important;
  &-icon {
    width: 10px;
    margin: 0;
    svg {
      left: initial;
      width: 15px;
      fill: var(--main-foreground);
    }
  }
  &-content {
    width: calc(100% - 80px);
    margin: 4px 0 0 20px;
  }
}

.status,
.orderstatus {
  margin: 0;
  background: var(--main-background);
}

.destination {
  align-items: initial;
}

.destination-content .m-top-half {
  margin-top: 2px!important;
}

.orderstatus .destination {
    padding: 10px 0 0;
    border: 0;
}

.signup .icon-inside-input.align-right-password {
  right: 15px;
}

{# /* // Tracking */ #}

.history-item-progress {
  width: 70px;
  margin: -2px 0 0 0;
}

.history-item-content {
  width: calc(100% - 80px);
  max-width: 100%;
}

.history-item-message {
  max-width: 100%;
  font-size: var(--font-smallest);
}

.tracking-item-time {
  color: var(--main-foreground);
}

{# /* // WhatsApp Opt-in */ #}

.whatsapp-form input,
.whatsapp-form .input-group-addon {
  border-color: var(--accent-color);
}

{# /* // Helpers */ #}

.border-top {
  border-color: var(--border-color);
}

{# /* // Errors */ #}

.alert-danger-bagged {
  margin-top: 5px;
  border-radius: var(--border-radius);
  float: left;
  background: none;
  color: #cc4845;
}

.general-error {
  background: var(--danger);
  border-color: var(--danger);
}

{# /* // Badge */ #}

.badge {
  border: 0;
}

{# /* // Payment */ #}

.payment-category-label {
  font-size: 8px;
  text-transform: uppercase;
  letter-spacing: 1px;

  &.text-semi-bold {
    font-weight: normal;
  }
}

.payment-item-discount {
  display: inline-block;
  float: left;
  clear: initial;
  margin: -1px 0 0 10px;
  padding: 4px 6px;
  color: var(--label-foreground);
  background: var(--label-background);
  border-radius: 6px;
  font-size: var(--font-smallest);
  text-transform: uppercase;
}

.payment-option {
  border-radius: 0;
  color: var(--main-foreground);
  background-color: var(--main-foreground-opacity-05);
  border: 0;
}

.radio-content.payment-option-content {
  background: var(--main-background);
  border: 1px solid var(--main-foreground-opacity-10);
  border-top: 0;
  border-radius: 0;
}


{# /* // Overlay */ #}

.overlay {
  background: var(--main-foreground-opacity-15);
}
.overlay-title {
  color: var(--main-foreground-opacity-60);
}

{# /* // List Picker */ #}

.list-picker .unchecked {
  fill: var(--main-foreground);
}
.list-picker li {
  border-color: var(--border-color);
  background: var(--main-background);

  &:hover {
    color: var(--accent-color);
  }

  &.active {
    background: var(--main-background);
    color: var(--accent-color);

    .checked {
      fill: var(--accent-color);
    }
  }
}

.list-picker-content {
  background: var(--main-background);
  border-color: var(--border-color);
}

{# /* // Loading */ #}

.loading {
  background: var(--main-background-opacity-50);
  color: var(--accent-color);
}
.loading-spinner {
  color: var(--accent-color);
}
.loading-skeleton-radio {
  margin: 0 0 10px 0;
  padding: 15px;
  border-color: var(--main-foreground-opacity-15);
  border-radius: 0;
}

{# /* // Spinner */ #}

.round-spinner {
  border-color: var(--accent-color);
  border-left-color: var(--accent-color-opacity-50);

  &:after {
    border-color: var(--accent-color);
    border-left-color: var(--accent-color-opacity-50);
  }
}

.spinner > .spinner-elem {
  width: 6px;
  height: 6px;
}

.spinner-inverted > .spinner-elem {
  background: var(--button-foreground);
}

{# /* // Modal */ #}

.modal-dialog,
.modal .modal-dialog {
  background: var(--main-background);
  fill: var(--main-foreground);
}

.modal .modal-header .modal-close {
  color: var(--main-foreground);
  text-shadow: none;
}

{# /* // List */ #}

.list-group-item {
  border-color: var(--main-foreground-opacity-15);
}

{# /* // Announcement */ #}

.announcement {
  color: var(--accent-color-opacity-80);

  &-bg {
    background: var(--accent-color);
    box-shadow: 0px 3px 5px -1px var(--accent-color-opacity-10);
    border-radius: var(--border-radius);
  }

  &-close {
    color: var(--accent-color);
  }
}

{# /* // Alert */ #}

.alert {
  border-radius: var(--border-radius);
  &-info {
    background-color: var(--accent-color-opacity-15);
    border-color: var(--accent-color-opacity-20);
    color: var(--accent-color);
    .alert-icon {
      fill: var(--accent-color);
    }
  }
}

{# /* // Chip */ #}

.chip {
  background-color: var(--accent-color-opacity-15);
  color: var(--accent-color);
  border-radius: 5px;
}

{# /* // Review Block Detailed  */ #}
.price--display__free {
  color: var(--accent-color);
}

.review-block-detailed {
  margin: 0 !important;
  background: var(--main-background);
  border: none;
  border-radius: var(--border-radius);
  &-item {
    width: 100%;
    background: transparent;
    border-radius: 0;
    &.review-block-dropdown {
        padding-top: 0;
    }
  }
}

.review-block-detailed-item .icon-area {
  flex-basis: 30px;
}

{# /* // Tooltip */ #}

.tooltip-icon {
  fill: var(--main-foreground);
}

{# /* // Tabs */ #}

.tabs-wrapper {
  border-top-right-radius: var(--border-radius);
  border-top-left-radius: var(--border-radius);
  background: var(--main-foreground-opacity-05);
  border-bottom-color: var(--main-foreground-opacity-10);
}

.tab-item.active {
  color: var(--accent-color);
  font-weight: bold;
}

.tab-indicator {
  background-color: var(--accent-color);
}

{#/*============================================================================
  #Media queries
==============================================================================*/ #}

{# /* // Max width 576px */ #}

@media (max-width: $sm) {

  .headbar .container .row .col {
    flex-basis: auto;
    &.text-left {
      flex: 0 0 100%;
      max-width: 100%;
      order: 2;
      margin: 0;
      padding: 10px 15px;
      {% if settings.logo_position_mobile == 'center' %}
        text-align: center !important;
      {% else %}
        text-align: left !important;
      {% endif %}
    }
    &.text-right {
      background: #aac67b;
      text-align: center !important;
    }
  }

  .headbar-logo-text {
    display: inline-block;
    margin: 8px 0;
  }

  .security-seal {
    color: #000000;

    .d-inline-block:first-child {
      position: absolute;
      top: 1px;
      left: 50%;
      margin-left: -13px;
    }
    p {
      display: inline-block;
      &.text-semi-bold {
        margin-right: 50px !important;
      }
    }
    &-badge {
      margin: 0;
    }
  }

  .box-discount-coupon-applied {
    border: 1px solid var(--main-foreground-opacity-20) !important;
  }
  .box-discount-coupon .form-control {
    border: 1px solid var(--main-foreground-opacity-20);
    border-radius: var(--border-radius);
  }
  .summary .panel {
    border: 0;
  }
  .summary-container .container {
    padding: 0;
  }
  .summary-coupon {
    padding-top: 65px;
  }

  .btn-primary {
    margin: 0 !important;
  }

  .panel.summary-details {
    border: 0;
  }

  .payment-list-item .accordion-section-header-label {
    flex-direction: column;
  }

  .accordion-section-header-label {
    align-items: start;
    align-content: start;
  }

  .payment-item-discount {
    margin: 8px 0 0;
  }

  .user-detail-icon {
    width: 20px;
    margin-right: 10px;
  }

  .user-detail-content {
    width: calc(100% - 80px);
  }

  .orderstatus-footer {
    background: var(--main-background);
  }

}

{# /* // Min width 768px */ #}

@media (min-width: $md) {

  .container {
    max-width: 1000px;
  }

  .headbar {
    padding: 8px 0;
  }

  .success-order-id {
    padding-top: 0;
  }

  .table.table-scrollable {
    padding: 0;
  }

}

{# /* // Max width 0px */ #}

@media (max-width: $xs) {

  .modal-xs {
    background: var(--main-background);
  }

}

{#/*============================================================================
  CPAP Fit — checkout igual ao Figma 1P4JHFz4FEG8UEBkDOB1qm, frame 367:13649 (etapa Entrega, desktop 1920)

  Script de checkout é sempre NubeSDK (sem acesso à página), então o visual do checkout entra por aqui:
  este arquivo vira o checkout-*.css que o checkout carrega. Só CSS: preço, frete e pagamento não mudam.
  O rodapé azul vem do app NubeSDK (nube-apps/checkout-quick); aqui ele só ganha a largura da tela.
  Seletores do checkout v3 conferidos em 2026-10-19. Tudo sob :root para ganhar dos estilos nativos.
==============================================================================*/#}

:root {
  --qd-gold: #ad9361;
  --qd-cream: #f4f1ed;
  --qd-ink: #4a4a48;
  --qd-ink-strong: #2a282b;
  --qd-teal: #00a58c;
  --qd-offwhite: #fefdfc;
  --qd-line: #ccc;
  --qd-gap: clamp(32px, 6.5vw, 100px);
  --qd-lock: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'%3E%3Cpath fill='%23AD9361' d='M6 8V7C6 3.68629 8.68629 1 12 1C15.3137 1 18 3.68629 18 7V8H20C20.5523 8 21 8.44772 21 9V21C21 21.5523 20.5523 22 20 22H4C3.44772 22 3 21.5523 3 21V9C3 8.44772 3.44772 8 4 8H6ZM19 10H5V20H19V10ZM11 15.7324C10.4022 15.3866 10 14.7403 10 14C10 12.8954 10.8954 12 12 12C13.1046 12 14 12.8954 14 14C14 14.7403 13.5978 15.3866 13 15.7324V18H11V15.7324ZM8 8H16V7C16 4.79086 14.2091 3 12 3C9.79086 3 8 4.79086 8 7V8Z'/%3E%3C/svg%3E");
  --qd-tag: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 20 20'%3E%3Cpath d='M9.08683 1.75021L17.3364 2.92872L18.5149 11.1783L10.8546 18.8386C10.5292 19.1641 10.0016 19.1641 9.67608 18.8386L1.42653 10.5891C1.10109 10.2636 1.10109 9.736 1.42653 9.4105L9.08683 1.75021ZM9.67608 3.51798L3.1943 9.99975L10.2653 17.0708L16.7472 10.5891L15.8633 4.40186L9.67608 3.51798ZM11.4439 8.82125C10.793 8.1704 10.793 7.11513 11.4439 6.46425C12.0948 5.81338 13.15 5.81338 13.8009 6.46425C14.4518 7.11513 14.4518 8.1704 13.8009 8.82125C13.15 9.47217 12.0948 9.47217 11.4439 8.82125Z'/%3E%3C/svg%3E");
  --qd-check: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 20 20'%3E%3Cpath d='M5 10.2l3.2 3.2L15 6.6' fill='none' stroke='%23fefdfc' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'/%3E%3C/svg%3E");
}

:root body {
  background: #fff;
  color: var(--qd-ink);
  font-family: Montserrat, sans-serif;
  overflow-x: clip;
}

{#/* ---------- cabeçalho (367:13750): logo "10 anos" 200x60 e selo à direita ---------- */#}
:root .headbar {
  display: flex;
  align-items: center;
  height: 110px;
  padding: 0;
  background: var(--qd-offwhite);
  border-bottom: 1px solid var(--qd-line);
  box-shadow: none;
}
:root .headbar > .container {
  width: 100%;
  max-width: 1624px;
  padding: 0 12px;
}
:root .headbar .row {
  align-items: center;
  flex-wrap: nowrap;
  margin: 0;
}
:root .headbar .row > .col {
  padding: 0;
}
:root #headbar-left {
  order: 0;
  flex: 1 1 auto;
  min-width: 0;
}
:root .headbar-logo-img {
  display: block;
  width: 200px;
  height: 60px;
  max-width: none;
  max-height: none;
  object-fit: contain;
  object-position: left center;
  content: url("{{ 'images/logo-10-anos.png' | static_url }}");
}
:root #headbar-right {
  display: flex !important;
  order: 1;
  flex: 0 0 auto;
  align-items: center;
  justify-content: flex-end;
  width: auto;
  max-width: none;
  background: none !important;
  font: 400 14px/22px Montserrat, sans-serif;
  text-transform: uppercase;
  color: var(--qd-ink);
  white-space: nowrap;
}
:root #headbar-right::before {
  content: "Ambiente\00a0";
}
:root #headbar-right::after {
  content: "100% seguro";
  margin-right: 8px;
  padding-right: 34px;
  font-weight: 700;
  line-height: 24px;
  background: var(--qd-lock) right center / 24px no-repeat;
}
{#/* a linha do app NubeSDK vira o selo dentro do cabeçalho, como no Figma */#}
:root #nube-sdk-slot-after_header {
  display: none !important;
}

{#/* ---------- grade: formulário 780 + 100 + resumo 390 (367:13768) ---------- */#}
:root .main-container {
  max-width: 1290px;
  padding: 0 10px 60px;
}
:root #breadcrumb {
  max-width: 1270px;
  margin: 60px auto 20px;
  padding: 0;
  background: none;
}
@media (min-width: 768px) {
  :root #breadcrumb > .row,
  :root #main-row {
    display: flex;
    flex-wrap: nowrap;
    gap: var(--qd-gap);
    justify-content: center;
    max-width: 1270px;
    margin: 0 auto !important;
  }
  :root #breadcrumb > .row::after {
    content: "";
    flex: 0 0 390px;
  }
  :root #breadcrumb > .row > .col-md-8,
  :root #main-column {
    flex: 0 1 780px;
    max-width: 780px;
    padding: 0;
  }
  {#/* no Figma o resumo começa na altura das etapas (80 + 20 acima do formulário) */#}
  :root #secondary-column {
    flex: 0 0 390px;
    max-width: 390px;
    margin-top: -100px;
    padding: 0;
  }
}

{#/* ---------- etapas CARRINHO — ENTREGA — PAGAMENTO (367:13771) ---------- */#}
:root ul.breadcrumb-timeline {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 20px;
  height: 80px;
  margin: 0;
  padding: 0;
  list-style: none;
}
:root ul.breadcrumb-timeline > li {
  position: static;
  flex: 0 0 auto;
  width: auto;
  margin: 0;
  padding: 0;
}
:root ul.breadcrumb-timeline > li.breadcrumb-timeline-line {
  flex: 0 0 40px;
  width: 40px !important;
  height: 1px;
  background: var(--qd-line);
  border: 0;
}
:root ul.breadcrumb-timeline > li.breadcrumb-timeline-line::before,
:root ul.breadcrumb-timeline > li.breadcrumb-timeline-line::after {
  display: none;
}
:root .breadcrumb-timeline-item {
  position: relative;
  display: flex;
  align-items: center;
  width: auto;
  height: 80px;
  padding: 0 10px;
  background: none;
  border: 0;
  box-shadow: none;
  opacity: 1;
}
:root .breadcrumb-timeline-item-icon {
  display: none !important;
}
:root .breadcrumb-timeline-item-text {
  position: relative !important;
  inset: auto !important;
  transform: none !important;
  margin: 0;
  padding: 0;
  font: 500 16px/34px Montserrat, sans-serif;
  text-transform: uppercase;
  color: var(--qd-ink) !important;
  white-space: nowrap;
}
:root .breadcrumb-timeline-item.current .breadcrumb-timeline-item-text {
  font-weight: 700;
}
:root .breadcrumb-timeline-item.current .breadcrumb-timeline-item-text::after {
  content: "";
  position: absolute;
  left: 0;
  right: 0;
  top: 38px;
  height: 4px;
  border-radius: 10px;
  background: var(--qd-gold);
}

{#/* ---------- seções e títulos (367:13784) ---------- */#}
:root #main-column .panel {
  margin: 0 0 26px;
  padding: 0;
  background: none;
  border: 0;
  box-shadow: none;
}
:root .panel-header {
  margin: 0;
  padding: 0 0 26px;
  font: 500 20px/20px Montserrat, sans-serif;
  color: var(--qd-ink-strong);
  background: #fff;
  border: 0;
  text-transform: none;
}
:root .panel-header-tooltip {
  display: none;
}
:root .form-group {
  margin-bottom: 20px;
}

{#/* ---------- campos: rótulo em cima, campo de 50px (367:13997) ---------- */#}
:root .has-float-label {
  position: relative;
  display: flex;
  flex-direction: column;
  gap: 10px;
}
:root .has-float-label > label {
  order: -1;
  position: static !important;
  transform: none !important;
  top: auto !important;
  left: auto !important;
  display: block;
  width: auto;
  height: auto;
  min-height: 18.4px;
  margin: 0 !important;
  padding: 0 !important;
  opacity: 1 !important;
  background: none;
  font: 700 14px/18.4px Montserrat, sans-serif !important;
  letter-spacing: 0;
  color: var(--qd-ink) !important;
  white-space: normal;
}
{#/* obrigatório = todos menos complemento */#}
:root .has-float-label > label.input-label::after {
  content: "*";
  font: 700 14px/18.4px Montserrat, sans-serif;
}
:root .has-float-label > label.input-label[for$=".floor"]::after {
  content: none;
}
{#/* textos do Figma no lugar dos nativos (o campo é o mesmo) */#}
:root .has-float-label > label[for="shippingAddress.phone"],
:root .has-float-label > label[for="shippingAddress.floor"],
:root .has-float-label > label[for="billingAddress.id_number"],
:root #address-form-section > .panel-header,
:root tr.table-shipping-cost > td:first-child {
  font-size: 0 !important;
}
{#/* flex: sem a linha de base do texto escondido, a altura fica a do texto novo (18.4px) */#}
:root .has-float-label > label[for="shippingAddress.phone"],
:root .has-float-label > label[for="shippingAddress.floor"],
:root .has-float-label > label[for="billingAddress.id_number"] {
  display: flex;
}
:root .has-float-label > label[for="shippingAddress.phone"]::before {
  content: "Telefone";
  font: 700 14px/18.4px Montserrat, sans-serif;
}
:root .has-float-label > label[for="shippingAddress.floor"]::before {
  content: "Complemento (opcional)";
  font: 700 14px/18.4px Montserrat, sans-serif;
}
:root .has-float-label > label[for="billingAddress.id_number"]::before {
  content: "CPF";
  font: 700 14px/18.4px Montserrat, sans-serif;
}
:root #address-form-section > .panel-header::before {
  content: "Dados para a entrega";
  font: 500 20px/20px Montserrat, sans-serif;
}
:root .form-control {
  height: 50px;
  padding: 0 17px;
  border: 1px solid var(--qd-line);
  border-radius: 10px;
  background: #fff;
  box-shadow: none;
  font: 500 14px/normal Montserrat, sans-serif;
  letter-spacing: 0.14px;
  {#/* texto digitado um tom acima do placeholder (#4a4a48 no Figma) para não confundir os dois */#}
  color: var(--qd-ink-strong);
}
:root textarea.form-control {
  height: auto;
  padding: 15px 17px;
}
:root .form-control:focus {
  border-color: var(--qd-gold);
  box-shadow: none;
  outline: none;
}
:root .form-control::placeholder {
  color: var(--qd-ink);
  opacity: 1 !important;
}
:root .has-error .form-control {
  border-color: #d0021b;
}
:root .has-float-label > .form-control-help {
  position: absolute;
  inset: auto 17px 13px auto;
  font: 500 13px/24px Montserrat, sans-serif;
  color: var(--qd-ink);
}
:root .has-float-label > .input-validation-icon {
  position: absolute;
  inset: auto 17px 15px auto;
  margin: 0;
}
:root .has-float-label > .input-button {
  position: absolute;
  inset: auto 17px 15px auto;
  width: auto;
  white-space: nowrap;
}
:root .has-float-label > .input-button .form-group {
  margin: 0;
}
:root .has-float-label > .input-button .form-checkbox {
  position: static;
  margin: 0;
}

{#/* ---------- caixas de seleção (367:14171) ---------- */#}
:root label.form-checkbox {
  display: flex;
  align-items: flex-start;
  margin: -10px 0 0;
  padding: 0;
  cursor: pointer;
}
:root .form-checkbox > input[type="checkbox"] {
  position: absolute;
  width: 1px;
  height: 1px;
  opacity: 0;
}
:root .form-checkbox .form-options-content {
  display: flex;
  align-items: flex-start;
  gap: 10px;
}
:root .form-checkbox .form-group-icon {
  position: relative;
  flex: 0 0 20px;
  width: 20px;
  height: 20px;
  margin: 0;
  border: 1px solid var(--qd-ink-strong);
  border-radius: 4px;
  background: #fff;
}
:root .form-checkbox .form-group-icon svg {
  display: none !important;
}
:root .form-checkbox > input:checked + .form-options-content .form-group-icon {
  background: var(--qd-ink-strong) var(--qd-check) center / 18px no-repeat;
}
:root .form-checkbox > input:focus-visible + .form-options-content .form-group-icon {
  outline: 2px solid var(--qd-gold);
  outline-offset: 2px;
}
:root .form-checkbox .form-options-label {
  margin: 1px 0 0;
  font: 500 13px/18px Montserrat, sans-serif;
  color: var(--qd-ink);
}

{#/* ---------- opções de frete (367:13966): cartão creme, rádio com ponto dourado ---------- */#}
:root .shipping-options-container .panel-subheader {
  margin: 0 0 10px;
  font: 700 13px/18px Montserrat, sans-serif;
  color: var(--qd-ink);
}
:root .shipping-options-ship,
:root .shipping-options-pickup {
  display: flex;
  flex-direction: column;
  gap: 10px;
  margin: 0 0 10px;
}
:root .radio.shipping-option {
  margin: 0;
  padding: 0;
  border: 0;
  background: none;
  box-shadow: none;
}
:root .radio.shipping-option > label.label {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  width: 100%;
  margin: 0;
  padding: 16px;
  border: 0;
  border-radius: 10px;
  background: var(--qd-cream);
  cursor: pointer;
}
:root .radio.shipping-option input[type="radio"] {
  position: absolute;
  width: 1px;
  height: 1px;
  opacity: 0;
}
:root .radio.shipping-option .selector,
:root .formless-address .user-detail-icon {
  position: relative;
  inset: auto;
  flex: 0 0 20px;
  width: 20px;
  height: 20px;
  margin: 0;
  padding: 0;
  border: 1px solid var(--qd-ink-strong);
  border-radius: 50%;
  background: #fff;
}
:root .radio.shipping-option .selector::before,
:root .radio.shipping-option .selector::after {
  display: none;
}
:root .radio.shipping-option.active .selector::after,
:root .formless-address .user-detail-icon::after {
  content: "";
  display: block;
  position: absolute;
  inset: 0;
  width: 9px;
  height: 9px;
  margin: auto;
  border-radius: 50%;
  background: var(--qd-gold);
}
:root .formless-address .user-detail-icon svg {
  display: none;
}
:root .shipping-method-item {
  flex: 1;
  margin: 0;
  padding: 0;
}
:root .shipping-method-item > span {
  display: grid;
  grid-template-columns: 1fr auto;
  column-gap: 16px;
  row-gap: 4px;
}
:root .shipping-method-item-name {
  grid-column: 1;
  grid-row: 1;
  font: 600 14px/18.4px Inter, Montserrat, sans-serif !important;
  text-transform: uppercase;
  color: var(--qd-ink);
}
:root .shipping-method-item-desc {
  grid-column: 1;
  grid-row: 2;
  font: 500 13px/18px Montserrat, sans-serif !important;
  color: var(--qd-ink);
  opacity: 1 !important;
}
:root .shipping-method-item-price {
  grid-column: 2;
  grid-row: 1;
  margin: 0 !important;
  font: 700 13px/20px Montserrat, sans-serif !important;
  color: var(--qd-ink);
  text-align: right;
  white-space: nowrap;
}
:root .shipping-method-item-price *,
:root .shipping-method-item-desc * {
  font: inherit;
  color: inherit;
}
{#/* "Mais opções" nativo (367:13961) */#}
:root #shipping-more-options {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  margin: 10px 0 0;
  padding: 0;
  border: 0;
  background: none;
  font: 700 13px/18px Montserrat, sans-serif;
  color: var(--qd-ink);
  text-transform: none;
}
:root #shipping-more-options > span {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  text-decoration: underline;
  text-underline-position: from-font;
}
:root #shipping-more-options svg {
  width: 12px;
  height: 12px;
  fill: #2c4372;
}
{#/* "Alterar: CEP" ao lado do título Entrega */#}
:root .panel-header-button {
  float: right;
  margin-top: -46px;
  padding: 0;
  border: 0;
  background: none;
  font: 700 13px/18px Montserrat, sans-serif;
  color: var(--qd-ink);
  text-decoration: underline;
  text-underline-position: from-font;
}

{#/* ---------- dados para a entrega (367:14034 / 367:13911 / 367:14109) ---------- */#}
:root #address-form-section {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  column-gap: 20px;
  row-gap: 26px;
}
:root #address-form-section > * {
  grid-column: 1 / -1;
  margin: 0;
}
:root #address-form-section > .panel-header {
  padding: 0;
}
:root #address-form-section > .form-group:has(input[name="shippingAddress.first_name"]),
:root #address-form-section > .form-group:has(input[name="shippingAddress.last_name"]),
:root #address-form-section > .form-group:has(input[name="shippingAddress.phone"]) {
  grid-column: auto;
}
:root #address-form-section > .row:empty {
  display: none;
}
:root #address-form-section .row.third-gutters {
  display: flex;
  gap: 20px;
  margin: 0;
}
:root #address-form-section .row.third-gutters > .form-group {
  flex: 1 1 0;
  max-width: none;
  margin: 0;
  padding: 0;
}
:root .formless-address.form-control {
  height: auto;
  padding: 16px;
  border: 0;
  border-radius: 10px;
  background: var(--qd-cream);
}
:root .formless-address .review-block-detailed-item {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  margin: 0;
  padding: 0;
}
:root .formless-address .center-area {
  flex: 1;
  padding: 0;
}
:root .formless-address .content p {
  margin: 0 0 4px;
  font: 500 13px/18px Montserrat, sans-serif;
  color: var(--qd-ink);
}
:root .formless-address .content p:last-child {
  margin: 0;
}
:root .formless-address .content p:first-child {
  font: 600 14px/18.4px Inter, Montserrat, sans-serif;
  text-transform: uppercase;
}
:root .formless-address .content .text-bold {
  font-weight: 500;
}
:root .formless-address .change-button-area .btn-link {
  padding: 0;
  font: 700 13px/18px Montserrat, sans-serif;
  color: var(--qd-ink);
  text-decoration: underline;
  text-underline-position: from-font;
}

{#/* ---------- botão principal (367:14166) ---------- */#}
:root .btn-submit-step:not(.hide) {
  float: none !important;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 44px;
  margin: 6px 0 0 !important;
  padding: 0 16px;
  border: 0;
  border-radius: 60px;
  background: var(--qd-teal) !important;
  box-shadow: none;
  font: 700 12px/17px Montserrat, sans-serif;
  letter-spacing: 0;
  text-transform: uppercase;
  color: var(--qd-offwhite) !important;
}

{#/* ---------- resumo: cartões dos produtos (367:13804) ---------- */#}
:root #secondary-column .summary,
:root #secondary-column .summary-details.panel {
  margin: 0;
  padding: 0;
  background: none;
  border: 0;
  box-shadow: none;
}
:root #secondary-column .summary {
  top: 20px;
}
:root table.table-scrollable,
:root table.table-scrollable tbody {
  display: flex;
  flex-direction: column;
  gap: 12px;
  width: 100%;
  max-height: none;
  margin: 0;
  padding: 0;
  border: 0;
  overflow: visible;
}
:root table.table-scrollable tr {
  display: grid;
  grid-template-columns: 116px 1fr;
  grid-template-rows: 1fr auto auto 1fr;
  column-gap: 6px;
  min-height: 136px;
  padding: 0 16px 0 0;
  border: 1px solid rgba(0, 0, 0, 0.1);
  border-radius: 10px;
  background: var(--qd-offwhite);
}
:root table.table-scrollable td {
  display: block;
  width: auto !important;
  padding: 0;
  border: 0;
  background: none;
  text-align: left !important;
}
:root td.summary-img-wrap {
  grid-column: 1;
  grid-row: 1 / -1;
  align-self: center;
  padding: 10px 0 !important;
}
:root td.summary-img-wrap .summary-img,
:root td.summary-img-wrap .summary-img-thumb {
  width: 116px;
  height: 116px;
  margin: 0;
  padding: 0;
  border: 0;
  border-radius: 14px;
  overflow: hidden;
  background: #fff;
}
:root td.summary-img-wrap img {
  width: 116px;
  height: 116px;
  max-width: none;
  max-height: none;
  object-fit: cover;
  border-radius: 14px;
}
:root td.table-product-name {
  grid-column: 2;
  grid-row: 2;
  font: 500 13px/18px Montserrat, sans-serif;
  color: var(--qd-ink);
}
:root td.table-price {
  grid-column: 2;
  grid-row: 3;
  padding-top: 15px !important;
  font: 700 13px/20px Montserrat, sans-serif;
  color: var(--qd-teal);
}
:root td.table-price * {
  font: inherit;
  color: inherit;
}

{#/* ---------- resumo: totais e cupom (367:13824) ---------- */#}
:root .table-subtotal {
  padding: 16px 21px 0;
  border: 0;
  background: none;
}
:root .table-subtotal table {
  width: 100%;
  margin: 0;
}
:root .table-subtotal tbody,
:root .table-subtotal tfoot {
  display: flex;
  flex-direction: column;
  gap: 8px;
  border: 0;
}
:root .table-subtotal tfoot {
  margin-top: 8px;
}
:root .table-subtotal tr {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 10px;
}
:root .table-subtotal tfoot tr {
  align-items: flex-start;
  padding: 6px 0;
}
:root .table-subtotal td {
  padding: 0;
  border: 0;
  background: none;
  font: 500 13px/18.4px Inter, Montserrat, sans-serif;
  letter-spacing: 0.13px;
  color: var(--qd-ink-strong);
}
:root tr.table-shipping-cost > td:first-child::before {
  content: "Frete";
  font: 500 13px/18.4px Inter, Montserrat, sans-serif;
}
:root .table-subtotal td.text-right,
:root .table-subtotal td.text-right * {
  font: 700 15px/20px Montserrat, sans-serif;
  letter-spacing: 0;
  color: var(--qd-ink);
}
:root .table-subtotal tfoot td:first-child {
  font: 500 13px/16.5px Montserrat, sans-serif;
  color: var(--qd-ink-strong);
}
:root .table-subtotal tfoot td.text-right {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
}
:root .table-subtotal tfoot td.text-right > span:first-child,
:root .table-subtotal tfoot td.text-right > span:first-child * {
  font: 700 19px/20px Montserrat, sans-serif;
  color: var(--qd-teal);
}
:root #secondary-column .summary-coupon {
  padding: 8px 21px 20px;
  border: 0;
}
{#/* no celular o cupom aparece acima do formulário */#}
:root .summary-coupon.d-md-none {
  margin: 0 0 26px;
  padding: 0;
  border: 0;
  background: none;
}
:root .box-discount-coupon-applied {
  padding: 0 !important;
  border: 0 !important;
  background: none !important;
}
:root .box-discount-coupon-applied .row,
:root .box-discount-coupon-applied .col-12 {
  margin: 0;
  padding: 0;
}
:root .box-discount-coupon-applied .btn-link {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 42px;
  padding: 0 1px;
  border: 1px solid var(--qd-ink);
  border-radius: 20px;
  background: none;
  text-decoration: none;
  font: 500 13px/16.5px Montserrat, sans-serif;
  letter-spacing: 0;
  text-transform: uppercase;
  color: var(--qd-ink);
}
:root .box-discount-coupon-applied .btn-link > span {
  display: inline-flex;
  align-items: center;
  gap: 8px;
}
:root .box-discount-coupon-applied .btn-link .text-pre-line {
  text-decoration: none;
  letter-spacing: 0;
}
:root .box-discount-coupon-applied .coupon-icon {
  display: none;
}
:root .box-discount-coupon-applied .btn-link > span::before {
  content: "";
  flex: 0 0 20px;
  width: 20px;
  height: 20px;
  background: currentColor;
  -webkit-mask: var(--qd-tag) center / 20px no-repeat;
  mask: var(--qd-tag) center / 20px no-repeat;
}

{#/* ---------- rodapé do app NubeSDK (363:9230) na largura da tela ---------- */#}
:root #nube-sdk-slot-after_main_content {
  width: 100vw;
  max-width: none;
  margin-left: calc(50% - 50vw);
  padding: 0;
}
{#/* o app não tem media query: em telas menores o tema reduz as margens e empilha os benefícios.
   Estrutura do app: rodapé > conteúdo > (benefícios > lista, legal) + faixa em degradê */#}
@media (max-width: 1199.98px) {
  :root #nube-sdk-slot-after_main_content > .nube-column {
    gap: 40px !important;
  }
  :root #nube-sdk-slot-after_main_content > .nube-column > .nube-column {
    padding: 40px 24px 0 !important;
  }
  :root #nube-sdk-slot-after_main_content .nube-row > .nube-row {
    gap: 20px 40px !important;
    padding: 0 0 32px !important;
  }
  :root #nube-sdk-slot-after_main_content .nube-row > .nube-row > .nube-box {
    display: none !important;
  }
  :root #nube-sdk-slot-after_main_content > .nube-column > .nube-column > .nube-row:last-child {
    margin: 0 !important;
  }
}
@media (max-width: 767.98px) {
  :root #nube-sdk-slot-after_main_content .nube-row > .nube-row {
    flex-direction: column !important;
    align-items: flex-start !important;
  }
  :root #nube-sdk-slot-after_main_content > .nube-column > .nube-column > .nube-row:last-child {
    flex-direction: column !important;
    align-items: flex-start !important;
    padding: 20px 0 !important;
  }
}

{#/* ---------- celular (o Figma só tem desktop; mesmo estilo, empilhado) ---------- */#}
@media (max-width: 767.98px) {
  :root .headbar {
    height: 70px;
  }
  :root .headbar-logo-img {
    width: 133px;
    height: 40px;
  }
  :root #headbar-right {
    font-size: 11px;
    line-height: 16px;
  }
  :root #headbar-right::after {
    margin-right: 0;
    padding-right: 26px;
    line-height: 20px;
    background-size: 20px;
  }
  :root #breadcrumb {
    margin: 24px auto 8px;
  }
  :root ul.breadcrumb-timeline {
    gap: 8px;
    height: 56px;
  }
  :root ul.breadcrumb-timeline > li.breadcrumb-timeline-line {
    flex-basis: 20px;
    width: 20px !important;
  }
  :root .breadcrumb-timeline-item {
    height: 56px;
    padding: 0 4px;
  }
  :root .breadcrumb-timeline-item-text {
    font-size: 13px;
  }
  :root .breadcrumb-timeline-item.current .breadcrumb-timeline-item-text::after {
    top: 32px;
    height: 3px;
  }
  :root .main-container {
    padding: 0 16px 40px;
  }
  :root .panel-header {
    padding-bottom: 20px;
    font-size: 18px;
  }
  :root #address-form-section > .panel-header {
    padding-bottom: 0;
  }
  :root #address-form-section > .panel-header::before {
    font-size: 18px;
  }
  :root #address-form-section {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
  :root #address-form-section > .form-group:has(input[name="shippingAddress.phone"]) {
    grid-column: 1 / -1;
  }
}

{% endif %}
