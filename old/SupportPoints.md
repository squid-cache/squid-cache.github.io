# Support Points

Supporting Squid users is one of the primary functions of the Squid
Project. Commercial support has serious potential to help both Squid
users and the Squid Project.

The Squid Project is redesigning the current Squid Support Services
[page](http://www.squid-cache.org/Support/services.html) and the
corresponding service listing procedures with the following goals in
mind:

  - Encourage Squid Project contributions from service providers.

  - Reward service providers that contribute back to the Squid Project.

  - Significantly improve
    [](http://www.squid-cache.org/Support/services.html) quality and
    usability.

  - Rely on a "foxes guarding foxes" system. Minimize Project overheads.

The key idea is to assign every service listing zero or more Support
Points and to list services in the decreasing order of their Support
Points. Other listing orders may be supported as well, but the default
is going to be based on Support Points. Support Points calculation and
listing procedures are detailed in the sections below.

## Support Points Reporting Procedure: Self-Assessment

The Squid Project does not have the resources to accurately compute
Support Points for all service provider listings. If a service provider
wants to associate some Points with their listing, they must report
their Points along with appropriate calculation/justification. That
report is called Self-Assessment.

Squid Project folks reviewing new service entries before adding them to
the database will review Self-Assessments and may verify any submitted
number. Accepted Self-Assessments become public (linked from the Points
number in the support table) so that other service providers can
evaluate and, if needed, challenge them.

The first few Self-Assessments should probably be shared among
submitters to allow for at least one round of adjustments before they
are published and applied.

## Conflict of Interest Disclosure

Very few people can drive these changes, and all of them are conflicted
in one way or the other, so we must approach this as a "foxes guarding
foxes" project where inherit conflicts of interests are acknowledged and
channeled for common good rather than avoided.

## Support Points Calculation

  - 
    
    |                         |                    |                              |
    | ----------------------- | ------------------ | ---------------------------- |
    | **Category**            | **Support Points** | **N**                        |
    | User Support            | log(15 \* N)       | number of squid-users emails |
    | Developer Support       | log(15 \* n)       | number of squid-dev emails   |
    | Squid Development       | log(75 \* N)       | number of trunk commits      |
    | General Project Support | log(N)             | donations size               |
    | log(N)                  | duty bonuses       |                              |
    

Bonuses for volunteers performing specific, regular project duties:

  - 
    
    |                       |       |                                                  |
    | --------------------- | ----- | ------------------------------------------------ |
    | Release Maintainer    | 33900 | \= 30\*(2\*365 + 4\*52 + 16\*12)                 |
    | Build Farm Maintainer | 6080  | \= 20\*(0\*365 + 4\*52 + 8\*12)                  |
    | System Administrator  | TBD   |                                                  |
    | Foundation Director   | 0     | Directorship is a conflict of interests position |
    

    ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    Commits are counted by Author, not Committer fields (if both are
    present). The number of trunk commits should include individual
    commits inside bzr merges because they usually indicate a larger or
    more important/difficult contribution. Most non-trunk commits are
    ported by the release maintainer and so are covered by Maintainer
    bonus.
    
    ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    Donations may include monetary donations to the Foundation and
    non-monetary contributions with clear monetary value regularly used
    by the Project, such as payments for Squid Project hosting services
    or testing software.
    
    ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    All numbers are calculated for the past year (starting approximately
    395 days from the calculation date) and remain fresh for one year
    since submission (but may be occasionally updated before they become
    stale). Activities during the last 30 days should be excluded to
    minimize submission duels and rushed submissions relying on
    potentially unsettled issues.
    
    ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    Logarithm base is 2. Log parameters below 1 are treated as 1 (and
    result in zero log value). The logarithm is applied to encourage
    balanced contributions and discourage attempts to game the system by
    "cheaply" inflating one of the sum elements.

## Expected Changes

We expect the general structure of Support Points calculation to remain
stable. However, the specifics will probably require some fine-tuning.
We hope that this scheme reflects service provider contribution but
understand that exact measurements and comparisons are not possible in
this problem domain.
