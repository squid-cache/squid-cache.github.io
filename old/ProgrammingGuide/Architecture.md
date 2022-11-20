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
[7230](https://tools.ietf.org/rfc/rfc7230) texts for a better
description on HTTP specifics and how it operates.

At the broad level Squid consists of five generic processing areas;

  - client facing (was "client-side") which implements HTTP, HTTPS,
    PROXY, FTP, ICP, HTCP, and SNMP protocols to communicate with
    clients, and

  - server facing (was "server-side") which implements HTTP, HTTPS, ICY,
    FTP, Gopher, WAIS, URN-N2H, and blind TCP tunnels to communicate
    with web servers (with or without an upstream proxy/relay) , and

  - between them is the cache storage. Which in broad terms provides the
    buffering mechanisms for data transit, and provides switching logic
    to determine data source between disk, memory, and server-side.

  - on each side of storage after client facing logic, and before
    server-facing there are optional diversions to pass the traffic
    through content adaptation services (URI rewrite, redirection, ICAP,
    eCAP, or HTTP request/reply manglers).

  - there is also a set of components performing extra support tasks.
    Such as; security (authentication and access control), (m)DNS
    client, IDENT client, WHOIS client, logging, QoS, WCCP, NAT client,
    cache/peer integration. Some are obvious, some not - protocols
    implemented which are not documented as directly server or client
    facing usually fall into this group.
    
      - ![BroadOverview.png](https://wiki.squid-cache.org/ProgrammingGuide/Architecture?action=AttachFile&do=get&target=BroadOverview.png)

**![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
TODO:** image is outdated.

  - Client Side now includes SNMP, PROXY, FTP, (with many bugs) SFTP
    protocols and "other" protocols.

  - Storage removed COSS and added CLP caches

  - Extra Processing Logics includes URN, ICAP, eCAP

  - Server side missing URN N2H translator.

## General Overview

  - ℹ️
    The general design level is where Squid-2 and Squid-3 differ. With
    Squid-2 being composed purely of event callback chains, Squid-3 adds
    the model of task encapsulation within Jobs.

**![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
TODO:** images with overview of data flow.

**![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
TODO:** pull in existing descriptions of I/O event model,
[AsyncJob](/AsyncJob)
model from source code.

**![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
TODO:** data processing diagram with color-coded for display of
[AsyncJob](/AsyncJob)
vs Event callback coverage.

## Transaction Processing

A **connection** (class Comm::Connection) begins with class TcpAcceptor
accept() when the TCP socket is accepted, or for UDP when a packet is
received. TCP connections end when the class Comm::Connection::close()
method is called, which must be done explicitly. UDP connections close
when the class Comm::Connection objects last reference is dropped,
`NOTE` that UDP sockets are shared so Comm::Connection::close() must not
be used by UDP transactions, it may close all active UDP traffic.

The following apply to TCP based protocols only:

A **master transaction** (class MasterXaction) manages information
shared among the HTTP or FTP request and all related protocol messages
(such as the corresponding HTTP/FTP/Gopher/etc. protocol response and
control messages) as well as ICAP, eCAP, and helper transactions caused
by protocol messages. Much of the code necessary to collect and share
this information has yet to be developed.

A **stream transaction** is an HTTP or FTP request with the
corresponding final protocol reply. It begins with a class \!Parser
successful parse() call when the protocol request arrives on the
connection. The details from its MasterXaction are copied into a
AccessLogEntry which accumulate the details about the stream and
eventually winds up in access.log.

An **ICAP transaction** (class Adaptation::Icap::Xaction) is an ICAP
request with the corresponding final ICAP response. Many ICAP
transactions may occur for a single Master Transaction and, IIRC, ICAP
OPTIONS revalidation transactions occur without a Master Transaction.

A **helper transaction** (class Helper::Xaction) may occur for each
plugin helper which squid.conf settings may cause to be used by the
stream transaction.

**![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
TODO:** alter the **master transaction** definition to cope with UDP
based protocols involving streams and content adapted. eg SNMPv3,
HTTP/3, QUICK, CoAP, CoAPS, DNS,
[WebSockets3](/WebSockets3)

### HTTP Request

The following sequence of checks and adjustments is applied to most HTTP
requests. This sequence starts after Squid parses the request header and
ends before Squid starts satisfying the request from the cache or origin
server. The checks are listed here in the order of their execution:

1.  Host header forgery checks

2.  [http\_access](http://www.squid-cache.org/Doc/config/http_access)
    directive

3.  ICAP/eCAP
    [adaptation](/SquidFaq/ContentAdaptation)

4.  [redirector](http://www.squid-cache.org/Doc/config/url_rewrite_program)

5.  [adapted\_http\_access](http://www.squid-cache.org/Doc/config/adapted_http_access)
    directive

6.  [store\_id](http://www.squid-cache.org/Doc/config/store_id)
    directive

7.  clientInterpretRequestHeaders()

8.  [cache](http://www.squid-cache.org/Doc/config/cache) directive

9.  ToS marking

10. nf marking

11. [ssl\_bump](http://www.squid-cache.org/Doc/config/ssl_bump)
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
[SslBump](/Features/HTTPS#Bumping_direct_SSL.2FTLS_connections)
is in use, Squid may create several fake CONNECT transactions for a
given TLS connection, and each CONNECT may go through the above motions.
If you use SslBump for intercepted port 443 traffic, then shortly after
a new connection is accepted by Squid, SslBump creates a fake CONNECT
request with TCP level information, and that CONNECT request goes
through the above sequence (matching step SslBump1 ACL if any). If an
"ssl\_bump peek" or "ssl\_bump stare" rule matches during that first
SslBump step, then SslBump code gets SNI and creates a second fake
CONNECT request that goes through the same sequence again.

Similarly (S)FTP native services have each message in a Stream
Transaction translated into various HTTP messages which should go
through the above above motions.

Your Squid directives and helpers must be prepared to deal with multiple
\[CONNECT\] requests per connection.

**![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
TODO:** document forwarding destination selection

**![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
TODO:** HTTP response callback processing sequence

**![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
TODO:** non-TCP transaction processing sequence?

**![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
TODO:** non-HTTP stream transactions?

Discuss this page using the "Discussion" link in the main menu
