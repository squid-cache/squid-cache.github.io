##master-page:KnowledgeBaseTemplate
##Page-Creation-Date:<<Date(2008-07-17T04:08:53Z)>>
##Page-Original-Author:[[Amos Jeffries]]
#format wiki
#language en

= Most Current Squid Benchmarks =

Speed and Requirement details of squid are a little hard to come by at present. Here is a list of the community contributed achievements.

If you are running any release of squid and can provide the same details with a better requests-per-second than one listed we would like to know about it.

Sorted by Squid Release and CPU.

<<TableOfContents>>

== Squid 3.0 STABLE 5 ==

=== Dual-Core ===
|| CPU || 1x Intel Core 2 Duo E4600 2.4 Ghz/800 MHz (2 MB L2 cache) ||
|| RAM || 3 GB PC2-5300 CL5 ECC DDR2 SDRAM DIMM ||
|| HDD || 2x 250 GB SATA in as a mirror configuration ||
|| OS  || OpenSUSE 10.3 ||
|| Users || ~100 ||
|| RPS || Unknown: 'reasonable response rate' ||
{{{
Submitted by: Philipp Rusch - New Vision. 2008-07-17.

IBM xSeries 3250 M2. This system is doing virus-scanning with ICAP-enabled Squid through KAV 5.5 Kaspersky AntiVirus for Internet Gateways
AND it is doing web-content filtering with SquidGuard 1.3
AND it is doing NTLM AUTH against the internal W2k3-ADS-domain
}}}

== Squid 2.7 ==

No details yet....

== Squid 2.6  ==

No details yet....

== Squid 2.5 STABLE ?? ==

NP: probably 2.5.STABLE7 or earlier going by the release dates.

|| CPU || P4 2.8GHz ||
|| RAM || 4 GB ||
|| HDD || 2 x 36GB 10 RPM, 2 x 73 15 RPM scsi disks  ||
|| OS  || Debian 2.4.25 ||
|| Users || ~3200 ||
|| RPS || 220 ||
|| Hit Ratio || 54% ||
{{{
Submitted by: Martin Marji Cermak. 2005-01-14.
http://www.squid-cache.org/mail-archive/squid-users/200501/0374.html
}}}

##please use [[MailTo(address AT domain DOT tld)]] for mail addresses; this will help hide them from spambots
----
CategoryKnowledgeBase
