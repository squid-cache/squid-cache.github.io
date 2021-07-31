#language en

= Squid 5 =

## adjust the box text as necessary for major milestones.
## || month year ||<style="background-color: #CC0022;"> Squid-5 is '''CONSIDERED DANGEROUS''' as the security people say. Due to unfixed vulnerabilities ''' [[http://www.squid-cache.org/Advisories/SQUID-...|CVE-...]] ''' and any other recently discovered issues. ||
## || month year ||<style="background-color: orange;"> the Squid-5 series became '''OBSOLETE''' with the release of distro-X shipping [[Squid-6]] ||
## || month year ||<style="background-color: yellow;"> Squid-5 series became '''DEPRECATED''' with the release of  [[Squid-6]] series ||
|| Aug 2021 ||<style="background-color: #82FF42;"> Released for production use. ||

The features have been set and large code changes are reserved for later versions.

Additions are limited to:
 * Security fixes
 * Serious Bug fixes
 * Documentation updates

Features ported from 2.7 in this release:

 * Class 6 (client response) delay pool
   - In the form of SquidConf:response_delay_pool and SquidConf:response_delay_pool_access for Squid-to-client speed limiting.

Basic new features in 5.1:

 *  '''Major UI changes:'''
  * Happy Eyeballs: Use each fully resolved forwarding destination ASAP.
    - Removes SquidConf:dns_v4_first feature as a side effect.
  * Reuse reserved Negotiate and NTLM helpers after an idle timeout.
  * Support logformat %codes in error page templates.
  * Support opening CONNECT tunnels through an HTTP cache peer.
  * Change annotation behaviour when multiple same-name annotations are received. (see bug Bug:4912)
    - Some reserved keys retain the old behaviour due to their usage (eg group= received from auth and external ACL helpers)

 * '''Minor UI changes:'''
  * Add SquidConf:auth_schemes to control schemes presence and order in 401s/407s.
  * Add ACL types annotate_transaction and annotate_client.
  * Make CONNECT ACL a built-in default.
  * Add SquidConf:collapsed_forwarding_access to restrict Collapsed Forwarding of HTTP, ICP and HTCP requests.
  * Add SquidConf:mark_client_connection and SquidConf:mark_client_packet directives for Netfilter MARK and CONNMARK control.
  * Add SquidConf:deny_info and error page '''%A''' code to display Squid listening IP address.
  * New %ssl::&lt;cert macro code to display received server X.509 certificate in PEM format.
  * New %proxy_protocol::&gt;h logformat code for logging received PROXY protocol TLV values.

 * '''Developer Interest changes:'''
  * [[https://datatracker.ietf.org/doc/draft-rousskov-icap-trailers/|ICAP Trailers]].
  * Remove USE_CHUNKEDMEMPOOLS compiler flag.
  * All binaries now use standard EXIT_SUCCESS or EXIT_FAILURE termination results for better OS integration.
  * Migrated to TrivialDB from deprecated BerkleyDB versions.
  * ntlm_fake_auth: add ability to test delayed responses.
  * basic_ldap_auth: return BH on internal errors.
  * Support RFC 8586: Loop Detection in Content Delivery Networks

## The intention with this series is to improve performance using C++11 features. Some remaining [[Squid-2.7]] missing features are listed as regressions in http://www.squid-cache.org/Versions/v5/RELEASENOTES.html#ss5.1

Packages of what will become Squid-5 source code are available at [[http://www.squid-cache.org/Versions/v5/]]

=== Security Advisories ===

See our [[http://www.squid-cache.org/Advisories/|Advisories]] list.

=== Open Bugs ===

## all bugs major and higher including older versions.
 . [[http://bugs.squid-cache.org/buglist.cgi?bug_id_type=anyexact&bug_severity=blocker&bug_severity=critical&bug_severity=major&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&chfieldto=Now&product=Squid&query_format=advanced&columnlist=bug_severity%2Cversion%2Cop_sys%2Cshort_desc&order=version%20DESC%2Cbug_severity%2Cbug_id&o2=equals&v2=unspecified&f1=version&o1=lessthaneq&v1=5| Major or higher bugs currently affecting this version]].
  * Bugs against any older version can be closed if found fixed in 5.x
  * Bugs inherited from older versions are not necessarily blockers on stable.


## bugs down to major added by this version
 . [[http://bugs.squid-cache.org/buglist.cgi?query_format=advanced&product=Squid&version=5&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_severity=blocker&bug_severity=critical&bug_severity=major&bug_severity=normal&bug_severity=minor&emailtype1=substring&email1=&emailtype2=substring&email2=&bugidtype=include&columnlist=bug_severity%2Cversion%2Cop_sys%2Cshort_desc&list_id=917&order=version DESC%2Cbug_severity%2Cbug_id| Bugs new in this version ]]


=== Squid-5 default config ===

##start defaultconfig

{{{
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
}}}

##end defaultconfig
