#format wiki
#language en

<<TableOfContents>>

= Traffic Interception with WCCP =

WCCP is a redirection method. Since a channel could be built using any two devices. The configurations have been broken into endpoint configurations. WCCP can use tunneling method (GRE), but this method is not hardware-accelerated and break network and routing rules.

=== Router WCCP end-point ===
<<FullSearch(title:regex:^ConfigExamples/Intercept/.*Wccp -title:regex:^ConfigExamples/Intercept/.*Receiver)>>

=== Squid WCCP end-point ===
<<FullSearch(title:regex:^ConfigExamples/Intercept/.*Wccp title:regex:^ConfigExamples/Intercept/.*Receiver)>>

= Traffic Interception by Policy Routing =

Alternative to tunneling. Policy Routing is a method of passing traffic directly to the interceptor unaltered.

<<FullSearch(title:regex:^ConfigExamples/Intercept/.*Route )>>


= Traffic Interception capture into Squid =

Once the packets reach the Squid box they still need passing into Squid. This is done by the NAT infrastructure of the operating system firewall.

<<FullSearch(title:regex:^ConfigExamples/Intercept/ -title:regex:^ConfigExamples/Intercept/.*Wccp -title:regex:^ConfigExamples/Intercept/.*Route )>>

 * [[../../Features/Tproxy4|Linux TPROXY Real Transparent Interception (without NAT)]]

----
CategoryConfigExample
