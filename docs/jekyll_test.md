## jekyll test playground


### explore group_by
{% assign directories = site.pages | group_by: "dir" %}
{% for dir in directories -%}
{%- if dir.name == "assets/css" -%}{%- continue -%}{%- endif -%}
- {{ dir.name | default: "/" }}
{% for e in dir.items -%}
{%- assign extension = e.name | split: "" | slice: -3, 3 | join: "" -%}
{% if extension == ".md"
%}    - <a href="{{ e.url }}">{{ e.title }} -> {{ e.name }}</a>
{% endif -%}
{% endfor -%}
{% endfor -%}


{% comment %}
## navigation tree
{% navigation_tree / %}
{% endcomment %}

{% comment %}
# simple
{% assign mypages = site.pages | sort_natural: "dir" %}
{% for current in mypages %}
- <a href="{{ current.url }}">title: "{{ current.title }}" dir: {{ current.dir }}, name {{ current.name }} </a>
{% endfor %}
{% endcomment %}

## site collections

- site.collections 

## site data

- site.data

