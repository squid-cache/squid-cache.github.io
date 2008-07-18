#format wiki
#language en
== Squid Merge Procedure ==

In order to clean up the quality of code entering Squid the core developers have arranged these simple requirements and procedure for submissions.

<<TableOfContents>>

=== Pre-Code ===

Before spending time coding, its best to discover whether or not the code is needed or useful.

We would like everyone to discuss their plans in the [[http://www.squid-cache.org/Support/mailing-lists.dyn#squid-dev|squid-dev]] mailing list (its open to anyone). So that we can
 * assist new developers in finding the best way to add their features
 * and, prevent duplication of effort (your feature may be half-developed already)
 * and, sometimes the feature wanted already exists in a unexpected way.

The core developers are often able to provide jobs of for anyone just wanting to contribute.

=== Code Style ===

There are specific coding styles used in Squid-2 and Squid-3. Both are different. They can be found (where is the most current??)

=== Submission Format ===

During the procedure below one entry is the squid-dev merge submission.

This submission may be a bzr [MERGE] bundle, or a manual [PATCH] unified diff patch.

Please make the subject of the email the name of your feature, and place a full description of the feature behavior and effects in the body. This description becomes the formal documentation in some cases. Provides a guideline for those reading your code. And almost always goes in verbatim as the description of the merge commit.

=== The Merge Procedure Itself ===

 1. check that you have added release notes, if any are needed: '''doc/release-notes-3.X.sgml'''. Don't worry about the HTML or TXT files, they are automatically built by the maintainer.

 1. If paid work: check that you have added the feature sponsor to the SPONSORS file.

 1. bring your development branch up to date as described in: [[http://wiki.squid-cache.org/Squid3VCS#head-9006c046b5c83dde25ebaaf96152eac43964b556|Squid3VCS]]

 1. run a full build test: '''./test-builds.sh'''.

 1. fix ALL issues with your code uncovered by that testing. If you are certain a problem is with the trunk code, discuss it with squid-dev.

 1. when your code passes testing [[http://wiki.squid-cache.org/Squid3VCS#head-15b44894cf04d464f2392ebcd20bce9f514f3657|Submit a merge bundle]] or patch for auditing. see above.

 1. Other developers often check your code for a number of things and provide feedback.

  1. Any negative feedback must be addressed (by re-coding, or logical argument) before its accepted.
  1. Two '''+''' votes from core developers jumps the request to high-priority for merge
  1. One '''-''' vote of veto or delay by any core developer blocks the merge until resolved
  1. Any 3 votes for inclusion see it accepted.
  1. A merge submission is automatically counted as one vote from the submitter.
  1. merge requests older than 10 days without negative votes are deemed accepted

 1. requests will normally be merged on the next maintenance cycle after acceptance (usually weekends).

 1. core developers may bump any patch for immediate merge.

 1. core developers may bump any patch for removal without notice or discussion within 10 days of commit. Longer and discussion is expected in squid-dev about why its being removed.


=== Core Developers ===

The core developers mentioned above are developers with serious long-term dedication to the Squid project and code in particular. They are all contactable through squid-dev, and often perform the auditing duties personally. They're the ones who often get yelled at if things go sour, so thats why they have quick veto power.

WhoWeAre
