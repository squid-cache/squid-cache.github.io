# Site Pages

List of all the pages in the site, grouped by directory
{% assign directories = site.pages | group_by: "dir" %}
{% for dir in directories -%}
{%- if dir.name == "assets/css" -%}{%- continue -%}{%- endif -%}
{%- assign have_index = dir.items | where: "name", "index.md"  | default: false -%}
- {% if have_index -%}[{{ dir.name | default: "/" }}]({{ dir.name | default: "/" }})
  {%- else -%}{{ dir.name | default: "/" }}{%- endif %}
{% for e in dir.items -%}
{%- assign extension = e.name | split: "" | slice: -3, 3 | join: "" -%}
{% if extension == ".md"
%}    - <a href="{{ e.url | replace: '.html', '' }}">{{ e.title | default: e.url | replace: ".html", ""}}</a> {%- unless e.title %}(Fix title){% endunless %}
{% endif -%}
{% endfor -%}
{% endfor -%}
