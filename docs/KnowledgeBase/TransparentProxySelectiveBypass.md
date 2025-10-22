---
categories: KnowledgeBase
---
# Transparent Proxy Selective Bypass

## Synopsis

Is it possible to selectively bypass a Transparent Interception Proxy
squid? If so, how?

## Explanation

Yes, it is possible to bypass a Squid running as an interception proxy.
Except for the fact that it's not up to squid to do it, but it's a task
for the underlying interception technology.

Once Squid gets engaged to serve a request, it cannot declare itself out
of the game, but has to either service it or fail it.

This requirement also determines what kind of filtering is possible;
generally speaking this restricts to only using network-level checks:
typically destination IP address and TCP port.

## Example

When running on a Linux host, interception will typically be handled,
via an `iptables` `REDIRECT` or `DNAT` rule, as detailed in
[Config Examples: Linux Redirect](/ConfigExamples/Intercept/LinuxRedirect)
or
[Config Examples: Linux DNAT](/ConfigExamples/Intercept/LinuxDnat).

To add an exception allowing direct access to www.example.com, the
iptables configuration example in that page should be changed like this:

    iptables -t nat -N BYPASS
    iptables -t nat -A PREROUTING -s SQUIDIP -p tcp --dport 80 -j ACCEPT
    iptables -t nat -A PREROUTING -p tcp --dport 80 -j BYPASS
    iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 3129
    iptables -t nat -A POSTROUTING -j MASQUERADE

    iptables -t nat -A BYPASS -d www.example.com -j ACCEPT

The **BYPASS** chain is the one performing the transparent interception
bypass. You can grow it as much as you wish appending one line like the
example for every destination host (or network) you wish NOT to
intercept.

For details on setting iptables up and the meaning of the various flags
and options, please see the iptables documentation.

## Problems with this solution

As a side effect, all sites served from the same IP address as
www.example.com, will be directly accessible as well. At this time, this
is an unavoidable side-effect using general-purpose technologies