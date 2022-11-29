# Squid 3.2

|          |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| today    | Squid-3.2 is **CONSIDERED DANGEROUS** as the security people say. Due to unfixed vulnerabilities **[CVE-2014-7141](http://www.squid-cache.org/Advisories/SQUID-2014_4.txt), [CVE-2014-7142](http://www.squid-cache.org/Advisories/SQUID-2014_4.txt), [CVE-2014-6270](http://www.squid-cache.org/Advisories/SQUID-2014_3.txt), [CVE-2014-3609](http://www.squid-cache.org/Advisories/SQUID-2014_2.txt), and [CVE-2014-0128](http://www.squid-cache.org/Advisories/SQUID-2014_1.txt)** and any other recently discovered issues. |
| Feb 2013 | the Squid-3.2 series became **DEPRECATED** with the release of [Squid-3.3](/Releases/Squid-3.3) series                                                                                                                                                                                                                                                                                                                                                                               |
| Aug 2012 | Released for production use.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |

The features have been set and large code changes are reserved for later
versions.

Additions are limited to:

  - Security fixes

  - Stability fixes

  - small optimizations

Features Ported from 2.7 in this release:

  - Unique Sequence numbering for access.log lines

  - [Features/LogModules](/Features/LogModules)
    (including log daemon module)

  - `Cache-Control: stale-if-error` handling and other staleness limits.

  - [acl](http://www.squid-cache.org/Doc/config/acl) urllogin type
    (available from 3.2.4)

Basic new features in 3.2:

  - Fully transparent credential pass-thru to
    [cache_peer](http://www.squid-cache.org/Doc/config/cache_peer)

  - Kerberos login to
    [cache_peer](http://www.squid-cache.org/Doc/config/cache_peer)

  - [Full HTTP/1.1
    Support](/Features/HTTP11)

  - [TProxy v4.1+ support for
    IPv6](/Features/Tproxy4)

  - Dynamic URL generation for
    [deny_info](http://www.squid-cache.org/Doc/config/deny_info)
    redirects

  - Multi-Lingual FTP directory listings

  - Multi-Lingual proxy configuration splash pages for captive portals

  - [Surrogate 1.0](/Features/Surrogate)
    protocol support

  - [SMP](/Features/SmpScale)
    Scaling worker processes

  - [''rock''](/Features/RockStore)
    SMP shared memory cache with disk backing

  - Helpers started on-demand instead of delaying startup and
    reconfigure process

  - [Multiplexer to add concurrency support for older
    helpers](/Features/HelperMultiplexer)

  - New helpers to demo
    [url_rewrite_program](http://www.squid-cache.org/Doc/config/url_rewrite_program)
    programs

  - New helper to lookup Kerberos or NTLM group via LDAP

  - New helper to de-mux Negotiate/NTLM and Negotiate/Kerberos
    authentication

  - *Purge* tool to manage UFS/AUFS/DiskD caches bundled

  - EUI (MAC address) logging and external ACL handling

  - [Features/AclRandom](/Features/AclRandom)

  - [Features/EDNS](/Features/EDNS)

  - [Features/LogDnsWait](/Features/LogDnsWait)

  - IPv6 support for TCP split-stack

Packages of squid 3.2 source code are available at
[](http://www.squid-cache.org/Versions/v3/3.2/)

## Security Advisories

See our [Advisories](http://www.squid-cache.org/Advisories/) list.

## Open Bugs

  - ![\<:(](https://wiki.squid-cache.org/wiki/squidtheme/img/frown.png)
    [Major or higher Bugs currently affecting this
    release](http://bugs.squid-cache.org/buglist.cgi?bug_id_type=anyexact&bug_severity=blocker&bug_severity=critical&bug_severity=major&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&chfieldto=Now&product=Squid&query_format=advanced&columnlist=bug_severity%2Cversion%2Cop_sys%2Cshort_desc&order=version%20DESC%2Cbug_severity%2Cbug_id).
    
      - Bugs against any older version can be closed if found fixed in
        3.2.
    
      - Bugs inherited from older versions are not necessarily blockers
        on 3.2 stable.

## Squid-3.2 default config

From 3.2 further configuration cleanups have been done to make things
easier and safer. The manager, localhost, and to_localhost ACL
definitions are now built-in.

  - 
    
    |                                                                      |                                                                                                                             |
    | -------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
    | ⚠️ | This minimal configuration does not work with versions earlier than 3.2 which are missing special cleanup done to the code. |
    

<!-- end list -->

    http_port 3128
    
    refresh_pattern ^ftp:           1440    20%     10080
    refresh_pattern ^gopher:        1440    0%      1440
    refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
    refresh_pattern .               0       20%     4320
    
    acl localnet src 10.0.0.0/8     # RFC 1918 possible internal network
    acl localnet src 172.16.0.0/12  # RFC 1918 possible internal network
    acl localnet src 192.168.0.0/16 # RFC 1918 possible internal network
    acl localnet src fc00::/7       # RFC 4193 local private network range
    acl localnet src fe80::/10      # RFC 4291 link-local (directly plugged) machines
    
    acl SSL_ports port 443
    
    acl Safe_ports port 80          # http
    acl Safe_ports port 21          # ftp
    acl Safe_ports port 443         # https
    acl Safe_ports port 70          # gopher
    acl Safe_ports port 210         # wais
    acl Safe_ports port 1025-65535  # unregistered ports
    acl Safe_ports port 280         # http-mgmt
    acl Safe_ports port 488         # gss-http
    acl Safe_ports port 591         # filemaker
    acl Safe_ports port 777         # multiling http
    acl CONNECT method CONNECT
    
    http_access allow manager localhost
    http_access deny manager
    http_access deny !Safe_ports
    http_access deny CONNECT !SSL_ports
    http_access allow localhost
    http_access allow localnet
    http_access deny all
