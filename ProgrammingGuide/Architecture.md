# Squid Architecture

## Broad Overview

Squid is operating at layers 4-7 on the [OSI data
model](http://wikipedia.org/wiki/OSI_model). So unlike most networking
applications there is no relationship between packets (a layer 3
concept) and the traffic received by Squid. Instead of packets HTTP
operates on a **message** basis (called segments in the OSI model
definitions), where an HTTP request and response can each be loosely
considered equivelent to one "packet" in a transport architecture. Just
like IP packets HTTP messages are stateless and the delivery is entirely
optional for process. See the RFC
[7230](https://tools.ietf.org/rfc/rfc7230#) texts for a better
description on HTTP specifics and how it operates.

At the broad level Squid consists of four generic processing areas;

  - a client-side which implements HTTP, HTTPS, FTP, ICP and HTCP
    protocols to communicate with clients, and

  - a server-side which implements HTTP, HTTPS, FTP, Gopher and WAIS to
    communicate with web servers, and

  - between them is the cache storage. Which in broad terms provides the
    buffering mechanisms for data transit, and provides switching logic
    to determine data source between disk, memory, and server-side.

  - there is also a set of components performing extra support tasks;
    security (authentication and access control), DNS client, IDENT
    client, and WHOIS client.
    
      - ![BroadOverview.png](https://wiki.squid-cache.org/ProgrammingGuide/Architecture?action=AttachFile&do=get&target=BroadOverview.png)

## General Overview

  - ![{i}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-info.png)
    The general design level is where Squid-2 and Squid-3 differ. With
    Squid-2 being composed purely of event callback chains, Squid-3 adds
    the model of task encapsulation within Jobs.

## Transaction Processing

A **master transaction** (class MasterXaction) manages information
shared among the HTTP or FTP request and all related protocol messages
(such as the corresponding HTTP/FTP/Gopher/etc. protocol response and
control messages) as well as ICAP, eCAP, and helper transactions caused
by protocol messages. Much of the code necessary to collect and share
this information has yet to be developed.

A **stream transaction** is an HTTP or FTP request with the
corresponding final protocol reply. It begins around the time (XXX:
define precisely) when the protocol request arrives on the connection.
The details from its MasterXaction are copied into a AccessLogEntry
which accumulate the details about the stream and eventually winds up in
access.log.

An **ICAP transaction** (class Adaptation::Icap::Xaction) is an ICAP
request with the corresponding final ICAP response. Many ICAP
transactions may occur for a single Master Transaction and, IIRC, ICAP
OPTIONS revalidation transactions occur without a Master Transaction.

A **helper transaction** (class Helper::Xaction) may occur for each
plugin helper which squid.conf settings may cause to be used by the
stream transaction.

### HTTP Request

The following sequence of checks and adjustments is applied to most HTTP
requests. This sequence starts after Squid parses the request header and
ends before Squid starts satisfying the request from the cache or origin
server. The checks are listed here in the order of their execution:

1.  Host header forgery checks

2.  [http\_access](http://www.squid-cache.org/Doc/config/http_access#)
    directive

3.  ICAP/eCAP
    [adaptation](https://wiki.squid-cache.org/ProgrammingGuide/Architecture/SquidFaq/ContentAdaptation#)

4.  [redirector](http://www.squid-cache.org/Doc/config/url_rewrite_program#)

5.  [adapted\_http\_access](http://www.squid-cache.org/Doc/config/adapted_http_access#)
    directive

6.  [store\_id](http://www.squid-cache.org/Doc/config/store_id#)
    directive

7.  clientInterpretRequestHeaders()

8.  [cache](http://www.squid-cache.org/Doc/config/cache#) directive

9.  ToS marking

10. nf marking

11. [ssl\_bump](http://www.squid-cache.org/Doc/config/ssl_bump#)
    directive

12. callout sequence error handling

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
[SslBump](https://wiki.squid-cache.org/ProgrammingGuide/Architecture/Features/HTTPS#Bumping_direct_SSL.2FTLS_connections)
is in use, Squid may create several fake CONNECT transactions for a
given TLS connection, and each CONNECT may go through the above motions.
If you use SslBump for intercepted port 443 traffic, then shortly after
a new connection is accepted by Squid, SslBump creates a fake CONNECT
request with TCP level information, and that CONNECT request goes
through the above sequence (matching step SslBump1 ACL if any). If an
"ssl\_bump peek" or "ssl\_bump stare" rule matches during that first
SslBump step, then SslBump code gets SNI and creates a second fake
CONNECT request that goes through the same sequence again.

Your Squid directives and helpers must be prepared to deal with multiple
\[CONNECT\] requests per connection.

Discuss this page using the "Discussion" link in the main menu
