---
categories: WantedFeature
---
# Feature: Dump live call info when crashing

- **Goal**: Include the origin where the current live call was
  scheduled in the cache.log crash messages.
- **Status**: *Not started*
- **ETA**: *unknown*
- **Version**:
- **Priority**:
- **Developer**:
- **More**: Bug
    [2463](https://bugs.squid-cache.org/show_bug.cgi?id=2463)

# Details

More information can be printed about the current call, at the slightly
increased risk of a nested crash if AsyncCall::print() fails because the
call object itself is corrupted.
