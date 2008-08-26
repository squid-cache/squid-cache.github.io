##master-page:SquidTemplate
#format wiki
#language en

## add some descriptive text. A title is not necessary as the WikiPageName is already added here.

## if you want to have a table of comments remove the heading hashes from the next line
##[[TableOfContents]]

StringNg is FrancescoChemolli's effort at improving squid's handling of strings (and memory buffers in general).
While probably not yet optimal, its aim is to be an improvement on the current implementation, especially to aid improve the string users in squid.

== Aims ==
Aim of this implementation effort is to increase the primitives squid uses for string manipulation, in particular:
 1. memory management
 :: strings should be refcounted and automatically cleaned-up
 1. low-cost copying
 1. low-cost string slicing (substrings) and pattern matching
 :: to improve string parsing (HTTP in particular, but not only)
 1. reasonable appending semantics
 1. memory manager friendlyness
 1. functionally complete interface

== Architectural overview ==
A couple of classes work together to perform the job:
 * {{{String}}} is the public face, and offers access to accessor functions etc.
 * {{{String::Buf}}} performs the (private) low-level work of memory management

{{{Buf}}}'s general structure is:
{{{#!cplusplus
class Buf {            //Buf is actually a private member class of String
    char *mem;         //handle to the underlying memory region
    u_int32_t bufsize; //size of the memory region
    u_int32_t bufused; //extent of the memory region actually used
    u_int32_t refs;    //refcount: how many Strings hold references to this Buf

    // constructrors, destructors, etc

    // utility functions to be described later
};
class String {
    Buf *memhandle;    //reference to the Buf managing the low-level storage area
    char *buf;         //MUST point into memhandle->mem. It's our data
    u_int32_t len;     //actual length of this string

    // constructors, destructors
    // assignment operators
    // accessors, etc.
    // utility functions
};
}}}

Strings have an N-to-1 relationship with Bufs: one Buf hold the data of many strings, possibly partly or totally.
An empty string (equivalent to {{{char * =NULL}}} references no Buf.

Importing a {{{char[]}}} (at construction time or via assignment) into a String requires allocating a big enough Buf and copying the string over.

Assignment (or copy-construction) of a String is cheap: clone the data members of String and increase the refcount of the underlying membuf.

String slicing is also cheap: after bounds checking etc, create a new String which points to a portion of the sliced String, and refcount the Buf.

Appending is a bit trickier. It can be done without copying the appended-to string, provided that there is enough unused space in the Buf AND that the appended-to String is at the end of the used region in the Buf. If those are true, the appended String is copied over, otherwise a new big enough Buf is created, the appended-to string is copied at its head, and then the append takes place. This operation should be cheap enough in most common cases, which are when the Buf is owned by a single String.

Memory Manager friendliness can be obtained by tuning the allocation strategies for Bufs. Current thoughts are:
- small Bufs (<8Kb) should be managed by MemPools.
- Bufs bigger than 8Kb should be allocated in sizes compatible with the system page size (minus malloc() overhead). This will maximize the amount of memory available for use while avoiding heap fragmentation.


Development will be held out-of-tree until a reasonable prototype of the implementing class has been reached.
The code is in LaunchPad at [[https://code.launchpad.net/~kinkie/squid/string-ng|lp:~kinkie/squid/string-ng]]
