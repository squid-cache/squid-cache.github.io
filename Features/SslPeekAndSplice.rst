##master-page:Features/FeatureTemplate
#format wiki
#language en
##
## Change to 'yes' for a listing under Features in the Squid FAQ.
#faqlisted no

= Feature: SSL Peek and Splice =

 * '''Goal''': Make bumping decisions after the origin server name is known, especially when intercepting SSL. Avoid bumping non-SSL traffic.
 * '''Status''': completed.
 * '''Version''': 3.5
 * '''Developer''': AlexRousskov and Christos Tsantilas
 * '''More''': unofficial development [[https://code.launchpad.net/~measurement-factory/squid/peek-and-splice|branch]].


= Motivation =

Many !SslBump deployments try to minimize potential damage by ''not'' bumping sites unless the local policy demands it. Without this feature, the decision is made based on very limited information: A typical HTTP CONNECT request does not contain many details and intercepted TCP connections reveal nothing but IP addresses and port numbers. Peek and Splice gives admins a way to make bumping decision later in the SSL handshake process, when client SNI and the SSL server certificate are available (or when it becomes clear that we are not dealing with an SSL connection at all!).


= Implementation overview =

Peek and Splice peeks at the SSL client Hello message and SNI info (if any), sends identical or a similar (to the extent possible) Hello message to the SSL server, and then peeks at the SSL server Hello message. The decision to splice or bump can be made at any of those stages (but what Squid does at stage N affects its ability to splice or bump at stage N+1!). If the decision is ''not'' to bump, the two TCP connections are spliced at TCP level, with Squid shoveling TCP bytes back and forth without any decryption.

= Configuration =

== Actions ==

Several actions are possible when a proxy handles an SSL connection. See the SquidConf:ssl_bump directive in your squid.conf.documented for a list of actions your version of Squid supports. Some actions are only possible during certain processing steps. During a given processing step, Squid ''ignores'' SquidConf:ssl_bump lines with impossible actions. This helps us keep configuration sane. Processing steps are discussed further below.


||'''Action'''||'''Applicable processing steps'''||'''Description'''||
||'''splice'''||step1, step2, and sometimes step3||Become a TCP tunnel without decoding the connection.||
||'''bump'''||step1, step2, and sometimes step3||Establish a secure connection with the server and, using a mimicked server certificate, with the client||
||'''peek'''||step1, step2||Receive SNI and client certificate (step1), or server certificate (step2) while preserving the possibility of splicing the connection. Peeking at the server certificate usually precludes future bumping of the connection (see Limitations). This action is the focus of this project.||
||'''stare'''||step1, step2||Receive SNI and client certificate (step1), or server certificate (step2) while preserving the possibility of bumping the connection. Staring at the server certificate usually precludes future splicing of the connection.||
||'''terminate'''||step1, step2, step3||Close client and server connections.||
||||||Older actions mentioned here for completeness sake:||
||'''client-first'''||step1||Ancient-style bumping: Establish a secure connection with the client first, then connect to the server. Cannot mimic server certificate well, which causes a lot of problems.||
||'''server-first'''||step1||Old-style bumping: Establish a secure connection with the server first, then establish a secure connection with the client, using a mimicked server certificate. Does not support peeking, which causes various problems.<<BR>>When used for intercepted traffic SNI is not available and the server raw-IP will be used in certificates. ||
||'''none'''||step1||Same as "splice" but does not support peeking and should not be used in configurations that use those steps.||

All actions except peek and stare correspond to ''final'' decisions: Once an SquidConf:ssl_bump directive with a final action matches, no further SquidConf:ssl_bump evaluations will take place, regardless of the current processing step.


== Processing steps ==

Bumping Squid goes through several TCP and SSL "handshaking" steps. Peeking steps give Squid more information about the client or server but often limit the actions that Squid may perform in the future.

||'''step1'''||Get TCP-level and CONNECT info. Evaluate ssl_bump and perform the first matching action (splice, bump, peek, stare, or terminate). This is the only step that is always performed.||
||'''step2'''||Get SSL Client Hello info. Evaluate ssl_bump and perform the first matching action (splice, bump, peek, stare, or terminate). Peeking usually prevents future bumping. Staring usually prevents future splicing.||
||'''step3'''||Get SSL Server Hello info. Evaluate ssl_bump and perform the first matching action (splice, bump, or terminate). In most cases, the only remaining choice at this step is whether to terminate the connection. The splicing or bumping decision is usually dictated by either peeking or staring at the previous step.||


Squid configuration has to balance the desire to gain more information (by delaying the final action) with the requirement to perform a certain final action (which sometimes cannot be delayed any further).


== New ACLs? ==

'''!ServerName''': We may have to add a new dstdomain-like ACL to match the server name obtained by various means during !SslBmp steps: From CONNECT request URI, to client SNI, to SSL server certificate CN. Without such a universal ACL, it may be difficult to write rules such as serverIsBank and haveServerName in the examples below because each !SslBump step has access to an increasing number of names but has to evaluate the same set of ssl_bump ACLs. We will not add a yet another ACL if real-world use cases can be solved using existing ACLs. However, this approach is likely to hit Squid bug BUG:4034.

'''!AtStep''': Squid works hard to simplify configuration by considering '''all''' SquidConf:ssl_bump rules during each bumping step. In some special cases, the admin may want to restrict certain rules to specific steps. This would be possible by adding !AtStep ACL that would match "!SslBump1", "!SslBump2", and "!SslBump3" or similar constants.

'''!PeekingAllowsBumping''' and '''!StaringAllowsSplicing''': During step2, peeking usually precludes future bumping and staring usually precludes splicing. In the future, Squid may support ACLs that can tell whether the current transaction matches those "usual" conditions. For now, our focus is on least-invasive peeking (and not bumping) cases.


== Examples ==

=== Avoid bumping banking traffic  ===

All of the examples in this section:
 * splice bank traffic,
 * bump non-bank traffic, and
 * peek as deep as possible while satisfying other objectives stated in the comments below.

These examples differ only in how they treat traffic that cannot be classified as either "bank" or "not bank" because Squid cannot infer a server name while satisfying other objectives stated in the comments below. The examples assume that the serverIsBank ACL mismatches when Squid does not yet know a server name.

{{{
# Do no harm:
# Splice indeterminate traffic.
ssl_bump splice serverIsBank
ssl_bump bump haveServerName
ssl_bump peek all
ssl_bump splice all
}}}

{{{
# Trust, but verify:
# Bump if in doubt.
ssl_bump splice serverIsBank
ssl_bump bump haveServerName
ssl_bump peek all
ssl_bump bump all
}}}

{{{
# Better safe than sorry:
# Terminate all strange connections.
ssl_bump splice serverIsBank
ssl_bump bump haveServerName
ssl_bump peek all
ssl_bump terminate all
}}}



= Current status =

 ''' This section is out of date'''

The branch code is not usable "as is", but does contain a lot of critical knowledge that took us several months to discover. We have uncovered many SSL and OpenSSL limitations in the project area and were able to work around some of them. We now understand how things can work and have mostly working code for various stages of Peek and Splice.

The missing pieces are:

 * Configuration: Very complex and difficult to get right because there are many stages of Peek and Splice, the decisions at the current stage affects future stages, and the intended future stages affect the decisions at previous stages! Attacking this problem directly produces a long list of squid.conf directives with complex interactions that are next to impossible to configure correctly. We have an alternative configuration design plan that we are almost happy about, but virtually no proper configuration code yet.
 * Connecting existing code snippets for various Peek and Splice stages to the configuration and to each other.
 * Getting the code ready for production use. We need to remove a lot of shortcuts and simplifications in the existing code.
 * More testing, documentation, and submission for the official review.

== Mimicked SSL client Hello properties ==

This section documents SSL client Hello message fields generated by Squid. Please note that for splicing to work, the client Hello message must be sent "as is", without any modifications at all. On the other hand, sending the client Hello message "as is" precludes Squid from eventually bumping the connection in most real-world use cases. Thus, the decision whether to mimic the client Hello or send it "as is" is critical to Squid's ability to splice or bump the connection after the Hello message has been sent.

||'''SSL client Hello field'''||'''Forwarded?'''||'''Comments'''||
||SSL Version||yes||SSL v3 and above (i.e. TLS) only.||
||Ciphers list||yes|| ||
||Server name||yes|| ||
||Ciphers list||yes|| ||
||Random bytes||yes|| ||
||Compression||partially||Compression request flag is mimicked. If compression is requested by the client, then the compression algorithm in the mimicked message is set by Squid OpenSSL (instead of being copied from the client message). This may be OK because the only widely used algorithm is deflate. It is possible that OpenSSL does not support other compression algorithms.||
||TLS extensions||sometimes||We will probably need to mimic at least some of these for splicing TLS connections to work.||
||other||sometimes||There are probably other fields. We should probably mimic some of them. However, blindly forwarding everything is probably a bad idea because it is likely to lead to SSL negotiation failures during bumping.||

= Limitations =

== Peeking at the server often precludes bumping ==

To peek at the server certificate, Squid must forward the entire client Hello intact. If that client Hello or the server response contains any SSL/TLS extensions that Squid does not support or understand (many do!), then Squid cannot reliably bump the connection because the other two sides of that bumped communication may start using those extensions, confusing Squid's OpenSSL in unpredictable ways. Possible solutions or workarounds (all deficient in various ways):

 a. If bumping is more valuable/important than splicing in your environment, you should "stare" instead of peeking. Staring usually precludes future splicing, of course. Pick your poison.

 a. We could add an ACL that will tell you whether those extensions and other complications are present in Client Hello. This is doable, but if that ACL usually evaluates to "yes", do we really want to do all this extra development and then complicate Squid configurations?

 a. We could teach Squid to understand more SSL extensions. This may require significant low-level work (because we would have to do what OpenSSL cannot do for us). This approach may eventually cover many popular cases, but will never cover everything and will require ongoing additions, of course.

 a. Squid could ignore the client and/or server extensions and try to bump anyway. The exact results cannot be predicted, but will often be a total transaction failure, possibly with user-visible browser warnings.

 a. We could teach Squid to abandon the current server connection and then bump a newly open one. This is something we do not want to do as it is likely to create an even worse operational problems with Squids being auto-blocked for opening and closing connections in vein.


== SSL session resumption ==

During SSL session resumption, there is no server certificate for Squid to examine. The initial implementation does not try to find the implied server certificate by caching session information, but even with such a cache (indexed by the session ticket), there is no guarantee that the certificate will be found in the Squid cache. Moreover, session caching itself may require bumping to learn the session ticket (SSL [[https://tools.ietf.org/html/rfc5077#section-3.3|NewSessionTicket]] message comes after the initial handshake)! The admin has to decide whether sessions missing server certificates are going to be spliced with little or no information available about the server.


More limitations are TBD.

----
CategoryFeature
