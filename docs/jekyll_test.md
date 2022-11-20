## site pages
{% assign mypages = site.pages | sort: "title" %}
{% for current in mypages %}
{% if current.title != empty %}- <a href="{{ current.url }}">title: "{{ current.title }}" dir: {{ current.dir }}, name {{ current.name }} </a>{% endif %}
{% endfor %}

## site collections

- site.collections 

## site data

- site.data

