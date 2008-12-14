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

= Method of Calculation =
There is no good fixed benchmark test yet to measure by so comparisons are not strictly correct. Here is how the follow details are calculated:

 * At an administrator estimated peak traffic time run '''squidclient mgr:info''' or otherwise pull the info report from '''cachemgr.cgi'''

|| Users || Maximum value seen for '''Number of clients accessing cache'''. ||
|| RPS || Add all number for '''Average *** requests per minute since start''' together and divide by 60 for per-second ||
|| Hit Ratio || Values of '''Request Hit Ratios''': 5min - 60min . Only total hit ratio matters here. disk and memory hit ratios are highly specific to the amount of RAM available.  ||

## TEMPLATE entry:
##
##|| CPU ||  ||
##|| RAM ||  ||
##|| HDD ||  ||
##|| OS  ||  ||
##|| Users ||  ||
##|| RPS ||  ||
##|| Hit Ratio || ||
##
##{{{
##Submitted by: NAME - COMPANY-IF_ALLOWED. DATE.
##}}}
##

= Records =

== Squid 3.0 ==

=== STABLE 5 ===
|| Dual-Core ||
|| CPU || 1x Intel Core 2 Duo E4600 2.4 Ghz/800 MHz (2 MB L2 cache) ||
|| RAM || 3 GB PC2-5300 CL5 ECC DDR2 SDRAM DIMM ||
|| HDD || 2x 250 GB SATA in as a mirror configuration ||
|| OS  || OpenSUSE 10.3 ||
|| Users || ~100 ||
|| RPS || Unknown: 'reasonable response rate' ||
|| Hit Ratio || ||

{{{
Submitted by: Philipp Rusch - New Vision. 2008-07-17.

IBM xSeries 3250 M2. This system is doing virus-scanning with ICAP-enabled Squid through KAV 5.5 Kaspersky AntiVirus for Internet Gateways
AND it is doing web-content filtering with SquidGuard 1.3
AND it is doing NTLM AUTH against the internal W2k3-ADS-domain
}}}

== Squid 2.7 ==
=== STABLE 4 ===
|| Dual-Core ||
|| CPU || Core 2 Duo 2.33 GHz ||
|| RAM || 8 GB ||
|| HDD || 4x 160GB SATA for cache ||
|| OS  || ||
|| Users || ~2300 ||
|| RPS || 280 ||
|| Request Hit Ratio || 41.7-43.8% ||
{{{
Submitted by: Nyamul Hassan. 2008-11-18.
Squid is doing a close to default configuration with ICP with peers and Collapsed Forwarding off.
}}}

== Squid 2.6  ==
=== STABLE 6 ===
|| Quad Core ||
|| CPU || Intel(R) Xeon(R) CPU  E5420  @ 2.50GHz ||
|| RAM || 50 GB ||
|| HDD || N/A (Memory Cache of 40 GB) ||
|| OS  || Centos 5 ||
|| Users || N/A (Reverse Proxy) ||
|| RPS || 323 ||
|| Hit Ratio || 87.1% - 86.0% ||
|| Byte Hit ratio|| 36.4% - 46.7% ||
## JM Wishes to be kept anonymous.


== Squid 2.5 ==

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

= Other Benchmarking =

Mark Nottingham benchmarked Squid 2.5 vs 2.6 in late 2006:
http://www.mnot.net/blog/2006/08/21/caching_performance

The Measurement Factory benchmarked Squid 2.4, in particular IO systems in 2000
http://polygraph.ircache.net/Results/bakeoff-2/


##please use [[MailTo(address AT domain DOT tld)]] for mail addresses; this will help hide them from spambots
----
CategoryKnowledgeBase
