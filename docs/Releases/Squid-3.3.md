# Squid 3.3

|          |                                                                                                                                                                                                                                                                                                                                                                             |
| -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| today    | Squid-3.3 is **CONSIDERED DANGEROUS** as the security people say. Due to unfixed vulnerabilities **[CVE-2014-7141](http://www.squid-cache.org/Advisories/SQUID-2014_4.txt), [CVE-2014-7142](http://www.squid-cache.org/Advisories/SQUID-2014_4.txt) and [CVE-2014-6270](http://www.squid-cache.org/Advisories/SQUID-2014_3.txt)** and any other recently discovered issues. |
| Dec 2013 | the Squid-3.3 series became **DEPRECATED** with the release of [Squid-3.4](/Releases/Squid-3.4) series                                                                                                                                                                                                                            |
| Feb 2013 | Released for production use.                                                                                                                                                                                                                                                                                                                                                |

The features have been set and large code changes are reserved for later
versions.

Additions are limited to:

  - Security fixes

  - Stability fixes

  - small optimizations

  - Documentation updates

  - Porting of Squid-2.7 feature regressions

  - Bug fixes

Features ported from 2.7 in this release:

  - external acl %ACL and %DATA tags (from 3.3.5)

Basic new features in 3.3:

  - New helper to log access.log to an SQL Database

  - New helper to quota session access time

  - [Features/BumpSslServerFirst](/Features/BumpSslServerFirst)

  - [Features/MimicSslServerCert](/Features/MimicSslServerCert)

  - New directive
    [request\_header\_add](http://www.squid-cache.org/Doc/config/request_header_add)
    for custom HTTP headers

The intention with this series is to improve the upgrade path and
concentrate on further portability improvements. Squid-2.7 missing
features are listed as regressions in
[](http://www.squid-cache.org/Versions/v3/3.3/RELEASENOTES.html#s6)

Packages of squid 3.3 source code are available at
[](http://www.squid-cache.org/Versions/v3/3.3/)

## Security Advisories

See our [Advisories](http://www.squid-cache.org/Advisories/) list.

## Open Bugs

  - ![\<:(](https://wiki.squid-cache.org/wiki/squidtheme/img/frown.png)
    [Major or higher Bugs currently affecting this
    release](http://bugs.squid-cache.org/buglist.cgi?bug_id_type=anyexact&bug_severity=blocker&bug_severity=critical&bug_severity=major&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&chfieldto=Now&product=Squid&query_format=advanced&columnlist=bug_severity%2Cversion%2Cop_sys%2Cshort_desc&order=version%20DESC%2Cbug_severity%2Cbug_id).
    
      - Bugs against any older version can be closed if found fixed in
        3.3.
    
      - Bugs inherited from older versions are not necessarily blockers
        on 3.3 stable.

## Squid-3.3 default config

From 3.3 a few performance improvements have been done. The manager
regex ACLs have been moved after the DoS and protocol smuggling attack
protections.

  - 
    
    |                                                                      |                                                                                                                             |
    | -------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
    | ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png) | This minimal configuration does not work with versions earlier than 3.2 which are missing special cleanup done to the code. |
    

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
    
    acl SSL_ports port 443          # https
    
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
    
    http_access deny !Safe_ports
    http_access deny CONNECT !SSL_ports
    http_access allow localhost manager
    http_access deny manager
    http_access allow localnet
    http_access allow localhost
    http_access deny all
