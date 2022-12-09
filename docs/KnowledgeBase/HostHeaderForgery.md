---
categories: KB
---
# Host header forgery detected

## Symptoms

    SECURITY ALERT: Host header forgery detected on ... (local IP does not match any domain IP)
    SECURITY ALERT: By user agent: ...
    SECURITY ALERT: on URL: ...

## Explanation

This is an alert generated as part of a new security feature added in
[Squid-3.2](/Releases/Squid-3.2)
to protect the network against hijacking by malicious web scripts.

As outlined in advisory
[SQUID-2011:1](http://www.squid-cache.org/Advisories/SQUID-2011_1.txt)
these scripts are able to bypass browser security measures and spread
infections through the network. They do so by forging the *Host:*
headers on HTTP traffic going through an interception proxy.

> :information_source:
    When port 443 is intercepted the client SNI value used in a
    generated CONNECT request can have this check performed. If that SNI
    name does not resolve to the destination server IP(s) this message
    will be output and TLS halted.

To avoid this vulnerability Squid has resolved the domain name the
client was supposedly contacting and determined that the IP the HTTP
request was going to does not belong to that domain name.

The **first line** of the three cites:
1. the **local=** (packet destination IP) address of the domain the
        client was connecting to,
1. the **remote=** (packet source IP) address of the client making
        the connection,  and the reason for the alert.

In this case it is **"local IP does not match any domain IP"**.

With [host_verify_strict](http://www.squid-cache.org/Doc/config/host_verify_strict)
enabled there are other checks that can alert.

The **second and third lines** are self explanatory.

## Fix

Use the [WPAD/PAC](/SquidFaq/ConfiguringBrowsers#Fully_Automatic_Configuration)
protocol to **automatically configure** the browser agents instead
of intercepting traffic

**OR**

use an Active Directory(R) GPO to **automatically configure** the
browser agents instead of intercepting traffic.

**OR**

configure the browsers manually

> :information_source:
    all of these methods make the client browser agent aware of the
    proxy. This causes the browser to send a differently formatted HTTP
    request which avoids both the security vulnerability and checks
    which are displaying the alert.

You may also determine from the details mentioned in the alert that the
client has being hijacked or infected. In this case the proper fix may
involve other actions to remove the infection which we will not cover
here.

## Workaround

> :information_source:
    As of May 2012, [Squid-3.2.0.18](/Releases/Squid-3.2)
    will pass traffic which fails these validation checks to the same
    origin as intended by the client. But will disable caching, route
    error recovery and peer routing in order to do so safely. The
    intention in future is to support those features safely for this
    traffic.

There really are no workarounds. Only fixes. Although there may be some
things configured in the network which are causing the alert to happen
when it should not.

The below details are mandatory configuration for NAT intercept or
TPROXY proxies. Some of them appeared previously to be optional due to
old Squid bugs which have now been fixed.

* ensure that NAT is performed on the same box as Squid.
    > :information_source:
        Squid **MUST** have access to the NAT systems records of what
        the original destination IP was. Without that information all
        traffic will get a 409 HTTP error and log this alert.
    
    > :information_source:
        When operating Squid on a different machine to your router use
        **Policy Routing** or a tunnel to deliver traffic to squid. Do
        not perform destination NAT (DNAT, REDIRECT, Port Forwarding) on
        the router machine before the traffic hits Squid.

* ensure that the DNS servers Squid uses are the same as those used by
    the client(s).
    > :information_source:
        Certain popular CDN hosting networks use load balancing systems
        to determine which website IPs to return in the DNS query
        response. These are based on the querying DNS resolvers IP. If
        Squid and the client are using different resolvers there is an
        increased chance of different results being given. Which can
        lead to this alert.

* ensure that your DNS servers are obeying the IP rotation TTL for
    that domain name.
    > :information_source:
        Certain CDN networks load balance by rotating a set of IPs in
        and out of service with each TTL cycle. Storing the website IPs
        longer than the TTL permits is a violation of DNS protocol which
        produces incorrect DNS responses periodically. This alert is
        just one of the more visible side effects that violation causes.

* ensure that the commercial 8.8.8.8 service is not being used
    directly.
    
    > :information_source:
        This service is known to be particularly bad with rotation of
        lookup results on each query - much faster than even the TTL for
        the zones it is serving.
    
    > :information_source:
        If you really need to use this service at all a local DNS
        resolver should be setup that uses it as upstream forwarder. The
        local network machines can use that local resolver to access
        DNS.

These are optional and may not be possible, but is useful when they
work:

* enable EDNS (extended-DNS jumbogram) and large UDP packet support.
    - Some popular domains are hosted on more IPs than will fit in a
        regular DNS query response. Their responses may appear
        inconsistent as IPs appear and disappear in the small set the
        regular DNS packet displays.
    - [Squid-3.2](/Releases/Squid-3.2)
        can attempt to use EDNS to get larger packets with all IPs of
        these domains by setting the
        [dns_packet_max](http://www.squid-cache.org/Doc/config/dns_packet_max)
        directive. This reduces Squids chance of loosing the IP the
        client is connecting to but requires both your resolver to
        support EDNS and network to support jumbograms
* restrict HTTP persistent (keep-alive) connections
    - Since the issue with CDNs is basically their DNS responses
        changing too rapidly the long lifetime of HTTP connections can
        exceed that change and cause false failures.
    - The
        [client_lifetime](http://www.squid-cache.org/Doc/config/client_lifetime)
        can be configured to similarly short times to reduce the
        occurrence of these mismatches. The default 1 day is tuned to
        match DNS recommended best practice TTL.
    - Alternatively
        [client_persistent_connections](http://www.squid-cache.org/Doc/config/client_persistent_connections)
        can be set to **off** to disable HTTP keep-alive entirely.

## Alternative Causes

Interception performed at the DNS layer by the use of *dnsmasq* tool
or other DNS trickery altering the IP destination the clients
receive for a domain lookup.

In these cases [Squid-3.2](/Releases/Squid-3.2)
hijacking protection will pass the traffic through to the clients
destination IP address **without** redirecting to any specific other IP.
Additional Destination-NAT configuration is required to identify the
packets and ensure they are delivered to the correct site regardless of
any other details.
