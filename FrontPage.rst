#language en
#pragma section-numbers off

[[TableOfContents]]

= Squid Proxy Web Cache Wiki =

This is a wiki dedicated to hosting documentation, hints and assorted notes about the Squid Web Cache. Eventually it will host the Squid FAQ and assorted documentation.

= Hotmail and IE6 Issue With Interception Proxies =
Recent changes at Hotmail.com and within IE6 has led to some users receiving a blank page in response to a login request when browsing through a proxy operating in interception, or transparent, mode. This is thought to be due to Internet Explorer 6 sending a syntactically incorrect Accept-Encoding header for requests to Hotmail.com.

A workaround is simply to add the following three lines to /etc/squid/squid.conf: {{{acl hotmail_domains dstdomain .hotmail.msn.com
acl ie6 browser MSIE[[:space:]]6
header_access Accept-Encoding deny ie6 hotmail_domains}}}

(para-quoted from http://www.swelltech.com/news.html for the concise summary)

= General Questions =
 * ["NTLMIssues"]: Things you can (and cannot) do with NTLM
 * ZeroSizedReply: Recurrent issues with some setups.
 * MultipleInstances: how-to run multiple squid servers on a single box.
 * PerformanceAnalisys: "Help! My users complain that the proxy is slow!"

= Developers corner =
== Squid Sprint ==
Recently an informal squid sprint was held in Stockholm, hosted by HenrikNordström. Some of the topics of discussion...
 * ["StoreAPI"]

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
 * The current version of the [http://www.squid-cache.org/Doc/FAQ/FAQ.html Squid FAQ]
 * The [http://devel.squid-cache.org Squid development site]
 * The [http://www.squid-cache.org/bugs/index.cgi Bugzilla] database
 * Squijj [http://www.mnot.net/squij/] refresh_pattern analysis
 * Calamaris [http://freshmeat.net/projects/calamaris/] log file analysis
 * Visolve's Squid 3.0 [http://squid.visolve.com/squid/configuration_manual_30.htm configuration manual]
