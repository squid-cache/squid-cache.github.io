# Feature: Cache Manager Action ACL

  - **Goal**: A Request-type ACL which matches against the action name
    of a cache manager request.

  - **Status**: not started

  - **ETA**: unknown

  - **Version**:

  - **Developer**:

# Details

[Squid-3.2](/Releases/Squid-3.2#)
cache manager access through [](http://) and [](https://) URLs requires
a way to control which actions are visible to which users.

At present regex patterns can be used on the path portion of these
requests. But this involves the administrator knowing the internal path
representations for cache manager requests and compounding multiple ACLs
to identify the manager requests from other traffic.

It would be good to provide a simpler ACL which tests seamlessly for
manager request properties and then checks only the action name portion
of the URL. Ignoring additional parameters and internal 'well-known'
path locations.

[CategoryFeature](/CategoryFeature#)
