##master-page:CategoryTemplate
#format wiki
#language en

## This is a Feature documentation template. Remove this comment and replace  placeholder questions with the actual information about the feature.

= Feature: TPROXY Update =

 * '''Goal''': Balabit only supports TProxy version 4.1 but in the squid "--enable-tproxy" requires version 2 which is obsolete for a while.

 * '''Status''': Basics Integrated to 3.1. Experimental patches on others.

 * '''ETA''': 30 April, 2008

 * '''Version''': 2.6, 3.0, 3.1

 * '''Developer''': Laszlo Attilla Toth (of Balabit), AmosJeffries, AdrianChadd

 * '''More''': http://www.balabit.com/downloads/files/tproxy/

= Sponsor =

This feature is presently being Sponsored and developed by Balabit.

= Details =
''by Laszlo Attilla Toth''

Current implementation doesn't require kernel support, only a new socket option, IP_TRANSPARENT, also I made a patch which drops "--enable-tproxy" because TProxy 4.1 uses netfilter/iptables (TPROXY target and socket match). If "--enable-linux-netfilter" is used, the "tproxy" option is available for "http_proxy".

It is not yet finished, the squid proxy doesn't bind to the client's address. Furthermore I think it would be better to have a different option for this, and "tproxy" wouldn't imply this.

The patch is available here for 2.6-STABLE18:

 http://www.balabit.com/downloads/files/tproxy/

----
CategoryFeature
