---
---
# Error Handling

This page details
[SquidCodingGuidelines](/DeveloperResources/SquidCodingGuidelines) related to
validating code invariants and input.


## Primary API choices

There are several primary ways to handle error conditions in Squid code. For
any given context, only one approach is usually the correct choice. Using the
list below, pick the _first_ one that matches your use case. See further below
for notes about such special rare cases as bug workarounds, unreachable code,
optional custom assertion messages, and legacy code.

1. If the condition can be checked at compilation time, use `static_assert()`.
   Minor code adjustments to make compile-time assertions possible may be
   allowed, but Squid currently avoids explicit `constexpr`, and sprinkling
   Squid code with many `constexpr` specifiers to get some compile-time
   assertion working is usually a bad idea.

2. If the condition describes a code invariant (e.g., "our caller must supply
   a non-nil pointer"), use `Assure()`. In most cases, `Assure()` failures
   kill the checking transaction but keep its kid process alive. Neither
   outcome is guaranteed though because Squid may catch and handle the
   exception before it kills the transaction, or the exception may propagate
   to the top level where it kills the kid process.

3. If the condition describes some input characteristics (e.g., "the client
   sent a syntactically valid HTTP request to Squid"), do not use any of the
   above calls. Instead, create and throw a `TextException` object, return
   `std::nullopt`, or otherwise signal the problem to the caller. In most
   cases, adding a level-0/1 `debugs()` `ERROR` or `WARNING` message is _not_
   a good idea. This is especially true when Squid cache administrator can do
   nothing about that bad input, and that bad input does not represent some
   very unusual or dangerous situation. Most transaction-related input
   validation failures ought to be reflected in various error details logged
   to `access.log`, not level-0/1 `cache.log` messages.


## Squid bug workarounds

In special rare cases, implementing a temporary bug workaround would be much
better than killing the affected transaction or Squid. In such cases, produce
`DBG_CRITICAL` or `DBG_IMPORTANT` _reporting_ with `ERROR` _and_ `Squid BUG`
labels but without calling `Assure()`.

```C++
debugs(33, DBG_IMPORTANT, "ERROR: Squid BUG: ConnStateData did not close " << clientConnection);
```

More good examples can be found among `git grep ERROR:.Squid.BUG:` matches.


## Unreachable code

Unreachable code is special because there is no meaningful condition to be
evaluated inside that code (unless you consider `true` to be meaningful).
Reaching an unreachable code is a Squid bug. If this bug can be detected at
compile time, use `#error` preprocessor instruction. Otherwise, use `Assure()`
with the following always-false condition pattern:

```C++
Assure(!"invariant description");
```

Good examples can be found among `git grep 'Assure.!"'` matches.


## Custom assertion messages

Compiler-generated `static_assert()`, `Assure()`, `assert()`, and deprecated
`Must()` error messages spell out the specified condition. In special rare
cases, it is desirable to replace that generated message with a custom one.
When doing so, please preserve the message generation algorithm by describing
what should be happening (i.e. the expected condition) rather than what went
wrong. For example,

```C++
// XXX: This bad custom message describes the problem rather than the condition:
static_assert(sizeof(quotedOut) > 0, "quotedOut has zero length");

// OK: These custom messages describe the condition:
static_assert(id > 0, "debugs() message ID must be positive");
Assure2(headerSize >= SwapMetaPrefixSize, "UnpackPrefix() validates metadata length");
```


## Legacy error handling

Legacy error handling macros include `Must()`, `Must3()`, and `TexcHere()`. Do
not use them in new code. The information below is provided to guide the
replacement of legacy calls with their modern equivalents.

* Legacy `Must()` was probably meant for checking input, but developers
  started to use it for checking code invariants as well. The mixture of these
  two use case categories made it impossible to address various `Must()`
  problems, necessitating the introduction of `Assure()` and deprecation of
  `Must()` in 2022 commit b9a1bbfb. When replacing `Must()`, one has to
  determine the correct use case category (as detailed in the enumerated list
  at the beginning of the "Error handling" section).

* Legacy `Must3()` is like `Must()` but supports a custom message. Existing
  `Must3()` custom messages are inconsistent -- some describe the correct
  condition and some describe the failure.

* Legacy `TexcHere()` is a convenience macro. Modern code spells out
  `TextException` and `Here()` explicitly.

Keep in mind that it is usually best to leave legacy code intact. Upgrading
legacy code may be appropriate when your pull request has to modify that
specific legacy code lines for other legitimate in-scope reasons or your pull
request is actually dedicated to upgrading legacy code. In those exceptional
cases, the author becomes responsible for providing a high quality
replacement, of course.


## Other special cases

`Assure()` is not available in code residing outside of `src/`, in helper code
that has not been upgraded to use `src/base` APIs, and in legacy C code. Use
`assert()` instead.

The following error handling functions are not covered by this documentation.
They should be avoided in most cases, especially in new code: `fatalf()`,
`fatal()`, `fatal_dump()`, xassert()`.

