= Bazaar =

----

/!\ '''''This page is obsolete and only kept for historic purposes. Squid has transitioned to git and github as SCM and main source repository'''''

----

Bazaar is a distributed VCS written in python. It offers both drop-in CVS replacement work flow (use checkouts to work on code), and full distributed work flow (every copy is a new branch), up to the user to work as they want.

<<TableOfContents>>

 . Back to DeveloperResources

= Installation =
Bazaar is available in most O/S's these days: http://bazaar-vcs.org/Download.

Things to install (as a user):

 * bzr
  . version 1.2 or later recommended for best performance, but 1.0 or later is sufficient.
 * bzr-email (as a package it may be a bit old, try:
  . {{{mkdir -p ~/.bazaar/plugins/ && bzr branch http://bazaar.launchpad.net/~bzr/bzr-email/trunk/ ~/.bazaar/plugins/email}}} Then do 'bzr help email' and setup any local machine configuration you need in bazaar.conf - such as mailer to use etc.
 * bzrtools (optional)
  . adds the cbranch plugin, making it easier to work with a local repository

= Repository Location =
For committers:

{{{
bzr+ssh://USERNAME@bzr.squid-cache.org/bzr/squid3/trunk
}}}
For anonymous access/mirroring/etc:

{{{
http://bzr.squid-cache.org/bzr/squid3/trunk
}}}
== Repository Mirrors ==
Also mirrors are available at:

 * https://code.launchpad.net/~squid/squid/trunk
 * https://code.launchpad.net/~squid/squid/3.5
 * https://code.launchpad.net/~squid/squid/3.4
 * https://code.launchpad.net/~squid/squid/3.3
 * https://code.launchpad.net/~squid/squid/3.2
 * https://code.launchpad.net/~squid/squid/3.1
## * https://code.launchpad.net/~squid/squid/3.0

== Repository Developer branches ==
 * https://code.launchpad.net/squid

= Web view =
 * http://bazaar.launchpad.net/~squid/squid/trunk/files
 * http://bazaar.launchpad.net/~squid/squid/3.5/files
 * http://bazaar.launchpad.net/~squid/squid/3.4/files
 * http://bazaar.launchpad.net/~squid/squid/3.3/files
 * http://bazaar.launchpad.net/~squid/squid/3.2/files
 * http://bazaar.launchpad.net/~squid/squid/3.1/files
## * http://bazaar.launchpad.net/~squid/squid/3.0/files

= Recipes =
== Let bzr know who you are ==
bzr needs to know your identity. A bzr identity is your name & email address.

{{{
bzr whoami "Your Fullname <email@address.domain>"
}}}
or to verify what bzr thinks your identity is

{{{
bzr whoami
}}}
If you don't do this bzr guesses based on your account and compuer name.

== Tell bzr where to find the Squid bugzilla ==
add the following in $HOME/.bazaar/bazaar.conf [DEFAULT] section

{{{
bugzilla_squid_url = http://bugs.squid-cache.org
}}}
This enables bzr commit --fixes squid:<bugnumber> to mark bugs as fixed

== Setup a mirror/development environment ==
The following sections will describe how to set up your local repository for Squid development. Two options are shown, differing in where the local repository is:

 plain method :: The bazaar repository is in the root of your Squid source tree.
 cbranch method :: The local bazaar repository is somewhere else in your filesystem, separate from where you do development. Easier to back up and branches are persistent in the repository even if you should happen to delete a whole source tree intentionally or by accident. Which means you can easily recover a branch after you have deleted the source tree.

== Create local repository ==
{{{
# create a local repository to store branches in
bzr init-repo --2a --no-trees ~/squid-repo

# Create a place where to keep working trees
mkdir -p ~/source/squid

# Configure ~/.bazaar/locations.conf mapping the working trees to your repository
cat >> ~/.bazaar/locations.conf << EOF
[/home/USER/source/squid]
cbranch_target=/home/USER/squid-repo
cbranch_target:policy = appendpath
[/home/USER/source/squid/trunk]
public_branch = http://bzr.squid-cache.org/bzr/squid3/trunk/
EOF
}}}

=== Upgrade an old local repository ===
Squid-3 repositories have been upgraded to '''2a''' format in September 2012. When using a local repository or branch checkout from prior to that period you may encounter repository format errors when using bzr.

The following upgrade procedures are recommended:
{{{
# upgrade the local repository format (takes approx 30-90 minutes)
bzr upgrade --2a
}}}

== Checkout an existing branch ==
After your setup is done its time to checkout the first branch you are going to work on directly, or create a child branch for. In most cases this will be the '''trunk''' branch.

{{{
cd ~/source/squid
bzr cbranch --lightweight http://bzr.squid-cache.org/bzr/squid3/trunk trunk

# bind the local copy of trunk to the official copy
# so that it can be used to commit merges to trunk and activate the 'update' command
cd trunk
bzr bind http://bzr.squid-cache.org/bzr/squid3/trunk
}}}

or

{{{
cd ~/source/squid
bzr checkout http://bzr.squid-cache.org/bzr/squid3/trunk trunk
}}}


 . {i} If you have commit access to trunk use ''' bzr+ssh://USERNAME@bzr.squid-cache.org/bzr/squid3/trunk ''' instead of http://...

== Make a new child branch to hack on ==
First follow the instructions above to setup a development environment

Now, in the below example, replace SOURCE with the branch you want your new branch based on, and NAME with the name you want your new branch to have in the following:
{{{
cd ~/source/squid
bzr cbranch --lightweight ~/squid-repo/trunk NAME
cd NAME
bzr merge --remember ~/squid-repo/trunk
}}}
== Share the branch with others: ==
you want to share (read-only) the branch with others also do:

{{{
cd NAME
bzr push --remember PUBLIC_URL
}}}
e.g. if you were to use the launchpad.net bzr hosting service:

{{{
bzr push --remember bzr+ssh://bazaar.launchpad.net/~USER/squid/NAME
}}}
to update the shared copy in the future all you need to run is

{{{
bzr push
}}}
== bring a branch up to date with its ancestor ==
First update your copy of the ancestor;

{{{
cd ~/source/squid/trunk
bzr update
}}}
Then merge the changes into your child branch:

{{{
cd ../NAME
bzr merge
[fix conflicts if any]
bzr commit -m "Merge from trunk"
}}}
Then continue hacking on your branch.

If bzr merge complains on not having a source to merge from then use the following merge command once

{{{
bzr merge --remember ~/squid-repo/trunk
}}}
== Verify branch connectivity ==
If bzr update in the ancestor branch runs very quick and doesn't seem to bring in any updates then verify that the branch is properly bound to the main repository location, not only having it as parent. "bzr info" should report something like the following:

{{{
Lightweight checkout (format: dirstate or dirstate-tags or pack-0.92 or rich-root or rich-root-pack)
Location:
       light checkout root: .
  repository checkout root: /home/henrik/squid-repo/squid3/trunk
        checkout of branch: bzr+ssh://bzr.squid-cache.org/bzr/squid3/trunk/
         shared repository: /home/henrik/squid-repo/squid3
Related branches:
  parent branch: bzr+ssh://bzr.squid-cache.org/bzr/squid3/trunk/
}}}
If "checkout of branch" is missing or indicates your local repository instead of the main source then you need to bind the tree. But first verify that you really are in the main working tree and not your own branch..

{{{
bzr bind bzr+ssh://bzr.squid-cache.org/bzr/squid3/trunk/
}}}
== Submit a patch for inclusion in the main tree or discussion ==
Verify the contents of your branch

{{{
bzr diff -r submit: | less
}}}
If it looks fine then generate a diff bundle:

{{{
bzr diff -r submit: > your-patch-name.diff
}}}
Edit the file, add a preamble to the beginning of it stating its purpose, and email to the squid-dev mailing list (squid-dev@squid-cache.org).

You can use the following commands to email the patch directly, but they skip the step of adding a preamble.

{{{
bzr send --mail-to=squid-dev@squid-cache.org
}}}
{{{
bzr send -oYourFeatureName.merge
}}}
It's also possible to cherrypick what to send using the -r option. See {{{bzr help revisionspec}}} for details

== Commit directly to trunk ==
Make sure you have a clean up to date trunk tree:

{{{
cd ~/squid/source/trunk
bzr status
bzr update
}}}
bzr status should show nothing. If it shows something:

{{{
bzr revert
}}}
If you are merging a development branch:

{{{
cd ~/squid/source/trunk
bzr merge ~/squid/source/childbranchFOO
bzr commit -m "Merge feature FOO"
}}}
If you are applying a plain patch from somewhere:

{{{
cd ~/squid/source/trunk
bzr patch PATCHFILE_OR_URL
bzr commit
# edit the commit message
}}}
If you are back/forward porting a specific change:

{{{
cd ~/squid/source/trunk
bzr merge -c REVNO OTHERBRANCH_URL
bzr commit
# edit the commit message
}}}
== cherry pick something back to an older release using CVS ==
Generate a diff using bzr:

{{{
bzr diff -r FROMREVNO..TOREVNO > patchfile
}}}
or if its a single commit

{{{
bzr diff -c COMMITREVNO > patchfile
}}}
and apply that to cvs with patch:

{{{
patch -p0 <patchfile
}}}
== Merge another branch into yours ==
You can merge in arbitrary patterns, though because bzr 1.0 defaults to 'merge3' for conflict resolution the best results occur if a hub-and-spoke system is used where each branch only merges from one other branch, except when changes from a 'child' branch are completed and being merged into that branch.

{{{
cd ~/squid/source/DESTINATION
bzr merge ~/squid/source/SOURCE_OF_FOO
bzr commit -m "Merge feature FOO"
}}}
'''NP:''' The DESTINATION branch must be a local checkout of files to patch. The SOURCE branch may be the folder, bundle, or online URL of another branch.

== diffing against arbitrary revisions/branches ==
To diff against a different branch there are several options. The most common and most useful one is 'ancestor' and will give you the diff since the most recent merge of that other branch. If there is a third branch that has been merged into both your branch and the one you are diffing, it's changes will appear in the diff. There is work underway to provide diffs that handle any merge pattern more gracefully - see [[http://bundlebuggy.aaronbentley.com/request/<47730F98.2030405@utoronto.ca>|merge-preview]] as the start of the work in bzr.

{{{
cd MYBRANCH
bzr diff -r ancestor:URL_OF_OTHER_BRANCH
}}}
Another useful option is to diff against the current tip of a branch, which will show things that you have not merged from that branch as 'removed' and things you have created locally as 'added':

{{{
cd MYBRANCH
bzr diff -r branch:URL_OF_OTHER_BRANCH
}}}
You can also diff against arbitrary revnos in the other branch:

{{{
cd MYBRANCH
bzr diff -r 34:URL_OF_OTHER_BRANCH
}}}
For more information:

{{{
bzr help revisionspec
}}}
== Helper scripts ==
While bzr provides simple operation access. So did CVS in most cases. The problem is, mistakes are easier too. We need to provide some recipes as easy to use scripts.

 * cleaning up a branch or patch for auditing
  * '''./scripts/source-maintenance.sh'''
 * testing a branch before submission
  * '''./test-builds.sh''' in squid source. Runs configure and build permutation tests.

## Not needed... bzr does these very nicely itself.
## * submitting a patch for consideration
## * all three of the above in sequence with problem handling.
## * merging a patch from TRUNK down to a STABLE branch
## * merging a child branch up to its parent and handling conflicts
## == Migrate existing branches ? ==
## * Migrate in progress development branches
## hno: I vote no on this. It's up to respective sub-project to merge over if they like.
## = Possible future things =
## {{{
## > But some script to mirror HEAD and STABLE branches into CVS while
## > keeping the CVS structure of things would be nice in order to continue
## > serving reasonable anoncvs read-only access. Not a requirement however.
## }}}
## robert: I'd *prefer* to set an expectation about a switchover time and switch & disable the CVS mirrors; because the higher fidelity of a VCS that does renames etc makes correct mirroring into CVS really annoying.
##
## hno: The existing sourceforge CVS mirror will continue as before. Just needs a small update in the script used to change the source tree from cvs to bzr. It's not an exact or correct mirror and has never been, just good enough for developments.
## = Notes from the mailing list thread: =
## * Anonymous access [e.g. to 'track HEAD']
## * Mirrorable repositories to separate out trunk on bzr.squid-cache.org from devel.squid-cache.org as we currently do (as people seem happy with this setup).
## * commits to trunk over ssh or similar secure mechanism
## * works well with branches to remove the current cruft we have to deal with on sourceforge with the mirror from trunk.
## * works well on windows and unix
## * friendly to automation of hbr build tests etc in the future.
## * anonymous code browsing facility (viewvc etc)
