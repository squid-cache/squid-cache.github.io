##master-page:SquidTemplate
#format wiki
#language en

## add some descriptive text. A title is not necessary as the WikiPageName is already added here.

## if you want to have a table of comments remove the heading hashes from the next line
##[[TableOfContents]]

!StringNg is FrancescoChemolli's effort at improving squid's handling of strings (and memory buffers in general).

== Aims ==
Aim of this implementation effort is to increase the primitives squid uses for string manipulation, in particular:
 1. memory management
 :: strings should be refcounted and automatically cleaned-up
 1. low-cost copying
 1. low-cost string slicing (substrings)
 :: to improve string parsing (HTTP in particular, but not only)
 1. good appending semantics
 1. memory manager (!MemPools) friendlyness
 1. functionally complete interface
 :: leaving the memory-managed realm should be unnecessary except when engaging external libraries.

== Architectural overview ==
Three main classes perform the job
 * {{{SBuf}}} is the public face, and offers access to various manipulation functions. It's aimed at efficient manipulation of binary blobs.
 * {{{SBuf::SBufStore}}} performs the (private) low-level work of memory management, via the {{{RefCountable}}} framework
 * {{{StringNg}}} uses a SBuf as a backing store, and implements encoding-aware handling of (non-binary) strings, e.g. for Unicode etc.

Instances of SBuf have an N-to-1 relationship with instances of SBufStore: one SBufStore holds the data of many strings, possibly overlapping in part or in whole.

An empty SBuf (equivalent to {{{char * =NULL}}} references no SBufStore.

In general SBufs' contents are read-only, and attempting writes to them will perform a copy-on-write operation. Shortcuts are provided for the expected common cases, e.g. appending to a SBuf (no COW when there is unused space at the end of the SBufStore) or when the SBuf is the only holder of the SBufStore.

Importing a {{{char[]}}} (at construction time or via assignment) into a SBuf requires allocating a big enough SBufStore and copying the string over.

Assignment (or copy-construction) of a SBuf is cheap via refcounting

String slicing is also cheap: after bounds checking etc, a new SBuf is created, pointing to a portion of the underlying SBufStore. No attempt is made at joining SBufs with the same contents.

Appending is a bit trickier. It can be done without copying the appended-to SBuf, provided that there is enough unused space in the SBufStore AND that the appended-to SBuf is at the end of the used region in the SBufStore. If those are true, the appended SBuf is copied over, otherwise a new big enough SBufStore is created (using hints on the SBuf's history to determine how much headroom to leave), the appended-to SBuf is copied at its head, and then the append takes place. This operation should be cheap enough in most common cases, which are when the SBufStore is owned by a single SBuf.

Memory Manager friendliness can be obtained by tuning the allocation strategies for Bufs. Current thoughts are:
- small SBufStores (<8Kb) should be managed by !MemPools.
- SBufStores bigger than 8Kb should be allocated in sizes compatible with the system page size (minus malloc() overhead). This will maximize the amount of memory available for use while avoiding heap fragmentation.

|| /!\ || A SBufList class is on the drawing board, which would provide even cheaper append semantics, and writev(2)-friendly comm functions. ||

=== Optimizations ===
SBufs (and !StringNgs) are mainly immutable. It needn't be so in all cases. For instance, changing portions of strings may be allowed when a SBuf owns a SBufStore (aka when the SBufStore's refcount is 1).

=== Thread safety ===
Thread safety is currently out of scope. This work is however a step in the right direction, as it moves all string-related logic in one place. If it is ever attempted, the best API would seem to be through a lock object, rather than through lock()/unlock().


=== Prototype ===
Development was started out-of-tree until a reasonable prototype of the implementing class was reached. Launchpad. Branch [[https://code.launchpad.net/~kinkie/squid/string-ng|lp:~kinkie/squid/string-ng]].

Currently being carried out as a feature-branch of HEAD at [[https://code.launchpad.net/~kinkie/squid/|lp:~kinkie/squid/stringng]].

=== Step-by-step diagram of MemBuf-emulation functionalities ===
|| /!\ || Note: this diagram is out-of-date. SBufs no longer point to a char* inside the SBufStore address space, but carry an {offset,length} relative to the head of the SBufStore. ||
{{attachment:KBuf-work-diagram.png}}
