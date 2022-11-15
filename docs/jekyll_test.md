## site pages
{% assign mypages = site.pages | sort: "title" %}
{% for current in mypages | sort  %}
{% if current.title != null and current.title != "" %}- <a href="{{ current.url }}">title: "{{ current.title }}" dir: {{ current.dir }}, name {{ current.name }} </a>{% endif %}
{% endfor %}

## site collections

- site.collections 

## site data

- site.data

