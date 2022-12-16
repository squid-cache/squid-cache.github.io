---
FaqSection: misc
---
# Related software

## Clients

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

## Load Balancers

- [Pen](http://siag.nu/pen/) is a simple load-balancer with session
affinity for TCP-based protocols.
- [Linux Virtual Server](http://www.linuxvirtualserver.org/) is a
kernel-based layer 3-7 load balancer for Linux

## HA Clusters

- [Keepalived](http://www.keepalived.org/) is a software suite that
  implements HA (via VRRP) and status monitoring with failover
  capabilities. It's focused on Linux, support for other OSes is
  unclear.
- [VRRPd](http://off.net/~jme/vrrpd/) is aimple implementation of
  VRRPv2

## Monitoring

### Availability monitoring

- [Nagios](http://www.nagios.org/) is a very popular open-source
  enterprise monitoring platform.

### Performance monitoring

- [Munin](https://munin-monitoring.org/) is a very flexible
  platform for collecting long-term performance data
- [Cacti](http://www.cacti.net/) is especially suited for collecting
  SNMP-basd data
- [RRDtool](http://oss.oetiker.ch/rrdtool) is the grandparent of F/OSS
  performance monitoring solutions
- [SqStat](http://samm.kiev.ua/sqstat/) is an alternate frontend using
  the cache manager interface to collect and display real-time data.

## Logfile Analysis

- [Squeezer](http://sourceforge.net/projects/squidoptimizer/) is a
  logfile analysis software aimed at measuring Squid's performance

## Squid add-ons

- [Squirm](http://squirm.foote.com.au/) is a configurable, efficient
  redirector for Squid by Chris Foote `<chris AT senet DOT com DOT

- [jesred](http://www.linofee.org/~jel/webtools/jesred/) by
  Jens Elkner `<elkner AT wotan DOT cs DOT Uni-Magdeburg DOT de>`.

- [SquidGuard](https://en.wikipedia.org/wiki/SquidGuard) is a free (GPL), flexible
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
  ICP_STORE_NOTIFY/ICP_RELEASE_NOTIFY messages upon
  storing/releasing an object from their cache. The CSS maintains an
  up to date 'object map' recording the availability of objects in its
  neighbouring caches.

## Cacheability Validators

The [Cacheability Engine](http://www.mnot.net/cacheability/) is a python
script that validates an URL, analyzing the clues a web server gives to
understand how cacheable is the served content.