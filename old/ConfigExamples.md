This is a collection of example Squid Configurations intended to
demonstrate the flexibility of Squid.

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

# Online Manuals

We now provide an the Authoritative Configuration Manual for each
version of squid. These manuals are built daily and directly from the
squid source code to provide the most up to date information on squid
options.

For Squid-4 the Manual is at
[](http://www.squid-cache.org/Versions/v4/cfgman/)

For Squid-5 the Manual is at
[](http://www.squid-cache.org/Versions/v5/cfgman/)

A combined Squid Manual can be found at
[](http://www.squid-cache.org/Doc/config/) with details on each option
supported in Squid, and what differences can be encountered between
major Squid releases.

# Current configuration examples

Categories:

## Authentication

[Overview and
explanation](https://wiki.squid-cache.org/ConfigExamples/Features/Authentication#)

1.  ConfigExamples/Authenticate/Bypass
2.  ConfigExamples/Authenticate/Groups
3.  ConfigExamples/Authenticate/Kerberos
4.  ConfigExamples/Authenticate/Ldap
5.  ConfigExamples/Authenticate/LoggingOnly
6.  ConfigExamples/Authenticate/MultipleSources
7.  ConfigExamples/Authenticate/Mysql
8.  ConfigExamples/Authenticate/Ncsa
9.  ConfigExamples/Authenticate/Ntlm
10. ConfigExamples/Authenticate/NtlmCentOS5
11. ConfigExamples/Authenticate/NtlmWithGroups
12. ConfigExamples/Authenticate/Radius
13. ConfigExamples/Authenticate/WindowsActiveDirectory

## Interception

[Overview and
explanation](https://wiki.squid-cache.org/ConfigExamples/ConfigExamples/Intercept#)

[WCCP v1
overview](https://wiki.squid-cache.org/ConfigExamples/Features/Wccp#)

[WCCP v2
overview](https://wiki.squid-cache.org/ConfigExamples/Features/Wccp2#)

1.  ConfigExamples/Intercept/AtSource
2.  ConfigExamples/Intercept/CentOsTproxy4
3.  ConfigExamples/Intercept/Cisco2501PolicyRoute
4.  ConfigExamples/Intercept/Cisco3640Wccp2
5.  ConfigExamples/Intercept/CiscoAsaWccp2
6.  ConfigExamples/Intercept/CiscoIOSv11Wccp1
7.  ConfigExamples/Intercept/CiscoIOSv12Wccp1
8.  ConfigExamples/Intercept/CiscoIOSv15Wccp2
9.  ConfigExamples/Intercept/CiscoIos1246T2Wccp2
10. ConfigExamples/Intercept/CiscoPixWccp2
11. ConfigExamples/Intercept/DebianWithRedirectorAndReporting
12. ConfigExamples/Intercept/FedoraCoreWccp2Receiver
13. ConfigExamples/Intercept/FreeBsdIpfw
14. ConfigExamples/Intercept/FreeBsdPf
15. ConfigExamples/Intercept/FreeBsdWccp2Receiver
16. ConfigExamples/Intercept/Ipfw
17. ConfigExamples/Intercept/IptablesPolicyRoute
18. ConfigExamples/Intercept/JuniperSRXRoutingPolicy
19. ConfigExamples/Intercept/LinuxBridge
20. ConfigExamples/Intercept/LinuxDnat
21. ConfigExamples/Intercept/LinuxIpfwadm
22. ConfigExamples/Intercept/LinuxLocalhost
23. ConfigExamples/Intercept/LinuxRedirect
24. ConfigExamples/Intercept/OpenBsdPf
25. ConfigExamples/Intercept/PfPolicyRoute
26. ConfigExamples/Intercept/SolarisOpenIndianaIPF
27. ConfigExamples/Intercept/SslBumpExplicit
28. ConfigExamples/Intercept/SslBumpWithIntermediateCA

## Content Adaptation features

[Overview and
explanation](https://wiki.squid-cache.org/ConfigExamples/SquidFaq/ContentAdaptation#)

[ICAP
overview](https://wiki.squid-cache.org/ConfigExamples/Features/ICAP#)

[eCAP
overview](https://wiki.squid-cache.org/ConfigExamples/Features/eCAP#)

1.  ConfigExamples/ContentAdaptation/C-ICAP
2.  ConfigExamples/ContentAdaptation/eCAP

## Caching

1.  ConfigExamples/Caching/AdobeProducts
2.  ConfigExamples/Caching/CachingAVUpdates
3.  ConfigExamples/Caching/WindowsUpdates

## Captive Portal features

1.  ConfigExamples/Portal/Splash
2.  ConfigExamples/Portal/ZeroConfUpgrade

## Reverse Proxy (Acceleration)

1.  ConfigExamples/Reverse/BasicAccelerator
2.  ConfigExamples/Reverse/ExchangeRpc
3.  ConfigExamples/Reverse/HttpsVirtualHosting
4.  ConfigExamples/Reverse/MultipleWebservers
5.  ConfigExamples/Reverse/OutlookWebAccess
6.  ConfigExamples/Reverse/SslWithWildcardCertifiate
7.  ConfigExamples/Reverse/VirtualHosting

## Instant Messaging / Chat Program filtering

[Overview and
explanation](https://wiki.squid-cache.org/ConfigExamples/ConfigExamples/Chat#)

1.  ConfigExamples/Chat/FacebookMessenger
2.  ConfigExamples/Chat/Gizmo
3.  ConfigExamples/Chat/Signal
4.  ConfigExamples/Chat/Skype
5.  ConfigExamples/Chat/Telegram
6.  ConfigExamples/Chat/Viber
7.  ConfigExamples/Chat/Whatsapp
8.  ConfigExamples/Chat/Wire
9.  ConfigExamples/Chat/YahooMessenger

## Multimedia and Data Stream filtering

1.  ConfigExamples/Streams/Other
2.  ConfigExamples/Streams/RealAudio
3.  ConfigExamples/Streams/Vimeo
4.  ConfigExamples/Streams/YouTube

## Torrent Filtering

  - ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    Torrent filtering is not simple task and can't be done using Squid's
    only. It uses arbitrary ports, protocols and transport. You must
    also use active network equipment and some experience.

[ConfigExamples/TorrentFiltering](https://wiki.squid-cache.org/ConfigExamples/ConfigExamples/TorrentFiltering#)

## SMP (Symmetric Multiprocessing) configurations

  - ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    Squid SMP support is an ongoing series of improvements in
    [Squid-3.2](https://wiki.squid-cache.org/ConfigExamples/Squid-3.2#)
    and later. The configuration here may not be exactly up to date. Or
    may require you install a newer release.

<!-- end list -->

1.  ConfigExamples/SmpCarpCluster

## High Performance service

1.  ConfigExamples/ExtremeCarpFrontend

see also [WCCP v2
overview](https://wiki.squid-cache.org/ConfigExamples/Features/Wccp2#)
for high-availability service.

## General

1.  ConfigExamples/BlockingMimeTypes
2.  ConfigExamples/ChrootJail
3.  ConfigExamples/ClusteringTproxySquid
4.  ConfigExamples/CoinMiners
5.  ConfigExamples/DynamicContent
6.  ConfigExamples/DynamicContent/Coordinator
7.  ConfigExamples/FullyTransparentWithTPROXY
8.  ConfigExamples/MultiCpuSystem
9.  ConfigExamples/MultiplePortsWithWccp2
10. ConfigExamples/NatAndWccp2
11. ConfigExamples/PhpRedirectors
12. ConfigExamples/SquidAndWccp2
13. ConfigExamples/UbuntuTproxy4Wccp2
14. ConfigExamples/Wccp2AndNat
15. ConfigExamples/WebwasherChained

## Strange and Weird configurations

This is a section for weird (and sometimes wonderful) configurations
Squid is capable of. Clued in admin often find no actual useful benefits
from going to this much trouble, but well, people seems to occasionally
ask for them...

1.  ConfigExamples/Strange/BlockingTLD
2.  ConfigExamples/Strange/RotatingIPs
3.  ConfigExamples/Strange/TorifiedSquid

# External configuration examples

\* [](http://freshmeat.net/articles/view/1433/) - Configuring a
Transparent Proxy/Webcache in a Bridge using Squid and ebtables (Jan
1st, 2005)

# Create new configuration example

Choose a good
[WikiName](https://wiki.squid-cache.org/ConfigExamples/WikiName#) for
your new example and enter it here:

[CategoryConfigExample](https://wiki.squid-cache.org/ConfigExamples/CategoryConfigExample#)
