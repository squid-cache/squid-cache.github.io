{%- assign category = page.name | split: "" | reverse | slice: 3, 100 | reverse | join: "" -%}
{%- assign pages_in_category = site.pages | where_exp: "page", "page.categories contains category" | sort: "title" -%}

# Pages in category {{ category }}

{% for p in pages_in_category -%}
* [{%- if p.title -%}{{ p.title }}{%- else -%}{{p.url}}{%- endif -%}]({{ p.url | replace: ".html", "" }})
{% endfor %}
