---
categories: Feature
---
# Feature: Helper Multiplexer
- **Goal**: Implement some external mechanism to allow adoption of
    Squid's multi-slot helper protocol
- **Status**: Implementation completed.
- **Version**: 3.2
- **Developer**:
    [FrancescoChemolli](/FrancescoChemolli)
- **More**:
   
## Details

Squid 3.0+ supports a multi-slot variant of the helper protocol, which
allows to run multiple concurrent requests over a single helper.

Few helpers support that protocol yet. Aim of this Feature is to have a
middleware object which talks the multi-slot protocol to Squid and runs
a farm of helpers talking the single-slot variant of the protocol to
them.

