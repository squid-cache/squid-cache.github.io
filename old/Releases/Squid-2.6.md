# Squid-2.6

|          |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| today    | Squid-2.6 is **CONSIDERED DANGEROUS** as the security people say. Due to unfixed vulnerabilities **[CVE-2014-7141](http://www.squid-cache.org/Advisories/SQUID-2014_4.txt), [CVE-2014-7142](http://www.squid-cache.org/Advisories/SQUID-2014_4.txt), [CVE-2014-6270](http://www.squid-cache.org/Advisories/SQUID-2014_3.txt), [CVE-2012-5643](http://www.squid-cache.org/Advisories/SQUID-2012_1.txt), [CVE-2013-0189](http://www.squid-cache.org/Advisories/SQUID-2012_1.txt), [CVE-2009-0801](http://www.squid-cache.org/Advisories/SQUID-2011_1.txt)** and any other recently discovered issues. |
| Aug 2012 | the Squid-2.6 series became **OBSOLETE** with the release of [Squid-3.2](/Releases/Squid-3.2#) features                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| May 2008 | the Squid-2.6 series became **DEPRECATED** with the release of [Squid-2.7](/Releases/Squid-2.7#) series                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| Jul 2006 | Released for production use.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |

During the sprint it was recognised that it would be beneficial to
collect all of the available completed Squid-2.5 based works into a
Squid-2.6 release while we work on getting
[Squid-3.0](/Releases/Squid-3.0#)
ready.

There is very a large list of completed features developed for Squid-2.5
over the years and then ported and merged to Squid-3, but in reality
production environments are all running the Squid-2.5 versions with
different amounts of extra patches today. Not surprising given the fact
that Squid-2.5 has been feature frozen for 3 years now.

The general consensus among the code sprint participants
([Henrik\_Nordström](/Henrik_Nordstr%C3%B6m#),
[FrancescoChemolli](/FrancescoChemolli#)
& our kind host
[GuidoSerassio](/GuidoSerassio#))
is that there is a benefit in collecting all of this already existing
and proven Squid-2.x work into a Squid-2.6 release. It is a fairly low
effort, especially considering that each of these pieces have been
fairly well validated separately both by Squid developers and
independenly by numerous users of these features, but will buy us a
great deal in momentum while working on
[Squid-3.0](/Releases/Squid-3.0#)
to stabilize.

List of things we have thought of include in a Squid-2.6 release include

  - addition of IPPROTO\_TCP & IPPROTO\_UDP usage - OK

  - Cygwin full support - almost complete
    
      - \--enable-default-hostsfile configure option - OK
    
      - Windows service - OK
    
      - ARP acl - OK
    
      - Native Windows helpers (basic, NTLM, negotiate and groups) - OK

  - negotiate (+ NTLM cleanup) - OK

  - reverse proxy improvements - OK

  - ssl client + fixes - OK

  - epoll (linux) - OK

  - digest LDAP helper - OK

  - overlapping helper requests - OK

  - external acl improvements - OK
    
      - %PATH - OK
    
      - log= - OK
    
      - password= from 3.0 - OK
    
      - grace parameter from external\_acl\_fuzzy / 3.0 (but not the
        cache "level" thing) - OK

  - UNIX sockets IPC - OK

  - custom log formats - OK

  - ETag - OK

  - MAXHOSTNAMELEN cleanup - OK

  - Connection pinning - OK

  - Bug \#802: squid should report username in stats when auth is
    enabled - OK

  - Bug \#907: patch to suppress version string in HTTP headers and HTML
    error pages - OK

  - Bug \#1326: Correctly use search path from /etc/resolv.conf - OK

  - WCCPv2 - OK

  - Collapsed Forwarding - OK

And there is some upcoming projects which may get included if they make
it in time:

  - epoll support for pending connections (added by SSL update)

  - FreeBSD kqueue support - OK

  - Deferred reads cleanup - Partial (epoll/kqueue only)

  - cbdatareference (needs to be resurrected from old 2.6 branch) - NAK
    (no time)

  - New improved COSS (maybe even production ready?) - OK

  - Automake updates to work with newer autoconf/automake - OK

  - commloops separation - OK

Packages of squid 2.6 source code are available at
[](http://www.squid-cache.org/Versions/v2/2.6/)

# Opinions on if there should be a release

Summary of the opinions regarding a Squid-2.6 release

Full in favor, including performance enhancements:

  - Henrik Nordstrom \*

  - Guido Serassio \*

  - Adrian Chadd \*

  - Francesco 'Kinkie' Chemolli

  - Reuben Farrelly

  - Steven Wilton

In favor, but no clear indication

  - Andrey Shorin

  - Paul Armstrong

Mixed feelins

  - Duane Wessels \*

  - Robert Collins \*

Maybe, not including performance enhancements:

  - Alex Rousskov \*

\* = Core team member
