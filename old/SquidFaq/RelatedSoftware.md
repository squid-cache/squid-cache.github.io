# Clients

  - [Wget](ftp://gnjilux.cc.fer.hr/pub/unix/util/wget/) is a
    command-line Web client. It supports HTTP and FTP URLs, recursive
    retrievals, and HTTP proxies.

  - If you want to test your Squid cache in batch (from a cron command,
    for instance), you can use the
    [echoping](ftp://ftp.internatif.org/pub/unix/echoping/) program,
    which will tell you (in plain text or via an exit code) if the cache
    is up or not, and will indicate the response times.

  - The **squidclient** is bundled with squid. It is very basic, but
    especially suited to working with Squid.

## Stress-testing tools

  - [curl-loader](http://sourceforge.net/projects/curl-loader) is a
    stress-testing tool for performance analysis

  - [ApacheBenc](http://httpd.apache.org/docs/2.0/programs/ab.html) (aka
    *ab*) is a very basic stress-testing software

# Load Balancers

  - [Pen](http://siag.nu/pen/) is a simple load-balancer with session
    affinity for TCP-based protocols.

  - [Layer-7 switching](http://www.linux-l7sw.org/) is a Layer-7
    load-balancing engine for Linux. It's a young project, stemming off
    the more mature Keepalived.

  - [Linux Virtual Server](http://www.linuxvirtualserver.org/) is a
    kernel-based layer 3-7 load balancer for Linux

# HA Clusters

  - [Keepalived](http://www.keepalived.org/) is a software suite that
    implements HA (via VRRP) and status monitoring with failover
    capabilities. It's focused on Linux, support for other OSes is
    unclear.

  - [VRRPd](http://off.net/~jme/vrrpd/) is aimple implementation of
    VRRPv2

# Monitoring

## Availability monitoring

  - [Nagios](http://www.nagios.org/) is a very popular open-source
    enterprise monitoring platform.

## Performance monitoring

  - [Munin](http://munin.projects.linpro.no/) is a very flexible
    platform for collecting long-term performance data

  - [Cacti](http://www.cacti.net/) is especially suited for collecting
    SNMP-basd data

  - [RRDtool](http://oss.oetiker.ch/rrdtool) is the grandparent of F/OSS
    performance monitoring solutions

  - [SqStat](http://samm.kiev.ua/sqstat/) is an alternate frontend using
    the cache manager interface to collect and display real-time data.

# Logfile Analysis

Rather than maintain the same list in two places, please see the
[Logfile Analysis Scripts](http://www.squid-cache.org/Scripts/) page on
the Web server.

  - [Squeezer](http://sourceforge.net/projects/squidoptimizer/) is a
    logfile analysis software aimed at measuring Squid's performance

## SGI's Performance Co-Pilot

Jan-Frode Myklebust writes:

I use Performance CoPilot from [](http://oss.sgi.com/projects/pcp/) for
keeping track of squid and server performance. It comes by default with
a huge number of system performance metrics, and also has a nice plugin
(PMDA, Performance Metrics Domain Agent) for collecting metrics from the
squid access.log.

i.e. it can collect historic, or show live how many requests/s or byte/s
squid is answering of type:

  - total

  - get

  - head

  - post

  - other

  - size.zero le3k le10k le30k le100k le300k le1m le3m gt3m unknown

  - client.total

  - cached.total

  - cached.size.zero le3k le10k le30k le100k le300k le1m le3m gt3m
    unknown

  - uncached.total

  - uncached.size.zero le3k le10k le30k le100k le300k le1m le3m gt3m
    unknown

and also combine this with system level metrics like load, system cpu
time, cpu i/o wait, per partition byte/s, network interface byte/s, and
much more..

Because of it's historic logs of all this, it's great for collecting the
performance numbers during high activity, and then replaying it to
analyse what goes wrong later on.

# Configuration Tools

  - Kenichi Matsui has a simple perl script which generates a 3D
    hierarchy map (in VRML) from squid.conf.
    [3Dhierarchy.pl](ftp://ftp.nemoto.ecei.tohoku.ac.jp/pub/Net/WWW/VRML/converter/3Dhierarchy.pl).

# Squid add-ons

  - [transproxy](http://www.transproxy.nlc.net.au/) is a program used in
    conjunction with the Linux Transparent Proxy networking feature, and
    ipfwadm, to intercept HTTP and other requests. Transproxy is written
    by John Saunders `<john AT nlc DOT net DOT au>`

  - A [redirector
    package](ftp://ftp.sbs.de/pub/www/cache/redirector/redirector.tar.gz)
    from Iain Lea `<iain AT ecrc DOT de>` to allow Intranet (restricted)
    or Internet (full) access with URL deny and redirection for sites
    that are not deemed acceptable for a userbase all via a single proxy
    port.

  - [Junkbusters](http://internet.junkbuster.com) Corp has a copyleft
    privacy-enhancing, ad-blocking proxy server which you can use in
    conjunction with Squid.

  - [Squirm](http://squirm.foote.com.au/) is a configurable, efficient
    redirector for Squid by Chris Foote `<chris AT senet DOT com DOT
    au>`.

  - Pedro L Orso `<orso AT ineparnet DOT com DOT br>` has adapated the
    Apache's htpasswd into a CGI program called
    [chpasswd.cgi](http://web.onda.com.br/orso/chpasswd.html).

  - [jesred](http://ivs.cs.uni-magdeburg.de/~elkner/webtools/jesred/) by
    Jens Elkner `<elkner AT wotan DOT cs DOT Uni-Magdeburg DOT de>`.

  - [SquidGuard](http://www.squidguard.org/) is a free (GPL), flexible
    and efficient filter and redirector program for squid. It lets you
    define multiple access rules with different restrictions for
    different user groups. SquidGuard uses squid standard redirector
    interface.

  - The Smart Neighbour (URL disappeared) (or 'Central Squid Server' -
    CSS) is a cut-down version of Squid without HTTP or object caching
    functionality. The CSS deals only with ICP messages. Instead of
    caching objects, the CSS records the availability of objects in each
    of its neighbour caches. Caches that have smart neighbours update
    each smart neighbour with the status of their cache by sending
    ICP\_STORE\_NOTIFY/ICP\_RELEASE\_NOTIFY messages upon
    storing/releasing an object from their cache. The CSS maintains an
    up to date 'object map' recording the availability of objects in its
    neighbouring caches.

  - The [Cerberian content
    filter](http://www.marasystems.com/?section=cerberian) is a very
    flexible URL rating system with full Squid integration provided by
    [MARA Systems AB](http://marasystems.com/download/cerberian). The
    service requires a license (priced by the number of seats) but
    evaluation licenses are available.

# Ident Servers

For [Windows NT](http://ftp.tdcnorge.no/pub/windows/Identd/),
[Windows 95/98](http://identd.sourceforge.net/), and
[Unix](http://www2.lysator.liu.se/~pen/pidentd/).

# Cacheability Validators

The [Cacheability Engine](http://www.mnot.net/cacheability/) is a python
script that validates an URL, analyzing the clues a web server gives to
understand how cacheable is the served content. An online tool is
available at [](http://www.ircache.net/cgi-bin/cacheability.py)

Back to the
[SquidFaq](https://wiki.squid-cache.org/SquidFaq/RelatedSoftware/SquidFaq#)
