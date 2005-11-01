#language en

During the sprint it was recognised that it would be beneficial to collect all of the available completed Squid-2.5 based works into a Squid-2.6 release while we work on getting Squid-3.0 ready.

There is very a large list of completed features developed for Squid-2.5 over the years and
then ported and merged to Squid-3, but in reality production environments are all running the Squid-2.5 versions with different amounts of extra patches today.
Not surprising given the fact that Squid-2.5 has been feature frozen for 3 years now.

The general consensus among the code sprint participants (HenrikNordström, ["Kinkie"] & our kind host GuidoSerassio) is that there is a benefit in collecting all of this already
existing and proven Squid-2.x work into a Squid-2.6 release. It is a fairly low effort, especially considering that each of these pieces have been fairly well
validated separately both by Squid developers and independenly by numerous users of these features, but will buy us a great deal in momentum while working on
Squid-3.0 to stabilize.

List of things we have thought of include in a Squid-2.6 release include

  * cbdatareference
  * addition of IPPROTO_TCP & IPPROTO_UDP usage 
  * Cygwin full support
    * --enable-default-hostsfile configure option 
    * Windows service
    * ARP acl 
  * negotiate (+ NTLM cleanup)
  * reverse proxy improvements
  * ssl client + fixes
  * epoll (linux)
  * digest LDAP helper
  * overlapping helper requests
  * external acl improvements
  * UNIX sockets IPC
  * custom log formats
  * ETag
  * MAXHOSTNAMELEN cleanup
  * Connection pinning
  * Bug #802: squid should report username in stats when auth is enabled 
  * Bug #907: patch to suppress version string in HTTP headers and HTML error pages
  * Bug #1326: Correctly use search path from /etc/resolv.conf 

And there is some upcoming projects which may get included if they make it in time:

  * FreeBSD kqueue support



=== Opinions on if there should be a release ===

Summary of the opinions regarding a Squid-2.6 release


Full in favor, including performance enhancements:

  * Henrik Nordstrom *
  * Guido Serassio *
  * Adrian Chadd *
  * Francesco 'Kinkie' Chemolli
  * Reuben Farrelly

In favor, but no clear indication

  * Andrey Shorin
  * Paul Armstrong

Maybe, not including performance enhancements:

  * Alex Rousskov *

No answer yet:

  * Duane Wessels *
  * Robert Collins *


* = Core team member
