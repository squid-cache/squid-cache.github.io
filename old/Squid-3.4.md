# Squid 3.4

|          |                                                                                                                                                                                                                                                                                                                                                 |
| -------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Jan 2015 | Squid-3.4 series became **DEPRECATED** with the release of [Squid-3.5](https://wiki.squid-cache.org/Squid-3.4/Squid-3.5#) series                                                                                                                                                                                                                |
| Sep 2014 | Squid-3.4.7 and older are **CONSIDERED DANGEROUS** as the security people say. Due to unfixed vulnerabilities **[CVE-2014-7141](http://www.squid-cache.org/Advisories/SQUID-2014_4.txt), [CVE-2014-7142](http://www.squid-cache.org/Advisories/SQUID-2014_4.txt), and [CVE-2014-6270](http://www.squid-cache.org/Advisories/SQUID-2014_3.txt)** |
| Dec 2013 | Released for production use.                                                                                                                                                                                                                                                                                                                    |

The features have been set and code changes are reserved for later
versions.

Additions are limited to **Security and Bug fixes**

  - ![\<:(](https://wiki.squid-cache.org/wiki/squidtheme/img/frown.png)
    [Major bugs still
    in 3.4](http://bugs.squid-cache.org/buglist.cgi?query_format=advanced&product=Squid&target_milestone=---&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_severity=blocker&bug_severity=critical&bug_severity=major&emailtype1=substring&email1=&emailtype2=substring&email2=&bugidtype=include&order=bugs.bug_severity%2Cbugs.bug_id&chfieldto=Now&cmdtype=doit)

Features ported from 2.7 in this release:

  - [Store ID](https://wiki.squid-cache.org/Squid-3.4/Features/StoreID#)
    - a redesign of the store-URL rewrite feature from 2.7.

Basic new features in 3.4:

  - [SSL server certificate
    validator](https://wiki.squid-cache.org/Squid-3.4/Features/SslServerCertValidator#)

  - [note](http://www.squid-cache.org/Doc/config/note#) directive for
    annotating transactions

  - [TPROXY](https://wiki.squid-cache.org/Squid-3.4/Features/Tproxy4#)
    Support for BSD systems

  - [spoof\_client\_ip](http://www.squid-cache.org/Doc/config/spoof_client_ip#)
    directive for managing TPROXY spoofing

  - Various Access Control updates:
    
      - **server\_ssl\_cert\_fingerprint** type to match certificate
        fingerprints
    
      - **note** type to match annotations for a transaction.
    
      - **all-of** and **any-of** types for complex configurations.
    
      - No-lookup DNS for certain
        [acl](http://www.squid-cache.org/Doc/config/acl#) types.

  - Support OK/ERR/BH response codes and kv-pair options from any helper

  - Improved pipeline queue configuration.

  - Multicast DNS

The intention with this series is to improve portability and stability.
Some remaining Squid-2.7 missing features are listed as regressions in
[](http://www.squid-cache.org/Versions/v3/3.4/RELEASENOTES.html#ss5.1)

Packages of squid 3.4 source code are available at
[](http://www.squid-cache.org/Versions/v3/3.4/)

## Security Advisories

See our [Advisories](http://www.squid-cache.org/Advisories/) list.

## Open Bugs

  - ![\<:(](https://wiki.squid-cache.org/wiki/squidtheme/img/frown.png)
    [Major or higher Bugs currently affecting this
    release](http://bugs.squid-cache.org/buglist.cgi?bug_id_type=anyexact&bug_severity=blocker&bug_severity=critical&bug_severity=major&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&chfieldto=Now&product=Squid&query_format=advanced&columnlist=bug_severity%2Cversion%2Cop_sys%2Cshort_desc&order=version%20DESC%2Cbug_severity%2Cbug_id&o2=equals&v2=unspecified&f1=version&o1=lessthaneq&v1=3.4).
    
      - Bugs against any older version can be closed if found fixed in
        3.4.
    
      - Bugs inherited from older versions are not necessarily blockers
        on 3.4 stable.
