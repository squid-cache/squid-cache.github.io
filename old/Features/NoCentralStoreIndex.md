# Feature: No in-memory central index

  - **Goal**: Allow store to grow unbounded by memory

  - **Status**: *Not started*

  - **ETA**: unknown

  - **Version**:

  - **Developer**:

## Details

Squid is currently operating around a single in-memory index of all
cached objects, which is quite good for performance but very resource
demanding in bigger installations and also making it harder to add SMP
support.

The big single in-memory store index is starting to become quite a
burden. There is a need for something which scales better with both size
and CPU.

We need to move away from this, providing an asyncronous store lookup
mechanism allowing the index to be moved out from the core and down to
the store layer. Ultimately even supporting shared stores used by
multiple Squid frontends.

Goal of not having a central index, making it possible to push more of
the store logics down..

[CategoryFeature](/CategoryFeature)
|
[CategoryWish](/CategoryWish)
