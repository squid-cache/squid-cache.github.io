# Squid Web Cache FAQ Table of Contents

  - [/FaqIndex](/SquidFaq/FaqIndex)
    contains the detailed list of covered topics

  - [/AboutSquid](/SquidFaq/AboutSquid)
    is about squid itself and the people behind it

  - [/InnerWorkings](/SquidFaq/InnerWorkings):
    a few insights into squid and its underlying logic

## Installation and Use

  - [/BinaryPackages](/SquidFaq/BinaryPackages)
    describes how to easily install official packages for some OS

  - [/CompilingSquid](/SquidFaq/CompilingSquid)
    describes how to compile the software

  - [/InstallingSquid](/SquidFaq/InstallingSquid)
    no use in compiling without installing, right?

  - [/ConfiguringSquid](/SquidFaq/ConfiguringSquid)
    how to configure squid, especially regarding cache relationships and
    IRCache

  - [/SecurityPitfalls](/SquidFaq/SecurityPitfalls):
    common security problems in new setups

  - [/ConfiguringBrowsers](/SquidFaq/ConfiguringBrowsers):
    how to tell the most common browsers that they should be using a
    proxy

  - [/OperatingSquid](/SquidFaq/OperatingSquid):
    how to perform various tasks on squid and its cache

# Modes

  - Explicit Proxy (or Forward Proxy) is the basic mode, upon which
    everything else is built.

  - [/InterceptionProxy](/SquidFaq/InterceptionProxy)
    or how to run a proxy without your users knowing (mostly)

  - [/ReverseProxy](/SquidFaq/ReverseProxy)
    or Accelerator-mode: running Squid to improve a webserver pool's
    performance

  - *Offline* or aggressive mode: serving up stale data with minimal
    network usage

  - ESI processor (or ESI surrogate): Assembling web pages. This is a
    sub-type of accelerator mode which since
    [Squid-3.3](/Releases/Squid-3.3)
    is enabled automatically and cannot be used with other modes.

## Troubleshooting

  - [/OrderIsImportant](/SquidFaq/OrderIsImportant).
    The most common mistake ever made is to overlook this. Even experts
    do it.

  - [/TroubleShooting](/SquidFaq/TroubleShooting)
    gives a few hints on what to do when squid fails or misbehaves

  - [KnowledgeBase](/KnowledgeBase):
    Covers how things are supposed to work and what to look out for.
    
      - Includes specific help guides for supported operating systems.

  - [ConfigExamples](/ConfigExamples):
    Gives detailed configurations in case you have missed something

  - [/SystemWeirdnesses](/SquidFaq/SystemWeirdnesses)
    shows how to expect some operating-system-dependent unexpected
    behaviors

  - [/ToomanyMisses](/SquidFaq/ToomanyMisses):
    why more than just a few TCP_SWAPFAIL_MISS

  - [/WindowsUpdate](/SquidFaq/WindowsUpdate):
    configuring squid to pass Windows Update

  - [/ChromebookUpdate](/SquidFaq/ChromebookUpdate):
    configuring squid to pass ChromeOS Updates

  - [/AddACacheDir](/SquidFaq/AddACacheDir):
    hints on how to increase a cache's capacity

  - [/ClearingTheCache](/SquidFaq/ClearingTheCache):
    how to wipe your entire disk cache in one easy step

  - [/RAID](/SquidFaq/RAID):
    Why Squid and RAID play nasty together and what to do about it.

  - [/BugReporting](/SquidFaq/BugReporting):
    if all else fails, how to report bugs to the Squid team.

# Performance Tuning

  - [/SystemSpecificOptimizations](/SquidFaq/SystemSpecificOptimizations)
    has a few OS-specific tips for performance tuning

  - [/SquidProfiling](/SquidFaq/SquidProfiling)
    How to identify obvious resource shortages with Squid (A work in
    progress)

  - [/NetworkOptimizations](/SquidFaq/NetworkOptimizations)

# Features

  - [/SquidLogs](/SquidFaq/SquidLogs):
    writing and most important **reading** the various squid log files

  - [/SquidMemory](/SquidFaq/SquidMemory)
    describes how squid uses RAM and how to optimize its usage

  - [/SquidAcl](/SquidFaq/SquidAcl)
    (or Authorization): controlling squid's powerful access control
    features

  - [/ContentAdaptation](/SquidFaq/ContentAdaptation)
    how to analyze, capture, block, replace, or modify the messages
    being proxied

  - [/CacheDigests](/SquidFaq/CacheDigests)
    or ICP on steroids

  - [/MiscFeatures](/SquidFaq/MiscFeatures):
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

  - [/RelatedSoftware](/SquidFaq/RelatedSoftware)

  - [/OtherResources](/SquidFaq/OtherResources):
    articles on other sites (HOWTOs or samples of specific setups)

  - [/TermIndex](/SquidFaq/TermIndex):
    glossary of common terms

  - [/CompleteFaq](/SquidFaq/CompleteFaq)
    is a meta-document with the entire FAQ contents.
