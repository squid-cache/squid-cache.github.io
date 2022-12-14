# Site Pages

List of all the pages in the site, grouped by directory
{% assign directories = site.pages | group_by: "dir" %}
{% for dir in directories -%}
{%- if dir.name == "assets/css" -%}{%- continue -%}{%- endif -%}

- {{ dir.name | default: "/" }}
{% for e in dir.items -%}
{%- assign extension = e.name | split: "" | slice: -3, 3 | join: "" -%}
{% if extension == ".md"
%}    - <a href="{{ e.url }}">{{ e.title | default: e.url | replace: ".html", ""}}</a> (len: {{ e.content | size }})
{% endif -%}
{% endfor -%}
{% endfor -%}
