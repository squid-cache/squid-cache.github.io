**Squid Roadmap**

  - see also the [Schedule for Feature
    Removals](https://wiki.squid-cache.org/RoadMap/RoadMap/Removal#)

# Roadmap rules

To minimize noise and the number of half-baked abandoned features, two
Feature sets are established for Squid development projects: The TODO
List and The Wish List.

  - TODO list  
    TODO list features determine the release focus and timeline. Each
    feature must document their desired effect and estimated development
    time. Each feature must have at least one known active developer
    behind it willing to prioritize the feature and be ready to spend
    the time to fully develop the proposed feature (i.e., write, test,
    document, commit, and provide initial support).

<!-- end list -->

  - Wish List  
    The Wish List accumulates features that do not meet the strict TODO
    List criteria. Many of these features can be implemented if there is
    enough demand or a sponsor. Some may get implemented outside of the
    official process, submitted as patches, and accepted into the
    release.

There are no freezing points in the RoadMap. Instead, the development
version gets branched whenever a reasonable number of features have been
added. One branch gets renumbered and used as ongoing development. The
other for Point Releases made at regular intervals with bug fixes.

All features must pass an auditing process for commit, and any feature
which has passed that review process at time of branching will be
included in the next series of releases.

Features which have not reached completion or have failed the audit, are
automatically delayed to the next Squid series. Which should not be an
unreasonable delay given the fast-track release plan.

## Squid 6

|       |                               |
| ----- | ----------------------------- |
| today | Now in **DEVELOPMENT** cycle. |

The set of new features is determined by submissions and available
developer time. New features may be completed and added at any time.
Features accepted before 2023-02-05 (see
[ReleaseSchedule](https://wiki.squid-cache.org/RoadMap/ReleaseSchedule#))
will be part of this release.

Basic new features in 6.0:

  - **Major UI changes:**
    
      - Remove 8K limit for single access.log line
    
      - Add
        [tls\_key\_log](http://www.squid-cache.org/Doc/config/tls_key_log#)
        to report TLS communication secrets

  - **Minor UI changes:**
    
      - Add %transport::\>connection\_id
        [logformat](http://www.squid-cache.org/Doc/config/logformat#)
        code
    
      - Add
        [paranoid\_hit\_validation](http://www.squid-cache.org/Doc/config/paranoid_hit_validation#)
        directive
    
      - Report SMP store queues state (mgr:store\_queues)
    
      - Add
        [cache\_log\_message](http://www.squid-cache.org/Doc/config/cache_log_message#)
        directive

  - **Developer Interest changes:**
    
      - Replaced X-Cache and X-Cache-Lookup headers with Cache-Status
    
      - Reject HTTP/1.0 requests with unusual framing
    
      - codespell check added to source maintenance enforcement
    
      - Streamlined ./configure handling of optional libraries
    
      - Add --progress option to test-builds.sh
    
      - Remove layer-00-bootstrap from test script
    
      - Convert LRU map into a CLP map
    
      - Remove legacy context-based debugging in favor of
        [CodeContext](https://wiki.squid-cache.org/RoadMap/CodeContext#)

  - **Removed features**:
    
      - Remove unused cache\_diff binary
    
      - Remove obsolete membanger test
    
      - Remove deprecated leakfinder (--enable-leakfinder)

Packages of what will become Squid-6 source code are available at
[](http://www.squid-cache.org/Versions/v6/)

### Security Advisories

See our [Advisories](http://www.squid-cache.org/Advisories/) list.

### Open Bugs

  - [Major or higher bugs currently affecting this
    version](http://bugs.squid-cache.org/buglist.cgi?bug_id_type=anyexact&bug_severity=blocker&bug_severity=critical&bug_severity=major&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&chfieldto=Now&product=Squid&query_format=advanced&columnlist=bug_severity%2Cversion%2Cop_sys%2Cshort_desc&order=version%20DESC%2Cbug_severity%2Cbug_id&o2=equals&v2=unspecified&f1=version&o1=lessthaneq&v1=6).
    
      - Bugs against any older version can be closed if found fixed in
        6.x

<!-- end list -->

  - [Bugs new in this
    version](http://bugs.squid-cache.org/buglist.cgi?query_format=advanced&product=Squid&version=6&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_severity=blocker&bug_severity=critical&bug_severity=major&bug_severity=normal&bug_severity=minor&emailtype1=substring&email1=&emailtype2=substring&email2=&bugidtype=include&columnlist=bug_severity%2Cversion%2Cop_sys%2Cshort_desc&list_id=917&order=version%20DESC%2Cbug_severity%2Cbug_id)

# TODO

These are the features we are trying to work on at present. New features
may be requested, suggested, or added to the plan at any time. Those
which are completed and merged will be in the next formal branch after
their merge date.

# Bug Zapping

  - [Serious
    Bugs](http://bugs.squid-cache.org/buglist.cgi?query_format=advanced&product=Squid&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_severity=blocker&bug_severity=critical&bug_severity=major&bugidtype=include&columnlist=bug_severity%2Cversion%2Cop_sys%2Cshort_desc&list_id=917&order=version%20DESC%2Cbug_severity%2Cbug_id)

<!-- end list -->

  - [General Bug
    Zapping](http://bugs.squid-cache.org/buglist.cgi?query_format=advanced&product=Squid&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_severity=major&bug_severity=normal&bugidtype=include&columnlist=bug_severity%2Cversion%2Cop_sys%2Cshort_desc&list_id=917&order=version%20DESC%2Cbug_severity%2Cbug_id)

<!-- end list -->

  - [Minor
    Bugs](http://bugs.squid-cache.org/buglist.cgi?query_format=advanced&product=Squid&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_severity=minor&bug_severity=trivial&bugidtype=include&columnlist=bug_severity%2Cversion%2Cop_sys%2Cshort_desc&list_id=917&order=version%20DESC%2Cbug_severity%2Cbug_id)

## Features Under Development

Features currently being worked on have a Goal, an ETA, and a Developer
is listed; but Status is not "completed":

  - 1.  Features/
        AclNamespaces
    2.  Features/
        AclRequestStatus
    3.  Features/
        ActAsOrigin
    4.  Features/
        BenchmarkCacheMgrPage
    5.  Features/
        BetterStringBuffer
    6.  Features/
        BrowsableStorage
    7.  Features/
        CacheDirFailover
    8.  Features/
        ClientSideCleanup
    9.  Features/
        ConfigUpdater
    10. Features/
        FasterHttpParser
    11. Features/
        HTTP2
    12. Features/
        HotConf
    13. Features/
        HttpStatusStringsPassThrough
    14. Features/
        InternalRedirectors
    15. Features/
        MemcachedStoreDir
    16. Features/
        ObsoleteOses
    17. Features/
        Optimizations
    18. Features/
        RequestBuffering
    19. Features/
        ServiceOverload
    20. Features/
        Socks
    21. Features/
        SourceLayout

Some feature work saying completed but still having an ETA:

1.  Features/
    CacheMgrRefactor

# Wish List

Wishlist consists of features which have been suggested or requested but
do not yet have a Developer or any contributor listed as willing to see
the feature completed and support it.

Please contact squid-dev and discuss these if you with to take on
development of one.

a Goal, an ETA, and a Developer is listed; but Status is not
"completed":

  - 1.  Features/
        AclMgrAction
    2.  Features/
        AutoCacheDirSizing
    3.  Features/
        ControlChannel
    4.  Features/
        Diagnostics
    5.  Features/
        DumpCallInfoOnCrash
    6.  Features/
        EtagSupport
    7.  Features/
        ExternalRefreshCheck
    8.  Features/
        HelperPause
    9.  Features/
        IcpLoggingAcl
    10. Features/
        Ipv6DelayPool
    11. Features/
        MaxObjectAge
    12. Features/
        MonitorUrl
    13. Features/
        MultipleUnlinkdQueues
    14. Features/
        NetDbForIpv6
    15. Features/
        NoCentralStoreIndex
    16. Features/
        PartialResponsesCaching
    17. Features/
        Quota
    18. Features/
        SimpleWebServer
    19. Features/
        SquidAppliance
    20. Features/
        SrvDnsOriginServerLocation
    21. Features/
        StackableIO
    22. Features/
        StaleWhileRevalidate
    23. Features/
        TCPAccess
    24. Features/
        UrnSupportRemoval
    25. Features/
        VarySupport
    26. Features/
        XvaryOptions

Some beginner
[Tasks](https://wiki.squid-cache.org/RoadMap/RoadMap/Tasks#) which
anyone can help with.

Old Squid-2 wishlist:

  - Variant Invalidation

More ideas are available
[elsewhere](https://wiki.squid-cache.org/RoadMap/WishList#).
