---
categories: KnowledgeBase
---
# Client-Squid NTLM authentication protocol description

This document details the mechanics of the
[NTLM](http://davenport.sourceforge.net/ntlm.html) authentication scheme
as applied to Web proxies.

Client-side, it is supported by Microsoft's Internet Explorer and by
Mozilla Firefox (now on all platforms).

Server-side it is supported by Microsoft Proxy / ISA Server (of course),
Squid version 2.5 (only NTLMv1 up to Squid 2.5STABLE5), and via an
Apache 1.3 module _mod_ntlm_winbind_
is available from [Samba's](http://www.samba.org) repository.

## The mechanics of NTLM authentication

1. The client connects and issues a request without any authentication
    info. This happens for ALL new connections, unlike what happens with
    most Basic authentication implementations which will supply
    authentication information automatically for all connections after a
    successful authentication is performed.
1. The server returns a 407 status code, along with an header:
    `Proxy-Authenticate: NTLM  ` No realm, domain or anything is
    specified. Of course, additional Proxy-Authenticate headers might be
    supplied to announce other supported authentication schemes. There
    is a bug in all version of Microsoft Internet Explorer by which the
    NTLM authentication scheme MUST be declared first or it will not be
    selected. This goes against RFC 2616, which recites "A user agent
    MUST choose to use the strongest auth scheme it understands" and
    NTLM, while broken in many ways, is still worlds stronger than
    Basic.
1. At this point, Squid disconnects the connection, forcing the client
    to initiate a new connection, regardless of any keep-alive
    directives from the client. This is a bug-compatibility issue. It
    may not be required with HTTP/1.1, but there is no way to make sure.
1. The client re connects and issues a GET-request, this time with an
    accompanying `Proxy-Authorization: NTLM some_more_stuff` header,
    where some_more_stuff is a base64-encoded negotiate packet. The
    server once again replies with a 407 ("proxy auth required") status
    code, along with an header: `Proxy-Authenticate: NTLM
    still_some_more_stuff` where some_more_stuff is a base64-encoded
    challenge packet. Somewhere in this packet is the challenge nonce.
    From here on it is vital that the TCP connection be kept alive,
    since all subsequent authentication-related information is tied to
    the TCP connection. If it's dropped, it's back to square one,
    authentication-wise.
1. The client sends a new GET-request, along with an header:
    `Proxy-Authenticate: NTLM cmon_we_are_almost_done` where
    cmon_we_are_almost_done is an authenticate packet. The packet
    includes information about the user name and domain, the challenge
    nonce encoded with the user's password (actually it MIGHT contain it
    encoded TWICE using different algorithms).
1. Either the server denies the authentication via a 407/DENIED or
    403/DENIED return code, and we're back to square one, or it returns
    the requested resource. From now on, until the TCP connection is
    kept alive, no further credentials will be sent from the client to
    the proxy. The TCP connection is marked as "OK", and the client
    expects that it can pump whatever it wants.

## See Also

- <http://davenport.sourceforge.net/ntlm.html>
