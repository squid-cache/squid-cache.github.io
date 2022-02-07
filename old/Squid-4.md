# Squid 4

|          |                                                                                                                          |
| -------- | ------------------------------------------------------------------------------------------------------------------------ |
| Aug 2021 | Squid-4 series became **DEPRECATED** with the release of [Squid-5](https://wiki.squid-cache.org/Squid-4/Squid-5#) series |
| Jul 2018 | Released for production use.                                                                                             |

The features have been set and large code changes are reserved for later
versions.

  - Additions are limited to:

  - Security fixes

  - Stability fixes

  - Bug fixes

  - Documentation updates

  - ![{X}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png)
    This series of Squid requires a C++11 capable compiler. The
    currently known compilers which meet this criteria and build Squid-4
    reliably are GCC 4.9+ and Clang 3.5+

Basic new features in version 4:

  - **Major UI changes:**
    
      - RFC [6176](https://tools.ietf.org/rfc/rfc6176#) compliance
        (SSLv2 support removal)
    
      - Secure ICAP service connections
    
      - Add url\_lfs\_rewrite: a URL-rewriter based on local file
        existence
    
      - [on\_unsupported\_protocol](http://www.squid-cache.org/Doc/config/on_unsupported_protocol#)
        directive to allow Non-HTTP bypass
    
      - Removal of
        [refresh\_pattern](http://www.squid-cache.org/Doc/config/refresh_pattern#)
        ignore-auth and ignore-must-revalidate options
    
      - Remove
        [cache\_peer\_domain](http://www.squid-cache.org/Doc/config/cache_peer_domain#)
        directive
    
      - basic\_msnt\_multi\_domain\_auth: Superceeded by
        basic\_smb\_lm\_auth
    
      - Update
        [external\_acl\_type](http://www.squid-cache.org/Doc/config/external_acl_type#)
        directive to take logformat codes in its format parameter
    
      - Removal of ESI custom parser
    
      - Experimental GnuTLS support for some TLS features

  - **Minor UI changes:**
    
      - Sub-millisecond transaction logging
    
      - ext\_kerberos\_ldap\_group\_acl -n option to disable automated
        SASL/GSSAPI
    
      - negotiate\_kerberos\_auth outputs group= kv-pair for use in note
        ACL
    
      - security\_file\_certgen helper supports memory-only mode
    
      - Adaptation support for Expect:100-continue in HTTP messages
    
      - Add
        [url\_rewrite\_timeout](http://www.squid-cache.org/Doc/config/url_rewrite_timeout#)
        directive
    
      - Update localnet ACL default definition for RFC
        [6890](https://tools.ietf.org/rfc/rfc6890#) compliance
    
      - Persistent connection timeouts
        [request\_start\_timeout](http://www.squid-cache.org/Doc/config/request_start_timeout#)
        and
        [pconn\_lifetime](http://www.squid-cache.org/Doc/config/pconn_lifetime#)
    
      - Per-rule
        [refresh\_pattern](http://www.squid-cache.org/Doc/config/refresh_pattern#)
        matching statistics in cachemgr report
    
      - Configurable helper queue size, with consistent defaults and
        better overflow handling

  - **Developer Interest changes:**
    
      - C++11
    
      - New helper concurrency channel-ID assignment algorithm
    
      - Simplify MEMPROXY\_CLASS\_\* macros
    
      - Simplify CBDATA API and rename CBDATA\_CLASS
    
      - HTTP Parser structural redesign
    
      - Base64 crypto API replacement
    
      - Enable long (--foo) command line parameters on squid binary
    
      - Implemented selective debugs() output for unit tests
    
      - Improved SMP support

The intention with this series is to improve performance using C++11
features. Some remaining
[Squid-2.7](https://wiki.squid-cache.org/Squid-4/Squid-2.7#) missing
features are listed as regressions in
[](http://www.squid-cache.org/Versions/v4/RELEASENOTES.html#ss5.1)

Packages of what will become Squid-4 source code are available at
[](http://www.squid-cache.org/Versions/v4/)

## Security Advisories

See our [Advisories](http://www.squid-cache.org/Advisories/) list.

## Open Bugs

  - [Major or higher bugs currently affecting this
    version](http://bugs.squid-cache.org/buglist.cgi?bug_id_type=anyexact&bug_severity=blocker&bug_severity=critical&bug_severity=major&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&chfieldto=Now&product=Squid&query_format=advanced&columnlist=bug_severity%2Cversion%2Cop_sys%2Cshort_desc&order=version%20DESC%2Cbug_severity%2Cbug_id&o2=equals&v2=unspecified&f1=version&o1=lessthaneq&v1=4).
    
      - Bugs against any older version can be closed if found fixed in
        4.x
    
      - Bugs inherited from older versions are not necessarily blockers
        on stable.

<!-- end list -->

  - [Bugs new in this
    version](http://bugs.squid-cache.org/buglist.cgi?query_format=advanced&product=Squid&version=4&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_severity=blocker&bug_severity=critical&bug_severity=major&bug_severity=normal&bug_severity=minor&emailtype1=substring&email1=&emailtype2=substring&email2=&bugidtype=include&columnlist=bug_severity%2Cversion%2Cop_sys%2Cshort_desc&list_id=917&order=version%20DESC%2Cbug_severity%2Cbug_id)

## Squid-4 default config

    http_port 3128
    
    # Example rule allowing access from your local networks.
    # Adapt to list your (internal) IP networks from where browsing
    # should be allowed
    acl localnet src 0.0.0.1-0.255.255.255  # RFC 1122 "this" network (LAN)
    acl localnet src 10.0.0.0/8             # RFC 1918 local private network (LAN)
    acl localnet src 100.64.0.0/10          # RFC 6598 shared address space (CGN)
    acl localnet src 169.254.0.0/16         # RFC 3927 link-local (directly plugged) machines
    acl localnet src 172.16.0.0/12          # RFC 1918 local private network (LAN)
    acl localnet src 192.168.0.0/16         # RFC 1918 local private network (LAN)
    acl localnet src fc00::/7               # RFC 4193 local private network range
    acl localnet src fe80::/10              # RFC 4291 link-local (directly plugged) machines
    
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
