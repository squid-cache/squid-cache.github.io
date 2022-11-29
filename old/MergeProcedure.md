# Squid Merge Procedure

The requirements outlined in this document are meant to speedup
acceptance of code changes while reducing rewrites, minimizing
conflicts, and maintaining high quality of the committed code. If the
requirements need changing, please discuss *before* violating them.
Other than that, please use common sense and do what you think is in the
best interest of Squid.

1.  [\#Before_you_start_coding](#Before_you_start_coding), make sure
    your future changes are welcomed and coordinate your plans with
    other developers.

2.  Implement your changes while following
    [SquidCodingGuidelines](/SquidCodingGuidelines).
    Use git for version control (see
    [GitHints](/GitHints)).

3.  Complete [\#Submission_Checklist](#Submission_Checklist).

4.  Submit a [\#Pull_Request](#Pull_Request) on GitHub.

5.  Monitor for automated test failures and work with reviewers to get
    enough [\#Votes](#Votes),
    [updating](/GitHints#Update_a_previously_submitted_pull_request)
    your pull request as needed.

6.  Remind Core Developers to merge your eligible pull request as needed
    (until merging is [automated](#Automation)).

7.  Enjoy your code becoming official\!

8.  Support your changes by addressing bug reports and answering related
    development questions.

## Before you start coding

Before spending time coding, please discuss your plans on the
[squid-dev](http://www.squid-cache.org/Support/mailing-lists.html#squid-dev)
mailing list so that others can

  - confirm that the proposed feature is not already supported and is
    welcomed,

  - assist you in finding the best way to add your feature, and

  - prevent duplication of effort (somebody else might be working on
    similar changes already).

## Submission Checklist

If you are sure that an item does not apply to your specific situation,
just skip it (at your own risk).

1.  The code is ready to be published and distributed under the Squid
    licensing terms.

2.  Release notes updated: **doc/release-notes/release-X.sgml**. Don't
    worry about the HTML or TXT files, they are automatically built by
    the maintainer. Only the SGML files need updating.

3.  The feature sponsor is added to the SPONSORS.list file.

4.  Copyright statement and license for newly imported code are added to
    the CREDITS file.

5.  Development branch can be merged into the official master branch
    without conflicts and the merge result contains nothing but the
    proposed new code/changes.

6.  *git diff --check upstream/master* produces no warnings/errors and
    exits with zero status code. Adjust remote (i.e., "upstream") to
    match the official repository (i.e.,
    *github.com:squid-cache/squid.git*) as needed.

7.  **./test-builds.sh** succeeds. In the unlikely event the test fails
    because of the bugs in the official code, file a bug report or
    discuss on squid-dev. Your future pull request will get stuck if it
    cannot pass these basic build tests\!

## Pull Request

All commits to the official repository require a GitHub pull request
(PR). This requirement ensures that all official changes are peer
reviewed, and all official branches are always in working order (to the
extent our testing can detect bugs, of course). It also helps reduce
commit noise and backporting overheads. This section documents PR
requirements. See
[GitHints](/GitHints)
for PR submission recipes.

1.  Please complete [\#Submission_Checklist](#Submission_Checklist)
    before making a pull request. If you really need to post a PR
    earlier, then start your PR title with a "\[WIP\] " prefix (six
    characters indicating a "work in progress") and explain why you are
    posting an unchecked PR in the PR comment. By default, WIP PRs are
    not reviewed, but they do go through CI tests.

2.  Please use English and plain text formatting.

3.  PR title is the first line of the anticipated commit message. Be
    specific but succinct. Do not exceed
    [65](https://github.com/measurement-factory/anubis#commit-message)
    characters.

4.  PR description is the anticipated commit message body (following the
    first line described above and a blank line). Avoid detailing your
    changes (your changes should speak for themselves\!). Focus on *why*
    you changed the code and on the anticipated *impact* of your
    changes. Do not exceed
    [72](https://github.com/measurement-factory/anubis#commit-message)
    characters per line.

5.  By default, individual PR branch commits will be
    [automatically](#Automation) squash-merged. Thus, you may leave
    intermediate commits in your branch when posting your PR -- a
    reviewer should ignore them and review their cumulative result
    instead. Avoid squashing *during* GitHub review iterations.

6.  *During* GitHub review iterations, avoid merging fresh master (or
    target branch) changes into your PR branch unless such an update
    becomes necessary. After the PR is approved, your PR branch will be
    [automatically](#Automation) merged into then-current target branch.

7.  A PR commit not authored by you should have the right author set
    (via *git commit --author=...* or equivalent).

If you cannot submit your changes in the form of a pull request, find a
developer who can do that for you.

## Votes

The first matching rule wins. A submission is automatically counted as
one positive vote from the submitter.

  - ℹ️
    Any developer may vote.
    
    ℹ️
    These rules are not yet fully enforced on GitHub but they (or their
    next revision) will be. For now, GitHub will not allow to merge your
    pull request without a core developer (other than you) approval, but
    all the voting rules still apply.

  - One negative vote by a core developer blocks the merge until
    resolved.

  - Two positive votes from core developers accept the submission (with
    a high priority for merging).

  - Any three positive votes accept the submission.

  - Submissions older than 10 days without negative votes are accepted.

## Exceptions

In truly exceptional situations (that ought to be disclosed and
discussed as soon as possible):

1.  Core developers may commit any changes immediately.

2.  Within 10 days of the commit, core developers may remove any
    submission without prior notice or discussion. A post-factum notice
    (and discussion) are still expected on squid-dev.

### Core Developers

The [core
developers](/WhoWeAre)
mentioned above are experienced developers with serious long-term
dedication and contribution to the Squid Project as a whole and Squid
code in particular. They are usually active on squid-dev and often
review submissions. Core folks have collective responsibility for the
Squid Project and may use their super powers to resolve conflicts or
prevent disasters.

## Automation

The "trusted master" principle enforced by merge automation states that
the master branch automatically gets all *trusted* code changes and
nothing else. In this context, an trusted code change is, by definition,
a non-empty sequence of git commits that satisfies the following
requirements:

1.  the sequence is (the beginning of) an [approved](#Votes) pull
    request branch on GitHub,

2.  the sequence can be merged into master without conflicts, and

3.  the last commit in the sequence has passed all the required QA
    tests.

Currently, PR branches are squashed when merging. Squashing
significantly reduces master noise and ensures that each master commit
is trusted because automated tests interrogate the to-be-committed (and
usually the latest) PR branch revision. If needed, we can find a way to
mark the trusted commits specially while merging unsquashed branches
under exceptional circumstances.

Currently, the approval of earlier PR branch revisions automatically
extends to all future branch revisions (until manually withdrawn) but
that may change or even become configurable on a per-PR basis.

Automated master commits are performed by a program called *merge bot*.
Only the merge bot has the rights to modify master. The Squid Project is
currently using the
[Anubis](https://github.com/measurement-factory/anubis#readme) merge bot
with the following configuration:

|                         |                                                                                                                                                                                                    |                |
| ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- |
| **Field**               | **Description**                                                                                                                                                                                    | **Value**      |
| *github_login*         | The bot uses this GitHub user account for all GitHub communications, including target branch updates. This user needs to have write access to the repository.                                      | "squid-anubis" |
| *staging_branch*       | The name of the bot-maintained git branch used for testing PR changes as if they were merged into their target branch.                                                                             | auto           |
| *necessary_approvals*  | The minimal number of core developers required for a PR to be merged. PRs with fewer votes are not merged, regardless of their age.                                                                | 1              |
| *sufficient_approvals* | The minimal number of core developers required for a PR to be merged fast (i.e., without waiting for `config::voting_delay_max`)                                                                   | 2              |
| *voting_delay_min*    | The minimum merging age of a PR. Younger PRs are not merged, regardless of the number of votes. The PR age string should comply with [timestring](https://github.com/mike182uk/timestring) parser. | "2d"           |
| *voting_delay_max*    | The maximum merging age of a PR that has fewer than `config::sufficient_approvals` votes. The PR age string should comply with [timestring](https://github.com/mike182uk/timestring) parser.       | "10d"          |
| *staging_checks*       | The expected number of CI tests executed against the staging branch.                                                                                                                               | 2              |
| *guarded_run*          | Only PRs (manually) labeled `M-cleared-for-merge` are merged by Anubis.                                                                                                                            | true           |
