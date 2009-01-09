##master-page:FeatureTemplate
#format wiki
#language en
#faqlisted yes
#completed yes

= Feature: Connection Pinning =

 * '''Goal''': Support connection handling required for NTLM authentication passthrough

 * '''Status''': complete

 * '''Version''': 2.6, 3.1

 * '''Developer''': HenrikNordstrom (2.6), Christos Tsantilas (3.1)

 * '''More''': draft-jaganathan-kerberos-http-01.txt and Squid 2 implementation;
 * '''More''': also http://www.squid-cache.org/bugs/show_bug.cgi?id=1632

== Details ==
Connection Pinning is especially useful for proxied connections to servers using Microsoft Integrated Login (NTLM/Negotiate), it needs:

 * code to tie a client-side and a server-side socket exclusively when needed
 * code to activate the tying when a stateful authentication layer is seen
 * code to mark the objects downloaded over a pinned connection uncacheable
 * code to add a header advertising this capability to clients

The HTTP protocol extensions used to negotiate this is documented in Internet Draft draft-jaganathan-kerberos-http-01.txt (a copy can be found in doc/rfc/ in the development tree)

This feature has been implemented for [[Squid-2.6]] by HenrikNordström during the CodeSprintOct2005 code sprint in Torino.

Connection Pinning has been re-implemented in Squid 3.1

== Configuration Options ==
''details relevant to Squid-3.1''

This feature is enabled by default in Squid-3.1 and makes use of the '''connection-auth''' option.

The option can be applied on '''http_port''', '''https_port''', and '''cache_peer''' lines. It controls connections either IN or OUT of those access points. If either is disabled connection auth cannot be performed.

When used on a receiving port it can be set to ON or OFF. 
Default is ON.
{{{
http_port ... connection-auth[=on|off]
https_port ... connection-auth[=on|off]
}}}


When used on a cache_peer link it can be set to ON, OFF, or AUTO. 
Default is AUTO which attempts to detect the peer capability when needed.
{{{
cache_peer ... connection-auth[=on|off|auto]
}}}

----
CategoryFeature
