# Feature: Http Status strings pass-through

  - **Goal**: It'd be nice to let http status strings pass through when
    squid doesn't need to change them for whatever reason.

  - **Status**: *Not started*

<!-- end list -->

  - **ETA**: 1

  - **Version**: 3.3

  - **Priority**: 5

  - **Developer**:
    [FrancescoChemolli](/FrancescoChemolli#)

  - **More**: Migrated from bug
    [1868](https://bugs.squid-cache.org/show_bug.cgi?id=1868#).

# Details

The current list of status strings is hardcoded in
HttpStatusLine.cc:httpStatusString. Letting origin strings through
currently incurs in memory management-related difficulties. After
[../BetterStringBuffer](/Features/BetterStringBuffer#)
lands it'll be considerably easier to implement.

[CategoryFeature](/CategoryFeature#)
