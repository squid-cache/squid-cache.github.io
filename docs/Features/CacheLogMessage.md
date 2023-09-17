---
categories: Feature
---
# Feature: Cache Log Message individual control

- **Goal**: allow controlling each cache log message individually
- **Version**: 6.0
- **Developer**: Eduard Bagdasaryan

## Details

Enable controlling certain aspects of individual log messages via a squid.conf directive.
Details on the configuration directive are in the
[configuration manual](http://www.squid-cache.org/Doc/config/cache_log_message/)

Individual messages have to be instrumented to support this feature, to be instrumented
with an ID.
The list of IDs supported is in the "debug-messages.dox" file for that specific version;
[this is the current list in master](https://github.com/squid-cache/squid/blob/master/doc/debug-messages.dox).

Message IDs are guaranteed to not change to guarantee forward compatibility.


## Internals

To instrument a message, one needs to:
1. make a note of the value of variable `DebugMessageIdUpperBound` in file `src/debug/Messages.h`
1. increment it by 1
1. add a line corresponding to the message in `doc/debug-messages.dox`
1. in the message to be instrumented, change the second argument from DBG_* macro to one of
  - `Critical(id)`
  - `Important(id)`
  - `Dbg(id)`
  - where the id is the one noted in the first step
1. in the file containing that message, it might be necessary to `#include "debug/Messages.h"`
1. try a full build
1. submit a PR to the Squid project to share the fruit of the labour :)

