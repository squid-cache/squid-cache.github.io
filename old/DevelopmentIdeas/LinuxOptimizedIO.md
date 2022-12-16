# Linux-Specific I/O Optimizations

Linux 2.6.17 (but the concepts were refined and interfaces altered in
2.6.18+) implemented a few new system calls for zero-copy I/O operations
involving pipes: splice, tee and vmsplice

  - *splice* copies an user-specified amount data from a pipe into
    another pipe

  - *tee* is like splice but doesn't consume data from the input, and
    can be thus invoked multiple times on the same pipe

  - *vmsplice* copies data from an user-specified memory region into a
    pipe

Those ***might*** be useful in different cases: respectively disk cache
hit, cacheable miss and (probably) error pages. We need to verify that
the semantics are right, and what kind of compromises are required to
implement them

**Resources**:

  - [](http://lwn.net/Articles/178199/)

  - [](http://lwn.net/Articles/179492/)

  - [](http://lwn.net/Articles/181169/)

**Discussion**
