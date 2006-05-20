#language en
During the sprint it was recognised that it would be beneficial to collect all of the available completed Squid-2.5 based works into a Squid-2.6 release while we work on getting Squid-3.0 ready.

There is very a large list of completed features developed for Squid-2.5 over the years and then ported and merged to Squid-3, but in reality production environments are all running the Squid-2.5 versions with different amounts of extra patches today. Not surprising given the fact that Squid-2.5 has been feature frozen for 3 years now.

The general consensus among the code sprint participants (HenrikNordström, FrancescoChemolli & our kind host GuidoSerassio) is that there is a benefit in collecting all of this already existing and proven Squid-2.x work into a Squid-2.6 release. It is a fairly low effort, especially considering that each of these pieces have been fairly well validated separately both by Squid developers and independenly by numerous users of these features, but will buy us a great deal in momentum while working on Squid-3.0 to stabilize.

List of things we have thought of include in a Squid-2.6 release include

 * addition of IPPROTO_TCP & IPPROTO_UDP usage - OK
 * Cygwin full support
  * --enable-default-hostsfile configure option - OK
  * Windows service
  * ARP acl - OK
 * negotiate (+ NTLM cleanup) - OK
 * reverse proxy improvements - OK
 * ssl client + fixes - OK
 * epoll (linux)
 * digest LDAP helper - OK
 * overlapping helper requests - OK
 * external acl improvements
  * %PATH - OK
  * log= - OK
  * password= from 3.0
  * grace parameter from external_acl_fuzzy / 3.0 (but not the cache "level" thing)
 * UNIX sockets IPC - OK
 * custom log formats - OK
 * ETag
 * MAXHOSTNAMELEN cleanup - OK
 * Connection pinning
 * Bug #802: squid should report username in stats when auth is enabled - OK
 * Bug #907: patch to suppress version string in HTTP headers and HTML error pages - OK
 * Bug #1326: Correctly use search path from /etc/resolv.conf - OK
 * WCCPv2 - OK
 * Collapsed Forwarding - OK
And there is some upcoming projects which may get included if they make it in time:

 * FreeBSD kqueue support
 * Deferred reads cleanup
 * cbdatareference (needs to be resurrected from old 2.6 branch)
 * New improved COSS (maybe even production ready?) - OK

 * Automake updates to work with newew autoconf/automake
=== Opinions on if there should be a release ===
Summary of the opinions regarding a Squid-2.6 release

Full in favor, including performance enhancements:

 * Henrik Nordstrom *
 * Guido Serassio *
 * Adrian Chadd *
 * Francesco 'Kinkie' Chemolli
 * Reuben Farrelly
 * Steven Wilton
In favor, but no clear indication

 * Andrey Shorin
 * Paul Armstrong
Mixed feelins

 * Duane Wessels *
 * Robert Collins *
Maybe, not including performance enhancements:

 * Alex Rousskov *
* = Core team member
