##master-page:KnowledgeBaseTemplate
##Page-Creation-Date:<<Date(2009-11-13T13:33:07Z)>>
##Page-Original-Author:AmosJeffries
#format wiki
#language en

= Squid on FreeBSD =

== Pre-Built Binary Packages ==
Binaries for Alpha and Intel platforms, from the FreeBSD ports collection.
http://www.freebsd.org/cgi/ports.cgi?query=^squid-&stype=name

{{{
 yum install squid
}}}


== Building Squid on FreeBSD ==

Squid is developed on FreeBSD. The [[SquidFaq/CompilingSquid|general build instructions]] should be all you need.

== Troubleshooting ==

=== ERROR: Could not send signal N to process NN: (3) No such process ===

FreeBSD contains additional security settings to prevent users sending fatal or other signals to other users applications.

{{{
 sysctl security.bsd.see_other_uids
}}}

Unfortunately this catches Squid in the middle. Since the administrative process of Squid normally runs as root and the child worker process runs as some other non-privileged user (by default: '''nobody'''). The '''root''' administrative process is unable to send signals such as ''shutdown'' or ''reconfigure'' to its own child.

----
CategoryKnowledgeBase
