# Squid Knowledge Base

{%- assign pages = site.pages | where_exp: "p", "p.url contains page.url" | sort: "title" %}
{% for p in pages -%}
1. [{%- if p.title -%}{{ p.title }}{%- else -%}{{p.url}}{%- endif -%}]({{ p.url | replace: ".html", "" }})
{% endfor %}
