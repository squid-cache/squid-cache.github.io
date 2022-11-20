# Feature: HTTP/1.1 support

  - **Goal**: HTTP/1.1 RFC compliance

  - **Status**: 90% compliant and counting.

  - **Version**: 3.2

  - **More**:
    
      - RFC [7230](https://tools.ietf.org/rfc/rfc7230) HTTP/1.1:
        Message Syntax and Routing
        
          - RFC [2817](https://tools.ietf.org/rfc/rfc2817) Upgrading to
            TLS Within HTTP/1.1
    
      - RFC [7231](https://tools.ietf.org/rfc/rfc7231) HTTP/1.1:
        Semantics and Content
        
          - RFC [7238](https://tools.ietf.org/rfc/rfc7238) Status Code
            308 (Permanent Redirect)
    
      - RFC [7232](https://tools.ietf.org/rfc/rfc7232) HTTP/1.1:
        Conditional Requests
    
      - RFC [7233](https://tools.ietf.org/rfc/rfc7233) HTTP/1.1: Range
        Requests
    
      - RFC [7234](https://tools.ietf.org/rfc/rfc7234) HTTP/1.1:
        Caching
    
      - RFC [7235](https://tools.ietf.org/rfc/rfc7235) HTTP/1.1:
        Authentication
        
          - RFC [2617](https://tools.ietf.org/rfc/rfc2617) Basic and
            Digest Access Authentication
        
          - RFC [4559](https://tools.ietf.org/rfc/rfc4559) SPNEGO-based
            Kerberos and NTLM HTTP Authentication

## Summary

Squid-3.2 claims HTTP/1.1 support. Squid v3.1 claims HTTP/1.1 support
but only in sent requests (from Squid to servers).

Earlier Squid versions do not claim HTTP/1.1 support by default because
they cannot fully handle Expect:100-continue, 1xx responses, and/or
chunked messages.

Co-Advisor tests no longer detect RFC MUST-level violations in Squid
trunk when it comes to requirements unrelated to caching. Many
caching-related requirements are still violated. The "compliance
percentage" in the project header is essentially a marketing gimmick
(i.e., meaningless or misleading but technically correct information).
We are actively working on fixing all known violations detected by
Co-Advisor.

### Checklist

Squid v4+ compliance with RFC MUST-level requirements as of August 2018:
[HTTP-1.1-Checklist\_2018-08-09.ods](/Features/HTTP11?action=AttachFile&do=get&target=HTTP-1.1-Checklist_2018-08-09.ods).

Squid v3 and v2 results collected in August 2013:
[HTTP-1.1-Checklist\_2013-08-21.ods](/Features/HTTP11?action=AttachFile&do=get&target=HTTP-1.1-Checklist_2013-08-21.ods).

The linked document contains the results of automated Co-Advisor
HTTP/1.1 compliance tests for several Squid versions. Each test consists
of almost 900 individual test cases, targeting various MUSTs in RFC 2616
and 7230-7235. Each Squid v3+ column summarizes the results of several
tests. These tests were identical from HTTP point of view. If a given
test case showed different results during those tests, the exact test
case outcome could not be determined. Such outcomes are marked with a
letter 'U'. All other markings correspond to stable results. Some test
cases fail due to lack of an HTTP/1.1 feature support in Squid,
incompatibility with the test suite, a test suite bug, or other reasons.
Such test cases are marked with question marks. The remaining test case
outcomes are successes and violations. Only successful outcomes count
towards the "test cases passed" percentage.

The tests are on vanilla Squid with no special alterations made during
build. The 2.7 test appears to have been done with the configurable
HTTP/1.1 advertisement to Servers turned on.

## Compliance

The following compliance notes apply to
[Squid-3.2](/Releases/Squid-3.2)
and later. Older Squid did not even conditionally comply with HTTP/1.1.

### Message Syntax and Routing

Specification Document: RFC [7230](https://tools.ietf.org/rfc/rfc7230)

1.  HTTP/1.1 requires that we upgrade to our highest supported version.
    This has been found problematic with certain broken clients and
    servers.
    
      - NP: ICY protocol seems to be the main breakage. So ICY support
        has been implemented natively to fix this.
    
      - NP: Sharepoint and several other MS products break with
        authentication loops when different HTTP/1.x versions are
        advertised on server and client side (as seen with
        [Squid-3.1](/Releases/Squid-3.1)).
        This is resolved with
        [Squid-3.2](/Releases/Squid-3.2)
        advertising HTTP/1.1 in both sides.

2.  HTTP/1.1 requires support for chunked encoding in both parsers and
    composers. This applies to both responses and requests.
    
      - Both Squid-3 and Squid-2 contain at least response chunked
        decoding. The chunked encoding portion is available from
        [Squid-3.2](/Releases/Squid-3.2)
        on all traffic except CONNECT requests.
    
      - Squid is missing support for chunked encoding trailers.
    
      - Squid is missing support for deflate and gzip transfer
        encodings.
    
      - Squid is missing support for HTTP message Trailers.

Specification Document: RFC [2817](https://tools.ietf.org/rfc/rfc2817)

1.  Squid is conditionally compliant with this feature. Always ignores
    the header content and ensures **Upgrade** header is dropped safely.

2.  Squid with
    [ssl-bump](/Features/SslBump)
    feature enabled will attempt to upgrade CONNECT requests to TLS
    regardless of the presence of Upgrade headers.

### Semantics and Content

Specification Document: RFC [7231](https://tools.ietf.org/rfc/rfc7231)

1.  The forwarding path needs to be cleaned up to better separate HTTP
    messages and actual content, allowing for proper forwarding of 1xx
    responses. 1xx forwarding has been implemented in
    [Squid-3.2](/Releases/Squid-3.2)
    but the forwarding path still needs further work to make this
    efficient.
    
      - This is likely to touch the store API as today all messages go
        via the store, even if just an interim 1xx response.

Specification Document: RFC [7238](https://tools.ietf.org/rfc/rfc7238)

  - Squid is fully compliant with this specification.

### Conditional Requests

Specification Document: RFC [7232](https://tools.ietf.org/rfc/rfc7232)

  - Squid is missing support for **If-Unmodified-Since** validation.

  - Missing **If-None-Match** header creation on revalidation requests

### Range Requests

Specification Document: RFC [7233](https://tools.ietf.org/rfc/rfc7233)

  - Squid is unable to store range requests and is currently limited to
    converting the request into a full request or passing it on
    unaltered to the backend server.
    
      - We need to implement storage to allow for partial range storage.
    
      - There are also a handful of bugs in the existing range handling
        which need to be resolved.

### Caching

Specification Document: RFC [7234](https://tools.ietf.org/rfc/rfc7234)

  - Many caching-related requirements are still violated. see Co-Advisor
    checklist.

### Authentication

Specification Document: RFC [7235](https://tools.ietf.org/rfc/rfc7235)

Specification Document: RFC [2617](https://tools.ietf.org/rfc/rfc2617)

  - Squid fully supports Basic authentication.

  - There are outstanding bugs in minimal Digest authentication
    behaviour.

  - Squid is missing support for Digest auth-int authentication mode.

Specification Document: RFC [4559](https://tools.ietf.org/rfc/rfc4559)

  - Squid fully supports Negotiate/Kerberos authentication.
    
      - \- Squid will additionally generate **Connection:Proxy-Support**
        header to enforce semantics when chained. - Squid additionally
        supports Negotiate for Proxy-Auth.

  - There are outstanding bugs in the NTLM and Negotiate/NTLM
    implementation.

[CategoryFeature](/CategoryFeature)
