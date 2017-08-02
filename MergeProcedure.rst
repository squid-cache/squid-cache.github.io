#format wiki
#language en
= Squid Merge Procedure =

The requirements outlined in this document are meant to speedup acceptance of code changes while reducing rewrites, minimizing conflicts, and maintaining high quality of the committed code. If the requirements need changing, please discuss ''before'' violating them. Other than that, please use common sense and do what you think is in the best interest of Squid.

 1. [[#Before_you_start_coding]], make sure your future changes are welcomed and coordinate your plans with other developers.
 1. Implement your changes while following SquidCodingGuidelines. Use git for version control (see GitHints).
 1. Complete [[#Submission_Checklist]].
 1. Submit a [[#Pull_Request]] on !GitHub.
 1. Monitor for automated test failures and work with reviewers to get enough [[#Votes]], [[GitHints#Update_a_previously_submitted_pull_request|updating]] your pull request as needed.
 1. Remind Core Developers to merge your eligible pull request as needed.
 1. Enjoy your code becoming official!
 1. Support your changes by addressing bug reports and answering related development questions.

== Before you start coding ==

Before spending time coding, please discuss your plans on the [[http://www.squid-cache.org/Support/mailing-lists.html#squid-dev|squid-dev]] mailing list so that others can

 * confirm that the proposed feature is not already supported and is welcomed,
 * assist you in finding the best way to add your feature, and
 * prevent duplication of effort (somebody else might be working on similar changes already).

== Submission Checklist ==

If you are sure that an item does not apply to your specific situation, just skip it (at your own risk).

 1. The code is ready to be published and distributed under the Squid licensing terms.

 1. Release notes updated: '''doc/release-notes/release-X.sgml'''. Don't worry about the HTML or TXT files, they are automatically built by the maintainer. Only the SGML files need updating.

 1. The feature sponsor is added to the SPONSORS.list file.

 1. Copyright statement and license for newly imported code are added to the CREDITS file.

 1. Development branch rebased on top of the official master branch.

 1. ''git diff --check upstream/master'' produces no warnings/errors and exits with zero status code. Adjust remote (i.e., "upstream") to match the official repository (i.e., ''github.com:squid-cache/squid.git'') as needed.

 1. '''./test-builds.sh''' succeeds. In the unlikely event the test fails because of the bugs in the official code, file a bug report or discuss on squid-dev. Your future pull request will get stuck if it cannot pass these basic build tests!

== Pull Request ==

All commits to the official repository require a !GitHub pull request (PR). This requirement ensures that all official changes are peer reviewed, and all official branches are always in working order (to the extent our testing can detect bugs, of course). It also helps reduce commit noise and backporting overheads. This section documents PR requirements. See GitHints for PR submission recipes.

 1. Please complete [[#Submission_Checklist]] before making a pull request. If you really need to post a PR earlier, then start your PR title with a "[WIP] " prefix (six characters indicating a "work in progress") and explain why you are posting an unchecked PR in the PR comment. By default, WIP PRs are not reviewed, but they do go through CI tests.
 1. Please use English and plain text formatting.
 1. PR title is the first line of the anticipated commit message. Be specific but succinct (do not exceed 72 characters).
 1. PR description is the anticipated commit message body (following the first line described above and a blank line). Avoid detailing your changes (your changes should speak for themselves!). Focus on ''why'' you changed the code and on the anticipated ''impact'' of your changes.
 1. PR branch should contain all commits that you want to see in the official tree and nothing else. If your branch has intermediate/housekeeping commits, squash them. Most PR branches should contain a single commit. If your branch contains multiple commits, reviewers may ask you to squash them. /!\ Currently, the rules in this item are not enforced. Approved PRs are manually squashed during commit instead, but that approach is wrong and will change when official commits are fully automated.
 1. Each PR branch commit should follow the same language/title/body rules outlined above.
 1. Each PR commit not authored by you should have the right author set (via ''git commit --author=...'' or equivalent).

If you cannot submit your changes in the form of a pull request, find a developer who can do that for you.

== Votes ==
The first matching rule wins. A submission is automatically counted as one positive vote from the submitter.

 {i} Any developer may vote.

 {i} These rules are not yet fully enforced on !GitHub but they (or their next revision) will be. For now, !GitHub will not allow to merge your pull request without a core developer (other than you) approval, but all the voting rules still apply.

 1. One negative vote by a core developer blocks the merge until resolved.

 1. Two positive votes from core developers accept the submission (with a high priority for merging).

 1. Any three positive votes accept the submission.

 1. Submissions older than 10 days without negative votes are accepted.

== Exceptions ==

In truly exceptional situations (that ought to be disclosed and discussed as soon as possible):

 1. Core developers may commit any changes immediately.

 1. Within 10 days of the commit, core developers may remove any submission without prior notice or discussion. A post-factum notice (and discussion) are still expected on squid-dev.

=== Core Developers ===
The [[WhoWeAre|core developers]] mentioned above are experienced developers with serious long-term dedication and contribution to the Squid Project as a whole and Squid code in particular. They are usually active on squid-dev and often review submissions. Core folks have collective responsibility for the Squid Project and may use their super powers to resolve conflicts or prevent disasters.
