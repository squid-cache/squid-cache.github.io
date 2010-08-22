#format wiki
#language en
== Squid Merge Procedure ==
In order to clean up the quality of code entering Squid, the core developers have arranged these simple requirements and procedure for submissions.

<<TableOfContents>>

=== Pre-Code ===
Before spending time coding, its best to discover whether or not the code is needed or useful.

We would like everyone to discuss their plans in the [[http://www.squid-cache.org/Support/mailing-lists.dyn#squid-dev|squid-dev]] mailing list (its open to anyone). So that we can

 * assist new developers in finding the best way to add their features
 * and, prevent duplication of effort (your feature may be half-developed already)
 * and, sometimes the feature wanted already exists in a unexpected way.

Other developers are often able to provide projects for anyone just wanting to contribute.

=== Code Style ===
Squid-2 and Squid-3 use different coding styles.

'''Squid-3''':
 * Squid3CodingGuidelines lists the fine details of syntax required.
 * Formatting is presently enforced automatically post-commit.
## * Self-checks may be done using '''astyle 1.22''' and the '''scripts/srcformat.sh''' script.

'''Squid-2''':

 * Properly indented with a style similar to the rest of the code.
 * Any C code will be indented by GNU indent 1.9.1 (exact version, no other GNU indent version) with the options:
 * {{{indent -br -ce -i4 -ci4 -l80 -nlp -npcs -npsl -d0 -sc -di0 -psl}}}.

=== Submission Format ===
Submissions are emailed to squid-dev for merging, one submission per post. The submission email must contain:

 * '''Subject''': The name of the new feature or a brief change description, prefixed with [MERGE] or [PATCH].
 * '''Main body''': A full description of the new feature or change. The description guides those reading your code. Its verbatim copy is usually used as the commit message if your submission is accepted.
 * '''Attachment''': A bzr [MERGE] bundle or a manual [PATCH] in a unified diff format.

=== Merging Steps for Squid3 ===
 1. Check that you have added release notes, if any are needed: '''doc/release-notes/release-3.X.sgml'''. Don't worry about the HTML or TXT files, they are automatically built by the maintainer.

 1. If applicable, check that you have added the feature sponsor to the SPONSORS file.

 1. Bring your development branch up to date as described in: [[http://wiki.squid-cache.org/Squid3VCS#head-9006c046b5c83dde25ebaaf96152eac43964b556|Squid3VCS]]

 1. Run a full build test: '''./test-builds.sh'''.

 1. Fix ALL issues with your code uncovered by that testing. If you are certain a problem is with the trunk code, discuss it on squid-dev.

 1. When your code passes testing, [[http://wiki.squid-cache.org/Squid3VCS#head-15b44894cf04d464f2392ebcd20bce9f514f3657|Submit a merge bundle]] or patch for auditing. see above.

 1. Read reviews and address feedback, if any. This step may require re-coding and resubmitting your work or defending your choices until your submission is accepted (i.e., gets a passing vote, see below).

Submissions are normally merged on the next maintenance cycle after acceptance (usually weekends).

==== Squid3 Voting ====
The first matching rule wins. A submission is automatically counted as one positive vote from the submitter.

 1. One negative vote by a core developer blocks the merge until resolved.

 1. Two positive votes from core developers accept the submission (with a high priority for merging).

 1. Any three positive votes accept the submission.

 1. Submissions older than 10 days without negative votes are accepted.

==== Squid3 Exceptions ====
 1. Core developers may commit any changes immediately.

 1. Within 10 days of the commit, core developers may remove any submission without prior notice or discussion. A post-factum notice (and discussion) are still expected on squid-dev.

=== Merging Steps for Squid2 ===
 1. The merge should be well tested, isolated, documented and cleaned up etc.

 1. The merge should only contain a specific change and not multiple unrelated changes. Unrelated changes should be broken up into separate commits each following their own path in this procedure.

 1. Larger or otherwise intrusive changes is sent to squid-dev for review. Ok for commit if there is a positive response from another core member, or no negative responses from anyone in a week.

 1. Smaller changes or changes you do not expect someone to say no on may be committed immediately.

 1. If a change is later found to cause trouble and not obviously trivial to fix then it will be thrown out, waiting for someone to make a proper fix.

Please try to not commit unfinished stuff needing more work to actually work the way intended. HEAD is not meant for development, that's supposed to done on branches..

If a follow up change (bugfix etc) is committed related to an earlier change please refer to the subject (first line) of the previous change in the commit message.

If you suspect that there will be a series of incremental commits relating to a specific feature or reorganisation then make the subject line easy to connect together by starting the title line with a short featurename:  (i.e. "rproxy: header fixes")

Add to the above the parts of the Squid-3 procedure you think makes sense. Use of common sense is the main rule of conduct.

=== Core Developers ===
The [[WhoWeAre|core developers]] mentioned above are experienced developers with serious long-term dedication and contribution to the Squid project as a whole and Squid code in particular. They are usually active on squid-dev and often perform the auditing duties personally. Core folks have collective responsibility for the Squid project and may use their super powers to resolve conflicts or prevent disasters.
