# Squid Web Cache FAQ Table of Contents

  - [/FaqIndex](https://wiki.squid-cache.org/SquidFaq/SquidFaq/FaqIndex#)
    contains the detailed list of covered topics

  - [/AboutSquid](https://wiki.squid-cache.org/SquidFaq/SquidFaq/AboutSquid#)
    is about squid itself and the people behind it

  - [/InnerWorkings](https://wiki.squid-cache.org/SquidFaq/SquidFaq/InnerWorkings#):
    a few insights into squid and its underlying logic

## Installation and Use

  - [/BinaryPackages](https://wiki.squid-cache.org/SquidFaq/SquidFaq/BinaryPackages#)
    describes how to easily install official packages for some OS

  - [/CompilingSquid](https://wiki.squid-cache.org/SquidFaq/SquidFaq/CompilingSquid#)
    describes how to compile the software

  - [/InstallingSquid](https://wiki.squid-cache.org/SquidFaq/SquidFaq/InstallingSquid#)
    no use in compiling without installing, right?

  - [/ConfiguringSquid](https://wiki.squid-cache.org/SquidFaq/SquidFaq/ConfiguringSquid#)
    how to configure squid, especially regarding cache relationships and
    IRCache

  - [/SecurityPitfalls](https://wiki.squid-cache.org/SquidFaq/SquidFaq/SecurityPitfalls#):
    common security problems in new setups

  - [/ConfiguringBrowsers](https://wiki.squid-cache.org/SquidFaq/SquidFaq/ConfiguringBrowsers#):
    how to tell the most common browsers that they should be using a
    proxy

  - [/OperatingSquid](https://wiki.squid-cache.org/SquidFaq/SquidFaq/OperatingSquid#):
    how to perform various tasks on squid and its cache

# Modes

  - Explicit Proxy (or Forward Proxy) is the basic mode, upon which
    everything else is built.

  - [/InterceptionProxy](https://wiki.squid-cache.org/SquidFaq/SquidFaq/InterceptionProxy#)
    or how to run a proxy without your users knowing (mostly)

  - [/ReverseProxy](https://wiki.squid-cache.org/SquidFaq/SquidFaq/ReverseProxy#)
    or Accelerator-mode: running Squid to improve a webserver pool's
    performance

  - *Offline* or aggressive mode: serving up stale data with minimal
    network usage

  - ESI processor (or ESI surrogate): Assembling web pages. This is a
    sub-type of accelerator mode which since
    [Squid-3.3](https://wiki.squid-cache.org/SquidFaq/Squid-3.3#) is
    enabled automatically and cannot be used with other modes.

## Troubleshooting

  - [/OrderIsImportant](https://wiki.squid-cache.org/SquidFaq/SquidFaq/OrderIsImportant#).
    The most common mistake ever made is to overlook this. Even experts
    do it.

  - [/TroubleShooting](https://wiki.squid-cache.org/SquidFaq/SquidFaq/TroubleShooting#)
    gives a few hints on what to do when squid fails or misbehaves

  - [KnowledgeBase](https://wiki.squid-cache.org/SquidFaq/KnowledgeBase#):
    Covers how things are supposed to work and what to look out for.
    
      - Includes specific help guides for supported operating systems.

  - [ConfigExamples](https://wiki.squid-cache.org/SquidFaq/ConfigExamples#):
    Gives detailed configurations in case you have missed something

  - [/SystemWeirdnesses](https://wiki.squid-cache.org/SquidFaq/SquidFaq/SystemWeirdnesses#)
    shows how to expect some operating-system-dependent unexpected
    behaviors

  - [/ToomanyMisses](https://wiki.squid-cache.org/SquidFaq/SquidFaq/ToomanyMisses#):
    why more than just a few TCP\_SWAPFAIL\_MISS

  - [/WindowsUpdate](https://wiki.squid-cache.org/SquidFaq/SquidFaq/WindowsUpdate#):
    configuring squid to pass Windows Update

  - [/ChromebookUpdate](https://wiki.squid-cache.org/SquidFaq/SquidFaq/ChromebookUpdate#):
    configuring squid to pass ChromeOS Updates

  - [/AddACacheDir](https://wiki.squid-cache.org/SquidFaq/SquidFaq/AddACacheDir#):
    hints on how to increase a cache's capacity

  - [/ClearingTheCache](https://wiki.squid-cache.org/SquidFaq/SquidFaq/ClearingTheCache#):
    how to wipe your entire disk cache in one easy step

  - [/RAID](https://wiki.squid-cache.org/SquidFaq/SquidFaq/RAID#): Why
    Squid and RAID play nasty together and what to do about it.

  - [/BugReporting](https://wiki.squid-cache.org/SquidFaq/SquidFaq/BugReporting#):
    if all else fails, how to report bugs to the Squid team.

# Performance Tuning

  - [/SystemSpecificOptimizations](https://wiki.squid-cache.org/SquidFaq/SquidFaq/SystemSpecificOptimizations#)
    has a few OS-specific tips for performance tuning

  - [/SquidProfiling](https://wiki.squid-cache.org/SquidFaq/SquidFaq/SquidProfiling#)
    How to identify obvious resource shortages with Squid (A work in
    progress)

  - [/NetworkOptimizations](https://wiki.squid-cache.org/SquidFaq/SquidFaq/NetworkOptimizations#)

# Features

  - [/SquidLogs](https://wiki.squid-cache.org/SquidFaq/SquidFaq/SquidLogs#):
    writing and most important **reading** the various squid log files

  - [/SquidMemory](https://wiki.squid-cache.org/SquidFaq/SquidFaq/SquidMemory#)
    describes how squid uses RAM and how to optimize its usage

  - [/SquidAcl](https://wiki.squid-cache.org/SquidFaq/SquidFaq/SquidAcl#)
    (or Authorization): controlling squid's powerful access control
    features

  - [/ContentAdaptation](https://wiki.squid-cache.org/SquidFaq/SquidFaq/ContentAdaptation#)
    how to analyze, capture, block, replace, or modify the messages
    being proxied

  - [/CacheDigests](https://wiki.squid-cache.org/SquidFaq/SquidFaq/CacheDigests#)
    or ICP on steroids

  - [/MiscFeatures](https://wiki.squid-cache.org/SquidFaq/SquidFaq/MiscFeatures#):
    Squid 2.X miscellaneous features

<!-- end list -->

1.  Features/
    AclRandom
2.  Features/
    AdaptationChain
3.  Features/
    AdaptationLog
4.  Features/
    AddonHelpers
5.  Features/
    Authentication
6.  Features/
    BearerAuthentication
7.  Features/
    CacheHierarchy
8.  Features/
    CacheManager
9.  Features/
    ClientBandwidthLimit
10. Features/
    CodeTestBed
11. Features/
    CollapsedForwarding
12. Features/
    ConfigIncludes
13. Features/
    ConnPin
14. Features/
    CustomErrors
15. Features/
    CyclicObjectStorageSystem
16. Features/
    DelayPools
17. Features/
    DiskDaemon
18. Features/
    Dnsserver
19. Features/
    DynamicSslCert
20. Features/
    EDNS
21. Features/
    Gzip
22. Features/
    HTTPS
23. Features/
    HelperMultiplexer
24. Features/
    ICAP
25. Features/
    IPv6
26. Features/
    LoadBalance
27. Features/
    LogFormat
28. Features/
    LogModules
29. Features/
    MultiCast
30. Features/
    NegotiateAuthentication
31. Features/
    QualityOfService
32. Features/
    Redirectors
33. Features/
    RockStore
34. Features/
    SHTTP
35. Features/
    Snmp
36. Features/
    SslBump
37. Features/
    Surrogate
38. Features/
    Tproxy4
39. Features/
    Wccp
40. Features/
    Wccp2
41. Features/
    eCAP

# Other FAQ

  - [/RelatedSoftware](https://wiki.squid-cache.org/SquidFaq/SquidFaq/RelatedSoftware#)

  - [/OtherResources](https://wiki.squid-cache.org/SquidFaq/SquidFaq/OtherResources#):
    articles on other sites (HOWTOs or samples of specific setups)

  - [/TermIndex](https://wiki.squid-cache.org/SquidFaq/SquidFaq/TermIndex#):
    glossary of common terms

  - [/CompleteFaq](https://wiki.squid-cache.org/SquidFaq/SquidFaq/CompleteFaq#)
    is a meta-document with the entire FAQ contents.
