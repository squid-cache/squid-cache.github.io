---
categories: ReviewMe
published: false
---
# Feature: Helper Multiplexer

  - **Goal**: Implement some external mechanism to allow adoption of
    Squid's multi-slot helper protocol

  - **Status**: Implementation completed.

  - **Version**: 3.2

  - **Developer**:
    [FrancescoChemolli](/FrancescoChemolli)

  - **More**:
    <ftp://ftp.squid-cache.org/pub/squid/contrib/helper-mux/> ;
    bundled with 3.2

# Details

Squid 3.0+ supports a multi-slot variant of the helper protocol, which
allows to run multiple concurrent requests over a single helper.

Few helpers support that protocol yet. Aim of this Feature is to have a
middleware object which talks the multi-slot protocol to Squid and runs
a farm of helpers talking the single-slot variant of the protocol to
them.

:information_source:
NP: The helper is bundled with
[Squid-3.2](/Releases/Squid-3.2),
however it works with earlier releases which are capable of the
multi-slot / concurrent protocol.

## Progress

What's currently done:

  - data flows forwarding engine

  - multiplexer is agnostic on the variant of helper protocol used

  - lazy instantiation of work helpers - no predetermined limit

  - some helper error handling

  - diagnostics and debugging (too much of it)

## TODO

What's left to do

  - handle work helper reaping / restarting
    
      - maybe will need to have the muxer understand at least part of
        the actual variant of the helper protocol.

  - debugging code cleanup

[CategoryFeature](/CategoryFeature)
