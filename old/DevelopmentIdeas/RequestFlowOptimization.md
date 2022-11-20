# Request Flow reorganization

(from the old Faq-O-Matic)

The request flow should be as clean as possible

1.  The proxy request flow should be just that. Separate cache from the
    request flow.

2.  No double or triple copying of data. Make use of reference counted
    data buffers to pass data as-is from reader to writer, including
    to/from cache.

3.  As few special cases as possible. Beware of "huge" requests, or
    joined requests with a "huge" distance between two users.

Due to requirement '3', I think we should drop the idea of joined
requests where there is more than one client. Better if we simply
support storage of partial objects, and then ignores the whole issue.

[Henrik\_Nordström](/Henrik_Nordstr%C3%B6m)

**Discussion**

[AdrianChadd](/AdrianChadd)
is working on this in the \[Squid-2.6\] codebase.
