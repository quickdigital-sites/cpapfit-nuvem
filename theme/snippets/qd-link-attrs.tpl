{#
  CPAP Fit: atributos de um link conforme o destino.
  Link para fora da loja (outro domínio) abre em nova aba; link da própria loja fica igual.
  Uso, dentro da tag: <a href="{{ url }}"{% include 'snippets/qd-link-attrs.tpl' with { url: url } %}>
  Links que o Twig não controla (HTML dos blocks "Código", texto rico) ficam com o
  frontend/src/js/components/external-links.js.
#}
{%- if url and url | is_external %} target="_blank" rel="noopener noreferrer"{% endif -%}
