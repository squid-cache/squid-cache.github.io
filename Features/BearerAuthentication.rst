##master-page:CategoryTemplate
#format wiki
#language en
#faqlisted yes

= Feature: Bearer Authentication =

 * '''Goal''': Make Squid support Bearer authentication protocol.

 * '''Status''': underway

 * '''Version''': 3.4+

 * '''Developer''': AmosJeffries

 * '''More Info''': RFC RFC:6750

<<TableOfContents>>

= Details =

'''Bearer''' is an HTTP authentication scheme created as part of OAuth 2.0 in RFC RFC:6750. A client wanting to access to a service is required to locate a control server trusted by that service, authenticate itself against the control server and retrieve an opaque token. The opaque token is delivered using HTTP authentication headers to the HTTP service which grants or denies access.

Bearer tokens are more secure than Basic authentication tokens since they are opaque blobs at the HTTP layer and do not necessarily contain user credentials in any form, but are less secure than Negotiate tokens as they are generated from criteria independent of the particular TCP channel used to relay HTTP traffic and may be re-played to gain access to the HTTP service.

Their security relative to Digest nonces depends entirely on how the server is generating the tokens and how they are validated. The token is opaque to all but the OAuth control server issuing it and the validator verifying it. However, the token itself may be intercepted and re-used by a third-party to gain access to the service for a short time. When the token is generated as a random blob or as a container for encrypted user identity they are equivalent to Digest nonce.

 . {i} '''Due to the weak security offered by OAuth it is advised to only use Bearer authentication over HTTPS connections'''

See [[Features/Authentication]] for details on other schemes supported by Squid and how authentication in general works.

== How does it work in Squid? ==

Bearer is at the one time both very simple and somewhat complex. Squids part has been kept intentionally minor and simple to improve the overall system security.

 . /!\ squid only implements the '''Autorization header field''' Bearer tokens. Alternative ''Form field'' method is not compatible with HTTP proxy needs and method ''URI query parameter'' is too insecure to be trustworthy.

The authentication helper is left to perform all of the risky security encryption and validation processes. Any credentials or tokens presented by the client are passed untouched to the helper.

The protocol lines used to do this are described below.

<<Include(Features/AddonHelpers,,3,from="^## start bearerauth protocol$", to="^## end bearerauth protocol$")>>


== What do I need to do to support Bearer on Squid? ==

Just like any other security protocol, support for Bearer in Squid is made up by two parts:
 1. code within Squid to talk to the client.
  * [[Squid-3.4]] or later built with {{{--enable-auth-bearer}}}

 2. one or more authentication helpers which perform the grunt work.
  * As yet there are no helpers freely available.

Of course the protocol needs to be enabled in the configuration file for everything to work.
{{{
auth_param bearer program /usr/sbin/your-helper
}}}
 {i} All other bearer parameters are optional. see SquidConf:auth_param BEARER section for more details.

== Testing ==

=== Testing Squid ===

Send any URL with a GET or any other request via Squid.
{{{
squidclient http://example.com/
}}}

Squid when setup correctly replies with ''Proxy-Authenticate: Bearer'' like shown:
{{{
HTTP/1.1 407 Proxy Authentication Required
Server: squid/3.2.0.14
Mime-Version: 1.0
Date: Thu, 12 Jan 2012 03:41:33 GMT
Proxy-Authenticate: Bearer realm="Squid"
...
}}}

== Troubleshooting ==


----
CategoryFeature
