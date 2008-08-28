##master-page:FeatureTemplate
#format wiki
#language en

= Feature: Connection Pinning =

 * '''Goal''': Why do we need it? Client/Sponsor Requested.

 * '''Status''': No started

 * '''ETA''': unknown

 * '''Version''': Squid 3

 * '''Developer''':

 * '''More''': draft-jaganathan-kerberos-http-01.txt and Squid 2 implementation;
## TODO: add real links
 * '''More''': also http://www.squid-cache.org/bugs/show_bug.cgi?id=1632

Connection Pinning is especially useful for proxied connections to servers using Microsoft Integrated Login (NTLM/Negotiate), it needs:

 * code to tie a client-side and a server-side socket exclusively when needed
 * code to activate the tying when a stateful authentication layer is seen
 * code to mark the objects downloaded over a pinned connection uncacheable
 * code to add a header advertising this capability to clients

The HTTP protocol extensions used to negotiate this is documented in Internet Draft draft-jaganathan-kerberos-http-01.txt (a copy can be found in doc/rfc/ in the development tree)

This feature has been implemented for [[Squid-2.6]] by HenrikNordström during the CodeSprintOct2005 code sprint in Torino.

Connection Pinning needs to be re-implemented in Squid 3.

----
CategoryFeature | CategoryWish
