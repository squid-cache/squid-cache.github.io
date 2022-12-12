# Programming guide: index of articles

{% assign pdir = site.pages | where_exp: "p", "p.url contains page.dir" %}
{% for p in pdir -%}
{%- assign purl =  p.url | replace: page.dir, "" | replace: ".html", "" -%}
{%- if purl == "" -%}{%- continue -%}{%- endif -%}
* [{{ purl }}]({{ purl }})
{% endfor %}
