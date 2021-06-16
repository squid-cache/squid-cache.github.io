#language en

= Future Release Schedule =

Major stable releases follow a two-year schedule. Beta branches are spawned six months before the corresponding major stable release.

||<:> '''Date''' || '''Release''' || '''Type''' ||
|| 2021-07-04 || v5.0.7 || beta ||
|| 2021-08-01 || v5.1 || stable ||
|| ||
|| 2021-08-02 || v6.0.0 || alpha ||
|| 2023-02-05 || v6.0.1 || beta||
|| 2023-07-06 || v6.1 || stable ||
|| ||
|| 2023-07-07 || v7.0.0 || alpha ||
|| 2025-02-02 || v7.0.1|| beta ||
|| 2025-07-03 || v7.1 || stable ||

= Notes =

The published dates follow the two-year cycle starting with August 1, 2021, with an additional Squid maintainer requirement that these event dates fall on a Sunday. If that additional requirement changes, the dates may be adjusted by up to seven days (in either direction).

A numbered vN branch is considered beta until it is declared stable. There will be no beta branch for the first 18 months of each two-year release cycle, reducing porting and maintenance overheads. The master branch will always be available for testing, of course. 

The tabulated events are nearly instantaneous and should occur (or be deemed occurred) at the beginning of the corresponding day (T00:00:00) in maintainer time zone. After the event, any commits on the corresponding branch must follow ReleaseProcess policies designated to that branch status. The corresponding numbered release should occur as soon as possible after the tabulated event; the maintainer may need about 20 hours (or more) to complete all the required release-making steps.

This release schedule does not affect the master branch and any daily snapshots.

As we gain more experience with these regularly scheduled releases, and as our QA abilities improve, we may decide to shorten the release cycle (e.g., from two to one year) and/or adjust beta duration (e.g., from six to three or nine months). If that happens, the dates after August 1, 2021 and/or the corresponding release numbers may change.
