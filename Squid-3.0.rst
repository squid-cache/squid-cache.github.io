#language en

=== Squid 3.0 ===

Currently in '''STABLE''' cycle.
The features have largely been set and large code changes are reserved for later versions. Additions are limited to '''Security and Bug fixes'''

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
