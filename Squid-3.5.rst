#language en

= Squid 3.5 =

## adjust the box text as necessary for major milestones.
## || month year  ||<style="background-color: #CC0022;"> Squid-3.5.* and older are '''CONSIDERED DANGEROUS''' as the security people say. Due to unfixed [[http://www.squid-cache.org/Advisories/|vulnerabilities]] ||
## || month year ||<style="background-color: orange;"> the Squid-3.5 series became '''OBSOLETE''' with the release of distro-X shipping [[Squid-3.x]] ||
## || month year ||<style="background-color: yellow;"> Squid-3.5 series became '''DEPRECATED''' with the release of  [[Squid-3.6]] series ||
|| Jan 2015 ||<style="background-color: #82FF42;"> Released for production use. ||

The features have been set and large code changes are reserved for later versions.

 Additions are limited to:
 * Security fixes
 * Stability fixes
 * Bug fixes
 * Documentation updates


## bugs down to major (all earlier releases and 'unknowns')
## . <:( [[http://bugs.squid-cache.org/buglist.cgi?query_format=advanced&product=Squid&target_milestone=---&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_severity=blocker&bug_severity=critical&bug_severity=major&emailtype1=substring&email1=&emailtype2=substring&email2=&bugidtype=include&order=bugs.bug_severity%2Cbugs.bug_id&chfieldto=Now&cmdtype=doit| Major bugs still in 3.5 ]]

Features ported from 2.7 in this release:

 * [[http://www.squid-cache.org/Doc/config/collapsed_forwarding/|Collapsed Forwarding]]

Basic new features in 3.5:

 * eCAP version 1.0 support
 * Authentication helper query extensions (see SquidConf:auth_param)
 * Caching large (>32KB) objects in [[Features/LargeRockStore|Rock storage]]
 * Extended cache HIT/MISS decision control (see SquidConf:send_hit, SquidConf:store_miss)
 * Logging of transaction start time (see SquidConf:logformat)
 * Adaptation service performed ACL test
 * Support named services
 * Upgraded squidclient tool
 * Helper support for concurrency channels (Digest Authentication, StoreID, URL-rewrite)
 * [[Features/FtpRelay|Native FTP protocol relay]]
 * Initial support for [[http://www.haproxy.org/download/1.5/doc/proxy-protocol.txt|PROXY protocol]]
 * Basic authentication MSNT helper changes

Added in 3.5.13:

  * Support Elliptic Curve ciphers in TLS

Features removed in 3.5:

 * COSS storage type has been superceded by [[Features/LargeRockStore|Rock]] storage type.
 * dnsserver helper has been superceded by DNS internal client.
 * DNS helper API has been superceded by DNS internal client.

The intention with this series is to improve performance and HTTP support. Some remaining Squid-2.7 missing features are listed as regressions in http://www.squid-cache.org/Versions/v3/3.5/RELEASENOTES.html#ss5.1

Packages of what will become squid 3.5 source code are available at
http://www.squid-cache.org/Versions/v3/3.5/

=== Security Advisories ===

See our [[http://www.squid-cache.org/Advisories/|Advisories]] list.

=== Open Bugs ===
 . <:( [[http://bugs.squid-cache.org/buglist.cgi?bug_id_type=anyexact&bug_severity=blocker&bug_severity=critical&bug_severity=major&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&chfieldto=Now&product=Squid&query_format=advanced&columnlist=bug_severity%2Cversion%2Cop_sys%2Cshort_desc&order=version%20DESC%2Cbug_severity%2Cbug_id| Major or higher Bugs currently affecting this release]].
  * Bugs against any older version can be closed if found fixed in 3.5.
  * Bugs inherited from older versions are not necessarily blockers on 3.5 stable.

=== Squid-3.5 default config ===

##start defaultconfig

From 3.5 a few performance improvements have been done. The manager regex ACLs have been moved after the DoS and protocol smuggling attack protections.

 || /!\ || This minimal configuration does not work with versions earlier than 3.2 which are missing special cleanup done to the code. ||

{{{
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
}}}

##end defaultconfig
