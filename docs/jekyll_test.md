## site pages
{% for current in site.pages %}
{% if current.title == blank %}- <a href="{{ current.url }}">title: "{{ current.title }}" dir: {{ current.dir }}, name {{ current.name }} </a>{% endif %}
{% endfor %}

## site collections

- site.collections 

## site data

- site.data

