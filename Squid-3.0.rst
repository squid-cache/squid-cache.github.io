#language en

=== Squid 3.0 ===

|| today ||<style="background-color: #CC0022;"> Squid-3.0 is '''CONSIDERED DANGEROUS''' as the security people say. Due to unfixed vulnerabilities ''' [[http://www.squid-cache.org/Advisories/SQUID-2014_4.txt|CVE-2014-7141]], [[http://www.squid-cache.org/Advisories/SQUID-2014_4.txt|CVE-2014-7142]], [[http://www.squid-cache.org/Advisories/SQUID-2014_3.txt|CVE-2014-6270]], [[http://www.squid-cache.org/Advisories/SQUID-2014_2.txt|CVE-2014-3609]], [[http://www.squid-cache.org/Advisories/SQUID-2012_1.txt|CVE-2012-5643]], [[http://www.squid-cache.org/Advisories/SQUID-2012_1.txt|CVE-2013-0189]], [[http://www.squid-cache.org/Advisories/SQUID-2011_1.txt|CVE-2009-0801]] ''' and any other recently discovered issues. ||
## || month year ||<style="background-color: orange;"> the Squid-3.0 series became '''OBSOLETE''' with the release of distro-X shipping [[Squid-3.x]] ||
|| Mar 2010 ||<style="background-color: yellow;"> the Squid-3.0 series became '''DEPRECATED''' with the release of [[Squid-3.1]] series ||
|| Dec 2007 || Released for production use. ||


The features have been set and code changes are reserved for later versions. Additions are limited to '''Security and Bug fixes'''

Basic new features in 3.0

 * [[Features/ICAP|ICAP (Internet Content Adaptation Protocol)]]
 * ESI (Edge Side Includes)
 * HTTP status ACL
 * Control Path-MTU discovery
 * Weighted Round-Robin peer selection mechanism
 * Per-User bandwidth limits (class 4 delay pool)

From STABLE 2
 * [[Features/ConfigIncludes|include Directive]]
 * Port-name ACL

From STABLE 6
 * umask Support

From STABLE 8
 * userhash Peer Selection
 * sourcehash Peer Selection
 * cachemgr.cgi Sub-Actions

Packages of squid 3.0 source code are available at
http://www.squid-cache.org/Versions/v3/3.0/


## To inform people about their options re: 2.7 vs 3.0
<<Include(Squid-2.7, ,1,from="^##start2vs3choice",to="^##end2vs3choice")>>
