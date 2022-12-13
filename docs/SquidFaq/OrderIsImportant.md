---
FaqSection: troubleshooting
---
# Squid configuration: Order Is Important!

  - Order is important
  - Order is critical

This is by far the No. 1 most repeated comment in the Squid user help
lists. Squid with its traditional "Bungled config line" is not exactly
helpful either when it comes to notifying what the problem is.

## Why?

Squid process its config file from the top down. Left to right. Creating
internal configuration information as it goes.

To create a metaphor there is a simple everyday procedure one performs
to enter a locked door. Unlock, open, and walk through. Get them out of
order. For example "unlock, walk, open" is possibly valid. But will
result in some pain when actually done that way and will not result in
the opener being on the far side of the doorway.

Similarly there are groups of actions which are individually configured
in squid.conf. But the order determines what the final situation is.

## Modes

Modern Squid run multiple *modes* of operation simultaneously.

The order of
[http_access](http://www.squid-cache.org/Doc/config/http_access)
forward-proxy and reverse-proxy configuration options determines whether
a reverse-proxy website visitor is able to reach the website. They also
determine whether that website is able to perform HTTPS, AJAX, JSON, or
other advanced website operations beyond plain simple HTTP. see the
relevant
[SquidFaq/ReverseProxy\#How_do_I_set_it_up](/SquidFaq/ReverseProxy#How_do_I_set_it_up)
example for specific order details. Generally the reverse-proxy needs to
be first.

The order and placement of
[debug_options](http://www.squid-cache.org/Doc/config/debug_options)
directives determines what debug levels are run during processing of the
configuration file and later during normal running of Squid.

## Authentication

The order of
[auth_param](http://www.squid-cache.org/Doc/config/auth_param)
**program** directives determines how Squid reports the authentication
options to Browsers. This has visible effects on what type of
authentication is performed. see
[Features/Authentication](/Features/Authentication)
for details and recommended ordering.

[acl](http://www.squid-cache.org/Doc/config/acl) **proxy_auth** and
[external_acl_type](http://www.squid-cache.org/Doc/config/external_acl_type)
using **%LOGIN** must be defined after
[auth_param](http://www.squid-cache.org/Doc/config/auth_param). Squid
will warn about authentication being used but not setup here.

[external_acl_type](http://www.squid-cache.org/Doc/config/external_acl_type)
using **%LOGIN** will trigger authentication challenges if those
credentials are not present. The placement of these tests affects which
rules around them require authentication.

Similarly [acl](http://www.squid-cache.org/Doc/config/acl) testing
authentication placement left-to-right on their line determins whether
the test bypasses, fails or triggers an auth challenges.

## Access Controls

[acl](http://www.squid-cache.org/Doc/config/acl) definition lines must
be specified before any point at which they are mentioned for use.

The order of individual access controls affects other lines of the same
type. For example each
[http_access](http://www.squid-cache.org/Doc/config/http_access) is
run in order and affect each other, but not any
[cache_peer_access](http://www.squid-cache.org/Doc/config/cache_peer_access)
in between.

This goes for each type of access directive. see
[SquidFaq/SquidAcl\#Access_Lists](/SquidFaq/SquidAcl#Access_Lists)
for a list of access types.

The order of individual words on each access control line is even more
critical. This can mean the difference between having an access control
line match or skip. Or whether Squid can process 300 or 3 thousand
requests per second. see
[SquidFaq/SquidAcl\#Common_Mistakes](/SquidFaq/SquidAcl#Common_Mistakes)
for details on how ordering of individual line words works.

## Major Transaction Milestones

A typical HTTP transaction goes through a sequence of checks and may be
shared with external helpers/services. Since these checks and services
may modify the transaction and/or its metadata, it is often critical to
know the order of their execution. For example, does the request target
URI get rewritten before or after the store ID helper runs? There is
currently no comprehensive documentation covering every major
transaction milestone, but this section may answer many related FAQs.

### Callout Sequence

The following sequence of checks and adjustments is applied to most HTTP
requests. This sequence starts after Squid parses the request header and
ends before Squid starts satisfying the request from the cache or origin
server. The checks are listed here in the order of their execution:

1. Host header forgery checks
1. [http_access](http://www.squid-cache.org/Doc/config/http_access)
    directive
1. ICAP/eCAP
    [adaptation](/SquidFaq/ContentAdaptation)
1. [redirector](http://www.squid-cache.org/Doc/config/url_rewrite_program)
1. [adapted_http_access](http://www.squid-cache.org/Doc/config/adapted_http_access)
    directive
1. [store_id](http://www.squid-cache.org/Doc/config/store_id)
    directive
1. clientInterpretRequestHeaders()
1. [cache](http://www.squid-cache.org/Doc/config/cache) directive
1. ToS marking
10. NetFilter (nf) marking
1. [ssl_bump](http://www.squid-cache.org/Doc/config/ssl_bump)
    directive
1. callout sequence error handling

A failed check may prevent subsequent checks from running.

A typical HTTP transaction (i.e., a pair of HTTP request and response
messages) goes through the above sequence once. However, multiple
transactions may participate in processing of a single "web page
download", confusing Squid admins. While all experienced Squid admins
know that a single web page may contain dozens and sometimes hundreds of
resources, each triggering an HTTP transaction, those multiple
transactions may happen even when requesting a single resource and even
when using simple command-line tools like curl or wget.

Internal Squid requests may cause even more confusion. For example, when
[SslBump](/Features/HTTPS#Bumping_direct_SSL.2FTLS_connections)
is in use, Squid may create several fake CONNECT transactions for a
given TLS connection, and each CONNECT may go through the above motions.
If you use SslBump for intercepted port 443 traffic, then shortly after
a new connection is accepted by Squid, SslBump creates a fake CONNECT
request with TCP level information, and that CONNECT request goes
through the above sequence (matching step SslBump1 ACL if any). If an
"ssl_bump peek" or "ssl_bump stare" rule matches during that first
SslBump step, then SslBump code gets SNI and creates a second fake
CONNECT request that goes through the same sequence again.

Similarly (S)FTP native services have each message in a Stream
Transaction translated into various HTTP messages which should go
through the above above motions.

Your Squid directives and helpers must be prepared to deal with multiple
*CONNECT* requests per connection.

## Others

Some others have a simpler interaction, but ordering is still important.

- refresh_pattern - top down first pattern match wins.
- delay_pools + delay_class + delay_parameters - must be added in
  that order: pools, class, parameters.
- cache_peer - order of individual cache_peer entries affects
  selection of default and first-available peer.
