##master-page:SquidTemplate
#format wiki
#language en
<<TableOfContents>>

= man(8) documentation guidelines and standards =
This is a '''proposal''' for a standard manual page documentation format and template. The aim is to allow documentation writers to focus on documentation and not on specific format and semantics, and to help integrate new texts with translation string automation.

== Entities to be documented ==
All application binary, scripts, and configuration files installed on end server systems are to be documented with a manual page.

=== TODO ===

== Documentation format ==
Use simplified ngroff syntax. see http://www.fnal.gov/docs/products/ups/ReferenceManual/html/manpages.html for ngroff format details.

Some additional markup is added for integration with '''po4a''' translation automation. see http://po4a.alioth.debian.org/man/man3pm/Locale::Po4a::Man.3pm.php for details on specific markup and limits imposed by those tools.

Each '''.SN''' section is preceded by an ''empty'' line. In ngroff syntax that is a line containing only a dot (.) as demonstrated below between the '''.TH''' line and the first '''.SN''' line.

The document overview is as follows. Introductory header markup as shown followed by any applicable sections. Which are detailed in more depth below.
{{{
.if !'po4a'hide' .TH binary.name 8
.
.SH NAME
.SH SYNOPSIS
.SH DESCRIPTION
.SH OPTIONS
.SH CONFIGURATION
.SH AUTHOR
.SH COPYRIGHT
.SH QUESTIONS
.SH REPORTING BUGS
.SH SEE ALSO
}}}

=== .SH NAME ===
Three lines of content only.
 1. name of file being documented. Marked not for translation.
 2. a hyphen. Marked not for translation.
 3. A one-line description of the file. Suitable for use in a title.

For example:
{{{
.
.SN NAME
.if !'po4a'hide' .B squid
.if !'po4a'hide' \-
HTTP Web Proxy caching server.
}}}
documents
{{{
squid - HTTP Web Proxy caching server.
}}}

=== .SH SYNOPSIS ===
The plain command line option syntax.

If an option takes a parameter those parameter descriptors are to be left open for translation. All other parts of the syntax are to be marked not for translation.

For example:
{{{
.
.SH SYNOPSIS
.if !'po4a'hide' .B squid
.if !'po4a'hide' .B [\-dh]
.if !'po4a'hide' .B [\-f
config\-file
.if !'po4a'hide' .B ]
}}}
documents:
{{{
squid [-dh] [-f config-file ]
}}}

=== .SH DESCRIPTION ===
The full description of what the file object is all about. It should but is not required to begin with the file name in bold. Paragraphs in the description are separated by '''.PP''' tags.

Use '''.if !'po4a'hide' ''' to mark any lines of syntax as not for translation.

Any words which name a file or binary should be marked out in bold.

For example:
{{{
.
.SH DESCRIPTION
.PP
.B squid
is a high-performance proxy caching server for web clients,
supporting FTP, gopher, ICAP, ICP, HTCP and HTTP data objects.
Unlike traditional caching software,
Squid handles all requests in a single, non-blocking process.
.PP
Squid keeps meta data and especially hot objects cached in RAM,
caches DNS lookups, supports non-blocking DNS lookups, and implements
negative caching of failed requests.
.
.if !'po4a'hide' http://www.squid-cache.org/
}}}

=== .SH OPTIONS ===
A fully documented list of available command line options.

The option switch and any accepted variable names are marked not for translation.

The option description is marked for translation.

For example:
{{{
.
.SH OPTIONS
.if !'po4a'hide' .TP 2
.if !'po4a'hide' .B \-d
Write debug info to stderr.
.TP
.if !'po4a'hide' .B "\-f config\-file"
Use configuration file
.B config\-file
}}}

=== .SH CONFIGURATION ===
Optional section specific to application binaries and maybe helper scripts.

Configuration files have their syntax covered under '''.SH DESCRIPTION'''

This section should cover snippets 
{{{
.
.SH CONFIGURATION
}}}

=== .SH AUTHOR ===
A list of relevant paragraphs specific to the authorship style of the documented program, script or file.

For a simple binary or script where the manual was also authored by the same individual(s):
{{{
.
.SH AUTHOR
This program and documentation was written by
.if !'po4a'hide' .I Authors Name <author@email.contact>
}}}

For a more complicated case where the application has one or more authors and is based on a prior work:
{{{
.
.SH AUTHOR
This program was written by
.if !'po4a'hide' .I Authors Name <author@email.contact>
.if !'po4a'hide' .I Authors Name <author@email.contact>
.if !'po4a'hide' .I Authors Name <author@email.contact>
.
Based on prior work in
.B older.source
by
.if !'po4a'hide' .I Authors Name <author@email.contact>
}}}

Where the manual documentation was by a different author or authors than the program:
{{{
.
.SH AUTHOR
This program was written by
.if !'po4a'hide' .I Authors Name <author@email.contact>
.
This manual was written by
.if !'po4a'hide' .I Authors Name <author@email.contact>
}}}

=== .SH COPYRIGHT ===
Details of the copyright associated with this binary, script, or configuration file.

For example:
{{{
.
.SH COPYRIGHT
Squid
.B example.binary
and this manual is Copyright 2010
.if !'po4a'hide' .I Authors Name <author@email.contact>
}}}

=== .SH QUESTIONS ===
Verbatim snippet detailing the Squid project user help contacts.

{{{
.SH QUESTIONS
Questions on the usage of this program can be sent to the
.I Squid Users mailing list
.if !'po4a'hide' <squid-users@squid-cache.org>
}}}

=== .SH REPORTING BUGS ===
Should begin with a standard text describing the Squid project points of contact:

{{{
.
.SH REPORTING BUGS
Report bugs or bug fixes using http://bugs.squid-cache.org/
.PP
Report serious security bugs to
.I Squid Bugs <squid-bugs@squid-cache.org>
.PP
Report ideas for new improvements to the
.I Squid Developers mailing list
.if !'po4a'hide' <squid-dev@squid-cache.org>
}}}

Any further points of contact or reporting should be listed following the Squid project contacts and be written in a similar syntax.

=== .SH SEE ALSO ===
References to other documentation related to this file.

Each item listed should have a line of its own for easy readability and to allow individual items to be marked not for translation.

Should start with a list of other manual pages, followed by a list of described external resources.

For example:
{{{
.
.SH SEE ALSO
.if !'po4a'hide' .B squid "(8), "
.if !'po4a'hide' .B cachemgr.cgi "(8), "
.br
The Squid FAQ wiki
.if !'po4a'hide' http://wiki.squid-cache.org/SquidFaq
.br
The Squid Configuration Manual
.if !'po4a'hide' http://www.squid-cache.org/Doc/config/
}}}

----
 Discuss this page using the "Discussion" link in the main menu

<<Include(/Discussion)>>
