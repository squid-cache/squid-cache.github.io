##master-page:Features/FeatureTemplate
#format wiki
#language en
##
## Change to 'yes' for a listing under Features in the Squid FAQ.
#faqlisted no

= Feature: SslBump Peek and Splice =

 * '''Goal''': Make bumping decisions after the origin server name is known, especially when transparently intercepting TLS/SSL.  Avoid bumping non-TLS traffic.
 * '''Status''': completed.
 * '''Version''': 3.5
 * '''Developer''': AlexRousskov and Christos Tsantilas
## * '''More''': unofficial development [[https://code.launchpad.net/~measurement-factory/squid/peek-and-splice|branch]].

 <<TableOfContents>>

= Motivation =

"Peek and Splice" is a collection of new [[Features/SslBump|SslBump]] actions and related features introduced in [[Squid-3.5]].  Older Squids used server-first and client-first actions that did not work well many cases. Many !SslBump deployments try to minimize potential damage by ''not'' bumping sites unless the local policy demands it. Before the new actions became available, the decision to bump was made based on very limited information:

 * A typical HTTP CONNECT request does not contain many details, and

 * intercepted TCP connections reveal nothing but IP addresses and port numbers.

Peek and Splice gives admin a way to make bumping decisions later in the TLS handshake process, when client SNI and the server certificate are available. Or when it becomes clear that we are not dealing with a TLS connection at all!


= Terminology =

In most cases, this page uses ''TLS'' to mean ''TLS or SSL''.


= Overview =

The Peek and Splice feature looks at the TLS Client Hello message and SNI info (if any), sends an identical or similar (to the extent possible) Client Hello message to the server, and then looks at the TLS Server Hello message.

The final decision to splice, bump, or terminate the connection can be made at any of those steps (but what Squid does at step N affects its ability to splice or bump at step N+1!).

Please see the [[#Actions|actions table]] below for definitions of the two "looking at" actions (i.e., peek and stare) as well as various final actions (e.g., "bump", "splice", "terminate", etc.).

== Processing steps ==

Bumping Squid goes through several TCP and TLS "handshaking" steps. Peeking steps give Squid more information about the client or server but often limit the actions that Squid may perform in the future. The image shows a simplified data flow and related events between a TLS client and a TLS server.  Note that with a bumping proxy between the client and the server ''__the flow is duplicated__'' where the first flow is between client and proxy and the second flow between proxy and server. 

{{attachment:TLS-handshake-02.png|TLS handshake between client and server}}


'''Step 1:'''
 i. Get TCP-level info from the client.
  * In forward proxy environments, also parse the CONNECT request.
  * In interception environments, create a fake CONNECT request using TCP-level info.
 i. Go through the [[SquidFaq/OrderIsImportant#Callout_Sequence|Callout Sequence]] with the CONNECT request mentioned above.
 i. Evaluate all SquidConf:ssl_bump rules and perform the first matching action (splice, bump, peek, stare, or terminate).

Step 1 is the only step that is always performed.

The CONNECT request is logged in access.log.

Note that for intercepted HTTPS traffic there is no "domain name" available at this point. The log entry will contain only the destination IP address and port. The same is true for some real CONNECT requests in a forward proxy environments.


'''Step 2:'''
 i. Get TLS Client Hello info from the client, including SNI where available. Adjust the CONNECT request from step1 to reflect SNI.
 i. Go through the [[SquidFaq/OrderIsImportant#Callout_Sequence|Callout Sequence]] with the adjusted CONNECT request mentioned above.
 i. Evaluate again all SquidConf:ssl_bump rules and perform the first matching action (splice, bump, peek, stare, or terminate).
  * Peeking at this step usually makes bumping at step 3 impossible.
  * Staring at this step usually makes splicing at step 3 impossible.

Step 2 is only performed if a peek or stare rule matched during the previous step.

The adjusted CONNECT request is logged in access.log during this step if this step is final (i.e., there is no step 3). However, when splicing, the adjusted CONNECT becomes attached to the resulting tunnel and is not logged until that tunnel is closed.


'''Step 3:'''
 i. Get TLS Server Hello info from the server, including the server certificate.
 i. Validate the TLS server certificate.
 i. Evaluate again all SquidConf:ssl_bump rules and perform the first matching action (splice, bump, or terminate) for the connection.

Step 3 is only performed if a peek or stare rule matched during the previous step.

The adjusted CONNECT request from the previous step is always logged in access.log during this step (if Squid gets to this step, of course). However, when splicing, the adjusted CONNECT becomes attached to the resulting tunnel and is not logged until that tunnel is closed.

In most cases, the only meaningful choice at step 3 is whether to terminate the connection. The splicing or bumping decision is usually dictated by either peeking or staring at the previous step.

Squid configuration has to balance the desire to gain more information (by delaying the final action) with the requirement to perform a certain final action (which sometimes cannot be delayed any further).


== Actions ==

Several actions are possible when a proxy handles a TLS connection. See the SquidConf:ssl_bump directive in your squid.conf.documented for a list of actions your version of Squid supports. Some actions are only possible during certain processing steps (see above). During a given processing step, Squid (3.5.8 and later) ''ignores'' SquidConf:ssl_bump lines with impossible actions. This helps us keep configuration sane. Processing steps are discussed further below.


||'''Action'''||'''Applicable processing steps'''||'''Description'''||
||'''peek'''||step1, step2||When a peek rule matches during step1, Squid proceeds to step2 where it parses the TLS Client Hello and extracts SNI (if any). When a peek rule matches during step 2, Squid proceeds to step3 where it parses the TLS Server Hello and extracts server certificate while preserving the possibility of splicing the client and server connections; peeking at the server certificate usually precludes future bumping (see Limitations).||
||'''splice'''||step1, step2, and sometimes step3||Become a TCP tunnel without decoding the connection. The client and the server exchange data as if there is no proxy in between.||
||'''stare'''||step1, step2||When a stare rule matches during step1, Squid proceeds to step2 where it parses the TLS Client Hello and extracts SNI (if any). When a stare rule matches during step2, Squid proceeds to step3 where it parses the TLS Server Hello and extracts server certificate while preserving the possibility of bumping the client and server connections; staring at the server certificate usually precludes future splicing (see Limitations).||
||'''bump'''||step1, step2, and sometimes step3||Establish a TLS connection with the server (using client SNI, if any) and establish a TLS connection with the client (using a mimicked server certificate).  '''However''', this is not what actually happens right now if a bump rule matches during step1. See bug Bug:4327 ||
||'''terminate'''||step1, step2, step3||Close client and server connections.||

Actions splice, bump, and terminate are final actions: They prevent further processing of the SquidConf:ssl_bump rules. Actions peek and stare allow Squid to proceed to the next !SslBump step.

||||||<#FFD0D0>pre-3.5 actions are listed below for completeness sake only; ''do not use these with [[Squid-3.5]] and newer''||
||'''client-first'''||step1||Ancient [[Squid-3.1]] style bumping: Establish a secure connection with the client first, then connect to the server. Cannot mimic server certificate well, which causes a lot of problems.||
||'''server-first'''||step1||Old [[Squid-3.3]] style bumping: Establish a secure connection with the server first, then establish a secure connection with the client, using a mimicked server certificate. Does not support peeking, which causes various problems.<<BR>>When used for intercepted traffic SNI is not available and the server raw-IP will be used in certificates. ||
||'''none'''||step1||Same as "splice" but does not support peeking and should not be used in configurations that use those steps.||

== See Also ==

If [[Squid-4]] or later fails to parse an expected TLS Client Hello message, Squid consults SquidConf:on_unsupported_protocol directive.


## == New ACLs? ==

##'''!PeekingAllowsBumping''' and '''!StaringAllowsSplicing''': During step2, peeking usually precludes future bumping and staring usually precludes splicing. In the future, Squid may support ACLs that can tell whether the current transaction matches those "usual" conditions. For now, our focus is on least-invasive peeking (and not bumping) cases.


== Configuration Examples ==

'''IMPORTANT :'''

 . /!\ If you use '''dstdomain''' ACL before the HTTP connection is bumped, please note that it will attempt to match the (fake or real) CONNECT request URI. Depending on your listening ports configuration, browser behavior, the current !SslBump step, and other factors, that URI may be just an IP address, and the reverse lookup of that IP address may not be the origin server domain name(s) in the encrypted requests. The '''ssl::server_name''' SquidConf:acl type may use (fake or real) CONNECT request URI, TLS client SNI, and server certificate subject information. It also has knobs to control which bits of information are used. However, it does not perform DNS lookups. Read SquidConf:acl documentation for your Squid version and choose carefully.

 . {i} Selecting an action only to happen at a particular step can be done using an '''at_step''' type SquidConf:acl.


Some how-to tutorials are available for common policies:

<<FullSearch(title:regex:^ConfigExamples/Intercept/SslBump -title:regex:Discussion$)>>

{{{
# common acls for the following examples:
acl serverIsBank ssl::server_name .bank1.example.com
acl serverIsBank ssl::server_name .bank2.example.net
# extend serverIsBank for all banks that are used by all users

acl monitoredSites ssl::server_name .foo.example.com
acl monitoredSites ssl::server_name .bar.example.org
}}}

=== Basic Splicing and Bumping ===

Only observe TCP/TLS metadata. Do not look at HTTP information. Modify nothing. Useful for logging purposes since the SNI and server certificates are peeked at and can be logged.

/!\ Depending on other settings, Squid may terminate connections if it cannot validate client SNI (Host header forgery detection) or the server certificate.

{{{
ssl_bump peek all
ssl_bump splice all
}}}

Only bump a set of sites.

/!\ Usually does not work for requests without SNI that go to monitoredSites -- they will not be bumped.

{{{
ssl_bump bump monitoredSites
ssl_bump peek all
ssl_bump splice all
}}}

Bump All Sites Except Banks

/!\ Usually does not work for requests that go to non-banks -- they will not be bumped.

/!\ Depending on other settings, Squid may terminate connections to banks if Squid cannot validate client SNI (Host header forgery detection) or the server certificate. 

{{{
ssl_bump splice serverIsBank
ssl_bump peek all
ssl_bump bump all
}}}


=== Peek at SNI and Bump ===

SNI is obtained by parsing TLS Client Hello during step #2 (which is instructed by ''ssl_bump peek step1''). Parsing TLS Client Hello does ''not'' preclude future bumping. If you want to get SNI and bump, then peek at step #1 and bump at the next step (i.e., step #2):

{{{
acl step1 at_step SslBump1
ssl_bump peek step1
ssl_bump bump monitoredSites !serverIsBank
ssl_bump splice all
}}}

Please note that making decisions based on steps #1 and #2 info alone gives you no knowledge about the TLS server point of view. All your decisions will be based on what the TLS ''client'' has told you. This is often not a problem because, in most cases, if the client lies (e.g., sends "bank.example.com" SNI to a "non-bank.example.com" server), the TLS server will refuse to establish the [bumped or spliced at step #2] connection with Squid. However, not all servers will do that and it is trivial to setup a malicious forwarding TLS server that will not. Also, if the client supplied no SNI information at all (e.g., you are dealing with IE on Windows XP), then your ACLs may not have enough information to go on during those first two steps, especially for intercepted connections.

If you also peek at step #2, you will know the server certificate, but you will no longer be able to bump the connection in most cases (see Limitations below).


=== Peek at SNI and Splice ===

The following configuration obtains SNI by parsing TLS Client Hello (due to a matching peek rule at step1) and then either splices bank connections OR stares at the TLS Server Hello (due to a matching stare rule) and bumps non-bank connections (due to the default bump-after-stare rule).


{{{
ssl_bump peek step1
ssl_bump splice serverIsBank
ssl_bump stare all
}}}

In the above configuration, the decision to splice (if any) is made during step #2 (and only during that step). The decision to bump (if any) is made during step #3 (and only during that step), using the default rule driven by the matching stare rule at step2. That late bumping decision allows Squid to mimic server certificate properties when bumping. The cost (i.e. cons) of that late bumping is the necessity to make the splicing decision based exclusively on client-supplied information.

This configuration was [[http://lists.squid-cache.org/pipermail/squid-users/2018-September/019150.html|discussed]] at length on the Squid users mailing list.

= Mimicking TLS Client Hello properties when staring =

This section documents TLS Client Hello message fields generated by the ssl_bump stare action. The information in this section is incomplete and somewhat stale.

||'''TLS Client Hello field'''||'''Forwarded?'''||'''Comments'''||
||TLS/SSL Version||yes||only SSL v3 and TLS versions.||
||Ciphers list||yes|| ||
||SNI extension||yes||SNI stands for Server Name Indication. It is the hostname of the origin server being contacted, '''not''' a URL domain name.||
||Random bytes||yes|| ||
||Compression||partially||Compression request flag is mimicked. If compression is requested by the client, then the compression algorithm in the mimicked message is set by Squid OpenSSL (instead of being copied from the client message). This may be OK because the only widely used algorithm is deflate. It is possible that OpenSSL does not support other compression algorithms.||
||Other TLS extensions||sometimes||We will probably need to mimic at least some of these for splicing TLS connections to work.||
||other||sometimes||There are probably other fields. We should probably mimic some of them. However, blindly forwarding everything is probably a bad idea because it is likely to lead to TLS negotiation failures during bumping.||

Please note that for splicing to work at a future step, the Client Hello message must be sent "as is", without any modifications at all. On the other hand, sending the Client Hello message "as is" precludes Squid from eventually bumping the connection in most real-world use cases. Thus, the decision whether to mimic the Client Hello (as staring does) or send it "as is" (as peeking does) is critical to Squid's ability to splice or bump the connection after the Hello message has been sent.

= Limitations =

== Peeking at the server often precludes bumping ==

To peek at the server certificate, Squid must forward the entire Client Hello intact. If that Client Hello or the server response contains any TLS extensions that Squid does not support or understand (many do!), then Squid cannot reliably bump the connection because the other two sides of that bumped communication may start using those extensions, confusing Squid's OpenSSL in unpredictable ways. Possible solutions or workarounds (all deficient in various ways):

 a. If bumping is more valuable/important than splicing in your environment, you should "stare" instead of peeking. Staring usually precludes future splicing, of course. Pick your poison.

 a. We could add an ACL that will tell you whether those extensions and other complications are present in Client Hello. This is doable, but if that ACL usually evaluates to "yes", do we really want to do all this extra development and then complicate Squid configurations?

 a. We could teach Squid to understand more TLS extensions. This may require significant low-level work (because we would have to do what OpenSSL cannot do for us). This approach may eventually cover many popular cases, but will never cover everything and will require ongoing additions, of course.

 a. Squid could ignore the client and/or server extensions and try to bump anyway. The exact results cannot be predicted, but will often be a total transaction failure, possibly with user-visible browser warnings.

 a. We could teach Squid to abandon the current server connection and then bump a newly open one. This is something we do not want to do as it is likely to create an even worse operational problems with Squids being auto-blocked for opening and closing connections in vain.


== TLS session resumption ==

During TLS session resumption, there is no server certificate for Squid to examine. The initial implementation does not try to find the implied server certificate by caching session information, but even with such a cache (indexed by the session ticket), there is no guarantee that the certificate will be found in the Squid cache. Moreover, session caching itself may require bumping to learn the session ticket (TLS [[https://tools.ietf.org/html/rfc5077#section-3.3|NewSessionTicket]] message comes after the initial handshake)! The admin has to decide whether sessions missing server certificates are going to be spliced with little or no information available about the server.


More limitations are TBD.


= Logging =

== %ssl::bump_mode logformat code ==

Squid logs a single access.log record to reflect CONNECT request handling. If you add %ssl::bump_mode to your logformat definition, its value in that record would depend on Squid version:

 * Squid v3.5 logs the first ssl_bump decision (usually a step1 action);
 * Squid v4+ logs the final ssl_bump decision (usually the last used ssl_bump action).

If the tunnel is bumped, then each bumped HTTP request is also logged, of course. The %ssl::bump_mode value in those records is the final !SslBump decision. Naturally, that value is either "bump" or one of the deprecated bumping actions (i.e. "server-first" or "client-first"). This logging behavior of bumped requests is the same for all modern Squid versions.

Here are two version-specific tables that document expected %ssl::bump_mode value for CONNECT and bumped requests.

Squid v3.5 logs:

||||||'''ssl_bump configuration'''||||'''logged value'''||
||'''step1'''||'''step2'''||'''step3'''|| '''CONNECT''' || '''bumped requests''' ||
||splice  || -          || -          ||  splice    ||   -    ||
||bump || -           || -          ||  bump    ||  bump  ||
||peek || splice ||  -           || peek      || - ||
||peek || bump || -           || peek      || bump   ||
||peek || peek || splice  || peek      || - ||
||peek || stare || bump ||  peek       || bump ||
||stare || peek || splice  || stare      || - ||
||stare || stare || bump ||  stare       || bump ||
||server-first || -           || -          ||  server-first    ||  server-first  ||
||client-first || -           || -          ||  client-first   ||  client-first  ||

Squid v4+ logs:

||||||'''ssl_bump configuration'''||||'''logged value'''||
||'''step1'''||'''step2'''||'''step3'''|| '''CONNECT''' || '''bumped requests''' ||
||splice || -          || -          ||  splice    ||   -    ||
||bump || -           || -          ||  bump    ||  bump  ||
||peek || splice ||  -           || splice      || - ||
||peek || bump || -           || bump      || bump   ||
||peek || peek || splice  || splice     || - ||
||peek || stare || bump ||  bump      || bump ||
||stare || peek || splice  || splice     || - ||
||stare || stare || bump ||  bump       || bump ||
||server-first || -           || -          ||  server-first    ||  server-first  ||
||client-first || -           || -          ||  client-first   ||  client-first  ||


The difference between the two tables is in the CONNECT column: Rows with multiple !SslBump steps differ.

----
CategoryFeature
