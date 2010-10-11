##master-page:SquidTemplate
#format wiki
#language en

## add some descriptive text. A title is not necessary as the WikiPageName is already added here.

## if you want to have a table of comments remove the heading hashes from the next line
##[[TableOfContents]]

!StringNg is FrancescoChemolli's effort at improving squid's handling of strings (and memory buffers in general).

It is now almost complete to be useable, a discussion about its interface, issues and integration strategy was held as part of the [[MeetUps/IrcMeetup-2009-01-17|January 2009 IRC meetup]]

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
 * {{{SBuf}}} is the public face, and offers access to various manipulation functions. It's aimed at efficient manipulation of binary buffers with some ASCII string-oriented manipulation functions.
 * {{{MemBlob}}} managed refcounted memory blobs {{{RefCountable}}} framework

Instances of SBuf have an N-to-1 relationship with instances of !MemBlob: one !MemBlob holds the data of many SBuf's, possibly overlapping in part or in whole.

SBufs implement copy-on-write to prevent aliasing side-effects. Shortcuts are provided for the  common cases, e.g. appending to a SBuf (no COW when there is unused space at the end of the !MemBlob) or when the SBuf is the only holder of the SBufStore.

Memory Manager friendliness can be obtained by tuning the allocation strategies for !MemBlobs. Current practices are: heuristics are used to define how much extra space to allocate. Burden is split between SBuf and !MemBlob: the former former uses SBuf-local informations (e.g. the length of the SBuf lifetime expressed in number of copy operations), while !MemBlob handles lower-level optimizations.

=== Optimizations ===
SBufs (and !StringNgs) are mainly immutable. It needn't be so in all cases. For instance, changing portions of strings may be allowed when a SBuf owns the !MemBlob (aka when the !MemBlob's refcount is 1).

=== Thread safety ===
Thread safety is currently out of scope.

=== Prototype ===
Currently being carried out as a feature-branch of HEAD at [[https://code.launchpad.net/~kinkie/squid/|lp:~kinkie/squid/stringng]].

=== Step-by-step diagram of MemBuf-emulation functionalities ===
|| /!\ || Note: this diagram is out-of-date. SBufs no longer point to a char* inside the SBufStore address space, but carry an {offset,length} relative to the head of the SBufStore. ||
{{attachment:KBuf-work-diagram.png}}

== Dead code repository ==
[[attachment:sbuf-mempool-failed-integration.patch]] contains an attempt at mempool integration.
It failed because global variables are initialized before mempools are running, which results in their buffers being xalloc()ed by mempools. At destruction time, mempools can't find the pool to free the item from (because it doesn't exists) and complains loudly.
The interim solution is to remove the dependency on mempools. Further attempts are re-introducing the isLiteral/isImported flags to !MemBlobs, or to make sure that mempools are initialized before global variables.
