#language en

= Squid 3.2 =

Currently in '''STABLE''' cycle.
The features have been set and large code changes are reserved for later versions.

Additions are limited to:
 * Security fixes
 * Stability fixes
 * small optimizations

Features Ported from 2.7 in this release:

 * Unique Sequence numbering for access.log lines
 * [[Features/LogModules]] (including log daemon module)
 * {{{Cache-Control: stale-if-error}}}  handling and other staleness limits.
 * SquidConf:acl urllogin type (available from 3.2.4)

Basic new features in 3.2:

 * Fully transparent credential pass-thru to SquidConf:cache_peer
 * Kerberos login to SquidConf:cache_peer
 * [[Features/HTTP11| Full HTTP/1.1 Support]]
 * [[Features/Tproxy4|TProxy v4.1+ support for IPv6]]
 * Dynamic URL generation for SquidConf:deny_info redirects
 * Multi-Lingual FTP directory listings
 * Multi-Lingual proxy configuration splash pages for captive portals
 * [[Features/Surrogate|Surrogate 1.0]] protocol support
 * [[Features/SmpScale|SMP]] Scaling worker processes
 * [[Features/RockStore| ''rock'' ]] SMP shared memory cache with disk backing
 * Helpers started on-demand instead of delaying startup and reconfigure process
 * [[Features/HelperMultiplexer| Multiplexer to add concurrency support for older helpers]]
 * New helpers to demo SquidConf:url_rewrite_program programs
 * New helper to lookup Kerberos or NTLM group via LDAP
 * New helper to de-mux Negotiate/NTLM and Negotiate/Kerberos authentication
 * ''Purge'' tool to manage UFS/AUFS/DiskD caches bundled
 * EUI (MAC address) logging and external ACL handling
 * [[Features/AclRandom]]
 * [[Features/EDNS]]
 * [[Features/LogDnsWait]]
 * IPv6 support for TCP split-stack

## Developer-only relevant features
## * [[Features/ConfigureInRefactoring]]
## * [[Features/CommCleanup]]

Packages of squid 3.2 source code are available at
http://www.squid-cache.org/Versions/v3/3.2/

=== Security Advisories ===

See our [[http://www.squid-cache.org/Advisories/|Advisories]] list.

=== Open Bugs ===
 . <:( [[http://bugs.squid-cache.org/buglist.cgi?bug_id_type=anyexact&bug_severity=blocker&bug_severity=critical&bug_severity=major&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&chfieldto=Now&product=Squid&query_format=advanced&columnlist=bug_severity%2Cversion%2Cop_sys%2Cshort_desc&order=version%20DESC%2Cbug_severity%2Cbug_id| Major or higher Bugs currently affecting this release]].
  * Bugs against any older version can be closed if found fixed in 3.2.
  * Bugs inherited from older versions are not necessarily blockers on 3.2 stable.
