#format wiki
#language en

= Transparent Interception with WCCP =

WCCP is a tunneling method. Since a tunnel could be built using any two devices. The configurations have been broken into endpoint configurations.

=== Router WCCP end-point ===
<<FullSearch(title:regex:^ConfigExamples/Intercept/.*Wccp -title:regex:^ConfigExamples/Intercept/.*Receiver)>>

=== Squid WCCP end-point ===
<<FullSearch(title:regex:^ConfigExamples/Intercept/.*Wccp title:regex:^ConfigExamples/Intercept/.*Receiver)>>

= Transparent Interception by Policy Routing =

Alternative to tunneling. Policy Routing is a method of passing traffic directly to the interceptor unaltered.

<<FullSearch(title:regex:^ConfigExamples/Intercept/.*Route )>>


= Transparent Interception capture into Squid =

Once the packets reach the Squid box they still need passing into Squid. This is done by the NAT infrastructure of the operating system firewall.

<<FullSearch(title:regex:^ConfigExamples/Intercept/ -title:regex:^ConfigExamples/Intercept/.*Wccp -title:regex:^ConfigExamples/Intercept/.*Route )>>

----
CategoryConfigExample
