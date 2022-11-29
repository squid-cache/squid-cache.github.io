# Troubleshooting: Hotmail.com

**Synopsis**

This website contains several rather broken systems. As of March 2011
these problems have been known for most of a decade and left unfixed by
the Webmasters.

**Symptoms**

  - Site complains about: **Intrusion Logged. Access denied.**

**Explanation**

HTTP is designed as a relay model, with a built-in concept of proxies
and defined behaviour. It operates with stateless requests. These
details are important when considering the Hotmail website.

The Hotmail is one of many websites with a security system is designed
assuming a model of end-to-end client-to-server connectivity.

  - It requires all requests to come from the same client IP address.

  - It requires all requests to go **to** the same server IP address.

This latter detail betrays a historic browser behaviour of finding an IP
that works for the website and re-using it for many connections. Squid
historically did load balancing across all DNS provided IPs.

Hotmail is not unique in having this problem. There are many smaller
websites which also exhibit these bad security decisions. Hotmail is
merely the most popular and thus well-known (and longest lasting)
problem.

**Workaround**

There are several changes needed to work with Hotmail. Each with their
own problems.

To force all client requests to go to a consistent IP address you must
disable destination load balancing in all network Systems when
connecting to Hotmail. Turned **off** the Squid
[balance_on_multiple_ip](http://www.squid-cache.org/Doc/config/balance_on_multiple_ip)
directive. Other load balancing software may or may not have similar
controls.

To force all client requests to go to Hotmail with consistent IPs. You
can do one of a few things:

  - Proxy clusters can use the **usernamehash** or **sourcehash**
    [cache_peer](http://www.squid-cache.org/Doc/config/cache_peer)
    algorithms to limit the HTTP request flow without hindering load
    balancing too much.

  - Recent Squid releases with TPROXYv4 support are able to spoof the
    client IP on their contacts. This spoofing gets around the website
    security system by allowing it access to the client IP. Effectively
    making it believe the proxy is not there. This can be complex to
    debug if things go wrong and requires modern systems from the kernel
    up.

  - Older Squid releases can use
    [tcp_outgoing_address](http://www.squid-cache.org/Doc/config/tcp_outgoing_address)
    directive Forcing all outgoing requests to Hotmail to use a fixed
    Squid outbound IP. This risks the old well-known problem that
    Hotmail *Single-Sign-On* is linked to the IP address as well and all
    clients visiting through the proxy may get to see each others email
    boxes.

  - Alternatively you can use NAT to set the outbound connection IP from
    a range of IPs so each client has a temporary but distinct IP for
    their entire Hotmail session.

[CategoryKnowledgeBase](/CategoryKnowledgeBase)
[SquidFaq/TroubleShooting](/SquidFaq/TroubleShooting)
