---
---
# Store Client internals

> :information_source:
    This documentation was written for Squid-2.6

*By [Henrik_Nordström](/HenrikNordstrom)*:

    Given the StoreEntry pointer for a cached object, how can I read its contents (HTML text)?

Depends on "who" you are and why.

Squid never (or almost never) keeps entire objects in memory. Instead
there is just what is currently needed to be sent to the clients. Also,
how this is done differs significantly between on-disk cache hits and
other requests.. (misses and memory hits have a lot in common however).

The official API for getting content out of a StoreEntry is the
undocumented storeclient API which primarily consists of

- `storeClientRegister` to register a new client of StoreEntry.
- `storeClientCopy` to request some data from the object
- `storeUnregister` to unregister to client from the StoreEntry.

client in this is "a internal reader of the StoreEntry", not neccesarily
a client of Squid..

But depending on "who" you are and why maybe this is not the interface
you are looking for. If you could tell a little more about what it is
you need to solve perhaps we can guide to a better place to get access
to the data you need.
