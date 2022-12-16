# Markdown conventions

Markdown offers a number of options for formatting; in this wiki
please stick to this subset - use this as a cheat sheet

### File names
Use CamelCase.md for all file names. If a file name only has one word,
capitalize it
### headers
Use leading hashes, e.g.
```
# page title
## subsection
### and so on
```
### paragraphs
Leave a blank line for a paragraph break

### line breaks
Terminate a line with a backlstash to force a line break
e.g.
```
Force a\
line break
```

### horizontal lines
three dashes on an empty line

### markdown escapes
Use a backslash

### lists
```
* list
  * sublist
1. numbered list
```
* list
  * sublist
1. numbered list

### emphasis
* \** **bold** \**
* \* *italic* \*
* \*** ***bold italic*** \***
* \~~ ~~strikethrogh~~ \~~
* \` `inline code` \` . Backticks can be escaped doubling them

### quotes
```
> start a paragraph with a gt character
```

### code blocks
triple backticks on an empty line

### links
* \[text](path_or_url): [squid web site](http://www.squid-cache.org/)
* \[links to headings](#links): [links to headings](#quotes) 
* \<<email.address@example.com>\>
* \<<http://example.com/plain_link>\>

### tables

```
title|title|title
---|---|---
start|with|dashes
more|columns|here
```
If you need to align, use colons in the dash lines:
```
left|center|right
:---|:---:|---:
some very | long text to show | how it works
```

### images
!\[Alt Image Text](path/or/url/to.jpg)