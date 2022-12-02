---
categories: ReviewMe
published: false
---
# Feature: Helper Pause State

  - **Goal**: Skip busy helpers without delays.

  - **Status**: Not Started.

  - **ETA**: unknown

  - **Version**: Squid 3

  - **Developer**:

## Details

*Chris Woodfield*: Allow helper children (url_rewriters, etc) to send
some sort of "pause" message back to squid to signal that that child is
temporarily unavailable for new queries, and then a "ready" message when
it's available again. (yes, this is kinda obscure - the issue here is a
single-threaded rewriter helper app that occasionally has to re-read its
rules database, and can't answer queries while it's doing so)

It is not clear whether expanding redirector API is the right direction.
It could be argued that folks that need non-basic adaptors should use
ICAP or eCAP instead because those feature-rich interfaces are designed
to handle complex scheduling and error bypass better.

A yet another alternative is to convert redirectors to use \*CAP-like
internal API so that they can benefit from common adaptation code and so
that we do not have to support too many complex ways of adapting
traffic.

Please discuss these issues before starting development.

### UPDATE: This issue has been further complicated.

There was a 'busy' state in the stateful helpers previously to indicate
a similar waiting. This was found to accumulate far too many helpers at
periods and block up the total load Squid could handle. It has now been
dropped from 3.1 to resolve those issues.

### UPDATE: There is now an alternative to pausing

The on-demand starting of new helpers from 3.2 can be leveraged to do
this in a far simpler design. By having helpers simply stop running when
their config becomes old. Squid will start new helpers as load requires
and helpers only need load config on startup.

[CategoryFeature](/CategoryFeature)
[CategoryWish](/CategoryWish)
