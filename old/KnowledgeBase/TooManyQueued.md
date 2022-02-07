# Too Many Queued Requests

**Synopsis**

Squid crashes and maybe restarts immediately. Logging complains about
too many queued requests.

**Symptoms**

  - FATAL: Too many queued ntlmauthenticator requests

  - FATAL: Too many queued negotiateauthenticator requests

  - FATAL: Too many queued basicauthenticator requests

  - FATAL: Too many queued digestauthenticator requests

  - FATAL: Too many queued redirector requests

**Explanation**

Squid uses helper processes to perform certain actions such as
authentication checks. The number of each helper is configurable by the
proxy admin. As can be expected these helpers have a limit to how many
actions they can process each second. Most of them handle only one
client request at a time.

This message is displayed once there are **more** simultaneous client
requests waiting to be handled than helpers available to process the
load. If you configure N helpers, this warning appears when 2N+1 clients
are waiting for replies. Depending on the squid version the factor may
be 2 or 5 queued per helper.

This warning is most often seen with NTLM authenticators. Due to the
nature of NTLM it locks one helper for the relatively long NTLM
handshake period. This radically reduces the number of concurrent client
requests that can be sent through Squid. Winbind places a maximum
capacity somewhere around 256 simultaneous NTLM handshakes. Higher
client connection rates require some skills organising fast handshakes
and managing multiple DC. Negotiate can handle many more handshakes, but
also has an annoyingly low capacity.

**Workaround**

  - concurrency - certain helper types are able to be made concurrent.
    These are basic auth, external ACL, URL re-write and redirect
    helpers. Annoyingly these are the helpers where this problem occurs
    least anyway. Raising concurrency is better than children, up to a
    point. There is a [helper
    multiplexer](https://wiki.squid-cache.org/KnowledgeBase/TooManyQueued/Features/HelperMultiplexer#)
    available to easily add support to any existing helper.

  - NTLM / Negotiate - if you hit this your only choice is to raise the
    number of helpers used. The protocols for these helpers do not
    support concurrency.

  - [Squid-3.2](https://wiki.squid-cache.org/KnowledgeBase/TooManyQueued/Squid-3.2#)
    and later have a *dynamic helper* feature which allows
    administrators to configure minimum and maximum helper numbers.
    Squid will attempt to run the minimum, but if traffic load requires
    more helpers they will be started. Up until the maximum is reached.
    If traffic exceeds the maximum helper this message may start
    appearing again.

[CategoryKnowledgeBase](https://wiki.squid-cache.org/KnowledgeBase/TooManyQueued/CategoryKnowledgeBase#)
[CategoryErrorMessages](https://wiki.squid-cache.org/KnowledgeBase/TooManyQueued/CategoryErrorMessages#)
