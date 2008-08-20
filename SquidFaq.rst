#language en
## add some descriptive text. A title is not necessary as the WikiPageName is already added here.
## if you want to have a table of comments remove the heading hashes from the next line
## [[TableOfContents]]

= Squid Web Cache FAQ Table of Contents =
 * /FaqIndex contains the detailed list of covered topics
 * /AboutSquid is about squid itself and the people behind it
 * /InnerWorkings: a few insights into squid and its underlying logic

===== Installation and Use =====
 * /CompilingSquid describes how to compile the software
 * /InstallingSquid no use in compiling without installing, right?
 * /ConfiguringSquid how to configure squid, especially regarding cache relationships and IRCache
 * /SecurityPitfalls: common security problems in new setups
 * /ConfiguringBrowsers: how to tell the most common browsers that they should be using a proxy
 * /OperatingSquid: how to perform various tasks on squid and its cache
 * /AddACacheDir: hints on how to increase a cache's capacity
 * /ClearingTheCache

===== Troubleshooting =====
 * /TroubleShooting gives a few hints on what to do when squid fails or misbehaves
 * /SystemWeirdnesses shows how to expect some operating-system-dependent unexpected behaviors
 * /ToomanyMisses: why more than just a few TCP_SWAPFAIL_MISS
 * /WindowsUpdate: configuring squid to pass Windows Update
 * /ClearingTheCache: how to wipe your entire disk cache in one easy step
 * [[/RAID]]: Why Squid and RAID play nasty together and what to do about it.

==== Performance Tuning ====
 * /SystemSpecificOptimizations has a few OS-specific tips for performance tuning
 * /DiskDaemon: what it is and how to optimize its running environment
 * /SquidProfiling How to identify obvious resource shortages with Squid (A work in progress)
 * /NetworkOptimizations

==== Features ====
 * /ProxyAuthentication: how to authenticate your users (mostly against MS Windows domains)
 * /SquidLogs: writing and most important '''reading''' the various squid log files
 * /SquidMemory describes how squid uses RAM and how to optimize its usage
 * /CacheManager explains how to use the Cache Manager to profile how squid is working
 * /SquidAcl (or Authorization): controlling squid's powerful access control features
 * /ContentAdaptation how to analyze, capture, block, replace, or modify the messages being proxied
 * /MultiCast explains how to set squid ICP up in a multicast environment
 * /SquidRedirectors explains how to tap into Squid's powerful ''redirector'' API
 * /CacheDigests or ICP on steroids
 * /SquidSnmp: using SNMP to monitor Squid's vital signs
 * /CyclicObjectStorageSystem or COSS: how to use it to optimize speed on small objects
 * /MiscFeatures: Squid 2.X miscellaneous features

==== Modes ====
 * /InterceptionProxy or how to run a proxy without your users knowing (mostly)
 * /ReverseProxy or Accelerator-mode: running Squid to improve a webserver pool's performance

==== Other FAQ ====
 * /RelatedSoftware
 * /OtherResources: articles on other sites (HOWTOs or samples of specific setups)
 * /TermIndex: glossary of common terms
 * /CompleteFaq is a meta-document with the entire FAQ contents.
