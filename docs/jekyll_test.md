## site pages

### explore group_by
{% assign mypages = site.pages | group_by: "dir" %}
{% for current in mypages %}
- {{ current.name }}
{% for e in current.items %}
   - <a href="{{ e.url }}">{{ e.title }} -> {{ e.name }}</a>
{% endfor %}
{% endfor %}


---
### Known Good
{% assign mypages = site.pages | sort_natural: "dir" %}
{% for current in mypages %}
- <a href="{{ current.url }}">title: "{{ current.title }}" dir: {{ current.dir }}, name {{ current.name }} </a>
{% endfor %}

## site collections

- site.collections 

## site data

- site.data

