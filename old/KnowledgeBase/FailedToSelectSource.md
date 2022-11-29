# Failed to select source for ...

**Synopsis**

Squid fails for some or all requests. Users see an error page.

**Symptoms**

A user will see the error page **ERR_CANNOT_FORWARD**:

    Unable to forward this request at this time.

Squid Logs:

1.  Failed to select source for \`[](http://)...'
    
      - always_direct = 0
    
      - never_direct = 1

2.  Failed to select source for \`[](http://)...'
    
      - always_direct = -1
    
      - never_direct = 1

3.  Failed to select source for \`[](http://)...'
    
      - always_direct = 0
    
      - never_direct = -1

4.  Failed to select source for \`[](http://)...'
    
      - always_direct = -1
    
      - never_direct = -1

**Explanation**

Squid contains several access control lists which determine how and
where a request may be fetched from.

These are (in order of testing):

  - [prefer_direct](http://www.squid-cache.org/Doc/config/prefer_direct)
    (on or off) - whether DIRECT connection to the origin is tried first
    or last.

  - [always_direct](http://www.squid-cache.org/Doc/config/always_direct)
    - whether connections to the origin are **required** (allow).

  - [never_direct](http://www.squid-cache.org/Doc/config/never_direct)
    - whether DIRECT to origin requests are blocked (allow).

  - [cache_peer_access](http://www.squid-cache.org/Doc/config/cache_peer_access)
    - whether the request is permitted to go to this peer (allow).

The error message is just stating the fact that your configuration of
these options does not allow this request to be sent directly to the
origin server
([never_direct](http://www.squid-cache.org/Doc/config/never_direct)
allow), and none of the peers is capable or allowed to forward the
request.

The most likely cause for this error is that you do not allow this cache
to make direct connections to origin servers
([never_direct](http://www.squid-cache.org/Doc/config/never_direct)
allow all), and all configured parent caches are currently unreachable.

**Workaround**

If the result is produced by an upstream peer, you will only see the
error page and not the log warnings (at level 1). You can workaround
that by sending the affected traffic elsewhere.

If the problem is being logged by your own Squid. You must fix it.

[CategoryKnowledgeBase](/CategoryKnowledgeBase)
[CategoryErrorMessages](/CategoryErrorMessages)
