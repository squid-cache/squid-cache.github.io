#format wiki
#language en

= Configuration Syntax =

This page summarizes squid.conf syntax issues related to revising squid.conf parsing to handle configuration values with spaces (and special characters), better regular expressions support, and more flexible comments. Currently, the grammar being documented here is not fully supported by Squid and is not final. Eventually, this page will document the revised syntax.

== Expected breakages (non-backward compatible changes) ==

The examples below just illustrate a general breakage point.Many similar breaking points are possible. Unless noted otherwise, the examples are not specific to the Squid configuration directive names or parameters they are using.

=== In legacy mode ===

{{{
acl http_access src 127.0.0.1
acl deny src 127.0.0.2
http_access allow foo # comment \
http_access deny bar
}}}

After comment-preserving unfolding, the above will be interpreted as

{{{
http_access allow foo http_access deny bar
}}}

instead of the current

{{{
http_access allow foo
}}}

Hopefully, nobody is using directive names and other "keywords" as ACL names while also trying to comment out line unfolding. Is it possible to come up with a more realistic breakage case for this comment handling change?


=== In strict mode ===

 1. `acl foo url_regex squid::"bar"` will be interpreted as a 3-letter "bar" RE. There is no remedy for this breakage but we hope that `squid::"` strings are very uncommon in ACL specifications.

 1. `acl foo url_regex squid::bar(baz)?` will cause "unknown function name: bar" errors. XXX: Should we relax this to only warn about unknown functions (and re-parsing as a legacy token)?

 1. `acl foo url_regex squid::parameters("file.txt")` will cause "cannot read parameter file: file.txt" errors. There is no remedy for this breakage but we hope that "squid::parameters(" strings are very uncommon.

 1. `some_directive "foo"` will be interpreted as configuring a 3-letter "foo" value for that directive (Squid will eat the quotes). There is no known general remedy for this breakage, unfortunately. However, there are also currently no ''known'' cases where somebody would actually want to use a quoted string like that in the old configuration and no workaround is implemented for that specific directive. Known directives with workarounds: SquidConf:acl and SquidConf:external_acl_type.


== Open Issues ==

=== Comment Syntax ===

Which of the following should be recognized as comments? There is an agreement that the last line should be parsed as if there is no comment there, for backward compatibility. Some other cases are required to be interpreted as comments for backward compatibility as well.

{{{
 # nothing special; clearly a comment!
 #no space after hash, almost "beginning" of line; uncertain
# no space before hash, but beginning of line; a comment (used in squid.conf.documented)
#no space before or after hash, beginning of line; a comment (used in squid.conf.documented)
foo bar # clearly a comment (used in squid.conf.documented)
foo bar #comment?
foo bar# comment? (clashes with logformat %# definitions!)
foo bar#not-a-comment!
}}}

=== Logformat uses %#, %", %', and "%{User-Agent}>h" ===

We need to make sure logformat parser uses relaxed tokens.


=== Multiline directives with comments ===

Squid comments extend to the end of the line. That makes it difficult to document individual directive parameter values in complex directives. It would be nice to support the following multiline directives with comments (and multiline strings):

{{{
# here are my well-documented access rules
http_access allow \
    myself    # let myself in \
    good_guys # allow the good guys \
    nsa       # and some special cases
}}}


== Preprocessor Grammar ==

Squid preprocessors handles line folding, configuration file inclusion (with #line support), conditional configuration, and `${macros}`. The primary parser gets preprocessed content.

{{{
raw_config = *line
line = single_line / folded_lines
single_line = *lchar EOL
folded_line = single_line <\> EOL line *line

lchar = ; any octet except EOL
EOL = ; the new line character or sequence
}}}

 /!\ Currently, preprocessor removes EOL from all lines, including when unfolding lines. We should change that to support multiline directives with comments. The revised preprocessor would still need to convert CRLF into LF (\n).

For primary grammar simplicity, the revised preprocessor should also add (as a preprocessing step) a new line character if none is found at the end of the file.


== Primary Grammar ==

This grammar is ambiguous because certain directives will use legacy syntax when parsing values while others may use strict syntax or a mix. Other than that, all expressions here are meant to be "greedy", meaning that they will absorb as much text as allowed. This greediness reduces ambiguity and simplifies grammar. For example, because the legacy parameter rules are greedy, they will absorb `<#>` that might otherwise be interpreted as a start of a comment.

{{{
; the primary parser actually parses one preprocessed line (see preprocessor grammar) at a time, but that
; line may contain multiple EOL characters as the result of line unfolding performed by the preprocessor
config = *( OWS directive OWS )

directive = name *( RWS parameter ) EOL

name = token
parameter = anonymous_parameter / named_parameter

anonymous_parameter = value
named_parameter = name <=> value ; No spaces around = allowed!

; This is where the grammar is ambiguous!
; The caller must ask for either strict_value, relaxed_value, or
; "strict_value if possible and relaxed_value otherwise"
; In the latter case, the parser must check that there is no <#>
; after the strict value. If there is, it is not a strict value!
value = strict_value / relaxed_value

strict_value = token / percent / RE / fcall /
               single_quoted_string / double_quoted_string

; any non-whitespace sequence that does not start with one of
; the two reserved prefixes: "squid::" and "regex::"
relaxed_value = xchar *xchar ; with prefix restrictions

; The "squid::" prefix avoids fcall clashes with relaxed_values
; and allows us to add more functions later.
; We may require that fcall is the only or last directive parameter.
fcall = "squid::" name <(> OWS farguments OWS <)>

; we can support just one required argument for now
farguments = fargument *( OWS <,> OWS <fargument> )
fargument = strict_value

; TBD, but reserve "regex::" now to avoid clashes with relaxed_values
RE = seven characters "regex::" followed by a self-delimiting
     sequence of characters

token = tchar *tchar
percent = alphanumeric *alphanumeric <%> ; add <.>?

; note that, unlike double_quoted_string, the contents of a single quoted string is 
; interpreted with only a couple of supported escape sequences and no %macro expansion
single_quoted_string = <'> *[sqchar / escape-sequence] <'>
double_quoted_string = dqstr_basic / dqstr_prefixed
dqstr_basic = <"> *[dqchar / escape-sequence] <">
; The "squid::" prefix avoids clashes with "include/file" syntax in relaxed ACLs
; This prefix will only be required in ACLs, for backward compatibility,
; or the admin can use a single_quoted_string instead
dqstr_prefixed = "squid::" dqstr_basic

tchar = alphanumeric / <_> / <-> / <.>   ; Token char (strict)
xchar = any char except schar            ; relaXed token char
lchar = any char except EOL              ; Line char
schar = any ASCII whitespace char or EOL ; Space char
sqchar = any char except single quote and backslash
dqchar = any char except double quote and backslash
escape-sequence = <\> lchar ; must refuse unsupported escapes!

OWS = *[whitespace]  ; optional whitespace
RWS = whitespace OWS ; required whitespace

whitespace = *schar / comment
comment = <#> *lchar

EOL = <\n>; the new line character (sanitized and added by preprocessor)
}}}

The syntax is defined using [[http://tools.ietf.org/html/rfc5234|ABNF]] but its correct interpretation is impossible without obeying restrictions specified in ;comments.
