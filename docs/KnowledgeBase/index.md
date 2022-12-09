# Squid Knowledge Base

{%- assign pages = site.pages | where: "categories", "KB" | sort: "title" %}
{% for p in pages -%}
* [{%- if p.title -%}{{ p.title }}{%- else -%}{{p.url}}{%- endif -%}]({{ p.url | replace: ".html", "" }})
{% endfor %}
