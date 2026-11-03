# StringNg

StringNg is Squid's representation of a String-buffer

## Aims
Aim of this implementation effort is to increase the primitives squid uses for string manipulation, in particular:

### memory management
- strings should be refcounted and automatically cleaned-up
- low-cost copying
- low-cost string slicing (substrings), to help with tokenization
- good appending semantics
- memory manager (MemPools) friendlyness
- functionally complete interface
    leaving the memory-managed realm should be unnecessary except when engaging external libraries.

## Architectural overview
Three main classes perform the job
- `SBuf` is the public face, and offers access to various manipulation functions.
    It's aimed at efficient manipulation of binary buffers with some ASCII string-oriented manipulation functions.
- `MemBlob` managed refcounted memory blobs RefCountable framework

Instances of SBuf have an N-to-1 relationship with instances of MemBlob:
one MemBlob holds the data of many SBuf's, possibly overlapping in part
or in whole.

SBufs implement copy-on-write to prevent aliasing side-effects.
Shortcuts are provided for the common cases, e.g. appending to a SBuf
(no COW when there is unused space at the end of the MemBlob) or when the SBuf
is the only holder of the MemBlob.

Memory Manager friendliness can be obtained by tuning the allocation
strategies for MemBlobs. Current practices are: heuristics are used
to define how much extra space to allocate. Burden is split between
SBuf and MemBlob: the former former uses SBuf-local information
(e.g. the length of the SBuf lifetime expressed in number of copy operations),
while MemBlob handles lower-level optimizations.

## Optimizations
SBufs (and StringNgs) are mainly immutable. It needn't be so in all cases.
For instance, changing portions of strings may be allowed when a SBuf
owns the MemBlob (aka when the MemBlob's refcount is 1).

### Thread safety
Thread safety is out of scope.
