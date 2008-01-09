#language en
## add some descriptive text. A title is not necessary as the WikiPageName is already added here.
## if you want to have a table of comments remove the heading hashes from the next line
## [[TableOfContents]]
This process used by the Squid Developers as a guideline in how and when new Squid releases are released:

 1. Finalise the list of to-be-included features. Features outside this list is not accepted for HEAD from this point
 1. When most of the to-be-included user visible features exists and is believed to work, release DEVEL-X and announce to squid-users. Repeat as neccesary when there is significant progress. At this point basic Release Notes should exists, and !ChangeLog will reflect any changes done, small as large. (I.E. overlapping requests may not be in at this point, but it's not user visible - so doesn't delay announce of DEVEL)
 1. When no giant bugs are found for a fortnight, release PRE1 and announce to squid-users. (At this point, Release Notes should be complete, these releases is to get some early adopters providing feedback and portability verification)
 1. When there has been a fortnight with no critical bugs, branch the new version and reopen HEAD for new developments.
 1. Give each PRE release a fortnight for bugs, and when we go for a fortnight with no new bugs, release STABLE1.
 1. From STABLE1 any changes should have a corresponding bugzilla entry, and be documented with description and patch on the bugs/patches page of the release.
 1. When needed and there has been at least a fortnight from the last large modification and at least one week from the last non-cosmetic patch elease the next STABLE version. Repeat as neccesary.
