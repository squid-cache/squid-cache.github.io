---
categories: WantedFeature
---
# Feature: Optimizations

- **Goal**: Waste less CPU
- **Status**: in progress
- **ETA**: unknown
- **Developer**:
  [AdrianChadd](/AdrianChadd), [AmosJeffries](/AmosJeffries),
  everyone
- **More**:
nnn
## Optimize the easy parts

Get rid of some unneeded duplicate copying of information

- There is a copy from the http.c server-side code (via storeAppend())
    to the client_side.c client-side code (via storeClientCopy()) - in
    progress in s27_adri branch.
- There is a copy out from the store memory into the client-side layer
    (via storeClientCopy()) - integrated into Squid-2.HEAD

## Optimise the hard parts

- The data copying involved in parsing http headers, URLs, and such
    from requests and replies - in progress in s27_adri branch.

## Implement scatter-gather IO

Avoid having to use the packer to pack HTTP request/reply and headers
into a buffer before write()ing to the network-side; this will not really
be worth it until the copies are eliminated (above) and the
[stackable IO model](/Features/StackableIO)
is in.

Use readv() to read into partially-filled large buffers - the goal is to
use larger buffers in the store memory if applicable to hold an entire
object in on memory allocation.
