##master-page:SquidTemplate
#format wiki
#language en
<<TableOfContents>>

= man(8) documentation guidelines and standards =
This is a guide for a standard manual page documentation format and template. The aim is to allow documentation writers to focus on documentation and not on specific format and semantics, and to help integrate new texts with translation string automation.

== Entities to be documented ==
All application binary, scripts, and configuration files installed on end server systems are to be documented with a manual page.

== Documentation format ==
Use simplified ngroff syntax. see http://www.fnal.gov/docs/products/ups/ReferenceManual/html/manpages.html for ngroff format details.

Some additional markup is added for integration with '''po4a''' translation automation. see http://po4a.alioth.debian.org/man/man3pm/Locale::Po4a::Man.3pm.php for details on specific markup and limits imposed by those tools.

Each '''.SH''' section is preceded by an ''empty'' line. In ngroff syntax that is a line containing only a dot (.) as demonstrated below between the '''.TH''' line and the first '''.SH''' line.

The document overview is as follows. Introductory header markup as shown followed by any applicable sections. Which are detailed in more depth below.
{{{
.if !'po4a'hide' .TH binary.name 8
.
.SH NAME
.SH SYNOPSIS
.SH DESCRIPTION
.SH OPTIONS
.SH CONFIGURATION
.SH KNOWN ISSUES
.SH AUTHOR
.SH COPYRIGHT
.SH QUESTIONS
.SH REPORTING BUGS
.SH SEE ALSO
}}}

=== .SH NAME ===
Three lines of content.
 1. name of file being documented. Marked not for translation.
 2. a hyphen. Marked not for translation.
 3. A one-line description of the file. Suitable for use in a title.

If a version number is relevant state it in a separate paragraph below the name details.

For example:
{{{
.
.SH NAME
.if !'po4a'hide' .B squid
.if !'po4a'hide' \-
HTTP Web Proxy caching server.
.PP
Version 1.0
}}}
documents
{{{
squid - HTTP Web Proxy caching server.

Version 1.0
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
A fully documented list of available command line options. With an empty line between each. The table column offset of the description text is 12 characters, set on the first '''.TP''' tag.

The option switch and any accepted variable names are marked not for translation (unlike in synopsis).

The option description is open for translation. Any repetition of the variable name is highlighted in bold.

For example:
{{{
.
.SH OPTIONS
.if !'po4a'hide' .TP 12
.if !'po4a'hide' .B \-d
Write debug info to stderr.
.
.if !'po4a'hide' .TP
.if !'po4a'hide' .B "\-f config\-file"
Use configuration file
.B config\-file
}}}

=== .SH CONFIGURATION ===
Optional section specific to application binaries and maybe helper scripts.

Configuration files have their syntax covered under '''.SH DESCRIPTION'''

This section should cover snippets of config. Usually from squid.conf. Actual config snippets are to be marked not for translation.

For a multi-line configuration block use '''.br''' (lower case is important) to split the lines legibly.

 /!\ Any word which ''begins'' with a dash / hyphen must be slash-escaped.

For example, URL re-writers would have something like this:
{{{
.
.SH CONFIGURATION
.PP The simplest configuration for URL re-writers is to add the script or binary name to
.B squid.conf
like so:
.if !'po4a'hide' .RS
.if !'po4a'hide' .B url_rewrite_program /usr/bin/squid/example.binary
.if !'po4a'hide' .RE
.PP Command line options sent to a helper script or binary are added to
.B squid.conf
following the helper binary name. Like so:
.if !'po4a'hide' .RS
.if !'po4a'hide' .B url_rewrite_program /usr/bin/squid/example.binary \-d
.if !'po4a'hide' .br
.if !'po4a'hide' .B url_rewrite_access ...
.if !'po4a'hide' .RE
}}}

=== .SH KNOWN ISSUES ===
Optional section specific to application binaries and maybe helper scripts.

Simple set of '''.PP''' paragraphs outlining the problems which are known with using the program or script.

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
.PP
Distributed under the GNU General Public License (GNU GPL) version 2 or later (GPLv2+).
}}}

If no exact copyright details are known use the following snippet:
{{{
.
.SH COPYRIGHT
This program and documentation is copyright to the authors named above.
.PP
Distributed under the GNU General Public License (GNU GPL) version 2 or later (GPLv2+).
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
Bug reports need to be made in English.
See http://wiki.squid-cache.org/SquidFaq/BugReporting for details of what you need to include with your bug report.
.PP
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
.if !'po4a'hide' .BR GPL "(7), "
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
.SH NAME
.if !'po4a'hide' .B binary.name
.if !'po4a'hide' \-
Description goes here
.PP
Version 1.0
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
.if !'po4a'hide' .TP 12
.if !'po4a'hide' .B \-d
Write debug info to stderr.
.
.if !'po4a'hide' .TP
.if !'po4a'hide' .B \-h
Display the binary help and command line syntax info using stderr.
.
.SH KNOWN ISSUES
.PP
Optional test goes here. If there is nothing major remove the whole section.
.
.SH CONFIGURATION
.PP See FAQ wiki page for examples of how to write configuration snippets.
.PP Or just write what you want to say, then mark it up according to the wiki styles.
.
.SH AUTHOR
This program was written by
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
This program and documentation is copyright to the authors named above.
.PP
Distributed under the GNU General Public License (GNU GPL) version 2 or later (GPLv2+).
.
.SH QUESTIONS
Questions on the usage of this program can be sent to the
.I Squid Users mailing list
.if !'po4a'hide' <squid-users@squid-cache.org>
.
.SH REPORTING BUGS
Bug reports need to be made in English.
See http://wiki.squid-cache.org/SquidFaq/BugReporting for details of what you need to include with your bug report.
.PP
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
.if !'po4a'hide' .BR squid "(8), "
.if !'po4a'hide' .BR GPL "(7), "
.br
The Squid FAQ wiki
.if !'po4a'hide' http://wiki.squid-cache.org/SquidFaq
.br
The Squid Configuration Manual
.if !'po4a'hide' http://www.squid-cache.org/Doc/config/
}}}

== TODO ==


The Manual best practice is to provide a man(x) page for each file installed on a server system. Squid installs a number of files of various types as listed below. Some work is underway to bring existing texts into matching these standard style of markup. However there are a number of installed files which have no manual at all.


|| '''Installed file''' || '''man(x)''' || '''Current State:''' ||
|| ~/access.log || {X} || Missing. Relevant? ||
|| ~/cache.log || {X} || Missing. Relevant? ||
|| ~/netdb.state || {X} || Missing. ||
|| ~/store.log || {X} || Missing. Relevant? ||
|| ~/swap.state || {X} || Missing. Convert wiki page info ||
|| errors/errpages.css || {X} || Missing ||
|| helpers/basic_auth/DB/basic_db_auth || 8 || Needs review of the perl/pod output. ||
|| helpers/basic_auth/getpwnam/basic_getpwnam_auth || 8 || (./) Done. ||
|| helpers/basic_auth/LDAP/basic_ldap_auth || 8 || (./) Done. ||
|| helpers/basic_auth/MSNT/msnt_auth || {X} || Missing. Convert README.html ||
|| helpers/basic_auth/MSNT/msntauth.conf || {X} || Missing. ||
|| helpers/basic_auth/MSNT/msntauth.conf.default || {X} || Missing. ||
|| helpers/basic_auth/MSNT-multi-domain/basic_msnt_multi_domain_auth.pl || {X} || Missing. Convert intro text with pod2man ||
|| helpers/basic_auth/NCSA/basic_ncsa_auth || 8 || (./) Done. ||
|| helpers/basic_auth/NIS/basic_nis_auth || {X} || Missing. ||
|| helpers/basic_auth/PAM/basic_pam_auth || 8 || (./) Done. ||
|| helpers/basic_auth/POP3/basic_pop3_auth.pl || {X} || Missing. ||
|| helpers/basic_auth/RADIUS/basic_radius_auth || 8 || (./) Done. ||
|| helpers/basic_auth/SASL/basic_sasl_auth || 8 || (./) Done. ||
|| helpers/basic_auth/SASL/basic_sasl_auth.pam || {X} || Missing. ||
|| helpers/basic_auth/SASL/basic_sasl_auth.conf || {X} || Missing. ||
|| helpers/basic_auth/SMB/basic_smb_auth || {X} || Missing. ||
|| helpers/basic_auth/SMB/basic_smb_auth.sh || {X} || Missing. ||
|| helpers/basic_auth/SSPI/basic_sspi_auth.exe || 8 || (./) Done. ||
|| helpers/digest_auth/eDirectory/digest_edir_auth || {X} || Missing. ||
|| helpers/digest_auth/LDAP/digest_ldap_auth || {X} || Missing. ||
|| helpers/digest_auth/file/digest_file_auth || 8 || (./) Done. ||
|| helpers/external_acl/AD_group/ext_ad_group_acl || 8 || (./) Done. ||
|| helpers/external_acl/file_userip/ext_file_userip_acl || 8 || (./) Done. ||
|| helpers/external_acl/kerberos_ldap_group/ext_kerberos_ldap_group_acl || 8 || (./) Done. ||
|| helpers/external_acl/LDAP_group/ext_ldap_group_acl || 8 || (./) Done. ||
|| helpers/external_acl/LM_group/ext_lm_group_acl || 8 || (./) Done. ||
|| helpers/external_acl/session/ext_session_acl || 8 || (./) Done. ||
|| helpers/external_acl/unix_group/ext_unix_group_acl || 8 || (./) Done. ||
|| helpers/external_acl/wbinfo_group/ext_wbinfo_group_acl || 8 || (./) Done. ||
|| helpers/log_daemon/file/log_file_daemon || {X} || Missing. ||
|| helpers/negotiate_auth/kerberos/negotiate_kerberos_auth || 8 || (./) Done. ||
|| helpers/negotiate_auth/kerberos/negotiate_kerberos_auth_test || {X} || Missing. Convert README ||
|| helpers/negotiate_auth/SSPI/negotiate_sspi_auth.exe || {X} || Missing. Convert readme.txt ||
|| helpers/negotiate_auth/wrapper/negotiate_wrapper || {X} || Missing. ||
|| helpers/ntlm_auth/fake/ntlm_fake_auth || {X} || Missing. Convert wiki NTLM fake auth page. ||
|| helpers/ntlm_auth/smb_lm/ntlm_smb_lm_auth || {X} || Missing ||
|| helpers/ntlm_auth/SSPI/ntlm_sspi_auth.exe || 8 || (./) Done. ||
|| helpers/ssl/cert_valid.pl || {X} || Missing. Convert intro text with pod2man ||
|| helpers/url_rewrite/url_fake_rewrite || {X} || Missing ||
|| helpers/url_rewrite/url_fake_rewrite.sh || {X} || Missing ||
|| src/dnsserver || {X} || Missing ||
|| src/mime.conf || {X} || Missing ||
|| src/mime.conf.default || {X} || Missing. Symlink to mime.conf manual? ||
|| src/recv-announce || {X} || Missing. ||
|| src/squid || 8 || (./) Done. ||
|| src/squid.conf || {X} || Missing. Convert squid.conf.documented ||
|| src/squid.conf.default || N/A || http://www.squid-cache.org/Doc/config/ instead  ||
|| src/squid.conf.documented || N/A || http://www.squid-cache.org/Doc/config/ instead ||
|| src/unlinkd || {X} || Missing ||
|| src/DiskIO/DiskDaemon/diskd || {X} || Missing ||
|| src/icmp/pinger || {X} || Missing ||
|| tools/cachemgr.cgi || 8 || (./) Done. ||
|| tools/squidclient || 1 || (./) Done. ||
|| tools/helper-mux.pl || {X} || Missing. Convert helper-mux.README to *.pl intro text for pod2man generation. ||

----
 Discuss this page using the "Discussion" link in the main menu

<<Include(/Discussion)>>
