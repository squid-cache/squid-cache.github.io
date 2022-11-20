# Web Proxy Auto Detection using DNS

## Overview

WPAD can use DNS to probe for the existance of a WPAD web server to
fetch the proxy configuration file from. The WPAD specification
enumerates a number of possibilities; the only required DNS method is
the "Well known alias" method.

The "Well known alias" method simply requires a "wpad." host to have an
IN A DNS resource entry. The User Agent constructs a series of DNS
lookups to discover this hostname and if it finds the host it will query
a web server at that host for a proxy autoconfiguration file.

A handful of other DNS-related methods are documented in the WPAD
specification; they are not covered in this article.

## Explanation

A WPAD-enabled User Agent will construct a DNS lookup for a "wpad" host
in a list of domain names. It may assemble this domain name list from a
variety of sources, including:

  - The reverse DNS resolution of the hosts' IP;

  - Configured DNS domain search list

The User Agent then tries an address (A) lookup for each of the domain
entries, prepended with "wpad". If it doesn't find an A response it
tries the next domain in the domain search list. Some clients may also
remove the leftmost part of the domain name and try again.

If an A record is found, the User Agent then attempts to connect to the
webserver at that address on the HTTP port (normally port 80) and
requests the "/wpad.dat" file, with the Host set to the domain name.

## Example

  - ℹ️
    Note: This example is browser and IPv4 specific.

A client has an IP 1.2.3.4 which resolves to host-1-2-3-4.pop1.isp.net.
The client has their DNS search set to "isp.net". The ISP runs a WPAD
server at wpad.isp.net.

  - The client does a PTR lookup on 1.2.3.4 and finds it resolves to
    host-1.2.3.4.pop1.isp.net;

  - The client does an A lookup on wpad.pop1.isp.net and finds it
    doesn't exist;

  - The client does an A lookup on wpad.isp.net and finds it exists;

  - The client issues a HTTP request to wpad.isp.net requesting
    [](http://wpad.isp.net/wpad.dat;)

  - The client retrieves wpad.dat and uses it as its proxy
    autoconfiguration script.

## Implementation Issues

  - Some have reported that various WPAD implementations require the
    WPAD host name to match one or more of the listed domains in the DNS
    domain search list. This is unverified but please consider ensuring
    the wpad domain exists in the DNS search list.
    
      - If the IP resolves to host-x-x-x-x.pop1.isp.net, and the WPAD
        DNS name is wpad.isp.net, make sure "isp.net" is configured in
        the DNS search list.
    
      - If the IP resolves to host-x.x.x.x.pop1.isp.net, and the WPAD
        DNS name is wpad.pop1.isp.net, having "isp.net" in the DNS
        search list may not be enough.

## Security Concerns

### WPAD DNS server searching

WPAD searches the DNS looking for wpad. at each domain. Additionally,
many clients implement a "Fallback" mechanism which checks the parent
domains as well. This means the following kind of example can occur:

  - WPAD looks for wpad.corp.example.com.;

  - WPAD looks for wpad.example.com.;

  - WPAD looks for wpad.com.;

  - WPAD looks for wpad.;

This can mean that a server configured to answer to the 'wpad' host in a
parent domain may return a proxy autoconfiguration file for an external
proxy service. This could be used as part of a denial of service or to
intercept client traffic. This "Fallback" mechanism is deprecated by the
IETF and is disabled in Mozilla Firefox, but may still be implemented in
some browsers.

Duane Wessels owns wpad.net, wpad.org and wpad.com; he provides graphed
statistics for his webserver at
[](http://www.life-gone-hazy.com/%7esnmp/http_status.cgi) . (I believe
the 404's include failed wpad.dat lookups; I should check -Adrian).

It would be nice if Registrars prohibited the registration of the "wpad"
domain name; its not known if this is policy for any current DNS
registry.

[CategoryTechnology](/CategoryTechnology)
