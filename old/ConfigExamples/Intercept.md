---
categories: [ConfigExample, ReviewMe]
published: false
---
# Traffic Interception with WCCP

WCCP is a forwarding/tunneling method. Since a tunnel could be built
using any two devices the configurations have been separated into
endpoint configurations.

L2 forwarding is best suited for when the proxy is directly connected to
the router, i.e. presists in the same L2-segment of LAN. Since Layer-2
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

## Router WCCP end-point

1.  ConfigExamples/Intercept/Cisco3640Wccp
    2
2.  ConfigExamples/Intercept/CiscoAsaWccp
    2
3.  ConfigExamples/Intercept/CiscoIOSv11Wccp
    1
4.  ConfigExamples/Intercept/CiscoIOSv12Wccp
    1
5.  ConfigExamples/Intercept/CiscoIOSv15Wccp
    2
6.  ConfigExamples/Intercept/CiscoIos1246T2Wccp
    2
7.  ConfigExamples/Intercept/CiscoPixWccp
    2

## Squid WCCP end-point

1.  ConfigExamples/Intercept/FedoraCoreWccp
    2Receiver
2.  ConfigExamples/Intercept/FreeBsdWccp2Receiver

# Traffic Interception by Policy Routing

Alternative to tunneling. Policy Routing is a method of passing traffic
directly to the interceptor unaltered.

1.  ConfigExamples/Intercept/Cisco2501PolicyRoute
2.  ConfigExamples/Intercept/IptablesPolicyRoute
3.  ConfigExamples/Intercept/PfPolicyRoute

# Traffic Interception capture into Squid

Once the packets reach the Squid box they still need passing into Squid.
This is done by the NAT infrastructure of the operating system firewall.

1.  ConfigExamples/Intercept/
    AtSource
2.  ConfigExamples/Intercept/
    CentOsTproxy4
3.  ConfigExamples/Intercept/
    DebianWithRedirectorAndReporting
4.  ConfigExamples/Intercept/
    FreeBsdIpfw
5.  ConfigExamples/Intercept/
    FreeBsdPf
6.  ConfigExamples/Intercept/
    Ipfw
7.  ConfigExamples/Intercept/
    JuniperSRXRoutingPolicy
8.  ConfigExamples/Intercept/
    LinuxBridge
9.  ConfigExamples/Intercept/
    LinuxDnat
10. ConfigExamples/Intercept/
    LinuxIpfwadm
11. ConfigExamples/Intercept/
    LinuxLocalhost
12. ConfigExamples/Intercept/
    LinuxRedirect
13. ConfigExamples/Intercept/
    OpenBsdPf
14. ConfigExamples/Intercept/
    SolarisOpenIndianaIPF
15. ConfigExamples/Intercept/
    SslBumpExplicit
16. ConfigExamples/Intercept/
    SslBumpWithIntermediateCA
17. ConfigExamples/Intercept/
    SslBumpWithIntermediateCA/Discussion

<!-- end list -->

  - [Linux TPROXY Real Transparent Interception (without
    NAT)](/Features/Tproxy4)

[CategoryConfigExample](/CategoryConfigExample)
