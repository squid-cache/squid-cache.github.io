##master-page:Features/FeatureTemplate
#format wiki
#language en
#faqlisted yes

= Feature: HTTPS (HTTP Secure or HTTP over SSL/TLS) =

 * '''Version''': 2.5
## * '''More''': 

<<TableOfContents>>

When a browser comes across an '''https://''' URL, it does one of two things:

 * opens an SSL/TLS connection directly to the origin server or
 * opens a TCP tunnel through Squid to the origin server using the ''CONNECT'' request method.

Squid interaction with these two traffic types is discussed below.


= CONNECT tunnel =

The ''CONNECT'' method is a way to tunnel any kind of connection through an HTTP proxy. By default, the proxy establishes a TCP connection to the specified server, responds with an HTTP 200 (Connection Established) response, and then shovels packets back and forth between the client and the server, without understanding or interpreting the tunnelled traffic. For the gory details on tunnelling and the CONNECT method, please see [[ftp://ftp.isi.edu/in-notes/rfc2817.txt|RFC 2817]] and the expired [[http://www.web-cache.com/Writings/Internet-Drafts/draft-luotonen-web-proxy-tunneling-01.txt|Tunneling TCP based protocols through Web proxy servers]] draft.

== CONNECT tunnel through Squid ==

When a browser establishes a CONNECT tunnel through Squid, [[SquidFaq/SquidAcl|Access Controls]] are able to control CONNECT requests, but only limited information is available. For example, many common parts of the request URL do not exist in a CONNECT request:
 * the URL scheme or protocol (e.g., http://, https://, ftp://, voip://, itunes://, or telnet://),
 * the URL path (e.g., ''/index.html'' or ''/secure/images/''),
 * and query string (e.g. ''?a=b&c=d'')

With HTTPS, the above parts are present in ''encapsulated'' HTTP requests that flow through the tunnel, but Squid does not have access to those encrypted messages. Other tunnelled protocols may not even use HTTP messages and URLs (e.g., telnet).

 /!\ It is important to notice that the protocols passed through CONNECT are not limited to the ones Squid normally handles. Quite literally '''anything''' that uses a two-way TCP connection can be passed through a CONNECT tunnel. This is why the Squid [[SquidFaq/SecurityPitfalls#The_Safe_Ports_and_SSL_Ports_ACL|default ACLs]] start with ''' {{{deny CONNECT !SSL_Ports}}} ''' and why you must have a very good reason to place any type of ''allow'' rule above them.


== Intercepting CONNECT tunnels ==

A browser sends CONNECT requests when it is configured to talk to a proxy. Thus, it should ''not'' be necessary to intercept a CONNECT request. TBD: Document what happens of Squid does intercept a CONNECT request, either because Squid was [mis]configured to intercept traffic destined to another proxy OR because a possibly malicious client sent a hand-crafted CONNECT request knowing that it is going to be intercepted.


== Bumping CONNECT tunnels ==

  {X} '''WARNING:''' {X}  HTTPS was designed to give users an expectation of privacy and security. Decrypting HTTPS tunnels without user consent or knowledge may violate ethical norms and may be illegal in your jurisdiction. Squid decryption features described here and elsewhere are designed for deployment with ''user consent'' or, at the very least, in environments where decryption without consent is legal. These features also illustrate why users should be careful with trusting HTTPS connections and why the weakest link in the chain of HTTPS protections is rather fragile. Decrypting HTTPS tunnels constitutes a man-in-the-middle attack from the overall network security point of view. Attack tools are an equivalent of an atomic bomb in real world: Make sure you understand what you are doing and that your decision makers have enough information to make wise choices.

## TODO: It would be nice to place the above WARNING text in some kind of editable wiki variable or an invisible page so that we can include the same warning in every SslBump-related page. We can include it by searching for WARNING in this page, but perhaps there is a simpler and more robust way.

Squid [[Features/SslBump|SslBump]] and associated features can be used to decrypt HTTPS CONNECT tunnels while they pass through a Squid proxy. This allows dealing with tunnelled HTTP messages as if they were regular HTTP messages, including applying detailed access controls and performing content adaptation (e.g., check request bodies for information leaks and check responses for viruses). Configuration mistakes, Squid bugs, and malicious attacks may lead to unencrypted messages escaping Squid boundaries.

From the browser point of view, encapsulated messages are not sent to a proxy. Thus, general interception limitations, such as inability to authenticate individual embedded requests, apply here as well.


= Direct SSL/TLS connection =

When a browser creates a direct secure connection with an origin server, there are no HTTP CONNECT requests. The first HTTP request sent on such a connection is already encrypted. In most cases, Squid is out of the loop: Squid knows nothing about that connection and cannot block or proxy that traffic. The reverse proxy and interception exceptions are described below.


== Direct SSL/TLS connection to a reverse proxy ==

Squid-2.5 and later can terminate TLS or SSL connections. You must have built with ''--enable-ssl''. See SquidConf:https_port for more information.

This is perhaps most useful in a surrogate (aka, http accelerator, reverse proxy) configuration. Simply configure Squid with a normal [[ConfigExamples#Reverse_Proxy_.28Acceleration.29|reverse proxy]] configuration using port 443 and SSL certificate details on an SquidConf:https_port line.


== Intercepting direct SSL/TLS connections ==

It is possible to [[SquidFaq/InterceptionProxy|intercept]] an HTTPS connection to an origin server at Squid's SquidConf:https_port. This may be useful in surrogate (aka, http accelerator, reverse proxy) environments, but limited to situations where Squid can represent the origin server using that origin server SSL certificate. In most situations though, intercepting direct HTTPS connections will not work and is pointless because Squid cannot do anything with the encrypted traffic -- Squid is not a TCP-level proxy.


== Bumping direct SSL/TLS connections ==

  {X} '''WARNING:''' {X}  HTTPS was designed to give users an expectation of privacy and security. Decrypting HTTPS tunnels without user consent or knowledge may violate ethical norms and may be illegal in your jurisdiction. Squid decryption features described here and elsewhere are designed for deployment with ''user consent'' or, at the very least, in environments where decryption without consent is legal. These features also illustrate why users should be careful with trusting HTTPS connections and why the weakest link in the chain of HTTPS protections is rather fragile. Decrypting HTTPS tunnels constitutes a man-in-the-middle attack from the overall network security point of view. Attack tools are an equivalent of an atomic bomb in real world: Make sure you understand what you are doing and that your decision makers have enough information to make wise choices.

## XXX: Avoid duplicating the warning text by including that text from somewhere instead.

A combination of Squid [[SquidFaq/InterceptionProxy|NAT Interception]], [[Features/SslBump|SslBump]], and associated features can be used to intercept direct HTTPS connections and decrypt HTTPS messages while they pass through a Squid proxy. This allows dealing with HTTPS messages sent to the origin server as if they were regular HTTP messages, including applying detailed access controls and performing content adaptation (e.g., check request bodies for information leaks and check responses for viruses). Configuration mistakes, Squid bugs, and malicious attacks may lead to unencrypted messages escaping Squid boundaries.

Currently, Squid-to-client traffic on intercepted direct HTTPS connections cannot use [[Features/DynamicSslCert|Dynamic Certificate Generation]], leading to browser warnings and rendering such configurations nearly impractical. This limitation will be addressed by the [[Features/BumpSslServerFirst|bump-server-first]] project.

From the browser point of view, intercepted messages are not sent to a proxy. Thus, general interception limitations, such as inability to authenticate requests, apply to bumped intercepted transactions as well.


= Secure browser-Squid connection =

While HTTPS design efforts were focused on end-to-end communication, it would also be nice to be able to encrypt the browser-to-proxy connection (without creating a CONNECT tunnel that blocks Squid from accessing and caching content). This would allow, for example, a secure use of remote proxies located across a possibly hostile network.

Squid can accept regular proxy traffic using SquidConf:https_port in the same way Squid does it using an SquidConf:http_port directive. Unfortunately, popular modern browsers do not permit configuration of TLS/SSL encrypted proxy connections. There are open bug reports against most of those browsers now, waiting for support to appear. If you have any interest, please assist browser teams with getting that to happen. Meanwhile, tricks using stunnel or SSH tunnels are required to encrypt the browser-to-proxy connection before it leaves the client machine. These are somewhat heavy on the network and can be slow as a result.


----
CategoryFeature
