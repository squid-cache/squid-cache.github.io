See [Discussed
Page](https://wiki.squid-cache.org/Features/Tproxy4/Discussion/Features/Tproxy4#)

There ebtables settings that was mentioned at:
[](http://wiki.squid-cache.org/ConfigExamples/Intercept/DebianWithRedirectorAndReporting?highlight=%28ebtables%29)
are in contradiction to this page regarding the action of the ebtables
rules. What should it be in order to make the bridged packets from the
LAN to go into the iptables plane? ACCEPT or DROP?

\-- [Eliezer
Croitoru](https://wiki.squid-cache.org/Features/Tproxy4/Discussion/Eliezer%20Croitoru#)

**DROP** is the correct target action. The semantics of ebtables rules
are that it either ACCEPTS the packet (delivering it **over the bridge**
to the remote machine) or DROPS it out into the local machine for
routing by iptables.

See the *--redirect-target* description in
[](http://linux.die.net/man/8/ebtables) - "Making it DROP in the
BROUTING chain will let the frames be routed."

There are however some strange combo of bugs in the kernel TCP stack,
combined with various misconfigured settings where the ACCEPT can have
the appearance of working. But the packets are in fact bouncing around,
potentially over the network off the remote machines interfaces and kind
of *echoing* back at Squid. That is of course quite bad for performance,
reliability, security, privacy, etc.

\--
[AmosJeffries](https://wiki.squid-cache.org/Features/Tproxy4/Discussion/AmosJeffries#)
