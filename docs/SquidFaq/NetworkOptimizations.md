---
categories: ReviewMe
published: false
FaqSection: performance
---
# Using multiple upstream providers

It is possible to balance the network load among different upstream
providers, but cooperation is needed from the host OS and networking
infrastructure. You need to use different `tcp_outgoing_address`es to
mark the packets intended for different upstream providers. You then
need to use policy routing on the host running Squid to correctly route
packets to the correct uplink provider. Some information on how to do it
on Linux systems can be found at
[](http://lukecyca.com/2004/09/28/howto-multirouting-with-linux/).

Back to the
[SquidFaq](/SquidFaq)
