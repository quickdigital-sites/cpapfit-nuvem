{#
  CPAP Fit: foto do primeiro slide (LCP) com versão de computador e de celular.
  Um <picture> só: o navegador baixa apenas a imagem do tamanho da tela, já com prioridade alta,
  sem esperar o JS do carrossel (antes a de computador vinha por swiper-lazy).
  Recebe: hero_desktop, hero_mobile (URL ou @media-lib:...), hero_alt.
#}
{% set qd_d = hero_desktop starts with '@media-lib:' ? (hero_desktop | resolve_media) : null %}
{% set qd_m = hero_mobile starts with '@media-lib:' ? (hero_mobile | resolve_media) : null %}

{% set qd_d_srcset = '' %}
{% if qd_d %}
	{% for srcSet in qd_d.srcSets if srcSet.format == 'webp' %}
		{% for size in srcSet.sizes %}
			{% set qd_d_srcset = qd_d_srcset ~ (qd_d_srcset ? ', ') ~ srcSet.baseUrl ~ size.w ~ '.webp ' ~ size.w ~ 'w' %}
		{% endfor %}
	{% endfor %}
	{% set qd_d_srcset = qd_d_srcset | default(qd_d.sourceUrl) %}
{% else %}
	{% set qd_d_srcset = hero_desktop %}
{% endif %}

{% set qd_m_srcset = '' %}
{% if qd_m %}
	{% for srcSet in qd_m.srcSets if srcSet.format == 'webp' %}
		{% for size in srcSet.sizes %}
			{% set qd_m_srcset = qd_m_srcset ~ (qd_m_srcset ? ', ') ~ srcSet.baseUrl ~ size.w ~ '.webp ' ~ size.w ~ 'w' %}
		{% endfor %}
	{% endfor %}
{% endif %}
{% set qd_m_src = qd_m ? qd_m.sourceUrl : hero_mobile %}

<picture class="qd-hero-picture">
	<source media="(min-width: 768px)" srcset="{{ qd_d_srcset }}" sizes="100vw" />
	<img
		fetchpriority="high"
		class="image-priority-high"
		alt="{{ hero_alt }}"
		src="{{ qd_m_src }}"
		{% if qd_m_srcset %}srcset="{{ qd_m_srcset }}" sizes="100vw"{% endif %}
	/>
</picture>
