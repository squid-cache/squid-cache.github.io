{%- assign my_category = page.name | split: "" | reverse | slice: 3, 100 | reverse | join: "" -%}

# Pages in category {{ category }}

{% include pages-list-by-category.html category=my_category %}
