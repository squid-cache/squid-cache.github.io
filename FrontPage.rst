#language en
#pragma section-numbers off

[[TableOfContents]]

= Squid Proxy Web Cache Wiki =

This is a wiki dedicated to hosting documentation, hints and assorted notes about the Squid Web Cache. Eventually it will host the Squid FAQ and assorted documentation.

= Hotmail and IE6 Issue With Interception Proxies =
Recent changes at Hotmail.com and has led to some users receiving a blank page in response to a login request when browsing through a proxy operating in interception, or transparent, mode. This is due to Hotmail incorrectly responding with Transfer-Encoding encoded response when the HTTP/1.0 request has an Accept-Encoding header. (Transfer-Encoding absolutely REQUIRES HTTP/1.1 and is forbidden within HTTP/1.0)

A workaround is simply to add the following three lines to /etc/squid/squid.conf: {{{acl hotmail_domains dstdomain .hotmail.msn.com
header_access Accept-Encoding deny hotmail_domains}}}

(para-quoted from http://www.swelltech.com/news.html for the concise summary)

= General Questions =
 * ["NTLMIssues"]: Things you can (and cannot) do with NTLM
 * ZeroSizedReply: Recurrent issues with some setups.
 * MultipleInstances: how-to run multiple squid servers on a single box.
 * PerformanceAnalisys: "Help! My users complain that the proxy is slow!"
 * BestOsForSquid: an all-time FAQ: "What is the best OS for Squid?"

= Developers corner =
== Squid Sprint ==
Recently an informal squid sprint was held in Rivoli, hosted by GuidoSerassio. Some of the topics of discussion...
 * CodeSprintOct2005
 * NegotiateAuthentication support for Squid-3 (the main focus of the sprint)
 * ["Squid-2.6"]
 * NiceLittleProjects: projects which can be completed in a few days' work, waiting for someone to step up. Any takers?

In december 2004 an informal squid sprint was held in Stockholm, hosted by HenrikNordström. Some of the topics of discussion...
 * ["StoreAPI"]
 * LibCacheReplacement: free thoughts about designing an event-driven generic cache lib

== ClientStreams ==
A transcript of a recent IRC chat about using ClientStreams to request pages internally to squid.

= Interesting starting points =
 * RecentChanges: see where people are currently working
 * FindPage: search or browse the pages hosted in this wiki in various ways
 * SiteNavigation: get an overview over this site and what it contains
 * SyntaxReference: quick access to wiki syntax
 * WikiSandBox: feel free to change this page and experiment with editing


You can find information about what a Wiki is and how to use it at AboutWiki.
= Other Squid-related resources =

 * The main [http://www.squid-cache.org/ Squid site]
 * The current version of the [http://www.squid-cache.org/Doc/FAQ/FAQ.html Squid FAQ] ( ["SquidFaq/FaqIndex"] is a local wikified Copy)
 * The [http://devel.squid-cache.org Squid development site]
 * The [http://www.squid-cache.org/bugs/index.cgi Bugzilla] database
 * Squijj [http://www.mnot.net/squij/] refresh_pattern analysis
 * Calamaris [http://freshmeat.net/projects/calamaris/] log file analysis
 * Visolve's Squid 3.0 [http://squid.visolve.com/squid/configuration_manual_30.htm configuration manual]
 * [http://people.redhat.com/stransky/squid/ Martin Stransky]'s squid page. He's the maintainer of the official Red Hat package
 * ExternalLinks: some external resources which might be of interest
