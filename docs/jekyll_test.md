## site pages
{% for current in site.pages %}
{% if current.title != "" %}- <a href="{{ current.url }}">{{ current.title }} dir: {{ current.dir }}, name {{ current.name }} </a>{% endif %}
{% endfor %}

## site collections

- site.collections 

## site data

- site.data

