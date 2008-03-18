##master-page:FeatureTemplate
#format wiki
#language en

= Feature: Better String memory usage =

 * '''Goal''':  Improve the usage of short strings to use best-practice, efficient, pointer-safe APIs.
 * '''Status''': On hold
 * '''ETA''': unknown
 * '''Version''': Squid 3.1
 * '''Developer''': AmosJeffries

== Details ==
Improve the usage of memory-pooled strings and the string API. The code is presently not using best-practice or pointer-safety with regards to short strings. Nor is it using them widely in place of un-pooled character arrays where it could provide greater memory management easily.

Plans for the string API are intended to allow improved access at all current usage of strings (ESI, ICAP, others?) and allow for improved and safer access to larger buffers (HTTP parser, URI Parser, etc).

== Requirements ==

=== I/O Buffers ===

The faster string counters revolve around Just-In-Time duplication of strings out of buffers. Such that strings which never actually need duplcation are not allocated memory or peform any copying.

The first steps of that is to make the low-level data buffers capable of communicating with the strings that are using them.

Buffers need to have a list of child strings added with register/deregister, and Destructor-cascade operations. The register/deregister kicked-off by the child strings when their JIT is triggered. Destructor cascade is kicked-off by the buffer when it needs to de-allocate and all remaining child strings must duplicate their data or loose it.

NP: a generically-written buffer may be a string itself referencing another larger buffer elsewhere.

=== Strings ===

The string itself should hold an offset and reference to its parent-buffer in addition to the character-pointer into the parent buffer if parent is present, or to its own duplicated buffer if necessary.

They should be read-only by default, with write-operations requiring a buffer-duplication to accomodate the new content without altering the parent buffer underneath other sibling-strings.

An alteration feedback mechanism needs to be added to prevent a string buffer being altered when it has child-strings itself. To prevent unnecessary duplication.

'''NP:''' Catenations are a special case here with no duplicate need IFF the string has its own already-duplicated buffer large enough to hold the extra.


=== String-Users ===

All code that uses these strings MUST NOT reference the raw-data buffer for access or manipulation. Offset-based API needs to be provided for all actions instead.

'''NP:''' I/O is the one exception to this, where output may be done from the current string buffer. 

Preferably IO is done through the highest-level of construct tracking the child-strings and thus being buffer-agnostic and most importantly length agnostic. It is up to the high-level object whether it outputs the original input buffer or the (possibly altered) child strings individually re-formatted.


=== Remaining Problems ===

The case remains that a buffer may be partially-parsed into three parts (or more, but 3 is the simplest case).
It maintains it's head pointer, and by referencing the child it may locate the childs start offset. This allows output of the A-part. The child itself can perform output of the B-part, changed or not.
BUT, if the B-part child has changed we no longer have the start-offset information for the C-part of the string. This will have to be maintained cleanly somewhere.

There are two options for handling this:
 * A small Dead-String class type to map these dead-spaces in the buffer. Which the parent creates when a child-string de-references itself indicating alteration as the reason (other reasons may be child-destruct).
 * We ensure parsers are run over the full buffer they need to, user keep reference to the C-parts IFF they need to and ignore this, considering all unreferenced areas of the parent buffer as unparsed/garbage. All IO at that point MUST be performed from the top-down to encompass these 'deletions'.

----
CategoryFeature | CategoryWish
