# Squid 6

|       |                               |
| ----- | ----------------------------- |
| current | Now in **DEVELOPMENT** cycle. |
| | |

The set of new features is determined by submissions and available
developer time. New features may be completed and added at any time.
Features accepted before 2023-02-05 (see
[ReleaseSchedule](/ReleaseSchedule)) will be part of this release.

## Basic new features in 6.0:
  - **Major UI changes:**
      - Remove 8K limit for single access.log line
      - Add
        [tls_key_log](http://www.squid-cache.org/Doc/config/tls_key_log) to report TLS communication secrets
  - **Minor UI changes:**
      - Add %transport::>connection_id
        [logformat](http://www.squid-cache.org/Doc/config/logformat)
        code
      - Add
        [paranoid_hit_validation](http://www.squid-cache.org/Doc/config/paranoid_hit_validation)
        directive
      - Report SMP store queues state (mgr:store_queues)
      - Add[cache_log_message](http://www.squid-cache.org/Doc/config/cache_log_message)
        directive
  - **Developer Interest changes:**
      - Replaced X-Cache and X-Cache-Lookup headers with Cache-Status
      - Reject HTTP/1.0 requests with unusual framing
      - codespell check added to source maintenance enforcement
      - Streamlined ./configure handling of optional libraries
      - Add --progress option to test-builds.sh
      - Remove layer-00-bootstrap from test script
      - Convert LRU map into a CLP map
      - Remove legacy context-based debugging in favor of _CodeContext_
  - **Removed features**:
      - Remove unused cache_diff binary
      - Remove obsolete membanger test
      - Remove deprecated leakfinder (--enable-leakfinder)

Packages of what will become Squid-6 source code are available at
http://www.squid-cache.org/Versions/v6/

## Security Advisories

See our [Advisories](http://www.squid-cache.org/Advisories/) list.

## Open Bugs

  - [Major or higher bugs currently affecting this
    version](http://bugs.squid-cache.org/buglist.cgi?bug_id_type=anyexact&bug_severity=blocker&bug_severity=critical&bug_severity=major&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&chfieldto=Now&product=Squid&query_format=advanced&columnlist=bug_severity%2Cversion%2Cop_sys%2Cshort_desc&order=version%20DESC%2Cbug_severity%2Cbug_id&o2=equals&v2=unspecified&f1=version&o1=lessthaneq&v1=6).

      - Bugs against any older version can be closed if found fixed in
        6.x

<!-- end list -->

  - [Bugs new in this
    version](http://bugs.squid-cache.org/buglist.cgi?query_format=advanced&product=Squid&version=6&bug_status=UNCONFIRMED&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&bug_severity=blocker&bug_severity=critical&bug_severity=major&bug_severity=normal&bug_severity=minor&emailtype1=substring&email1=&emailtype2=substring&email2=&bugidtype=include&columnlist=bug_severity%2Cversion%2Cop_sys%2Cshort_desc&list_id=917&order=version%20DESC%2Cbug_severity%2Cbug_id)
