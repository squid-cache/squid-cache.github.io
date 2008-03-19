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

  {i} Please clarify your goal. What "usage" aspects are you trying to improve? APIs are rarely the goal, they are usually the means to archive some goal(s). It is not clear what "improved access" means.


== Plan ==

Implementing a single semi-generic referenced-String class that acts as both a parent-buffer and a child-string (see below) simultaneously is easy enough. Once created we can slowly migrate usage of it around Squid. If done carefully with a char* and squidString  in/out conversion we can insert them seamlessly at any point in the code with no loss of performance, but an overall gain in places where two can reference each other.

  {i} Can you rewrite the above as a sequence of specific steps? This is a big and important project that will affect other code. Let's try to be clear about the steps. This will also help you describe the current status later.

== Design sketch ==

=== I/O Buffers ===

The faster string counters revolve around Just-In-Time duplication of strings out of buffers. Such that strings which never actually need duplication are not allocated memory or perform any copying.

The first steps of that is to make the low-level data buffers capable of communicating with the strings that are using them.

Buffers need to have a list of child strings added with register/deregister, and Destructor-cascade operations. The register/deregister kicked-off by the child strings when their JIT is triggered. Destructor cascade is kicked-off by the buffer when it needs to de-allocate and all remaining child strings must duplicate their data or loose it.

  {i} The above design will work, but there are alternatives. Can you compare the above with a simpler design where the buffer is locked by stings using it, but does not point back to them; if a string needs to be modified and the buffer has more than one lock, the buffer (or its affected portion) is copied for that string use, without any affect on other strings.

  {i} Please also address the overheads of content insertion or explicitly say that we are not going to address that at this stage: The above design optimizes parsing, but does not help much with the opposite process of content assembly (e.g., building an HTTP header). Should this project also allow for efficient, copy-free content assembly? One way to support that is to support buffers that consist of multiple independently-allocated areas.

NP: a generically-written buffer may be a string itself referencing another larger buffer elsewhere.

  {i} This needs clarification. Please define the primary roles of the buffer and string classes. For example, the string is responsible for maintaining information about an area of a buffer (buffer, offset, size) and read/write locks, while the buffer is responsible for everything else (memory management, duplication, insertion, search, comparison, etc.). This high-level role separation should probably be discussed before the class-specific sections.

=== Strings ===

The string itself should hold an offset and reference to its parent-buffer in addition to the character-pointer into the parent buffer if parent is present, or to its own duplicated buffer if necessary.

  {i} I do not think you need "parent buffers" and "own buffers". One kind of buffer should suffice. The "own buffer" is just a buffer that is currently used by one string. That can change whenever the string or its portion is duplicated by the user code.

They should be read-only by default, with write-operations requiring a buffer-duplication to accommodate the new content without altering the parent buffer underneath other sibling-strings.

An alteration feedback mechanism needs to be added to prevent a string buffer being altered when it has child-strings itself. To prevent unnecessary duplication.

'''NP:''' Concatenations are a special case here with no duplicate need IFF the string has its own already-duplicated buffer large enough to hold the extra.


=== String-Users ===

All code that uses these strings MUST NOT reference the raw-data buffer for access or manipulation. Offset-based API needs to be provided for all actions instead.

'''NP:''' I/O is the one exception to this, where output may be done from the current string buffer. 

Preferably IO is done through the highest-level of construct tracking the child-strings and thus being buffer-agnostic and most importantly length agnostic. It is up to the high-level object whether it outputs the original input buffer or the (possibly altered) child strings individually re-formatted.

  {i} Perhaps I am missing something, but I think it is OK to pass constant string content pointers to external code (I/O, system libraries, etc.) as long as the string is guaranteed to remain intact until the end of the call. Passing non-constant pointers requires write-locking, but is also OK under the same conditions. This will help with migrating from current code to the new API and allows for greater code reuse.

=== Remaining Problems ===

The case remains that a buffer may be partially-parsed into three parts (or more, but 3 is the simplest case).
It maintains it's head pointer, and by referencing the child it may locate the childs start offset. This allows output of the A-part. The child itself can perform output of the B-part, changed or not.
BUT, if the B-part child has changed we no longer have the start-offset information for the C-part of the string. This will have to be maintained cleanly somewhere.

  {i} It sounds like your buffer consists of parts here. If that is the case, the above design needs to reflect that. At least, it was not clear to me that you are proposing support for multi-part buffers as opposed to a single buffer, with multiple strings pointing to buffer areas. That is why I asked above whether you are going to optimize content generation as well.

There are two options for handling this:
 * A small Dead-String class type to map these dead-spaces in the buffer. Which the parent creates when a child-string de-references itself indicating alteration as the reason (other reasons may be child-destruct).
 * We ensure parsers are run over the full buffer they need to, user keep reference to the C-parts IFF they need to and ignore this, considering all unreferenced areas of the parent buffer as unparsed/garbage. All IO at that point MUST be performed from the top-down to encompass these 'deletions'.

----
CategoryFeature | CategoryWish
