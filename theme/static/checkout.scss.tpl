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
  --qd-gap: 100px;
  --qd-lock: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24'%3E%3Cpath fill='%23AD9361' d='M6 8V7C6 3.68629 8.68629 1 12 1C15.3137 1 18 3.68629 18 7V8H20C20.5523 8 21 8.44772 21 9V21C21 21.5523 20.5523 22 20 22H4C3.44772 22 3 21.5523 3 21V9C3 8.44772 3.44772 8 4 8H6ZM19 10H5V20H19V10ZM11 15.7324C10.4022 15.3866 10 14.7403 10 14C10 12.8954 10.8954 12 12 12C13.1046 12 14 12.8954 14 14C14 14.7403 13.5978 15.3866 13 15.7324V18H11V15.7324ZM8 8H16V7C16 4.79086 14.2091 3 12 3C9.79086 3 8 4.79086 8 7V8Z'/%3E%3C/svg%3E");
  --qd-tag: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 20 20'%3E%3Cpath d='M9.08683 1.75021L17.3364 2.92872L18.5149 11.1783L10.8546 18.8386C10.5292 19.1641 10.0016 19.1641 9.67608 18.8386L1.42653 10.5891C1.10109 10.2636 1.10109 9.736 1.42653 9.4105L9.08683 1.75021ZM9.67608 3.51798L3.1943 9.99975L10.2653 17.0708L16.7472 10.5891L15.8633 4.40186L9.67608 3.51798ZM11.4439 8.82125C10.793 8.1704 10.793 7.11513 11.4439 6.46425C12.0948 5.81338 13.15 5.81338 13.8009 6.46425C14.4518 7.11513 14.4518 8.1704 13.8009 8.82125C13.15 9.47217 12.0948 9.47217 11.4439 8.82125Z'/%3E%3C/svg%3E");
  --qd-check: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 20 20'%3E%3Cpath d='M5 10.2l3.2 3.2L15 6.6' fill='none' stroke='%23fefdfc' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'/%3E%3C/svg%3E");
}

:root body {
  background: #fff;
  color: var(--qd-ink);
  font-family: Montserrat, sans-serif;
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
  content: url("data:image/png;base64,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");
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
  content: "Ambiente";
  margin-right: 5px;
}
:root #headbar-right::after {
  content: "100% seguro";
  margin-right: 8px;
  padding-right: 34px;
  font-weight: 700;
  line-height: 24px;
  background-image: var(--qd-lock);
  background-repeat: no-repeat;
  background-position: right center;
  background-size: 24px 24px;
}
{#/* a linha do app NubeSDK vira o selo dentro do cabeçalho, como no Figma */#}
:root #nube-sdk-slot-after_header {
  display: none !important;
}

{#/* ---------- grade: formulário 780 + 100 + resumo 390 (367:13768) ---------- */#}
:root .main-container {
  max-width: 1290px;
  padding: 0 10px;
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
  {#/* o nativo posiciona as linhas soltas no rodapé da faixa; aqui ficam entre as etapas */#}
  position: static !important;
  align-self: center;
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
  {#/* o nativo é uma coluna (ícone em cima, texto embaixo) */#}
  flex-direction: row !important;
  align-items: center;
  justify-content: center;
  {#/* o nativo fixa o botão na largura do ícone (25px) */#}
  width: auto !important;
  min-width: 0 !important;
  max-width: none !important;
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
  top: auto !important;
  left: auto !important;
  transform: none !important;
  margin: 0 !important;
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
  top: 33px;
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
  {#/* o nativo corta o rótulo numa linha (nowrap + overflow hidden); no celular "Complemento (opcional)" não cabe */#}
  white-space: normal !important;
  overflow: visible !important;
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
  flex-wrap: wrap;
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
  top: auto;
  right: 17px;
  bottom: 13px;
  left: auto;
  font: 500 13px/24px Montserrat, sans-serif;
  color: var(--qd-ink);
}
:root .has-float-label > .input-validation-icon {
  position: absolute;
  top: auto;
  right: 17px;
  bottom: 15px;
  left: auto;
  margin: 0;
}
:root .has-float-label > .input-button {
  position: absolute;
  top: auto;
  right: 17px;
  bottom: 15px;
  left: auto;
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
  background-color: var(--qd-ink-strong);
  background-image: var(--qd-check);
  background-repeat: no-repeat;
  background-position: center;
  background-size: 18px 18px;
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
  top: auto;
  left: auto;
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
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
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
  {#/* 10px do "Mais opções" + 16px = os 26px entre seções do Figma */#}
  padding-top: 16px;
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  column-gap: 20px;
  row-gap: 26px;
}
:root #address-form-section > * {
  grid-column: 1 / 4;
  margin: 0;
}
:root #address-form-section > .panel-header {
  padding: 0;
}
:root #address-form-section > .form-group:nth-child(2),
:root #address-form-section > .form-group:nth-child(3),
:root #address-form-section > .form-group:nth-child(4) {
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
  grid-row: 1 / 5;
  align-self: center;
  box-sizing: border-box;
  width: 116px !important;
  height: 136px;
  padding: 10px 0 !important;
}
:root td.summary-img-wrap .summary-img,
:root td.summary-img-wrap .summary-img-thumb {
  position: relative;
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
  -webkit-mask-image: var(--qd-tag);
  -webkit-mask-repeat: no-repeat;
  -webkit-mask-size: 20px 20px;
  mask-image: var(--qd-tag);
  mask-repeat: no-repeat;
  mask-size: 20px 20px;
}

{#/* ---------- rodapé do app NubeSDK (363:9230) na largura da tela ---------- */#}
:root #nube-sdk-slot-after_main_content {
  width: 100vw;
  max-width: none;
  margin-top: 60px;
  margin-left: calc(50% - 50vw);
  padding: 0;
}
{#/* o app não tem media query: em telas menores o tema reduz as margens e empilha os benefícios.
   Estrutura do app: rodapé > conteúdo > (benefícios > lista > itens, legal) + faixa em degradê.
   Seletores só até o nível do item: cada item tem linhas internas (ícone + textos) que não podem herdar isto. */#}
{#/* com os 4 benefícios (Pix e cupom ligados) a linha só cabe a partir de ~1600px; abaixo disso eles quebram
   centralizados, sem os separadores */#}
@media (max-width: 1599.98px) {
  :root #nube-sdk-slot-after_main_content > .nube-column > .nube-column > .nube-row:first-child > .nube-row {
    gap: 20px 40px !important;
    padding: 24px 0 !important;
  }
  :root #nube-sdk-slot-after_main_content > .nube-column > .nube-column > .nube-row:first-child > .nube-row > .nube-box {
    display: none !important;
  }
}
@media (max-width: 1199.98px) {
  :root #nube-sdk-slot-after_main_content > .nube-column {
    gap: 40px !important;
  }
  :root #nube-sdk-slot-after_main_content > .nube-column > .nube-column {
    padding: 40px 24px 0 !important;
  }
  :root #nube-sdk-slot-after_main_content > .nube-column > .nube-column > .nube-row:first-child > .nube-row > .nube-row {
    flex-wrap: wrap !important;
    row-gap: 12px !important;
  }
  :root #nube-sdk-slot-after_main_content > .nube-column > .nube-column > .nube-row:last-child {
    margin: 0 !important;
  }
}
{#/* celular: como o rodapé da loja (frontend/src/css/footer.css) — um benefício por linha, linhas finas entre eles */#}
@media (max-width: 767.98px) {
  :root #nube-sdk-slot-after_main_content > .nube-column > .nube-column {
    padding: 30px 0 0 !important;
  }
  :root #nube-sdk-slot-after_main_content > .nube-column > .nube-column > .nube-row:first-child {
    min-height: 0 !important;
    border-top: 1px solid rgba(255, 255, 255, 0.3) !important;
  }
  :root #nube-sdk-slot-after_main_content > .nube-column > .nube-column > .nube-row:first-child > .nube-row {
    flex-direction: column !important;
    align-items: stretch !important;
    gap: 0 !important;
    padding: 16px 20px !important;
  }
  {#/* ícone + texto numa linha; a pílula do cupom desce para a linha de baixo, alinhada ao texto */#}
  :root #nube-sdk-slot-after_main_content > .nube-column > .nube-column > .nube-row:first-child > .nube-row > .nube-row {
    flex-wrap: wrap !important;
    align-items: center !important;
    row-gap: 12px !important;
    padding: 16px 0 !important;
  }
  :root #nube-sdk-slot-after_main_content > .nube-column > .nube-column > .nube-row:first-child > .nube-row > .nube-row > .nube-txt:last-child,
  :root #nube-sdk-slot-after_main_content > .nube-column > .nube-column > .nube-row:first-child > .nube-row > .nube-row > p:last-child {
    margin-left: 36px !important;
  }
  :root #nube-sdk-slot-after_main_content > .nube-column > .nube-column > .nube-row:first-child > .nube-row > .nube-row ~ .nube-row {
    border-top: 1px solid rgba(255, 255, 255, 0.3) !important;
  }
  :root #nube-sdk-slot-after_main_content > .nube-column > .nube-column > .nube-row:first-child > .nube-row > .nube-row > .nube-row {
    flex-wrap: wrap !important;
  }
  :root #nube-sdk-slot-after_main_content > .nube-column > .nube-column > .nube-row:last-child {
    flex-direction: column !important;
    align-items: flex-start !important;
    gap: 16px !important;
    padding: 24px !important;
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
    top: 28px;
    height: 3px;
  }
  :root .main-container {
    padding: 0 16px;
  }
  :root #nube-sdk-slot-after_main_content {
    margin-top: 40px;
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
  :root #address-form-section > * {
    grid-column: 1 / 3;
  }
  :root #address-form-section .row.third-gutters {
    flex-direction: column;
    gap: 26px;
  }
  {#/* em coluna o flex: 1 1 0 do computador zera a altura dos campos */#}
  :root #address-form-section .row.third-gutters > .form-group {
    flex: 0 0 auto;
  }
  :root #address-form-section > .form-group:nth-child(2),
  :root #address-form-section > .form-group:nth-child(3) {
    grid-column: auto;
  }
  :root #address-form-section > .form-group:nth-child(4) {
    grid-column: 1 / 3;
  }
}

{% endif %}
