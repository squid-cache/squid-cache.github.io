##master-page:SquidTemplate
#format wiki
#language en
<<TableOfContents>>

= man(8) documentation guidelines and standards =
This is a '''proposal''' for a standard manual page documentation format and template. The aim is to allow documentation writers to focus on documentation and not on specific format and semantics, and to help integrate new texts with translation string automation.

== Entities to be documented ==
All application binary, scripts, and configuration files installed on end server systems are to be documented with a manual page.

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

The option description is open for translation.

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

This section should cover snippets of config. Usually from squid.conf. Actual config snippets are to be marked not for translation.

For example, URL re-writers would have something like this:
{{{
.
.SH CONFIGURATION
.PP The simplest configuration for URL re-writers is to add the script or binary name to
.B squid.conf
like so:
.if !'po4a'hide' .RS
.if !'po4a'hide' url_rewrite_program /usr/bin/squid/example.binary
.if !'po4a'hide' .RE
.PP Command line options sent to a helper script or binary are added to
.B squid.conf
following the helper binary name. Like so:
.if !'po4a'hide' .RS
.if !'po4a'hide' url_rewrite_program /usr/bin/squid/example.binary -d
.if !'po4a'hide' .RE
}}}

=== .SH AUTHOR ===
A list of relevant paragraphs specific to the authorship style of the documented program, script or file.
Each paragraph ending with a list of author names and contacts and separated by a '''.PP''' tag.

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
.PP
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
.PP
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
distributed under the GNU Public License version 2 or later (GPL2+).
}}}

=== .SH QUESTIONS ===
Verbatim snippet detailing the Squid project user help contacts.

{{{
.
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

== Template manual page ==
This is a template only. Alter it according to the requirements detailed above to document an installed file.

{{{
.if !'po4a'hide' .TH binary.name 8
.
.SN NAME
.if !'po4a'hide' .B binary.name
.if !'po4a'hide' \-
Description goes here
.
.SH SYNOPSIS
.if !'po4a'hide' .B binary.name
.if !'po4a'hide' .B [\-dh]
.
.SH DESCRIPTION
.B binary.name
is an installed binary. The long description goes here
.
.SH OPTIONS
.if !'po4a'hide' .TP 2
.if !'po4a'hide' .B \-d
Write debug info to stderr.
.if !'po4a'hide' .B \-h
Display the binary help and command line syntax info using stderr.
.
.SH CONFIGURATION
.PP See FAQ wiki page for examples of how to write configuration snippets.
.PP Or just write what you want to say, then mark it up according to the wiki styles.
.
.SH AUTHOR
This program was written by
.if !'po4a'hide' .I Authors Name <author@email.contact>
.if !'po4a'hide' .I Authors Name <author@email.contact>
.if !'po4a'hide' .I Authors Name <author@email.contact>
.PP
Based on prior work in
.B older.source
by
.if !'po4a'hide' .I Authors Name <author@email.contact>
.PP
This manual was written by
.if !'po4a'hide' .I Authors Name <author@email.contact>
.
.SH COPYRIGHT
Squid
.B example.binary
and this manual is Copyright 2010
.if !'po4a'hide' .I Authors Name <author@email.contact>
distributed under the GNU Public License version 2 or later (GPL2+).
.
.SH QUESTIONS
Questions on the usage of this program can be sent to the
.I Squid Users mailing list
.if !'po4a'hide' <squid-users@squid-cache.org>
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
.
.SH SEE ALSO
.if !'po4a'hide' .B squid "(8) "
.br
The Squid FAQ wiki
.if !'po4a'hide' http://wiki.squid-cache.org/SquidFaq
.br
The Squid Configuration Manual
.if !'po4a'hide' http://www.squid-cache.org/Doc/config/
}}}

== TODO ==

Some work is underway to bring existing manual pages into matching these standard style of markup.
However there are a number of installed files which have no manual at all.

|| '''Installed file''' || '''Current State:''' ||
|| ~/access.log || {X} Missing. Relevant? ||
|| ~/cache.log || {X} Missing. Relevant? ||
|| ~/netdb.state || {X} Missing. ||
|| ~/store.log || {X} Missing. Relevant? ||
|| ~/swap.state || {X} Missing. Convert wiki page info ||
|| errors/errpages.css || {X} Missing ||
|| helpers/basic_auth/DB/basic_db_auth || Needs review of the perl/pod output. ||
|| helpers/basic_auth/getpwnam/basic_getpwnam_auth || Needs review ||
|| helpers/basic_auth/LDAP/basic_ldap_auth || Needs review ||
|| helpers/basic_auth/MSNT/msnt_auth || {X} Missing. Convert README.html ||
|| helpers/basic_auth/MSNT/msntauth.conf || {X} Missing. ||
|| helpers/basic_auth/MSNT/msntauth.conf.default || {X} Missing. ||
|| helpers/basic_auth/MSNT-multi-domain/basic_msnt_multi_domain_auth.pl || {X} Missing. Convert intro text with pod2man ||
|| helpers/basic_auth/NCSA/basic_ncsa_auth || Needs review ||
|| helpers/basic_auth/NIS/basic_nis_auth || {X} Missing. ||
|| helpers/basic_auth/PAM/basic_pam_auth || Needs review ||
|| helpers/basic_auth/POP3/basic_pop3_auth.pl || {X} Missing. ||
|| helpers/basic_auth/SASL/basic_sasl_auth || {X} Missing. Convert README ||
|| helpers/basic_auth/SASL/basic_sasl_auth.pam || {X} Missing. ||
|| helpers/basic_auth/SASL/basic_sasl_auth.conf || {X} Missing. ||
|| helpers/basic_auth/SMB/basic_smb_auth || {X} Missing. ||
|| helpers/basic_auth/SMB/basic_smb_auth.sh || {X} Missing. ||
|| helpers/basic_auth/SSPI/basic_sspi_auth || {X} Missing. Convert readme.txt ||
|| helpers/basic_auth/RADIUS/basic_radius_auth || Needs review ||
|| helpers/digest_auth/eDirectory/digest_edir_auth || {X} Missing. ||
|| helpers/digest_auth/ldap/digest_ldap_auth || {X} Missing. ||
|| helpers/digest_auth/password/digest_pw_auth || {X} Missing. ||
|| helpers/external_acl/ip_user/ip_user_check || {X} Missing. Convert example config files and README ||
|| helpers/external_acl/ldap_group/squid_ldap_group || Needs review ||
|| helpers/external_acl/mswin_ad_group/mswin_check_ad_group || {X} Missing. Convert readme.txt ||
|| helpers/external_acl/mswin_lm_group/mswin_check_lm_group || {X} Missing. Convert readme.txt ||
|| helpers/external_acl/session/squid_session || Needs review ||
|| helpers/external_acl/unix_group/squid_unix_group || Needs review ||
|| helpers/external_acl/wbinfo_group/wbinfo_group.pl || Needs review. Possibly merge to script and convert with pod2man ||
|| helpers/negotiate_auth/kerberos/negotiate_kerberos_auth || {X} Missing. Convert README ||
|| helpers/negotiate_auth/kerberos/negotiate_kerberos_auth_test || {X} Missing. Convert README ||
|| helpers/negotiate_auth/mswin_sspi/mswin_negotiate_auth || {X} Missing. Convert readme.txt ||
|| helpers/ntlm_auth/fakeauth/fakeauth_auth || {X} Missing. Convert wiki NTLM fake auth page. ||
|| helpers/ntlm_auth/mswin_sspi/mswin_ntlm_auth || {X} Missing. Convert readme.txt ||
|| helpers/ntlm_auth/no_check/no_check.pl || {X} Missing. Convert README.no_check_ntlm_auth ||
|| helpers/ntlm_auth/smb_lm/ntlm_smb_lm_auth || {X} Missing ||
|| helpers/url_rewrite/url_fake_rewrite || {X} Missing ||
|| helpers/url_rewrite/url_fake_rewrite.sh || {X} Missing ||
|| src/dnsserver || {X} Missing ||
|| src/mime.conf || {X} Missing ||
|| src/mime.conf.default || {X} Missing. Symlink to mime.conf manual? ||
|| src/squid || Needs review. Also, move from doc/squid.8.in to src/ next to relevant binary ||
|| src/squid.conf || {X} Missing. Convert squid.conf.documented ||
|| src/squid.conf.default || {X} Missing. Symlink to squid.conf manual? ||
|| src/squid.conf.documented || {X} Missing ||
|| src/unlinkd || {X} Missing ||
|| src/DiskIO/DiskDaemon/diskd || {X} Missing ||
|| src/icmp/pinger || {X} Missing ||
|| tools/cachemgr.cgi || Needs review. ||
|| tools/squidclient || (squidclient.1) Needs review. ||
|| tools/helper-mux.pl || {X} Missing. Convert helper-mux.README to *.pl intro text for pod2man generation. ||

----
 Discuss this page using the "Discussion" link in the main menu

<<Include(/Discussion)>>
