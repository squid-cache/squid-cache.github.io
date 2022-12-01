# Squid 3.5

|          |                                                                                                                                          |
| -------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| Jul 2018 | Squid-3.5 series became **DEPRECATED** with the release of [Squid-4](/Releases/Squid-4) series |
| Jan 2015 | Released for production use.                                                                                                             |

The features have been set and large code changes are reserved for later
versions.

  - Additions are limited to:

  - Security fixes

  - Stability fixes

  - Bug fixes

  - Documentation updates

Features ported from 2.7 in this release:

  - [Collapsed
    Forwarding](http://www.squid-cache.org/Doc/config/collapsed_forwarding/)

Basic new features in 3.5:

  - eCAP version 1.0 support

  - Authentication helper query extensions (see
    [auth_param](http://www.squid-cache.org/Doc/config/auth_param))

  - Caching large (\>32KB) objects in [Rock
    storage](/Features/LargeRockStore)

  - Extended cache HIT/MISS decision control (see
    [send_hit](http://www.squid-cache.org/Doc/config/send_hit),
    [store_miss](http://www.squid-cache.org/Doc/config/store_miss))

  - Logging of transaction start time (see
    [logformat](http://www.squid-cache.org/Doc/config/logformat))

  - Adaptation service performed ACL test

  - Support named services

  - Upgraded squidclient tool

  - Helper support for concurrency channels (Digest Authentication,
    StoreID, URL-rewrite)

  - [Native FTP protocol
    relay](/Features/FtpRelay)

  - Initial support for [PROXY
    protocol](http://www.haproxy.org/download/1.5/doc/proxy-protocol.txt)

  - Basic authentication MSNT helper changes

Added in 3.5.13:

  - Support Elliptic Curve ciphers in TLS

Features removed in 3.5:

  - COSS storage type has been superceded by
    [Rock](/Features/LargeRockStore)
    storage type.

  - dnsserver helper has been superceded by DNS internal client.

  - DNS helper API has been superceded by DNS internal client.

The intention with this series is to improve performance and HTTP
support. Some remaining Squid-2.7 missing features are listed as
regressions in
[](http://www.squid-cache.org/Versions/v3/3.5/RELEASENOTES.html#ss5.1)

Packages of what will become squid 3.5 source code are available at
[](http://www.squid-cache.org/Versions/v3/3.5/)

## Security Advisories

See our [Advisories](http://www.squid-cache.org/Advisories/) list.

## Open Bugs

  - ![\<:(](https://wiki.squid-cache.org/wiki/squidtheme/img/frown.png)
    [Major or higher Bugs currently affecting this
    release](http://bugs.squid-cache.org/buglist.cgi?bug_id_type=anyexact&bug_severity=blocker&bug_severity=critical&bug_severity=major&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&chfieldto=Now&product=Squid&query_format=advanced&columnlist=bug_severity%2Cversion%2Cop_sys%2Cshort_desc&order=version%20DESC%2Cbug_severity%2Cbug_id&o2=equals&v2=unspecified&f1=version&o1=lessthaneq&v1=3.5).
    
      - Bugs against any older version can be closed if found fixed in
        3.5.
    
      - Bugs inherited from older versions are not necessarily blockers
        on 3.5 stable.

## Squid-3.5 default config

From 3.5 a few performance improvements have been done. The manager
regex ACLs have been moved after the DoS and protocol smuggling attack
protections.

  - 
    
    |                                                                      |                                                                                                                             |
    | -------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
    | :warning: | This minimal configuration does not work with versions earlier than 3.2 which are missing special cleanup done to the code. |
    

<!-- end list -->

    http_port 3128
    
    acl localnet src 10.0.0.0/8     # RFC1918 possible internal network
    acl localnet src 172.16.0.0/12  # RFC1918 possible internal network
    acl localnet src 192.168.0.0/16 # RFC1918 possible internal network
    acl localnet src fc00::/7       # RFC 4193 local private network range
    acl localnet src fe80::/10      # RFC 4291 link-local (directly plugged) machines
    
    acl SSL_ports port 443
    
    acl Safe_ports port 80          # http
    acl Safe_ports port 21          # ftp
    acl Safe_ports port 443         # https
    acl Safe_ports port 70          # gopher
    acl Safe_ports port 210         # wais
    acl Safe_ports port 280         # http-mgmt
    acl Safe_ports port 488         # gss-http
    acl Safe_ports port 591         # filemaker
    acl Safe_ports port 777         # multiling http
    acl Safe_ports port 1025-65535  # unregistered ports
    
    acl CONNECT method CONNECT
    
    http_access deny !Safe_ports
    http_access deny CONNECT !SSL_ports
    http_access allow localhost manager
    http_access deny manager
    
    #
    # INSERT YOUR OWN RULE(S) HERE TO ALLOW ACCESS FROM YOUR CLIENTS
    #
    
    http_access allow localnet
    http_access allow localhost
    http_access deny all
    
    coredump_dir /squid/var/cache/squid
    
    refresh_pattern ^ftp:           1440    20%     10080
    refresh_pattern ^gopher:        1440    0%      1440
    refresh_pattern -i (/cgi-bin/|\?) 0     0%      0
    refresh_pattern .               0       20%     4320
