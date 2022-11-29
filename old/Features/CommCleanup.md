# Feature: Comm Layer cleanup

  - **Goal**: Improve code quality and maintainability.

  - **Status**: completed. debugging underway.

  - **Version**: Squid 3.2

  - **Developer**:
    [AmosJeffries](/AmosJeffries)

  - **More**:
    [branch](https://code.launchpad.net/~yadi/squid/cleanup-comm)

  - **Bugs**:

<!-- end list -->

  - [](http://bugs.squid-cache.org/show_bug.cgi?id=3070)

## Details

We need to cleanup and modulize the Comm Layer code.

At present its largely an undocumented collection of objects and
namespaces which interact to perform Comm actions. Some of what should
be comm actions are also spread amongst the other components within
Squid.

We need thin and clean comm layer that makes sense to developers. Clear
interaction with other component APIs. Most (perhaps all) developers
cannot even grasp all the interactions and inner dependencies, which
causes the snowball effect of degrading code quality.

At present the only distinction between comm and regular code is its
residence in comm.cc and com.h

### Progress

  - The comm code handling inbound client connections (accept /
    listeners) has now been cleaned up and isolated in a comm library
    with a small, clear and documented API.

Currently testing in 3.2:

  - The outbound connection setup for server connections (socket opening
    / connect / bind) has now been cleaned up and isolated in the comm
    library with a small clear and documented API.

  - FD handling throughout the code has been polished up to pass
    Connection objects instead of raw FD fro TCP connections.

  - DNS lookups have been extracted from comm layer TCP setup. The
    components needing a new connection are responsible for generating a
    Comm::Connection template with at minimum the destination IP in it.

  - CONNECT tunnel method retries. Are possible up until some bytes get
    transferred.

  - Persistent connections pooled by destination IP:port. Retrieval out
    of the pool is filtered on required local endpoint IP (if any) to
    support transparent interception and
    [tcp_outgoing_address](http://www.squid-cache.org/Doc/config/tcp_outgoing_address)
    which require a fixed local address.

### TODO

  - The inbound SSL layer still needs some attention to combine it
    behind the comm listener interface away from the higher levels of
    code. This can perhaps be done as part of the upgrade enabling SSL
    to use multiple system libraries other than OpenSSL.

  - The outbound SSL layer still needs some attention to combine it
    behind the comm connector interface away from the higher levels of
    code. This can perhaps be done as part of the upgrade enabling SSL
    to use multiple system libraries other than OpenSSL.

  - The socket reading operations need an API polished up.

  - The socket writing operations need an API polished up.

[CategoryFeature](/CategoryFeature)
[CategoryWish](/CategoryWish)
