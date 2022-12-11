---
categories: ReviewMe
published: false
---
# Squid Roadmap

* [Schedule for Feature Removals](/RoadMap/Removal)
* [WantedFeatures](/Categories/WantedFeature)
* some beginner [Tasks](/RoadMap/Tasks) which anyone can help with.

## Roadmap rules

To minimize noise and the number of half-baked abandoned features, two
Feature sets are established for Squid development projects: The TODO
List and The Wish List.

* TODO list 
    TODO list features determine the release focus and timeline. Each
    feature must document their desired effect and estimated development
    time. Each feature must have at least one known active developer
    behind it willing to prioritize the feature and be ready to spend
    the time to fully develop the proposed feature (i.e., write, test,
    document, commit, and provide initial support).
* Wish List  
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

> Now in **DEVELOPMENT** cycle.

The set of new features is determined by submissions and available
developer time. New features may be completed and added at any time.
Features accepted before 2023-02-05 (see [ReleaseSchedule](/ReleaseSchedule))
will be part of this release.

New features in 6.0:
- **Major UI changes:**
    - Remove 8K limit for single access.log line
    - Add [tls_key_log](http://www.squid-cache.org/Doc/config/tls_key_log)
        to report TLS communication secrets
- **Minor UI changes:**
    - Add %transport::\>connection_id
    [logformat](http://www.squid-cache.org/Doc/config/logformat) code
    - Add
    [paranoid_hit_validation](http://www.squid-cache.org/Doc/config/paranoid_hit_validation)
    directive
    - Report SMP store queues state (mgr:store_queues)
    - Add
        [cache_log_message](http://www.squid-cache.org/Doc/config/cache_log_message)
        directive
- **Developer Interest changes:**
    - Replaced X-Cache and X-Cache-Lookup headers with Cache-Status
    - Reject HTTP/1.0 requests with unusual framing
    - codespell check added to source maintenance enforcement
    - Streamlined ./configure handling of optional libraries
    - Add --progress option to test-builds.sh
    - Remove layer-00-bootstrap from test script
    - Convert LRU map into a CLP map
    - Remove legacy context-based debugging in favor of CodeContext

- **Removed features**:
    - Remove unused cache_diff tool
    - Remove obsolete membanger test
    - Remove deprecated leakfinder (--enable-leakfinder)

Packages of what will become Squid-6 source code are available at
<http://www.squid-cache.org/Versions/v6/>

### Security Advisories

See our [Advisories](http://www.squid-cache.org/Advisories/) list.

### Open Bugs

* [Major or higher bugs currently affecting this version](http://bugs.squid-cache.org/buglist.cgi?bug_id_type=anyexact&bug_severity=blocker&bug_severity=critical&bug_severity=major&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&chfieldto=Now&product=Squid&query_format=advanced&columnlist=bug_severity%2Cversion%2Cop_sys%2Cshort_desc&order=version%20DESC%2Cbug_severity%2Cbug_id&o2=equals&v2=unspecified&f1=version&o1=lessthaneq&v1=6)
* [Bugs new in this version](http://bugs.squid-cache.org/buglist.cgi?query_format=advanced&product=Squid&version=6&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_severity=blocker&bug_severity=critical&bug_severity=major&bug_severity=normal&bug_severity=minor&emailtype1=substring&email1=&emailtype2=substring&email2=&bugidtype=include&columnlist=bug_severity%2Cversion%2Cop_sys%2Cshort_desc&list_id=917&order=version%20DESC%2Cbug_severity%2Cbug_id)
* [Serious Bugs](http://bugs.squid-cache.org/buglist.cgi?query_format=advanced&product=Squid&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_severity=blocker&bug_severity=critical&bug_severity=major&bugidtype=include&columnlist=bug_severity%2Cversion%2Cop_sys%2Cshort_desc&list_id=917&order=version%20DESC%2Cbug_severity%2Cbug_id)
* [General Bug Zapping](http://bugs.squid-cache.org/buglist.cgi?query_format=advanced&product=Squid&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_severity=major&bug_severity=normal&bugidtype=include&columnlist=bug_severity%2Cversion%2Cop_sys%2Cshort_desc&list_id=917&order=version%20DESC%2Cbug_severity%2Cbug_id)
* [Minor Bugs](http://bugs.squid-cache.org/buglist.cgi?query_format=advanced&product=Squid&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_severity=minor&bug_severity=trivial&bugidtype=include&columnlist=bug_severity%2Cversion%2Cop_sys%2Cshort_desc&list_id=917&order=version%20DESC%2Cbug_severity%2Cbug_id)
