#language en

= Squid 3.1 =

Currently in '''STABLE / DEPRECATED''' cycle.
The features have been set and code changes are reserved for later versions. Additions are limited to '''Security and Bug fixes'''


Basic new features in 3.1:

 * [[Features/ConnPin|Connection Pinning (for NTLM Auth Passthrough)]]
 * [[Features/IPv6|Native IPv6]]
 * [[Features/QualityOfService|Quality of Service (QoS) Flow support]]
 * [[Features/RemoveNullStore|Native Memory Cache]]
 * [[Features/SslBump|SSL Bump (for HTTPS Filtering and Adaptation)]]
 * [[Features/Tproxy4|TProxy v4.1+ support]]
 * [[Features/eCAP|eCAP Adaptation Module support]]
 * [[Translations|Error Page Localization]]
 * Follow X-Forwarded-For support
 * X-Forwarded-For options extended (truncate, delete, transparent)
 * Peer-Name ACL
 * Reply headers to external ACL.
 * [[Features/AdaptationLog|ICAP and eCAP Logging]]
 * [[Features/AdaptationChain|ICAP Service Sets and Chains]]
 * ICY (SHOUTcast) streaming protocol support
 * [[Features/HTTP11|HTTP/1.1 support on connections to web servers and peers.]]

From 3.1.9

 * Solaris /dev/poll support

From 3.1.13

 * [[Features/DynamicSslCert| HTTPS man-in-middle certificate generation]]

## Developer-only relevant features
## * Features/NativeAsyncCalls

Packages of squid 3.1 source code are available at
http://www.squid-cache.org/Versions/v3/3.1/

=== Security Advisories ===

See our [[http://www.squid-cache.org/Advisories/|Advisories]] list.

=== Open Bugs ===
 * [[http://bugs.squid-cache.org/buglist.cgi?query_format=advanced&product=Squid&product=Website&target_milestone=3.0&target_milestone=3.1&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_severity=blocker&bug_severity=critical&bug_severity=major&bug_severity=normal&emailtype1=substring&email1=&emailtype2=substring&email2=&bugidtype=include&order=bugs.bug_severity%2Cbugs.bug_id&chfieldto=Now&cmdtype=doit|Bug Zapping]]
