##master-page:KnowledgeBaseTemplate
#format wiki
#language en
= Squid on Fedora =
<<TableOfContents>>

== Pre-Built Binary Packages ==
Binary RPMs for Fedora are available via the Fedora download/update servers for all active Fedora versions like most other free software.

Package information: https://apps.fedoraproject.org/packages/squid

Bug Reports: https://apps.fedoraproject.org/packages/squid/bugs

==== Squid-3.4 ====

Available on Fedora 21 - 22.

Install Procedure:
{{{
yum install squid
}}}

==== Squid-3.3 ====

Available on Fedora 19 - 20.

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

== Troubleshooting ==
----
CategoryKnowledgeBase SquidFaq/BinaryPackages
