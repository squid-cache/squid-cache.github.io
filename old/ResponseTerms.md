---
categories: ReviewMe
published: false
---
# Response Terminology

This page documents various response-related terms. This terminology
[will be](https://github.com/squid-cache/squid/pull/398) used, for
example, to describe logformat %codes dealing with responses.

TODO: Transform into a more general \[Configuration\] Terminology page.
This move should probably be done before PR
[\#398](https://github.com/squid-cache/squid/pull/398) changes are
committed.

TODO: The diagram below can be clarified a lot by using an image instead
of an ASCII art. Graphical diagrams is one of the reasons we may want to
document terminology here, on the wiki, instead of in
squid.conf.documented. On the other hand, we can probably teach
configuration [renderer](http://www.squid-cache.org/Doc/config/) to to
show images that use some simple embedding syntax in
squid.conf.documented. The latter would help address the "which Squid
version uses which terminology" problem.

    client <-- (sent) -- Squid server <-- (received) -- Squid client <-- (virgin) -- origin server or cache peer
    client <-- (sent) -- Squid server <-- (received) -- cache
    client <-- (sent) -- Squid server <-- (received) -- error generator
    client <-- (sent) -- Squid server <-- (received) -- pre-cache REQMOD request satisfaction service
    client <-- (sent) -- Squid server <-- (received) -- pre-cache RESPMOD adaptation service(s) <-- Squid client <-- (virgin) -- origin server or cache peer

\* **received**: a response received by Squid. Typical sources include
origin servers, cache peers, adaptation services, and the cache store.
Another possible source of received replies is a pre-cache REQMOD
adaptation service working in a request satisfaction mode. Unless
restricted further, received replies include both interim and final
responses.

\* **sent** : A response that was massaged (e.g., by http_reply_access
rules) and forwarded by the Squid server to a Squid client. Most sent
replies come from received responses that were adjusted for Squid client
use. This category also includes responses that were meant to be sent
but could not be (fully) written to the network due to exceptional
circumstances such as an unexpected client connection termination.

\* **adapted**: A response received from a RESPMOD adaptation service
(eCAP or ICAP).

\* **(internally) generated**: A response (usually an "error page")
created from scratch by Squid itself. Replies can be generated at
virtually any transaction processing stage, both before and after
caching and adaptation layers.

\* **final**: A response that ends the corresponding protocol
transaction (e.g., HTTP 200 OK).

\* **interim**: Not a final response (e.g., HTTP 100 Continue). In most
deployment environments, most transactions do not have interim
responses.

\* **last**: A single transaction may deal with zero or more interim
responses and at most one final response. Usually, a logformat %code is
expanded to the latest *at %code expansion time* response (i.e. the
final response or, if there is no final response, the interim response
closest to the final response). Since logformat %codes may be expanded
when setting annotations and communicating with helpers, external ACLs,
and adaptation services, the same %code may expand to different values
within the same transaction, depending on the timing of that %code use.
