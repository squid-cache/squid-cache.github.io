n---
---
# Git Hints

This page archives git recipes that may be useful in the context of
Squid development. It is not meant as a guide to git or GitHub. Most of
the recipes here target *developers* that will eventually submit pull
requests back to the Squid Project.

:warning:
Many later recipes rely on the setup (partially) shown in earlier
recipes. Your setup may be different; git-related naming conventions
vary a lot. If you start in the middle, make sure you understand what
you are doing before copy-pasting any commands\!

## When a recipe is missing

Use a search engine to solve git and GitHub problems. Virtually all
basic questions about git and GitHub (and many advanced ones) are
answered on the web. Git mastery helps, but is not required to do Squid
development. Git manipulations required for typical Squid development
are hardly rocket science.

## Create your public Squid repository on GitHub

1. Login to GitHub.
2. Navigate to the Squid
    [repository](https://github.com/squid-cache/squid).
3. Click the "Fork" button.

> :warning:
    If you are a part of an organization, that organization may already
    have a Squid repository fork that you should use instead.

## Create your local Squid work area

Your git work area will be a combination of your public Squid repository
(a.k.a. "origin" remote), the official Squid repository (a.k.a.
"upstream" remote), and your private (unpublished) Squid branches.

1. Clone your public Squid repository on GitHub into your local work
    area. By default, git will refer to your public repository as
    "origin". This is where you will publish your development branches.
    To get the right repository .git address for the first command,
    click the "clone or download" button while looking at your
    repository on GitHub. The "clone or download" button offers https
    and ssh protocols; for development work, you may find ssh
    authentication easier to work with. The example below uses an ssh
    address.
    :warning:
    You may need to upload your publish ssh key to your GitHub account
    first.

    ```bash
        $ git clone git@github.com:YOUR_GITHUB_LOGIN/squid.git
        $ cd squid
        $ git remote -v # Should show you the origin repository address
    ```

2. Point git to the official Squid repository on GitHub. These
    instructions call that repository "upstream", but the name of the
    remote is up to you. You will never push into this repository, but
    you will submit pull requests against it.

    ```bash
        $ git remote add -m master upstream git@github.com:squid-cache/squid.git
        $ git remote -v # Should show you the origin and upstream repository addresses
        $ git remote set-url --push upstream upstream-push-disabled # prevents and highlights accidental pushes
    ```

3. Optionally, load git
    [notes](http://alblue.bandlem.com/2011/11/git-tip-of-week-git-notes.html)
    to see original Bazaar revision numbers, --fixes URLs, and more
    co-author names in git logs:

        $ git fetch upstream refs/notes/commits:refs/notes/commits

    >  :warning:
        If you are a part of an organization, that organization may provide
        its own Squid annotations that you should load instead or in
        addition to the official ones.

## Start working on a feature or change

Most stand-alone code changes need a dedicated git branch. If you want
to submit your changes for the official inclusion, you must create a
dedicated branch for each such submission (a.k.a. pull request or PR).
Git branches are cheap. Each branch is little more than a named pointer
to the latest commit on the branch.

These commands assume that your changes are based on the latest
[official master branch](https://github.com/squid-cache/squid).

1. Make sure your upstream master is up to date:

        $ git fetch upstream master

2. Create a new local feature branch based on the the very tip of the
    upstream master. This example uses "support-foobar" as the branch
    name.

        $ git checkout -b support-foobar upstream/master

You can now make and commit changes to your local feature branch.

## Compare your changes with the official code

1. To compare with the official code that you have previously fetched:

        $ git diff upstream/master

2. To compare with the official code as it existed when you created
    your feature branch:

        $ fork_point=$(git merge-base --fork-point upstream/master support-foobar)
        $ git diff $fork_point

> :information_source:
    Use *git diff --check ...* to check for basic whitespace problems.

## Squash all the feature branch changes into a single commit

> :warning:
    These commands rewrite branch history. Rewriting history may mess up or
    even permanently destroy your work\! Consider pushing all changes to
    your GitHub repository *before* squashing your local tree and do *not*
    publish the squashed branch until you are sure it ends up with the same
    code as the last pushed commit.

> :information_source:
    If you need to both rebase and squash your feature branch, you may use
    interactive
    [rebase](#rebase-your-feature-branch-to-another-official-branch)
    and replace the default "pick" with "squash" commands there. The
    resulting squashed commit will get the metadata such as Date from the
    first feature branch commit, confusing readers and some tools
    (especially on long-lived feature branches), but you can fix that using
    something like *git commit --amend --date="$(date)"*. Doing two things
    at once (i.e., squashing and rebasing) is faster when things go
    smoothly, but it is more difficult to discover and fix problems. Also,
    rebasing an already *squashed* branch may reduce the number of conflicts
    but may also create more complex conflicts. Pick your poison.

1. Switch to the local up-to-date feature branch you want to squash:

        $ git checkout support-foobar

2. Find the master commit from which your feature branch originated,
    either by examining *git log support-foobar* or by using the
    following trick (which
    [reportedly](https://stackoverflow.com/questions/1527234/finding-a-branch-point-with-git)
    fails in some cases):

        $ fork_point=$(git merge-base --fork-point upstream/master support-foobar)

3. Double check that you found the right forking point before making
    any changes. For example:

        $ git show $fork_point

    and/or

        $ git log | less +/$fork_point

4. Undo all feature branch commits up to the forking point while
    keeping their cumulative results, staged in your working directory:

        $ git reset --soft $fork_point

5. Re-commit the staged results with a new commit message summarizing
    all the changes on the feature branch:

        $ git commit

    If you need to see your old commit messages, and you have published
    your unsquashed changes on GitHub as recommended earlier, then you
    can still easily get them from

        $ git log origin/support-foobar

6. Double check that the squashed result is identical to the published
    feature branch:

        $ git diff --exit-code origin/support-foobar || echo 'Start panicking!'

7. When comfortable, publish your squashed changes, permanently
    deleting the old feature branch commits:

        $ git push # will fail, giving you the last change to check its intended destination before you add --force

## Rebase your feature branch to be in sync with the current upstream master

> :warning:
    These commands rewrite branch history. Rewriting history may mess up or
    even permanently destroy your work\! Consider pushing all changes to
    your GitHub repository *before* rebasing your local tree.

> :information_source:
    If you need to both rebase and squash your feature branch, you may use
    the interactive rebase command shown below and replace the default
    "pick" with "squash" commands there. The resulting squashed commit will
    get the metadata such as Date from the first feature branch commit,
    confusing readers and some tools (especially on long-lived feature
    branches), but you can fix that using something like *git commit --amend
    --date="$(date)"*. Doing two things at once (i.e., squashing and
    rebasing) is faster when things go smoothly, but it is more difficult to
    discover and fix problems. Also, rebasing an already
    [squashed](#squash-all-the-feature-branch-changes-into-a-single-commit)
    branch may reduce the number of conflicts but may also create more
    complex conflicts. Pick your poison.

1. Make sure your upstream master is up to date:

        $ git fetch upstream master

2. Switch to the to the local up-to-date feature branch you want to
    rebase:

        $ git checkout support-foobar

3. Start the interactive rebase process. The command below should start
    your editor so that you can tell git what to do with each of the
    listed commits. The default "pick" action works well for simple
    cases.

        $ git rebase --interactive upstream/master

4. When comfortable, publish your rebased feature branch, permanently
    deleting the old feature branch commits:

        $ git push # will fail, giving you the last change to check its intended destination before you add --force

## Submit a pull request

1. Publish your feature branch in your GitHub repository:

        $ git push --set-upstream origin

2. When you are [ready](/MergeProcedure#Submission_Checklist):
    1. either go to [GitHub](https://www.github.com/), navigate to the
        support-foobar branch in your repository, and click the "new
        pull request" button next to the branch name
    2. or use a console pull request submission tool of your choice.
        This example uses [hub](https://hub.github.com/):

            $ hub pull-request

## Update a previously submitted pull request

1. When you are [ready](/MergeProcedure#Submission_Checklist),
    publish your updates in your GitHub repository:

        $ git push

2. GitHub will notice the updates in your public repository and reflect
    them in your pull request in the official repository. Now it is time
    to go through the reviewer comments inside the pull request and
    respond to those you have addressed with "Done", "Fixed", or another
    comment, as appropriate.

If you rebased your local feature branch or otherwise altered its
previously published history, then you will need to force-push your
changes. Forced pushes are normally OK for feature branches that you
have not knowingly shared with anybody (other than via pull requests).
In most other cases, force pushes are a *very bad idea*, so make sure
you know what you are doing\!

## Rebase your feature branch to another official branch

A feature branch that was branched off master often needs to be rebased
on top of a versioned Squid branch (e.g., v4.0) so that the feature can
be backported to a specific Squid release series. A similar need arises
when you were developing a, say, v3.5 fix but then realized that the
Squid Project wants you to submit a pull request against the *master*
branch instead.

> :warning:
    To simply cherry pick officially committed changes into a new feature
    porting branch, see "git cherry-pick --help". This section covers more
    complex (and relatively rare) use cases where rebasing the old feature
    branch is more appropriate than cheery picking individual commits into a
    new feature branch.

1. Here is a possible first step to switch the base of your feature
    branch:

        git rebase --fork-point upstream/master --interactive --onto upstream/v4.0

    The above command switches the base branch from the official master
    branch to the official branch called v4.0.
    :warning:
    If, prior to rebase, your feature branch is not up to date with its
    official base branch, then you will need to use *HEAD\~1* or a
    similar reference/SHA to identify the right fork point (i.e., the
    last official commit on your feature branch). Please note that this
    example assumes that all your feature branch commits sit on top of
    its base branch already. If that assumption is false in your use
    case, then you will need to rebase your branch commits on top of its
    base branch before switching the base branches (there is another
    [hint](#Rebase_your_feature_branch_to_be_in_sync_with_the_current_upstream_master)
    about that).

2. Changing the base branch often leads to conflicts that you will need
    to resolve. A *git rebase --continue* command will move you forward
    with the rebase process. Moreover, even without conflicts, you may
    need to modify your code to actually work well in another code base.
    This hint does *not* cover those common complications.

3. This example does not contain a final "git push" command that makes
    your changes public (after all conflicts are resolved, and the
    feature is tested on the new base branch). There are two primary
    options to publish your rebased feature:

      - Either push to the old origin feature branch (obliterating old
        public changes in that branch and updating any pull requests
        tied to that feature branch). Force-pushing is required here.

      - Or you can create a new origin feature branch dedicated to this
        backport (and then submit a brand new pull request based on that
        newly created feature branch). No force pushing is required.

It may be tempting to let git figure out the fork point for you. In most
cases dealing with switching between official base branches, git will
find a fork point where the target official branch (i.e., v4.0 in the
above example) forked off the other official branch (i.e., master in the
above example), resulting in your rebased branch containing hundreds of
unwanted official commits instead of just your feature changes. This is
why the above example explicitly sets the fork point\! Fortunately,
feature branch commits are easy to isolate (e.g., by looking at the
branch log) when all of those commits are already sitting on top of the
current base branch (which is a prerequisite for a less painful switch
anyway).

## What happens to origin/master?

The primary purpose of having your own public repository on GitHub is so
that you can submit pull requests and share code with your collaborators
or users. The copies of official branches in your forked repository will
become stale because neither you nor anybody else need them (everybody
should go upstream for the current official code). Unless you forked the
official Squid repository to create a splinter project, you can safely
ignore the copies of the official branches in your public Squid
repository on GitHub. You may pull upstream changes into origin once in
a while, as shown below, but many developers do not bother to do that.

    $ git push origin upstream/master:master
