---
categories: ReviewMe
published: false
---
# Feature: HTTP/2.0 support

  - **Goal**: HTTP/2.0 compliance.

<!-- end list -->

  - **Status**: Design groundwork underway.

  - **ETA**: unknown

  - **Version**: TBC

  - **Developer**:
    [AmosJeffries](/AmosJeffries)

  - **More**:
    
      - RFC [7540](https://tools.ietf.org/rfc/rfc7540)
    
      - RFC [7541](https://tools.ietf.org/rfc/rfc7541)
    
      - Bug [4248](https://bugs.squid-cache.org/show_bug.cgi?id=4248)
    
      - <http://http2.github.io/>

# Details

HTTP/2 was designed loosly based on the SPDY experimental protocol for
framing HTTP requests in a multiplexed fashion over SSL connections.
Avoiding the pipeline issues which HTTP has with its dependency on
stateful "\\r\\n" frame boundaries.

HTTP/2 has some major differences however:

  - HTTP/2 contains a magic connection prefix for automated protocol
    switching with HTTP/1.1 and HTTP/1.0

  - Frame layout has been significantly optimized for HTTP messaging
    outside web browser usages.

  - TLS is optional

  - Compression algorithms have been rewoven specifically for HTTP
    performance and to avoid security vulnerabilities in gzip
    compression as used in SPDY.

  - Several frame types and flow control semantics from SPDY have been
    dropped or optimized away.

Squid will support HTTP/2 formally and only support desired SPDY
features which are IEFT approved and placed in the HTTP/2 specification.

## Traffic from client to Squid

To implement a HTTP/2 receiving port in Squid we need to:

  - duplicate the HTTP client connection manager (ConnStateData,
    ClientSocketContext, ClientHttpRequest class triplet)
    
      - update the new version to decapsulate/encapsulate with HTTP/2
        framing on read/write
    
      - update the new manager to handle multiple parallel data pipeline
        channels ("streams" in the HTTP/2 grammar). At present there is
        only one active context and an idle pipeline queue. HTTP/2
        requires a minimum of 100 in parallel.

  - avoiding direct reads or writes to the client socket
    
      - mostly done as of
        [Squid-3.2](/Releases/Squid-3.2)
        but there are a few exceptions, ie tunnel and ssl-bump.

  - implement HTTP/2 header parser and packer routines

  - implement the HTTP/2 compression (HPACK) algorithms:
    
      - string-literal encoder
    
      - Huffman encoder/decoder

  - implement Upgrade header support:
    
      - for h2c label
    
      - for TLS/\*

  - implement TLS for systems where OpenSSL is not available.
    
      - Including ALPN extension support
    
      - Possibly also NPN extension support
    
      - :x:
        this is only required because browser manufacturers refuse once
        again to implement proxy support for HTTP/2 over port 80 or
        3128. Notable exception being MSIE which is being friendly to
        proxies.

### Progress

**Completed: (in
[Squid-3.5](/Releases/Squid-3.5))**

  - Solve Bug [3371](https://bugs.squid-cache.org/show_bug.cgi?id=3371)
    interference with our ability to detect and relay HTTP/2
    transparently

**Completed: (in
[Squid-4](/Releases/Squid-4))**

  - Implement TLS support using GnuTLS for systems where OpenSSL is not
    available.

**Completed: (in http2 branch)**

  - Detection of the HTTP/2 connection header magic octets in port 80
    intercepted traffic

  - Implement branching points for HTTP/2 frame parser

**Underway:**

  - Parsing HTTP/2 request

## Traffic from Squid to servers

To implement a server gateway in Squid we need to:

  - add a new HTTP/2.0 server connection pool similar but different to
    the HTTP/1.1 idle pconn pool
    
      - without timeout closures on the pool (timeout is relative to
        last use, not pooling time).
    
      - holding the connections which are actively in use but can be
        shared with more server requests.
    
      - pooling at the level of stateful connection manager object
        ([HttpStateData](/HttpStateData)
        presently) not stateless TCP connection details
        (Comm::Connection)

  - duplicate the HTTP server connection manager
    
      - update the new version to encapsulate/decapsulate with HTTP/2
        framing on read/write
    
      - update the new manager to handle multiple parallel data
        pipelines.

  - implement mandatory transport layer compression / decompression.
    
      - shared with receiving socket code, but different state tables

  - implement HTTP/2 header parser and packer routines
    
      - shared with receiving socket code

  - implement TLS for systems where OpenSSL is not available.
    
      - including ALPN extension support

### Progress

  - **None yet.**

[CategoryFeature](/CategoryFeature)
