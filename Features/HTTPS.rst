##master-page:Features/FeatureTemplate
#format wiki
#language en
#faqlisted yes

= Feature: HTTPS (HTTP over TLS or SSL) =

##  * '''Goal''': What must this feature accomplish? Try to use specific, testable goals so that it is clear whether the goal was satisfied. Goals using unquantified words such as "improve", "better", or "faster" are often not testable. Do not specify ''how'' you will accomplish the goal (use the Details section below for that).

## * '''Status''': completed.

 * '''Version''': 2.5

## * '''Developer''': Who is responsible for this feature? Use wiki names for developers who have a home page on this wiki.

## * '''More''': Where can folks find more information? Include references to other pages discussing or documenting this feature. Leave blank if unknown.

 <<TableOfContents>>

= Details =
Normally, when your browser comes across an '''https://''' URL, it does one of two things:

 * The browser opens an SSL connection directly to the origin server.
 * The browser tunnels the request through Squid with the ''CONNECT'' request method.

== SSL Main-In-The-Middle ==

Two words: {X} '''THINK AGAIN''' {X} , if you still want to reconsider a third time, and then consult your lawyers about the local wire tapping and anti-terrorism laws.


[[SquidFaq/InterceptionProxy|NAT Interception]] (also wrongly called ''transparent proxy'') cannot be used on SSL encrypted traffic. For the gory details on why please read the interception page, the explanation is quite long.

 || /!\ '''The SSL protocol was explicitly created to prevent interception of messages.''' /!\ ||

For the most part SSL meets this design goal. Although there are a few situations where Squid is able to decrypt messages passed through it. One of those situations is '''SSL termination''' setup as described below. Another is the '''CONNECT''' method outlined below using a PAC file to [[http://wiki.squid-cache.org/SquidFaq/ConfiguringBrowsers#Fully_Automatic_Configuration|automatically configure]] the client browser and [[Features/SslBump]] to decrypt.

== CONNECT method ==
The ''CONNECT'' method is a way to tunnel any kind of connection through an HTTP proxy.  The proxy doesn't understand or interpret the contents.  It just passes bytes back and forth between the client and server. For the gory details on tunnelling and the CONNECT method, please see [[ftp://ftp.isi.edu/in-notes/rfc2817.txt|RFC 2817]] and [[http://www.web-cache.com/Writings/Internet-Drafts/draft-luotonen-web-proxy-tunneling-01.txt|Tunneling TCP based protocols through Web proxy servers]] (expired).

Squid supports these encrypted protocols by "tunneling" traffic between clients and servers.  In this case, Squid can relay the encrypted bits between a client and a server.

Squid [[SquidFaq/SquidAcl|Access Controls]] are able to control CONNECT requests, but only limited information is available. The main thing to be aware of is that certain parts of the request URL do not exist:
 * the protocol (http://, https://, ftp://, voip://, itunes://, telnet://, etc),
 * the '''file path''' (''/index.html'', etc),
 * and query string (''?a=b&c=d'')

On HTTPS they are hidden inside the encrypted portion of the message. Other protocols may not even use URLs. ie telnet.

 /!\ It is important to notice that the protocols passed through CONNECT are not limited to the ones Squid normally handles. Quite literally '''anything''' that uses a two-way TCP connection can be passed through CONNECT tunnel. This is why the Squid [[SquidFaq/SecurityPitfalls#The_Safe_Ports_and_SSL_Ports_ACL|default ACLs]] published with Squid start with ''' {{{deny CONNECT !SSL_Ports}}} ''' and why it is very important that you have a good clear reason to do any type of ''allow'' rule above it.

== SSL Termination ==
Squid-2.5 and later can terminate TLS or SSL connections. You must have built with ''--enable-ssl''. See SquidConf:https_port for more information.

This is perhaps most useful in a surrogate (aka, http accelerator, reverse proxy) configuration. Simply configure Squid with a normal [[ConfigExamples#Reverse_Proxy_.28Acceleration.29|reverse proxy]] configuration using port 443 and SSL certificate details on an SquidConf:https_port line.

Alternatively, Squid can accept regular proxy traffic in these ports in the same way it does SquidConf:http_port. The major drawback here is that the popular modern browsers do not permit configuration of TLS/SSL encrypted proxy connections. We have open bugs against most of them now, waiting for support to appear. If you have any interest please assist getting that to happen. Meanwhile tricks using stunnel or SSH tunnels are required to encrypt the browser-to-proxy connection before it leaves the client machine. These are somewhat heavy on the network and can be slow as a result.

----
CategoryFeature
