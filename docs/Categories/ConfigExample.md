{%- assign my_category = page.name | split: "" | reverse | slice: 3, 100 | reverse | join: "" -%}

# Pages in category {{ category }}

{% include enumerate-files.html category=my_category %}
