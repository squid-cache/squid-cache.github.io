##master-page:SquidTemplate
#format wiki
#language en

## Installation guide for NetBSD in the build farm

## if you want to have a table of comments remove the heading hashes from the next line
## <<TableOfContents>>

== System Setup ==

 * use a default install
 * edit {{{/etc/defaults/rc.conf}}} to start sshd, {{{/etc/sshd_config}}} to add relevant ssh parameters
 * edit {{{/etc/ifconfig.<if>}}} to specify network parameters
 * setup ''pkgsrc''
   1. [[http://www.netbsd.org/docs/pkgsrc/platforms.html#bootstrapping-pkgsrc|Bootstrap pkgsrc]]

... to be continued ...


== Build instructions ==
 * make sure to set up the environment variables {{{AUTOMAKE_VERSION=1.9}}} and {{{AUTOCONF_VERSION=2.61}}}
----
Discuss this page using the "Discussion" link in the main menu

<<Include(/Discussion)>>
