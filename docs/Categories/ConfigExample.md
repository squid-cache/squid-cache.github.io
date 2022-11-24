{%- comment -%}
NOT YET WORKING

Create one page per category with the exact same contents.
Jekyll will figure out the rest
{%- endcomment -%}
{%- assign category = page.name | split: "" | reverse | slice: 3, 100 | reverse | join: "" -%}
# Pages in category {{ category }}
Categories: {{ site.categories | json_encode }}
{% for post in site.categories.ConfigExample %}
- {{ post.url }}
{% endfor %}