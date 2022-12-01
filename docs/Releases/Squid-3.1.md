# Squid 3.1

|          |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| today    | Squid-3.1 is **CONSIDERED DANGEROUS** as the security people say. Due to unfixed vulnerabilities **[CVE-2014-7141](http://www.squid-cache.org/Advisories/SQUID-2014_4.txt), [CVE-2014-7142](http://www.squid-cache.org/Advisories/SQUID-2014_4.txt), [CVE-2014-6270](http://www.squid-cache.org/Advisories/SQUID-2014_3.txt), [CVE-2014-3609](http://www.squid-cache.org/Advisories/SQUID-2014_2.txt), [CVE-2014-0128](http://www.squid-cache.org/Advisories/SQUID-2014_1.txt), [CVE-2009-0801](http://www.squid-cache.org/Advisories/SQUID-2011_1.txt)** and any other recently discovered issues. |
| Aug 2012 | the Squid-3.1 series became **DEPRECATED** with the release of [Squid-3.2](/Releases/Squid-3.2) series                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| Mar 2010 | Released for production use.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |

The features have been set and code changes are reserved for later
versions. Additions are limited to **Security and Bug fixes**

Basic new features in 3.1:

  - [Connection Pinning (for NTLM Auth
    Passthrough)](/Features/ConnPin)

  - [Native
    IPv6](/Features/IPv6)

  - [Quality of Service (QoS) Flow
    support](/Features/QualityOfService)

  - [Native Memory
    Cache](/Features/RemoveNullStore)

  - [SSL Bump (for HTTPS Filtering and
    Adaptation)](/Features/SslBump)

  - [TProxy v4.1+
    support](/Features/Tproxy4)

  - [eCAP Adaptation Module
    support](/Features/eCAP)

  - [Error Page
    Localization](/Translations)

  - Follow X-Forwarded-For support

  - X-Forwarded-For options extended (truncate, delete, transparent)

  - Peer-Name ACL

  - Reply headers to external ACL.

  - [ICAP and eCAP
    Logging](/Features/AdaptationLog)

  - [ICAP Service Sets and
    Chains](/Features/AdaptationChain)

  - ICY (SHOUTcast) streaming protocol support

  - [HTTP/1.1 support on connections to web servers and
    peers.](/Features/HTTP11)

From 3.1.9

  - Solaris /dev/poll support

From 3.1.13

  - [HTTPS man-in-middle certificate
    generation](/Features/DynamicSslCert)

Packages of squid 3.1 source code are available at
[](http://www.squid-cache.org/Versions/v3/3.1/)

## Security Advisories

See our [Advisories](http://www.squid-cache.org/Advisories/) list.

## Open Bugs

  - [Bug
    Zapping](http://bugs.squid-cache.org/buglist.cgi?query_format=advanced&product=Squid&product=Website&target_milestone=3.0&target_milestone=3.1&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_severity=blocker&bug_severity=critical&bug_severity=major&bug_severity=normal&emailtype1=substring&email1=&emailtype2=substring&email2=&bugidtype=include&order=bugs.bug_severity%2Cbugs.bug_id&chfieldto=Now&cmdtype=doit)

## Squid-3.1 default config

From 3.1 a lot of configuration cleanups have been done to make things
easier.

  - 
    
    |                                                                      |                                                                                                                             |
    | -------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
    | :warning: | This minimal configuration does not work with versions earlier than 3.1 which are missing special cleanup done to the code. |
    

<!-- end list -->

    http_port 3128
    
    refresh_pattern ^ftp:           1440    20%     10080
    refresh_pattern ^gopher:        1440    0%      1440
    refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
    refresh_pattern .               0       20%     4320
    
    acl manager url_regex -i ^cache_object:// +i ^https?://[^/]+/squid-internal-mgr/
    
    acl localhost src 127.0.0.1/32 ::1
    acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
    
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
