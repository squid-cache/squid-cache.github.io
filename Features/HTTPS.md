# Feature: HTTPS (HTTP Secure or HTTP over TLS)

  - **Version**: 2.5

  - **More**: RFC [2817](https://tools.ietf.org/rfc/rfc2817#),
    [2818](https://tools.ietf.org/rfc/rfc2818#),
    [Features/SHTTP](https://wiki.squid-cache.org/Features/HTTPS/Features/SHTTP#)

When a client comes across an **[](https://)** URL, it can do one of
three things:

  - opens an TLS connection directly to the origin server, or

  - opens a tunnel through a proxy to the origin server using the
    *CONNECT* request method, or

  - opens an TLS connection to a secure proxy.

Squid interaction with these traffic types is discussed below.

# CONNECT tunnel

The *CONNECT* method is a way to tunnel any kind of connection through
an HTTP proxy. By default, the proxy establishes a TCP connection to the
specified server, responds with an HTTP 200 (Connection Established)
response, and then shovels packets back and forth between the client and
the server, without understanding or interpreting the tunneled traffic.
For the gory details on tunneling and the CONNECT method, please see RFC
[2817](https://tools.ietf.org/rfc/rfc2817#) and the expired [Tunneling
TCP based protocols through Web proxy
servers](http://www.web-cache.com/Writings/Internet-Drafts/draft-luotonen-web-proxy-tunneling-01.txt)
draft.

## CONNECT tunnel through Squid

When a browser establishes a CONNECT tunnel through Squid, [Access
Controls](https://wiki.squid-cache.org/Features/HTTPS/SquidFaq/SquidAcl#)
are able to control CONNECT requests, but only limited information is
available. For example, many common parts of the request URL do not
exist in a CONNECT request:

  - the URL scheme or protocol (e.g., [](http://), [](https://),
    [](ftp://), voip://, itunes://, or [](telnet://)),

  - the URL path (e.g., */index.html* or */secure/images/*),

  - and query string (e.g. *?a=b\&c=d*)

With HTTPS, the above parts are present in *encapsulated* HTTP requests
that flow through the tunnel, but Squid does not have access to those
encrypted messages. Other tunneled protocols may not even use HTTP
messages and URLs (e.g., telnet).

  - ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    It is important to notice that the protocols passed through CONNECT
    are not limited to the ones Squid normally handles. Quite literally
    **anything** that uses a two-way TCP connection can be passed
    through a CONNECT tunnel. This is why the Squid [default
    ACLs](https://wiki.squid-cache.org/Features/HTTPS/SquidFaq/SecurityPitfalls#The_Safe_Ports_and_SSL_Ports_ACL)
    start with **`deny CONNECT !SSL_Ports`** and why you must have a
    very good reason to place any type of *allow* rule above them.

## Intercepting CONNECT tunnels

A browser sends CONNECT requests when it is configured to talk to a
proxy. Thus, it should *not* be necessary to intercept a CONNECT
request. TBD: Document what happens of Squid does intercept a CONNECT
request, either because Squid was \[mis\]configured to intercept traffic
destined to another proxy OR because a possibly malicious client sent a
hand-crafted CONNECT request knowing that it is going to be intercepted.

## Bumping CONNECT tunnels

  - ![{X}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png)
    **WARNING:**
    ![{X}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png)
    HTTPS was designed to give users an expectation of privacy and
    security. Decrypting HTTPS tunnels without user consent or knowledge
    may violate ethical norms and may be illegal in your jurisdiction.
    Squid decryption features described here and elsewhere are designed
    for deployment with *user consent* or, at the very least, in
    environments where decryption without consent is legal. These
    features also illustrate why users should be careful with trusting
    HTTPS connections and why the weakest link in the chain of HTTPS
    protections is rather fragile. Decrypting HTTPS tunnels constitutes
    a man-in-the-middle attack from the overall network security point
    of view. Attack tools are an equivalent of an atomic bomb in real
    world: Make sure you understand what you are doing and that your
    decision makers have enough information to make wise choices.

Squid
[SslBump](https://wiki.squid-cache.org/Features/HTTPS/Features/SslBump#)
and associated features can be used to decrypt HTTPS CONNECT tunnels
while they pass through a Squid proxy. This allows dealing with tunneled
HTTP messages as if they were regular HTTP messages, including applying
detailed access controls and performing content adaptation (e.g., check
request bodies for information leaks and check responses for viruses).
Configuration mistakes, Squid bugs, and malicious attacks may lead to
unencrypted messages escaping Squid boundaries.

From the browser point of view, encapsulated messages are not sent to a
proxy. Thus, general interception limitations, such as inability to
authenticate individual embedded requests, apply here as well.

# Direct TLS connection

When a browser creates a direct TLS connection with an origin server,
there are no HTTP CONNECT requests. The first HTTP request sent on such
a connection is already encrypted. In most cases, Squid is out of the
loop: Squid knows nothing about that connection and cannot block or
proxy that traffic. The reverse proxy and interception exceptions are
described below.

## Direct TLS connection to a reverse proxy

Squid-2.5 and later can terminate TLS or SSL connections. You must have
built with *--enable-ssl*. See
[https\_port](http://www.squid-cache.org/Doc/config/https_port#) for
more information. Squid-3.5 and later autodetect the availability of
GnuTLS library and enable the functionality if available. OpenSSL must
be enabled explicitly with the *--with-openssl* configure option. If the
library is installed in a non-standard location you may need to use the
*--with-foo=PATH* configure option. See *configure --help* for details.

This is perhaps most useful in a surrogate (aka, http accelerator,
reverse proxy) configuration. Simply configure Squid with a normal
[reverse
proxy](https://wiki.squid-cache.org/Features/HTTPS/ConfigExamples#Reverse_Proxy_.28Acceleration.29)
configuration using port 443 and SSL certificate details on an
[https\_port](http://www.squid-cache.org/Doc/config/https_port#) line.

## Intercepting direct TLS connections

It is possible to
[intercept](https://wiki.squid-cache.org/Features/HTTPS/SquidFaq/InterceptionProxy#)
an HTTPS connection to an origin server at Squid's
[https\_port](http://www.squid-cache.org/Doc/config/https_port#). This
may be useful in surrogate (aka, http accelerator, reverse proxy)
environments, but limited to situations where Squid can represent the
origin server using that origin server SSL certificate. In most
situations though, intercepting direct HTTPS connections will not work
and is pointless because Squid cannot do anything with the encrypted
traffic -- Squid is not a TCP-level proxy.

## Bumping direct TLS connections

  - ![{X}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png)
    **WARNING:**
    ![{X}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png)
    HTTPS was designed to give users an expectation of privacy and
    security. Decrypting HTTPS tunnels without user consent or knowledge
    may violate ethical norms and may be illegal in your jurisdiction.
    Squid decryption features described here and elsewhere are designed
    for deployment with *user consent* or, at the very least, in
    environments where decryption without consent is legal. These
    features also illustrate why users should be careful with trusting
    HTTPS connections and why the weakest link in the chain of HTTPS
    protections is rather fragile. Decrypting HTTPS tunnels constitutes
    a man-in-the-middle attack from the overall network security point
    of view. Attack tools are an equivalent of an atomic bomb in real
    world: Make sure you understand what you are doing and that your
    decision makers have enough information to make wise choices.

A combination of Squid [NAT
Interception](https://wiki.squid-cache.org/Features/HTTPS/SquidFaq/InterceptionProxy#),
[SslBump](https://wiki.squid-cache.org/Features/HTTPS/Features/SslBump#),
and associated features can be used to intercept direct HTTPS
connections and decrypt HTTPS messages while they pass through a Squid
proxy. This allows dealing with HTTPS messages sent to the origin server
as if they were regular HTTP messages, including applying detailed
access controls and performing content adaptation (e.g., check request
bodies for information leaks and check responses for viruses).
Configuration mistakes, Squid bugs, and malicious attacks may lead to
unencrypted messages escaping Squid boundaries.

Currently, Squid-to-client traffic on intercepted direct HTTPS
connections cannot use [Dynamic Certificate
Generation](https://wiki.squid-cache.org/Features/HTTPS/Features/DynamicSslCert#),
leading to browser warnings and rendering such configurations nearly
impractical. This limitation will be addressed by the
[bump-server-first](https://wiki.squid-cache.org/Features/HTTPS/Features/BumpSslServerFirst#)
project.

From the browser point of view, intercepted messages are not sent to a
proxy. Thus, general interception limitations, such as inability to
authenticate requests, apply to bumped intercepted transactions as well.

# Encrypted browser-Squid connection

Squid can accept regular proxy traffic using
[https\_port](http://www.squid-cache.org/Doc/config/https_port#) in the
same way Squid does it using an
[http\_port](http://www.squid-cache.org/Doc/config/http_port#)
directive. RFC [2818](https://tools.ietf.org/rfc/rfc2818#) defines the
protocol requirements around this.

Unfortunately, popular modern browsers do not yet permit configuration
of TLS encrypted proxy connections. There are open bug reports against
most of those browsers now, waiting for support to appear. If you have
any interest, please assist browser teams with getting that to happen.

Meanwhile, tricks using stunnel or SSH tunnels are required to encrypt
the browser-to-proxy connection before it leaves the client machine.
These are somewhat heavy on the network and can be slow as a result.

## Chrome

The Chrome browser is able to connect to proxies over TLS connections if
configured to use one in a PAC file or command line switch. GUI
configuration appears not to be possible (yet).

More details at
[](http://dev.chromium.org/developers/design-documents/secure-web-proxy)

## Firefox

The Firefox 33.0 browser is able to connect to proxies over TLS
connections if configured to use one in a PAC file. GUI configuration
appears not to be possible (yet), though there is a config hack for
[embedding PAC
logic](https://bugzilla.mozilla.org/show_bug.cgi?id=378637#c68).

There is still an important bug open:

  - Using a client certificate authentication to a proxy:
    [](https://bugzilla.mozilla.org/show_bug.cgi?id=209312)

If you have trouble with adding trust for the proxy cert, there is [a
process](https://bugzilla.mozilla.org/show_bug.cgi?id=378637#c65) by
Patrick [McManus](https://wiki.squid-cache.org/Features/HTTPS/McManus#)
to workaround that.

[CategoryFeature](https://wiki.squid-cache.org/Features/HTTPS/CategoryFeature#)
