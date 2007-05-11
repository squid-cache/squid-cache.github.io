= Web Proxy Auto Detection using DNS =

== Overview ==

WPAD can use DNS to probe for the existance of a WPAD web server to fetch the proxy configuration file from.

== Explanation (IPv4 specific) ==

A WPAD-enabled User Agent will construct a DNS lookup for a "wpad" host in a list of domain names. It may assemble this domain name list from a variety of sources, including:

 * The reverse DNS resolution of the hosts' IP;
 * Configured DNS domain search list

It then tries performing an address (A) lookup for each of the domain entries, prepended with "wpad". If it doesn't find an A response it removes the first part of the domain name and tries again.

If a match is found the User Agent then attempts to connect to the webserver at that address over port 80/http and request the "/wpad.dat" file, with the Host set to the domain name.

== Example ==

A client has an IP 1.2.3.4 which resolves to host-1-2-3-4.pop1.isp.net. The client has their DNS search set to "isp.net". The ISP runs a WPAD server at wpad.isp.net.

 * The client does a PTR lookup on 1.2.3.4 and finds it resolves to host-1.2.3.4.pop1.isp.net;
 * The client does an A lookup on wpad.pop1.isp.net and finds it doesn't exist;
 * The client does an A lookup on wpad.isp.net and finds it exists;
 * The client issues a HTTP request to wpad.isp.net on port 80/http requesting http://wpad.isp.net/wpad.dat;
 * The client retrieves wpad.dat and uses it as its proxy autoconfiguration script.

== Implementation Issues ==

 * Some have reported (Amos?) that various WPAD implementations require the WPAD domain name to match one or more of the listed domains in the DNS domain search list. This is unverified but please consider ensuring the wpad domain exists in the DNS search list.
  * If the IP resolves to host-x-x-x-x.pop1.isp.net, and the WPAD DNS name is wpad.isp.net, make sure "isp.net" is configured in the DNS search list.
  * If the IP resolves to host-x.x.x.x.pop1.isp.net, and the WPAD DNS name is wpad.pop1.isp.net, having "isp.net" in the DNS search list may not be enough.

== Security Concerns ==

=== WPAD DNS server searching ===

WPAD searches the DNS looking for wpad. at each domain. This means the following kind of example can occur:
 * WPAD looks for wpad.corp.example.com;
 * WPAD looks for wpad.example.com;
 * WPAD looks for wpad.com;

This can mean that servers configured to answer to the 'wpad' host in a domain listed in the DNS path may return a proxy autoconfiguration file for an external proxy service. This could be used as part of a denial of service or to intercept proxy traffic.

Duane Wessels owns wpad.net, wpad.org and wpad.com; he provides graphed statistics for his webserver at http://www.life-gone-hazy.com/%7esnmp/http_status.cgi . (I believe the 404's include failed wpad.dat lookups; I should check -Adrian).

It would be nice if Registrars prohibited the registration of the "wpad" domain name; its not known if this is policy for any current DNS registry.
