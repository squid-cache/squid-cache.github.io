#language en
<<TableOfContents>>
== Clients ==

 * [[ftp://gnjilux.cc.fer.hr/pub/unix/util/wget/|Wget]] is a command-line Web client. It supports HTTP and FTP URLs, recursive retrievals, and HTTP proxies.
 * If you want to test your Squid cache in batch (from a cron command, for instance), you can use the [[ftp://ftp.internatif.org/pub/unix/echoping/|echoping]] program, which will tell you (in plain text or via an exit code) if the cache is up or not, and will indicate the response times.
 * The '''squidclient''' is bundled with squid. It is very basic, but especially suited to working with Squid.

=== Stress-testing tools ===
 * [[http://sourceforge.net/projects/curl-loader|curl-loader]] is a stress-testing tool for performance analysis
 * [[http://httpd.apache.org/docs/2.0/programs/ab.html|ApacheBenc]] (aka ''ab'') is a very basic stress-testing software

== Load Balancers ==

 * [[http://siag.nu/pen/|Pen]] is a simple load-balancer with session affinity for TCP-based protocols.
 * [[http://www.linux-l7sw.org/|Layer-7 switching]] is  a Layer-7 load-balancing engine for Linux. It's a young project, stemming off the more mature Keepalived.
 * [[http://www.linuxvirtualserver.org/|Linux Virtual Server]] is a kernel-based layer 3-7 load balancer for Linux

== HA Clusters ==

 * [[http://www.keepalived.org/|Keepalived]] is a software suite that implements HA (via VRRP) and status monitoring with failover capabilities. It's focused on Linux, support for other OSes is unclear.
 * [[http://off.net/~jme/vrrpd/|VRRPd]] is aimple implementation of VRRPv2

== Monitoring ==

=== Availability monitoring ===
 * [[http://www.nagios.org/|Nagios]] is a very popular open-source enterprise monitoring platform.

=== Performance monitoring ===
 * [[http://munin.projects.linpro.no/|Munin]] is a very flexible platform for collecting long-term performance data
 * [[http://www.cacti.net/|Cacti]] is especially suited for collecting SNMP-basd data
 * [[http://oss.oetiker.ch/rrdtool|RRDtool]] is the grandparent of F/OSS performance monitoring solutions
 * [[http://samm.kiev.ua/sqstat/|SqStat]] is an alternate frontend using the cache manager interface to collect and display real-time data.

== Logfile Analysis ==

Rather than maintain the same list in two places, please see the
[[http://www.squid-cache.org/Scripts/|Logfile Analysis Scripts]] page
on the Web server.
 * [[http://sourceforge.net/projects/squidoptimizer/|Squeezer]] is a logfile analysis software aimed at measuring Squid's performance

=== SGI's Performance Co-Pilot ===
Jan-Frode Myklebust writes:

I use Performance !CoPilot from http://oss.sgi.com/projects/pcp/ for keeping track of squid and server performance. It comes by default with a huge number of system performance metrics, and also has a nice plugin (PMDA, Performance Metrics Domain Agent) for collecting metrics from the squid access.log.

i.e. it can collect historic, or show live how many requests/s or byte/s squid is answering of type:

 * total
 * get
 * head
 * post
 * other
 * size.zero le3k le10k le30k le100k le300k le1m le3m gt3m unknown
 * client.total
 * cached.total
 * cached.size.zero le3k le10k le30k le100k le300k le1m le3m gt3m unknown
 * uncached.total
 * uncached.size.zero le3k le10k le30k le100k le300k le1m le3m gt3m unknown

and also combine this with system level metrics like load, system cpu
time, cpu i/o wait, per partition byte/s, network interface byte/s,
and much more..

Because of it's historic logs of all this, it's great for collecting
the performance numbers during high activity, and then replaying it
to analyse what goes wrong later on.



== Configuration Tools ==

 * Kenichi Matsui has a simple perl script which generates a 3D hierarchy map (in VRML) from squid.conf. [[ftp://ftp.nemoto.ecei.tohoku.ac.jp/pub/Net/WWW/VRML/converter/3Dhierarchy.pl|3Dhierarchy.pl]].


== Squid add-ons ==

 * [[http://www.transproxy.nlc.net.au/|transproxy]] is a program used in conjunction with the Linux Transparent Proxy networking feature, and ipfwadm, to intercept HTTP and other requests. Transproxy is written by <<MailTo(john AT nlc DOT net DOT au, John Saunders)>>
 * A [[ftp://ftp.sbs.de/pub/www/cache/redirector/redirector.tar.gz|redirector package]] from <<MailTo(iain AT ecrc DOT de,Iain Lea)>> to allow Intranet (restricted) or Internet (full) access with URL deny and redirection for sites that are not deemed acceptable for a userbase all via a single proxy port.
 * [[http://internet.junkbuster.com|Junkbusters]] Corp has a copyleft privacy-enhancing, ad-blocking proxy server which you can use in conjunction with Squid.
 * [[http://squirm.foote.com.au/|Squirm]] is a configurable, efficient redirector for Squid by <<MailTo(chris AT senet DOT com DOT au,Chris Foote)>>.
 * <<MailTo(orso AT ineparnet DOT com DOT br,Pedro L Orso)>> has adapated the Apache's htpasswd into a CGI program called [[http://web.onda.com.br/orso/chpasswd.html|chpasswd.cgi]].
 * [[http://ivs.cs.uni-magdeburg.de/~elkner/webtools/jesred/|jesred]] by <<MailTo(elkner AT wotan DOT cs DOT Uni-Magdeburg DOT de,Jens Elkner)>>.
 * [[http://www.squidguard.org/|SquidGuard]] is a free (GPL), flexible and efficient filter and redirector program for squid. It lets you define multiple access rules with different restrictions for different user groups. !SquidGuard uses squid standard redirector interface.
 * The Smart Neighbour (URL disappeared) (or 'Central Squid Server' - CSS) is a cut-down version of Squid without HTTP or object caching functionality. The CSS deals only with ICP messages. Instead of caching objects, the CSS records the availability of objects in each of its neighbour caches. Caches that have smart neighbours update each smart neighbour with the status of their cache by sending ICP_STORE_NOTIFY/ICP_RELEASE_NOTIFY messages upon storing/releasing an object from their cache.  The CSS maintains an up to date 'object map' recording the availability of objects in its neighbouring caches.
 * The [[http://www.marasystems.com/?section=cerberian|Cerberian content filter]] is a very flexible URL rating system with full Squid integration provided by [[http://marasystems.com/download/cerberian|MARA Systems AB]]. The service requires a license (priced by the number of seats) but evaluation licenses are available.

== Ident Servers ==

For [[http://ftp.tdcnorge.no/pub/windows/Identd/|Windows NT]], [[http://identd.sourceforge.net/|Windows 95/98]],
and [[http://www2.lysator.liu.se/~pen/pidentd/|Unix]].

== Cacheability Validators ==

The [[http://www.mnot.net/cacheability/|Cacheability Engine]] is a python script that validates an URL, analyzing the clues a web server gives to understand how cacheable is the served content. An online tool is available at http://www.ircache.net/cgi-bin/cacheability.py

-----
Back to the SquidFaq
