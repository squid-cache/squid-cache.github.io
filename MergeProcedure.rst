#format wiki
#language en
= Squid Merge Procedure =

The requirements outlined in this document are meant to speedup acceptance of code changes while reducing rewrites, minimizing conflicts, and maintaining high quality of the committed code. If the requirements need changing, please discuss ''before'' violating them. Other than that, please use common sense and do what you think is in the best interest of Squid.

 1. [[#Before_you_start_coding]], make sure your future changes are welcomed and coordinate your plans with other developers.
 1. Implement your changes while following SquidCodingGuidelines. Use git for version control (see GitHints).
 1. Complete [[#Submission_Checklist]].
 1. Submit a [[#Pull_Request]] on !GitHub.
 1. Monitor for automated test failures and work with reviewers to get enough [[#Votes]], [[GitHints#Update_a_previously_submitted_pull_request|updating]] your pull request as needed.
 1. Remind Core Developers to merge your eligible pull request as needed (until merging is [[#Automation|automated]]).
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

== Automation ==

/!\ This work-in-progress section is not ready for use or even review.

/!\ This section documents the ''expected'' automation of master commits. The documented procedure has not been fully implemented yet and at least some details will change.

The "trusted master" principle enforced by merge automation states that the master branch automatically gets all ''trusted'' code changes and nothing else. In this context, an trusted code change is, by definition, a non-empty sequence of git commits that satisfies the following requirements:

 i. the sequence is (the beginning of) an [[#Votes|approved]] pull request branch on !GitHub,
 i. the sequence can be fast-forward merged into master without conflicts, and
 i. the last commit in the sequence has passed all the required QA tests.

By default, PR branches must contain a single commit. This rule significantly reduces master noise and ensures that each master commit is trusted because automated tests interrogate a single (usually the latest) PR branch revision rather than each PR branch revision. This rule can be violated in exceptional situations. We may also find a way to merge multi-commit branches while marking the trusted commits specially.

Currently, the approval of earlier PR branch revisions automatically extends to all future branch revisions (until manually withdrawn) but that may change or become configurable on a per-PR basis.

Automated master commits are performed by a program called ''merge bot''. Only the merge bot has the rights to modify master. This document only describes what the merge bot should do. The bot implementations may vary. There are existing merge bots that the Project should consider as alternatives to writing bespoke bot software. The merge bot may delegate implementation of some of its tasks (e.g., vote counting or QA tests) to other automation tools.

Upon noticing any relevant trigger event, the merge bot ensures that exactly one merge bot instance is running and then, for each open pull request, in the order of PR numbers, performs the PR merge steps outlined below. Any failure to perform an individual merge step (including validation failures) aborts that PR consideration, moving on to the next PR.

Here are the steps performed by the merge bot for each considered pull request:

 1. Validate PR approval (i.e., the "Changes approved" green light on !GitHub).
 1. Validate PR status checks (i.e., the "All checks have passed" green light on !GitHub).
 1. Create a new local ''auto'' branch, based of the official master branch.
 1. Merge the PR branch into the auto branch using the fast-forward merging algorithm. Eventual feature: Squash the PR changes if manually requested via a PR comment.
 1. Test the auto branch, updating PR status as needed. Eventual optimization: Or, when possible, just load the existing test result of the latest auto branch revision from the commit SHA-indexed cache.
 1. Validate PR status checks (i.e., the "All checks have passed" green light on !GitHub). This seemingly repeated check is necessary because !GitHub will no longer automatically retest modified PRs after this merge procedure is deployed. Such automatic retesting leads to O(N^2) tests when merging N PRs. Without automated retests, the merge bot must trigger tests of the latest PR code (and check their results).
 1. Validate PR approval (i.e., the "Changes approved" green light on !GitHub). This paranoid repeated check is added primarily because some tests may take a long time and reviewers often have last-minute regrets. The check itself does not cost much.
 1. Push the auto branch into the official master branch. (!GitHub will notice the merged changes and consider the PR merged.)
 1. Eventually: Archive testing artifacts.

Again, any step failure (including validation failures) aborts the steps sequence.

Merge bot trigger events are:

 * a PR voting change
 * a PR test result (change)
 * a PR branch change (although such changes are irrelevant if we can rely on the test result change instead)
 * a master branch change
 * a "merge" command directed at the merge bot by an authorized !GitHub user via a PR comment
