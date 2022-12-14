---
FaqSection: operation
---
# Content Adaptation

A proxy may analyze, capture, block, replace, or modify the messages it
proxies. Such actions are often called *content adaptation* even though
some of them do not alter anything.

Squid can be configured or modified to perform some forms of content
adaptation. This page highlights content adaptation approaches supported
by Squid.

## Use cases

The following are typical content adaptation needs. Virtually all of the
adaptations listed below have been implemented using one or more
mechanisms described in this document.

- Add, remove, or modify an HTTP header field (e.g., Cookie)
- Block messages based on request URLs
- Block messages based on content
- Redirect certain requests to a custom page or server
- Respond to certain requests with a custom page
- Modify a page to insert new content (e.g., warnings or ads)
- Modify a page to remove existing content (e.g., images or ads)
- Scale an embedded image (e.g., for mobile devices)

# Adaptation mechanisms

## ICAP

Internet Content Adaptation Protocol (RFC
[3507](http://www.rfc-editor.org/rfc/rfc3507.txt), subject to
[errata](http://www.measurement-factory.com/std/icap/)) specifies how an
HTTP proxy (an ICAP client) can outsource content adaptation to an
external ICAP server. Most popular proxies, including Squid, support
ICAP. If your adaptation algorithm resides in an ICAP server, it will be
able to work in a variety of environments and will not depend on a
single proxy project or vendor. No proxy code modifications are
necessary for most content adaptations using ICAP.

**Pros**: Proxy-independent, adaptation-focused API, no Squid
  modifications, supports remote adaptation servers, scalable.

**Cons**: Communication delays, protocol functionality limitations,
  needs a stand-alone ICAP server process or box.

One proxy may access many ICAP servers, and one ICAP server may be
accessed by many proxies. An ICAP server may reside on the same physical
machine as Squid or run on a remote host. Depending on configuration and
context, some ICAP failures can be bypassed, making them invisible to
proxy end-users.

see [Features: ICAP](/Features/ICAP)

## Client Streams

Squid provides [ClientStreams](/ProgrammingGuide/ClientStreams)
classes designed for embedded server-side includes (ESI). A Client
Streams node has access to the HTTP response message being received from
the origin server or being fetched from the cache. By modifying Squid
code, new nodes performing custom content adaptation may be added.
Client Streams are limited to response modification.

**Pros**: Fast, integrated.

**Cons**: Limited API documentation, lack of support, cannot adapt
requests, dependent on Squid (installation, code, license).

Unfortunately, Client Streams creators have not been actively
participating in Squid development for a while, little API
[documentation](/ProgrammingGuide/ClientStreams)
is available, and the long-term sustainability of the code is uncertain.
Custom Client Streams code integrated with Squid may need to be licensed
under GPL.

## eCAP

[eCAP](http://www.e-cap.org/) services are like ICAP services embedded
into Squid. eCAP is an interface that lets Squid and other servers to
use embedded adaptation modules that are dynamically or statically
loaded into the host application. This approach allows for fast content
adaptation without tight dependency on Squid sources. Other proxies and
even ICAP servers may chose to support the same API, removing dependency
on Squid.

**Pros**: Fast, integrated, adaptation-focused API, no Squid
modifications.

**Cons**: Dependent on Squid installation (at least in the
beginning)

Initial support for eCAP is available from [Squid 3.1](/RoadMap).
You can find more details [in Features/eCAP](/Features/eCAP).

## Squid.conf ACLs

Simple HTTP request header adaptation is possible without writing any
code. Squid supports a few configuration options that allow the
administrator to add, delete, or replace specified HTTP request headers:
[request_header_add](http://www.squid-cache.org/Doc/config/request_header_add),
[request_header_access](http://www.squid-cache.org/Doc/config/request_header_access),
and
[request_header_replace](http://www.squid-cache.org/Doc/config/request_header_replace).
Similar directives available for adapting response headers.

**Pros**: Fast, integrated, adaptation-focused API, no Squid
modifications.

**Cons**: Limited to simple header adaptations, dependent on Squid
installation.

The extent of header manipulation support depends on Squid version: Some
versions do not allow adding new headers and some do not allow replacing
old response headers, for example.

## Code hacks

It is possible to modify Squid sources to perform custom content
adaptation without using the Client Streams mechanism described above.
Simple and generic adaptations such as header manipulations may be
accepted into the official Squid code base, minimizing long-term
maintenance overheads.

**Pros**: Fast, integrated.

**Cons**: Must study Squid sources ), limited support,
dependent on Squid (installation, code, license).

Unfortunately, most adaptations are relatively complex, not limited to
headers, or highly customized and, hence, are unlikely to be accepted.
Message body adaptation is especially difficult because Squid does not
buffer the entire message body, but instead processes one semi-random
piece of content at a time.

Developers concerned with Squid code quality and bloat may not want to
help you with specific coding problems. On the other hand, you may need
to modify your code for every Squid release and license your software
under GPL. The code will not work with other proxies.

## Summary

Some adaptation mechanisms are limited in their scope. The following
table summarizes what messages and what message parts the mechanisms can
adapt.

| Mechanism              | Request Header | Request Body | Reply Header| Reply Body |
| ----------------------------------- | ----------- | ------------ | -------- | --- |
| [ICAP](#secICAP)                    | yes         | yes          | yes      | yes |
| [Client Streams](#secClientStreams) |             |              | yes      | yes |
| [eCAP](#seceCAP)                    | yes         | yes          | yes      | yes |
| [ACLs](#secACLs)                    | yes         |              | del      |     |
| [code hacks](#secCodeHacks)         | yes         | yes          | yes      | yes |

Each adaptation mechanism has its strength and weaknesses. The following
table attempts to rank mechanisms using frequently used evaluation
criteria.

| Evaluation Criteria | Mechanisms in rough order from "best" to "worst" |
| --- | --- |
| Squid independence                      | [ICAP](#secICAP), [eCAP](#seceCAP), [ACLs](#secACLs), [Client Streams](#secClientStreams), [code hacks](#secCodeHacks)       |
| Processing speed                        | [eCAP](#seceCAP) or [Client Streams](#secClientStreams) or [ACLs](#secACLs) or [code hacks](#secCodeHacks), [ICAP](#secICAP) |
| Development effort (header adaptation)  | [ACLs](#secACLs), [code hacks](#secCodeHacks), [Client Streams](#secClientStreams), [eCAP](#seceCAP), [ICAP](#secICAP)       |
| Development effort (content adaptation) | [eCAP](#seceCAP), [ICAP](#secICAP), [Client Streams](#secClientStreams), [code hacks](#secCodeHacks)                         |
| Versatility                             | [code hacks](#secCodeHacks), [eCAP](#seceCAP), [ICAP](#secICAP), [Client Streams](#secClientStreams), [ACLs](#secACLs)       |
| Maintenance overheads                   | [ACLs](#secACLs), [eCAP](#seceCAP), [ICAP](#secICAP), [Client Streams](#secClientStreams), [code hacks](#secCodeHacks)       |

## Additional resources

## Warning

Certain forms of content adaptation are considered harmful by
[IETF](http://www.ietf.org/) (see, for example, RFC
[3238](http://www.rfc-editor.org/rfc/rfc3238.txt)). Many forms of
content adaptation will annoy content owners, producers, consumers, or
all of the above. Not everything that is technically possible is
ethical, desirable, or legal. Think before you adapt others content\!
