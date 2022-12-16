# Squid Web Cache FAQ

## Introduction

{% assign section = "preamble" %}
{%- assign pages = site.pages | where: "FaqSection", section | sort: "title" -%}
{% for p in pages -%}
* [{%- if p.title -%}{{ p.title }}{%- else -%}{{p.url}}{%- endif -%}]({{ p.url | replace: ".html", "" }})
{% endfor %}

## Installation and Use

{% assign section = "installation" %}

{%- assign pages = site.pages | where: "FaqSection", section | sort: "title" -%}
{% for p in pages -%}
* [{%- if p.title -%}{{ p.title }}{%- else -%}{{p.url}}{%- endif -%}]({{ p.url | replace: ".html", "" }})
{% endfor %}


## Modes of operation

- Explicit Proxy (or Forward Proxy) is the basic mode, upon which
  everything else is built.
- *Offline* or aggressive mode: serving up stale data with
  minimal network usage
- ESI processor (or ESI surrogate): Assembling web pages.
  This is a sub-type of accelerator mode which since
  [Squid-3.3](/Releases/Squid-3.3)
  is enabled automatically and cannot be used with other modes


## Running squid

{% assign section = "operation" %}
{%- assign pages = site.pages | where: "FaqSection", section | sort: "title" -%}
{% for p in pages -%}
* [{%- if p.title -%}{{ p.title }}{%- else -%}{{p.url}}{%- endif -%}]({{ p.url | replace: ".html", "" }})
{% endfor %}

## Troubleshooting
{% assign section = "troubleshooting" %}
{%- assign pages = site.pages | where: "FaqSection", section | sort: "title" -%}
{% for p in pages -%}
* [{%- if p.title -%}{{ p.title }}{%- else -%}{{p.url}}{%- endif -%}]({{ p.url | replace: ".html", "" }})
{% endfor -%}

- the [KnowledgeBase](/KnowledgeBase)
  Covers how things are supposed to work and what to look out for. It includes specific help guides for supported operating systems.
- [ConfigExamples](/ConfigExamples):
  Gives detailed configurations in case you have missed something

## Performance Tuning
{% assign section = "performance" %}
{%- assign pages = site.pages | where: "FaqSection", section | sort: "title" -%}
{% for p in pages -%}
* [{%- if p.title -%}{{ p.title }}{%- else -%}{{p.url}}{%- endif -%}]({{ p.url | replace: ".html", "" }})
{% endfor %}

## Squid features

See [Features](/Features) for a run down of Squid's main features

## Other FAQ

{% assign section = "misc" %}
{%- assign pages = site.pages | where: "FaqSection", section | sort: "title" -%}
{% for p in pages -%}
* [{%- if p.title -%}{{ p.title }}{%- else -%}{{p.url}}{%- endif -%}]({{ p.url | replace: ".html", "" }})
{% endfor %}
