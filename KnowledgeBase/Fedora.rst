##master-page:KnowledgeBaseTemplate
#format wiki
#language en
= Squid on Fedora =
<<TableOfContents>>

== Pre-Built Binary Packages ==
http://download.fedoraproject.org/pub/fedora/linux/

Binary RPMs for Fedora are available via the Fedora download/update servers for all active Fedora versions like most other free software.

Package information: https://admin.fedoraproject.org/pkgdb/acls/name/squid

Bug Reports: https://admin.fedoraproject.org/pkgdb/acls/bugs/squid

Install Procedure:
{{{
yum install squid
}}}

== Compiling ==

Rebuilding the binary rpm is most easily done by checking out the package definition from cvs

{{{
cvs -d :pserver:anonymous@cvs.fedoraproject.org:/cvs/pkgs/ co squid
}}}

then do a "make local" in the version you want to recompile.

----
CategoryKnowledgeBase
