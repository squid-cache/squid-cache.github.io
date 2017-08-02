= Git Hints =

This page archives git recipes that may be useful in the context of Squid development. It is not meant as a guide to git or !GitHub. Most of the recipes here target ''developers'' that will eventually submit pull requests back to the Squid Project.

/!\ Many later recipes rely on the setup (partially) shown in earlier recipes. Your setup may be different; git-related naming conventions vary a lot. If you start in the middle, make sure you understand what you are doing before copy-pasting any commands!


<<TableOfContents>>

== When a recipe is missing ==

Use a search engine to solve git and !GitHub problems. Virtually all basic questions about git and !GitHub (and many advanced ones) are answered on the web. Git mastery helps, but is not required to do Squid development. Git manipulations required for typical Squid development is hardly rocket science.

== Create your public Squid repository on GitHub ==

 1. Login to !GitHub.
 2. Navigate to the official Squid [[https://github.com/squid-cache/squid|repository]].
 3. Click the "Fork" button. /!\ If you are a part of an organization, that organization may already have a Squid repository fork that you should use instead.


== Create your local Squid work area ==

Your git work area will be a combination of your public Squid repository (a.k.a. "origin" remote), the official Squid repository (a.k.a. "upstream" remote), and your private (unpublished) Squid branches.

 1. Clone your public Squid repository on !GitHub into your local work area. By default, git will refer to your public repository as "origin". This is where you will publish your development branches. To get the right repository .git address for the first command, click the "clone or download" button when looking at your repository on !GitHub.{{{#!shell
$ git clone git@github.com:YOUR_GITHUB_LOGIN/squid.git
$ cd squid
$ git remote -v # Should show you the origin repository address
}}}
 2. Point git to the official Squid repository on !GitHub. These instructions call that repository "upstream", but the name of the remote is up to you. You will never push into this repository, but you will submit pull requests against it.{{{#!shell
$ git remote add -m master upstream git@github.com:squid-cache/squid.git
$ git remote -v # Should show you the origin and upstream repository addresses
}}}

== Start working on a feature or change ==

Most stand-alone code changes need a dedicated git branch. If you want to submit your changes for the official inclusion, you must create a dedicated branch for each such submission (a.k.a. pull request or PR). Git branches are cheap. Each branch is little more than a named pointer to the latest commit on the branch.

These commands assume that your changes are based on the latest [[https://github.com/squid-cache/squid|official master branch]].


 1. Make sure your upstream master meta-information is up to date:{{{#!shell
$ git fetch upstream master
}}}
 2. Go to the very tip of the upstream master:{{{#!shell
$ git checkout upstream/master
}}}
 3. Create a new local feature branch. This example uses "support-foobar" as the branch name.{{{#!shell
$ git checkout -b support-foobar
}}}

You can now make and commit changes to your local feature branch.


== Compare your changes with the official code ==

 1. To compare with the official code that you have previously fetched:{{{#!shell
$ git diff upstream/master
}}}


== Submit a pull request via GitHub ==


 1. Publish your feature branch in your !GitHub repository:{{{#!shell
$ git push --set-upstream origin support-foobar
}}}
 2. When you are [[MergeProcedure#Submission_Checklist|ready]], go to !GitHub, navigate to the support-foobar branch in your repository, and click "new pull request" button next to the branch name.


== Submit a pull request from the console ==

 1. Publish your feature branch in your !GitHub repository:{{{#!shell
$ git push --set-upstream origin support-foobar
}}}
 2. When you are [[MergeProcedure#Submission_Checklist|ready]], use a console pull request submission tool of your choice. This example uses [[https://hub.github.com/|hub]]:{{{#!shell
$ hub pull-request
}}}

== Update a previously submitted pull request ==

 1. When you are [[MergeProcedure#Submission_Checklist|ready]], publish your updates in your !GitHub repository:{{{#!shell
$ git push
}}}
 2. !GitHub will notice the updates in your public repository and reflect them in your pull request in the official repository. Now it is time to go through the reviewer comments inside the pull request and respond to those you have addressed with "Done", "Fixed", or another comment, as appropriate.


If you rebased your local feature branch or otherwise altered its previously published history, then you will need to force-push your changes. Forced pushes are normally OK for feature branches that you have not knowingly shared with anybody (other than via pull requests). In most other cases, force pushes are a ''very bad idea'', so make sure you know what you are doing!

== What happens to origin/master? ==

The primary purpose of having your own public repository on !GitHub is so that you can submit pull requests and share code with your collaborators or users. The copies of official branches in your forked repository will become stale because neither you nor anybody else need them (everybody should go upstream for the current official code). Unless you forked the official Squid repository to create a splinter project, you can safely ignore the copies of the official branches in your public Squid repository on !GitHub. You may pull upstream changes into origin once in a while, but many developers do not bother to do that.
