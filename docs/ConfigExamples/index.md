# Catalog of configuration examples
> :warning:
    these examples are provided in the hope that they will be helpful,
    there is no warranty that they are up to date or that they will
    work in any specific use case

{% assign pdir = site.pages | where_exp: "p", "p.url contains page.dir" %}

{% for p in pdir -%}
{%- assign purl =  p.url | replace: page.dir, "" | replace: ".html", "" -%}
{%- if purl == "" -%}{%- continue -%}{%- endif -%}
* [{{ purl }}]({{ purl }})
{% endfor %}

