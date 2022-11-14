# Feature: Quota control

  - **Goal**: Better quota controls

  - **Status**: *Not started*

  - **ETA**: *unknown*

  - **Version**: Squid 3.2 or 3.3

  - **Developer**:

  - **More**: [squid-dev
    thread](http://www.squid-cache.org/mail-archive/squid-dev/200902/0138.html)

  - **Related Bugs**:
    
      - [1849](https://bugs.squid-cache.org/show_bug.cgi?id=1849#)
        (policy helper feature)

## Description

Squid needs better interface to control quotas. The existing approaches
to quota control require the use of external ACLs or redirectors. The
external helpers are only contacted at the start of the request and need
to work with information given only at the end of the request. Due to
these limitations, users may go significantly over their quota before
Squid reacts.

### Bandwidth Quotas

The external helpers need to process access.log to calculate the
bandwidth usage. Which limits accuracy in the worst-case with large and
long duration requests.

Also, external helpers cannot do traffic shaping (i.e., slowing down the
transfer instead of denying the request). It is not yet clear whether a
single interface should serve both purposes.

**Update:**

  - With TCP logging a helper can be written to account log information
    live and maintain any external accounting or traffic needed to
    maintain quota limits. An internal accounting pool is still needed
    per client to maintain limits on active requests.

### Time Quotas

The external helpers need to process permission at the start of the
request based on relation to earlier requests. Duration of the requests
themselves are not accounted. Long-polling in particular (such as chat
sessions over HTTP) may bypass the quota controls.

  - The `ext_session_acl` helper version 1.1 adds support for
    fixed-length sessions. Emulating a time quota within which new
    requests may be made. Long requests may continue outside this
    period, but no new requests may start without a new session being
    permitted.

  - ext\_time\_quota\_acl helper added with
    [Squid-3.3](/Releases/Squid-3.3#)
    allows an allocated period of time which is consumed as requests are
    made. Configurable long periods with no requests can be eliminated
    from the consumption.

[CategoryFeature](/CategoryFeature#)
[CategoryWish](/CategoryWish#)
