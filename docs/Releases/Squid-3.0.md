# Squid 3.0

|          |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| -------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| today    | Squid-3.0 is **CONSIDERED DANGEROUS** as the security people say. Due to unfixed vulnerabilities **[CVE-2014-7141](http://www.squid-cache.org/Advisories/SQUID-2014_4.txt), [CVE-2014-7142](http://www.squid-cache.org/Advisories/SQUID-2014_4.txt), [CVE-2014-6270](http://www.squid-cache.org/Advisories/SQUID-2014_3.txt), [CVE-2014-3609](http://www.squid-cache.org/Advisories/SQUID-2014_2.txt), [CVE-2012-5643](http://www.squid-cache.org/Advisories/SQUID-2012_1.txt), [CVE-2013-0189](http://www.squid-cache.org/Advisories/SQUID-2012_1.txt), [CVE-2009-0801](http://www.squid-cache.org/Advisories/SQUID-2011_1.txt)** and any other recently discovered issues. |
| Mar 2010 | the Squid-3.0 series became **DEPRECATED** with the release of [Squid-3.1](/Releases/Squid-3.1) series                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| Dec 2007 | Released for production use.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |

The features have been set and code changes are reserved for later
versions. Additions are limited to **Security and Bug fixes**

Basic new features in 3.0

  - [ICAP (Internet Content Adaptation
    Protocol)](/Features/ICAP)

  - ESI (Edge Side Includes)

  - HTTP status ACL

  - Control Path-MTU discovery

  - Weighted Round-Robin peer selection mechanism

  - Per-User bandwidth limits (class 4 delay pool)

From STABLE 2

  - [include
    Directive](/Features/ConfigIncludes)

  - Port-name ACL

From STABLE 6

  - umask Support

From STABLE 8

  - userhash Peer Selection

  - sourcehash Peer Selection

  - cachemgr.cgi Sub-Actions

Packages of squid 3.0 source code are available at
<http://www.squid-cache.org/Versions/v3/3.0/>

## Split Choice

As it stands, users will still need to make a choice between
[Squid-3.0](/Releases/Squid-3.0)
and [Squid-2.7]() when moving away from Squid-2.5 and
[Squid-2.6](/Releases/Squid-2.6).
This decision needs to be made on the basis of their feature needs.

The only help we can provide for this is to point out that:

  - [Squid-3.0](/Releases/Squid-3.0)
    has been largely sponsored by the Web-Filtering user community. With
    features aimed at adapting and altering content in transit.

  - [Squid-2.7]() has been largely sponsored by high-performance user
    community. With features aimed at Caching extremely high traffic
    volumes in the order of Terabytes per day.
