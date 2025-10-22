---
categories: [ConfigExample]
---
# Traffic Interception with WCCP

WCCP is a forwarding/tunneling method. Since a tunnel could be built
using any two devices the configurations have been separated into
endpoint configurations.

L2 forwarding is best suited for when the proxy is directly connected to
the router, i.e. persists in the same L2-segment of LAN. Since Layer-2
is a level below TCP/IP it can be treated as equivalent to *Policy
Routing* at the IP layer (the difference is PBR is executes on CPU,
against true L2 WCCP forwarding, which often executes on control plane
level) and requires only routing configuration on the receiving proxy
machine. Also note, L2 forwarding most often hardware accelerated and
has no additional overhead (because uses L2 header re-writes without
increasing packet), so it has best performance in most cases.

GRE tunneling is suitable for setups where the packets need to traverse
multiple other devices (hops) before reaching the proxy. This requires a
GRE interface configured on the receiving proxy to decapsulate the
tunnel in addition to routing configuration on the receiving proxy
machine.

Some older Cisco device types (notably ASA) place additional limitations
on which method they support. Recent IOS versions may expand them to
allow either method - or may not, check your Cisco device documentation
carefully.

## Catalog of use cases

{% include pages-list-by-path.html dir='ConfigExamples/Intercept/' -%}
* [Linux TPROXY Real Transparent Interception (without NAT)](/Features/Tproxy4)
