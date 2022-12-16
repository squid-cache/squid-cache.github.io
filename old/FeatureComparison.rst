##master-page:CategoryTemplate
#format wiki
#language en
= Feature Comparison Map for Squid =
This pages hope to be authoritative. If you know of any errors or missing features please let us know.

== Table Key ==
||||<style="text-align: center;">Key: ||
||Y ||Feature Available ||
||- ||Feature not available ||
||X ||Feature available as an experimental component ||
||B ||Feature is included, but has known issues and thus is '''deprecated'''. It will be fixed as time and resources allow ||
||P ||Patch available. ||
||||<style="text-align: center;"> ||
||s2 ||Available for STABLE release 2 ||
||s2+ ||Available for STABLE release 2 and later ||
||Ps2-5 ||Patch available for releases from 2 to 5 (inclusive) ||


== Feature Comparisons ==
||'''Feature''' ||'''2.5''' ||'''2.6''' ||'''2.7''' ||'''3.0''' ||'''3.1''' ||'''3.2''' ||<style="font-weight: bold;">3.HEAD|| ||
||||||||||||||<style="text-align: center;">'''Accepted Input Protocols''' ||
||HTCP ||Y ||Y ||Y ||Y ||Y ||Y ||Y||
||HTTP 0.9 ||Y ||Y ||Y ||Y ||Y ||Y ||Y||
||HTTP 1.0 ||Y ||Y ||Y ||Y ||Y ||Y ||Y||
||HTTP 1.1 ||- ||X ||Y ||Bs16+ ||Y ||Y ||Y||
||HTTPS ||- ||Y ||Y ||Y ||Y ||Y ||Y||
||ICP (v2) ||- ||Y ||Y ||Y ||Y ||Y ||Y||
||ICP (v3) ||- ||Y ||Y ||Y ||Y ||Y ||Y||
||ICY-over-HTTP ||- ||- ||X ||- ||Y ||Y ||Y||
||SNMPv1 ||- ||Y ||Y ||Y ||Y ||Y ||Y||
||||||||||||||<style="text-align: center;">'''URI Protocols handled''' ||
||HTTP 1.0 ||Y ||Y ||Y ||Y ||Y ||Y ||Y||
||[[Features/HTTP11|HTTP 1.1]] ||- ||- ||X ||- ||y ||Y ||Y||
||HTTPS ||Y ||Y ||Y ||Y ||Y ||Y ||Y||
||FTP ||Y ||Y ||Y ||Y ||Y ||Y ||Y||
||Gopher ||Y ||Y ||Y ||Y ||Y ||Y ||Y||
||Whois ||Y ||Y ||Y ||Y ||Y ||Y ||Y||
||||||||||||||<style="text-align: center;">'''Other Protocols''' ||
||HTCP ||Y ||Y ||Y ||Y ||Y ||Y ||Y||
||ICP (v2) ||Y ||Y ||Y ||Y ||Y ||Y ||Y||
||ICP (v3) ||- ||Y ||Y ||Y ||Y ||Y ||Y||
||ICAP ||- ||- ||- ||X ||Y ||Y ||Y||2.6: Patch available has major bugs ||
||eCAP ||- ||- ||- ||- ||Y ||Y ||Y||
||IPv6 ||- ||Ps13 ||- ||- ||Y ||Y ||Y||
||Surrogate 1.0 ||- ||- ||- ||X ||Y ||Y ||Y||Requires ESI for use in 3.0-3.1 ||
||Wais ||Y ||Y ||Y ||Y ||Y ||Y ||Y||
||||||||||||||<style="text-align: center;">'''Storage Filesystems''' ||
||AUFS ||- ||Y ||Y ||Y ||Y ||Y ||Y||
||DiskD ||Y ||Y ||Y ||Y ||Y ||Y ||Y||
||UFS ||Y ||Y ||Y ||Y ||Y ||Y ||Y||
||COSS ||- ||Y ||Y ||B ||B ||B ||B||
||rock ||- ||- ||- ||- ||- ||Y ||Y||
||||||||||||||<style="text-align: center;">'''Authentication Schemes''' ||
||Basic Authentication ||Y ||Y ||Y ||Y ||Y ||Y ||Y||
||Digest Authentication ||Y ||Y ||Y ||Y ||Y ||Y ||Y||
||NTLM Authentication ||Y ||Y ||Y ||Y ||Y ||Y ||Y||For full NTLMv2 we rely on Samba ||
||Negotiate Authentication ||- ||Y ||Y ||Y ||Y ||Y ||Y||aka Kerberos ||
||||||||||||||<style="text-align: center;">'''Efficiency aids''' ||
||[[Features/SmpScale|SMP Scalability]] ||- ||- ||- ||- ||- ||X ||X||
||[[Features/CollapsedForwarding|Collapsed Forwarding]] ||- ||Y ||Y ||- ||- ||- ||-||
||stale-if-error ||- ||- ||Y ||- ||- ||Y ||Y||
||[[Features/StaleWhileRevalidate|stale-while-revalidate]] ||- ||- ||Y ||- ||- ||- ||-||
||||||||||||||<style="text-align: center;">'''Authorization Sources''' ||
||RADIUS Authorization ||- ||Ys17 ||Y ||Y ||Y ||Y ||Y||
||LDAP Authorization || ||Y ||Y ||Y ||Y ||Y ||Y||
||PAM Authorization || ||Y ||Y ||Y ||Y ||Y ||Y||
||Samba Authorization || ||Y ||Y ||Y ||Y ||Y ||Y||
||eDirectory Authorization ||- ||- ||Y ||Y ||Y ||Y ||Y||
