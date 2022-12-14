---
categories: [ConfigExample]
---
# Policy Routing web traffic on a Cisco 2501 Router

  - *by Brian Feeny*

## Outline

Here is how I have Interception proxying working for me, in an
environment where my router is a Cisco 2501 running IOS 11.1.

You also need to configure the squid machine to handle the traffic it
receives. See [ConfigExamples/Intercept](/ConfigExamples/Intercept)
for details on configuring the rest.

## Cisco Configuration

> :warning:
    Replace SQUIDIP in the following with the IP address of your Squid
    host.
    :warning:
    Replace ROUTERIP in the following with the IP address of your
    Router.

In IOS 11.1 the route-map command is "process switched" as opposed to
the faster "fast-switched" route-map which is found in IOS 11.2 and
later. Even more recent versions CEF switch for much better performance.

    !
    interface Ethernet0
     description To Office Ethernet
     ip address ROUTERIP 255.255.255.0
     no ip directed-broadcast
     no ip mroute-cache
     ip policy route-map proxy-redir
    !
    access-list 110 deny   tcp host SQUIDIP any eq www
    access-list 110 permit tcp any any eq www
    route-map proxy-redir permit 10
     match ip address 110
     set ip next-hop SQUIDIP

So basically from above you can see I added the "route-map" declaration,
and an access-list, and then turned the route-map on under int e0 "ip
policy route-map proxy-redir" The host above: SQUIDIP, is the ip number
of my squid host.

## Thanks

Many thanks to the following individuals and the squid-users list for
helping me get redirection and interception proxying working on my
Cisco/Linux box.

  - Lincoln Dale
  - Riccardo Vratogna
  - Mark White
  - [HenrikNordström](/HenrikNordstrom)
