# Feature: Better String memory usage

  - **Goal**: Improve the usage of short strings to use best-practice,
    efficient, pointer-safe APIs.

  - **Status**: general code conversion underway

  - **ETA**: unknown

  - **Developer**:
    [AmosJeffries](/AmosJeffries#),
    [FrancescoChemolli](/FrancescoChemolli#)

  - **More**: [](https://code.launchpad.net/~kinkie/squid/stringng)

## Details

Improve the usage of memory-pooled strings and the string API. The code
is presently not using best-practice or pointer-safety with regards to
short strings. Nor is it using them widely in place of un-pooled
character arrays where it could provide greater memory management
easily.

Plans for the string API are intended to allow improved access at all
current usage of strings (ESI, ICAP, others?) and allow for improved and
safer access to larger buffers (HTTP parser, URI Parser, etc).

  - ℹ️
    Please clarify your goal. What "usage" aspects are you trying to
    improve? APIs are rarely the goal, they are usually the means to
    achieve some goal(s). It is not clear what "improved access" means.

**Goal**: To implement a zero-copy data pathway from network/disk read
to network/disk write within Squid.

Safer access, means with a coded non-char\* access to raw data buffers
which we can store in state objects and be sure the pointers are not
going to die underneath the callee code. The present
\!SquidString/String implementation is limited by:

  - max-size of 65536 bytes. This was made evident by earlier attempts
    at using it universally for char\* replacement.

  - direct access to a self-controlled char\* buffer. No existing
    ability for non-local buffer sharing.

  - existing usage within squid strictly assuming the above two limits
    are always true.

[FrancescoChemolli](/FrancescoChemolli#)
has started a sample implementation, drawing from many concepts in this
page and
[AdrianChadd](/AdrianChadd#)'s
implementation in branch s27\_adri. General concepts and discussion in
[/StringNg](/Features/BetterStringBuffer/StringNg#),
will be merged here once better sketched.

## Plan

Implementing a single semi-generic referenced-String class that acts as
both a parent-buffer and a child-string (see below) simultaneously is
easy enough. Once created we can slowly migrate usage of it around
Squid. If done carefully with a char\* and SquidString in/out conversion
we can insert them seamlessly at any point in the code with no loss of
performance, but an overall gain in places where two can reference each
other.

  - ℹ️
    Can you rewrite the above as a sequence of specific steps? This is a
    big and important project that will affect other code. Let's try to
    be clear about the steps. This will also help you describe the
    current status later.

Steps:

  - discuss the design below until its clear what the best
    implementation is for Squid.
    
      - JIT, RefCount, const String, others?

  - Create a class to implement it.

  - Insert the class at request read handler and incrementally push down
    the request pathway

  - Insert the class at reply read handler and incrementally push down
    the network reply pathway

  - Insert the class at store read handler(s) and incrementally push
    down the cache-reply pathway

  - Look for any places still using xstrdup() or equivalent from these
    string objects, and incrementally push down those secondary pathways
    as well.

The steps have started. Progress so far is:

  - Adrian has implemented this in his own way for Squid-2 with
    non-copying strings.

  - We are stuck on step 1 for Squid-3.

It's the same methodology I used for the v6 makeover. Once we have
passed step-1, it should take 6-10 months to completion.

## Design sketch

### I/O Buffers

The faster string counters revolve around Just-In-Time duplication of
strings out of buffers. Such that strings which never actually need
duplication are not allocated memory or perform any copying.

The first steps of that is to make the low-level data buffers capable of
communicating with the strings that are using them.

Buffers need to have a list of child strings added with
register/deregister, and Destructor-cascade operations. The
register/deregister kicked-off by the child strings when their JIT is
triggered. Destructor cascade is kicked-off by the buffer when it needs
to de-allocate and all remaining child strings must duplicate their data
or loose it.

  - ℹ️
    The above design will work, but there are alternatives. Can you
    compare the above with a simpler design where the buffer is locked
    by stings using it, but does not point back to them; if a string
    needs to be modified and the buffer has more than one lock, the
    buffer (or its affected portion) is copied for that string use,
    without any affect on other strings.

The alternative I believe you refer to is RefCounted children instead of
JIT duplication. That was one of the initial models I looked at. It
would be much simpler and easier to use. The problem pointed out by
Adrian who has taken the JIT model into Squid-2 was that there are too
many places in Squid which assume the data it receives is going to exist
'forever'.

Choosing the RefCounted option would trade keeping the buffer memory in
use as long as even one byte of its content is ref-locked. The JIT
method trades that memory consumption + O(1) refcount, against
linked-list (fast unordered O(4) ) inserts at the parent buffer. Making
the child/parent buffers/strings one object type the implementation for
either can be coded and tested for speed + benefits in squid and the
best kept.

  - ℹ️
    Please also address the overheads of content insertion or explicitly
    say that we are not going to address that at this stage: The above
    design optimizes parsing, but does not help much with the opposite
    process of content assembly (e.g., building an HTTP header). Should
    this project also allow for efficient, copy-free content assembly?
    One way to support that is to support buffers that consist of
    multiple independently-allocated areas.

JIT model overheads of content insertion is a fall-back in worst-case to
the current squid behavior of duplicating each string/buffer. Best-case
is complete zero-copy. This is what I mean by no loss of performance. My
current understanding of both clones between server-side and client-side
is that they presently duplicate the same data several times in-transit
to and from each data pathway.

This model is hoping primarily to address the request/reply parsing and
also in-transit delays of copying HTTP-header portions. The data-object
portions are not expected to improve much with this. Only ESI or other
object-parsing may be peripherally affected.

NP: a generically-written buffer may be a string itself referencing
another larger buffer elsewhere.

  - ℹ️
    This needs clarification. Please define the primary roles of the
    buffer and string classes. For example, the string is responsible
    for maintaining information about an area of a buffer (buffer,
    offset, size) and read/write locks, while the buffer is responsible
    for everything else (memory management, duplication, insertion,
    search, comparison, etc.). This high-level role separation should
    probably be discussed before the class-specific sections.

The sub-note is about; that there may in fact be no need for two such
classes. The memory-manager may be completely capable of handling
allocations, leaving 'parent' and 'child' layers of the model a single
class type capable of referring to other objects of its own type. This
still needs investigation of the different use and behavior of the
current MemBuf, char\*, and SquidString.

### JIT Strings

The string itself should hold an offset and reference to its
parent-buffer in addition to the character-pointer into the parent
buffer if parent is present, or to its own duplicated buffer if
necessary.

  - ℹ️
    I do not think you need "parent buffers" and "own buffers". One kind
    of buffer should suffice. The "own buffer" is just a buffer that is
    currently used by one string. That can change whenever the string or
    its portion is duplicated by the user code.

Indeed, that is the intent. I use 'parent' and 'own' to differentiate
the case where these objects are referring to a seperate object 'parent'
(shared buffer by offset+lock on the external object) or has
master-control over a buffer (responsibiity for: allocate, de-allocate,
notify-cascade initiate on changes)

They should be read-only by default, with write-operations requiring a
buffer-duplication to accommodate the new content without altering the
parent buffer underneath other sibling-strings.

An alteration feedback mechanism needs to be added to prevent a string
buffer being altered when it has child-strings itself. To prevent
unnecessary duplication.

**NP:** Concatenations are a special case here with no duplicate need
IFF the string has its own already-duplicated buffer large enough to
hold the extra.

### String-Users

All code that uses these strings MUST NOT reference the raw-data buffer
for access or manipulation. Offset-based API needs to be provided for
all actions instead.

**NP:** I/O is the one exception to this, where output may be done from
the current string buffer.

Preferably IO is done through the highest-level of construct tracking
the child-strings and thus being buffer-agnostic and most importantly
length agnostic. It is up to the high-level object whether it outputs
the original input buffer or the (possibly altered) child strings
individually re-formatted.

  - ℹ️
    Perhaps I am missing something, but I think it is OK to pass
    constant string content pointers to external code (I/O, system
    libraries, etc.) as long as the string is guaranteed to remain
    intact until the end of the call. Passing non-constant pointers
    requires write-locking, but is also OK under the same conditions.
    This will help with migrating from current code to the new API and
    allows for greater code reuse.

Constants yes. char\* buffer pointers no. The essence of this is that
the new string objects are not nul-terminated. Child object has only an
offset and length into the raw buffer somewhere else which it supplies
via a \[\] operator or a lookup itself to de-reference the char\*. Many
of the current users depend on null-termination of char\* for stdlib
string functions, will die horribly if they attempt to random-access a
non-terminated buffer.

### Remaining Problems

The case remains that a buffer may be partially-parsed into three parts
(or more, but 3 is the simplest case). It maintains it's head pointer,
and by referencing the child it may locate the child start offset. This
allows output of the A-part. The child itself can perform output of the
B-part, changed or not. BUT, if the B-part child has changed we no
longer have the start-offset information for the C-part of the string.
This will have to be maintained cleanly somewhere.

There are two options for handling this:

  - A small Dead-String class type to map these dead-spaces in the
    buffer. Which the parent creates when a child-string de-references
    itself indicating alteration as the reason (other reasons may be
    child-destruct).

  - We ensure parsers are run over the full buffer they need to, user
    keep reference to the C-parts IFF they need to and ignore this,
    considering all unreferenced areas of the parent buffer as
    unparsed/garbage. All IO at that point MUST be performed from the
    top-down to encompass these 'deletions'.
    
      - ℹ️
        It sounds like your buffer consists of parts here. If that is
        the case, the above design needs to reflect that. At least, it
        was not clear to me that you are proposing support for
        multi-part buffers as opposed to a single buffer, with multiple
        strings pointing to buffer areas. That is why I asked above
        whether you are going to optimize content generation as well.

I'm indeed not proposing multi-part buffers. At least not in the design
on this page above. Reference to parts is only to logical sections of a
sequential raw buffer if partially parsed. I'm leaning towards ignoring
this and assuming the user takes care of any bits. That is more in line
with the parsing basis of this and general parser behavior.

This is an attempt to take a real N-kilobyte stream of data into one
buffer and handle the fact that dozens of small sections of its raw
ascii are used around Squid. Without duplicating it, we end up with
functions receiving an triplet object of {buf,offset,length}. Or in the
case of pre-parsed headers, a tree of these objects with for example,
the ones which point to hop-by-hop headers missing. Then we need to
reconstruct them into the socket write stream directly (think; non-copy
from network read to network/disk write).

Though true, the output generation optimization does need more thought.

[CategoryFeature](/CategoryFeature#)
