# GitHub Flavoured Markdown (GFM) Cheat Sheet

Source: https://gist.github.com/roshith-balendran/d50b32f8f7d900c34a7dc00766bcfb9c

I'll introduce to the basics of GitHub Flavoured Markdown...

[How to add GitHub Markdown anchoring links](#github-readme-anchor-links-)

## Index
[Heading](#heading) | [New paragraph](#new-paragraph) | [New Line](#new-line) | [Ignore Markup](#ignore-markup) | [Bullet Point](#bullet-point) | [Inline Formatting](#inline-formatting) | [Quoting Text](#quoting-text)
--- | --- | --- | --- | --- | --- | ---
[Tables](#tables) | [Strong & Emphasize](#strong-and-emphasize) | [Links & Email](#links-and-email) | [Images](#images) | [Lists](#lists) | [Block Quote](#block-quote) | [Inline Code](#inline-code)
[Block Code](#block-code) | [Horizontal Rules](#horizontal-rules) | [Fenced Code Block](#fenced-code-block) | [Formatting Code](#formatting-code) |  |  |

[Further Reading](#further-reading)

## GitHub Markdown anchoring links
* First create a heading: **#Cool Heading**
> The anchor link for that heading is the lowercase heading name with dashes where there are spaces.
* Put your desired text in brackets, followed by the anchor link in parentheses:<br/>
Eg : \[Go to Real Cool Heading section](#real-cool-heading)<br/>
[Go to Real Cool Heading section](#real-cool-heading)
* Also the Heading should be \"### Heading"

Summary of conversion rules:  
* Punctuation marks will be dropped  
* Leading white spaces will be dropped  
* Upper case will be converted to lower  
* Spaces between letters will be converted to -

### [Index⇪](#index)

## Headers
To create a header, add one to six # symbols before your heading text. The number of # you use will determine the size of the heading.

	Header 1
	========
	Header 2
	--------

or

	# Header 1
	## Header 2
	### Header 3
	#### Header 4
	##### Header 5
	###### Header 6

## New paragraph
Leave a blank line between lines of text.<br/>

## New Line / Line Break
To force a line break,  
* Put two spaces and a newline (return) at the end of the line.  
* Add \ at the end of line.  
* You can also use \<br/>  

* This two-line bullet 
won't break

* This two-line bullet  
will break

Here is the code:

```
* This two-line bullet 
won't break

* This two-line bullet  
will break
```

## Ignore Markup
Add \ before the markdown character.<br/>

## Bullet Point
Add - at the start of the line

### [Index⇪](#index)

## Inline Formatting
**Style** |   **Syntax**   | **Keyboard shortcut** | **Example** | **Output**
--------- | ---------- | --------------------- | ----------- | ---------- 
Bold | ** ** or __ __ | ⌘/ctrl+b |  \**This is bold text** | **This is bold text** 
Italic | * * or _ _ | ⌘/ctrl+i | \*This text is italicized* | *This text is italicized* 
Strikethrough | \~~ ~~ | | \~~This was mistaken text~~ | ~~This was mistaken text~~
Bold and italic | ** ** and _ _ | | \**This text is _extremely_ important** | **This text is _extremely_ important**

The following is a list of optional inline markups supported:

Style               | Markup           | Result if enabled     |
--------------------|------------------|-----------------------|
Intra-word emphasis | So A\*maz\*ing   | So A<em>maz</em>ing   |
Strikethrough       | \~~Much wow\~~   | <del>Much wow</del>   |
Underline [^under]  | \_So doge\_      | <u>So doge</u>        |
Quote [^quote]      | \"Such editor\"  | <q>Such editor</q>    |
Highlight           | \==So good\==    | <mark>So good</mark>  |
Superscript         | hoge\^(fuga)     | hoge<sup>fuga</sup>   |
Autolink            | http://t.co      | <http://t.co>         |
Footnotes           | [\^4] and [\^4]: | [^4] and footnote 4   |

## Quoting Text
You can Quote a line by adding "> " at the start of line.<br/>
Eg : \> Hi, Everyone<br/>
>Hi, Everyone

### [Index⇪](#index)

## Tables
Tables can be created easily. 
* There must be at least 3 dashes separating each header cell.
* The outer pipes (|) are optional, and you don't need to make the raw Markdown line up prettily.
* You can also use inline Markdown.
* Colons can be used to align columns. (Center :----:, Left :----, Right ----:)

Example :<br/>
Markdown | Less | Pretty<br/>
--- | --- | ---<br/>
*Still* | `renders` | **nicely**<br/>
1 | 2 | 3

Markdown | Less | Pretty
--- | --- | ---
*Still* | `renders` | **nicely**
1 | 2 | 3

## Strong and Emphasize
**Strong**: `**Strong**` or `__Strong__` (Command-B)  

*Emphasize*: `*Emphasize*` or `_Emphasize_`[^emphasize] (Command-I)

## Links and Email
### Inline
Just put angle brackets around an email and it becomes clickable: <roshithbalendran@gmail.com>  
`<roshithbalendran@gmail.com>`  

Same thing with urls: <https://www.google.com>  
` <https://www.google.com>`  

Perhaps you want to some link text like this: [GitHub](https://www.github.com "Title")  
`[GitHub Website](https://www.github.com "Title")` (The title is optional)  


### Reference style
Sometimes it looks too messy to include big long urls inline, or you want to keep all your urls together.  

Make [a link][arbitrary_id] `[a link][arbitrary_id]` then on it's own line anywhere else in the file:  
`[arbitrary_id]: https://www.github.com "Title"`
  
If the link text itself would make a good id, you can link [like this][] `[like this][]`, then on it's own line anywhere else in the file:  
`[like this]: https://www.github.com`  

[arbitrary_id]: https://www.github.com "Title"
[like this]: https://www.github.com 

### [Index⇪](#index)

## Images
#### Inline
`![Alt Image Text](path/or/url/to.jpg "Optional Title")`
#### Reference style
`![Alt Image Text][image-id]`  
on it's own line elsewhere:  
`[image-id]: path/or/url/to.jpg "Optional Title"`

## Lists

* Lists must be preceded by a blank line (or block element)
* Unordered lists start each item with a `*`
- `-` works too
	* Indent a level to make a nested list
		1. Ordered lists are supported.
		2. Start each item (number-period-space) like `1. `
		42. It doesn't matter what number you use, I will render them sequentially
		1. So you might want to start each line with `1.` and let me sort it out

Here is the code:

```
* Lists must be preceded by a blank line (or block element)
* Unordered lists start each item with a `*`
- `-` works too
	* Indent a level to make a nested list
		1. Ordered lists are supported.
		2. Start each item (number-period-space) like `1. `
		42. It doesn't matter what number you use, I will render them sequentially
		1. So you might want to start each line with `1.` and let me sort it out
```

## Block Quote

> Angle brackets `>` are used for block quotes.  
Technically not every line needs to start with a `>` as long as
there are no empty lines between paragraphs.  
> Looks kinda ugly though.
> > Block quotes can be nested.  
> > > Multiple Levels
>
> Most markdown syntaxes work inside block quotes.
>
> * Lists
> * [Links][arbitrary_id]
> * Etc.

Here is the code:

```
> Angle brackets `>` are used for block quotes.  
Technically not every line needs to start with a `>` as long as
there are no empty lines between paragraphs.  
> Looks kinda ugly though.
> > Block quotes can be nested.  
> > > Multiple Levels
>
> Most markdown syntaxes work inside block quotes.
>
> * Lists
> * [Links][arbitrary_id]
> * Etc.
```

## Inline Code
`Inline code` is indicated by surrounding it with backticks:  
`` `Inline code` ``

If your ``code has `backticks` `` that need to be displayed, you can use double backticks:  
```` ``Code with `backticks` `` ````  (mind the spaces preceding the final set of backticks)


## Block Code
If you indent at least four spaces or one tab, I'll display a code block.

	print('This is a code block')
	print('The block must be preceded by a blank line')
	print('Then indent at least 4 spaces or 1 tab')
		print('Nesting does nothing. Your code is displayed Literally')

I also know how to do something called [Fenced Code Blocks](#fenced-code-block) which I will tell you about later.

## Horizontal Rules
If you type three asterisks `***` or three dashes `---` on a line, I'll display a horizontal rule:

***

## Fenced Code Block

This is a fenced code block:

```
print('Hello world!')
```

You can also use waves (`~`) instead of back ticks (`` ` ``):

~~~
print('Hello world!')
~~~

## Formatting Code
If you want to format the code snippets in a specific Programming Language, simply add the name of the language after the back ticks. 
```  
\```swift  
    override func viewDidLoad() {  
        super.viewDidLoad()  
    }  
\```
```
```swift
    override func viewDidLoad() {
        super.viewDidLoad()
    }
```

### [Index⇪](#index)

## Further Reading
https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet<br/>
https://help.github.com/articles/basic-writing-and-formatting-syntax/#quoting-code<br/>
https://guides.github.com/features/mastering-markdown/<br/>
https://gist.github.com/MinhasKamal/7fdebb7c424d23149140