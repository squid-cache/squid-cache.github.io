---
---
# Core developers conversations

Core developers meet on a semi regular schedule to discuss
the code being contributed; here is a summary of the points discussed,
and a summary of the level of consensus reached.

**[C]** means that there is consensus on the bullet point; otherwise it
means the point has been discussed but no final decision has been made


## 2024-01-16

We spoke about the AsyncCalls and their frameworks and implementations,
and filesystem layout. This conversation stemmed from
[PR 1635](https://github.com/squid-cache/squid/pull/1635) and
[PR 1548](https://github.com/squid-cache/squid/pull/1548).

* **[C]** in this conversation we are not concerned with the mechanisms by which individual calls are fired
* **[C]** AsyncCall is a delayed function call, that can change the stack
* **[C]** our strategic goal is that all call sthat cannot be expressed as a c++ function call be implemented as AsyncCalls, including all callbacks
* **[C]** call queues and lists and so on are logically tied to calls, not to the firing mechanisms
* AsyncCall.h and related files should be moved out of `src` and into `src/calls`
* @kinkie will prepare a draft proposal on the things to be moved.
  The proposal should include a high level idea about why things should be moved;
  it does not need to include any description of why other things should not be moved