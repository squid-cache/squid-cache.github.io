# Feature: Diagnostics Information View

  - **Goal**: To add a basic diagnostic view to Squid for
    troubleshooting

  - **Status**: Not Started

<!-- end list -->

  - **ETA**: unknown

  - **Version**: none yet

<!-- end list -->

  - **Developer**:

  - **More**: bug
    [2334](https://bugs.squid-cache.org/show_bug.cgi?id=2334#)

# Details

From the initial feature request bug:

  - *by Guido Serassio*

Looking to squid-users messages, I have noticed that many times there
some other detail/check about the affected environment is needed before
is possible to answer to questions, and some info sometime are not so
immediately available.

Some examples:

  - If squid is compiled for 64 bit support

  - the exact platform name

  - Build options (already in -v output)

So, we could add this and other basic diagnostic info to squid -v output
and eventually add a new command line option for this.

[CategoryFeature](https://wiki.squid-cache.org/Features/Diagnostics/CategoryFeature#)
