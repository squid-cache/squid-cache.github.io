For squid 3.1 I propose to migrate the development trunk and web code browsers to [http://bazaar-vcs.org/ Bazaar].

Bazaar is available in most O/S's these days: http://bazaar-vcs.org/Download.

Things to install:
 * bzr
 * bzr-email (as a package it may be a bit old, try:
   {{{bzr branch http://bazaar.launchpad.net/~bzr/bzr-email/trunk/ ~/.bazaar/plugins/email}}}
   Then do 'bzr help email' and setup any local machine configuration you need in bazaar.conf - such as mailer to use etc.

Notes from the mailing list thread:

 * Anonymous access [e.g. to 'track HEAD']
 * Mirrorable repositories to separate out trunk on squid-cache.org from
devel.squid-cache.org as we currently do (as people seem happy with this
setup).
 * commits to trunk over ssh or similar secure mechanism
 * works well with branches to remove the current cruft we have to deal
with on sourceforge with the mirror from trunk.
 * works well on windows and unix
 * friendly to automation for build tests etc in the future.
 * anonymous code browsing facility (viewvc etc)

= Repository Location =

For committers:
{{{
bzr+ssh://squid-cache.org/bzr/squid3/trunk}}}

For anonymous access/mirroring/etc:
{{{
http://www.squid-cache.org/bzr/squid3/trunk}}}

= Recipes =

== Generate a patch for a commit ==
{{{bzr diff -c revno}}} or
{{{bzr diff -r revno..otherrevno}}} to use an arbitrary range.

The following commands are equivalent:
{{{bzr diff -c 10
bzr diff -r 9..10}}}

== Setup a mirror/development environment ==

This can be done many ways. The following recipe gives you a local repository which can be used to develop many branches in an offline manner with a single build directory (so you don't have to do a full rebuild when switching branches).

{{{# create a local repository to store branches in
bzr init-repo --no-trees ~/squid-repo
# get the 3.1 trunk into this repository
# If you have commit access to trunk:
export TRUNKURL=bzr+ssh://www.squid-cache.org/bzr/squid3/trunk
# otherwise:
export TRUNKURL=http://www.squid-cache.org/bzr/squid3/trunk

bzr branch $TRUNKURL ~/squid-repo/trunk

cd ~/squid-repo/trunk
# bind the local copy of trunk to the official copy so that it can be used to commit merges to trunk and activate the 'update' command
bzr bind $TRUNKURL
}}}

To update the local copy:
{{{
cd ~/squid-repo/trunk
bzr update
}}}

To get a working tree to perform edits or merges:
{{{
cd ~/source/squid
bzr checkout --lightweight ~/squid-repo/BRANCHNAME
}}}

To change the branch that a checkout has been made from
{{{
cd ~/source/squid/acheckout
bzr switch ~/squid-repo/BRANCHNAME
}}}

NOTE: Until bzr+ssh access to the trunk is available, you cannot commit to the trunk!

== Make a new branch to hack on ==
First follow the instructions above to setup a development environment

Now, replace SOURCE with the branch you want your new branch based on, and NAME with the name you want your new branch to have in the following:
{{{
bzr branch SOURCE ~/squid-repo/NAME
cd ~/source/squid
# alternatively, see the 'setup a development environment' recipe for instructions on switching a working area to a different branch.
bzr checkout --lightweight ~/squid-repo/NAME
}}}

If you want to share the branch with others also do:
{{{
bzr push PUBLIC_URL
}}}

e.g. if you were to use the launchpad.net bzr hosting service:
{{{
bzr push bzr+ssh://bazaar.launchpad.net/~USER/squid/NAME
}}}

== Commit to trunk ==
get a checkout of trunk.

Either follow 'setting up a development environment' and then {{{bzr switch}}} to your local copy of trunk, or just do a checkout:
{{{bzr checkout bzr+ssh://squid-cache.org/bzr/squid3/trunk}}}

Make sure you have a clean tree:
{{{bzr status
}}} This should show nothing. If it shows something:
{{{bzr revert}}}

If you are merging a development branch:
{{{
bzr merge DEVELOPMENTBRANCH_URL
bzr commit -m "Merge feature FOO"
}}}

If you are applying a patch from somewhere:
{{{
bzr patch PATCHFILE_OR_URL
bzr commit
# edit the commit message
}}}

If you are back/forward porting a specific change:
{{{
bzr merge -c REVNO OTHERBRANCH_URL
bzr commit
# edit the commit message
}}}

= TODO =

 * Install bzr and its additional components on the squid-cache.org server.
   Needs bzr, bzrtools, loggerhead installed. 1.0 or newer of bzr desired.

 * the snapshot scripts need a little update to use the right tools for checking out the source tree.
   Needs clarification about which/what/where these are.

 * the release scripts as well
   Needs clarification about which/what/where these are.

 * Write up recipes for how to do common tasks:
   * cherry pick something back to an older release using CVS
   * cherry pick something back to an older release using bzr. 
   * bring a new branch up to date with it's ancestor
   * merge another branch into yours
   * how to generate a clean patch when having another branch merged into yours (i.e. diff relative to an up to date version of that branch, not
your natural ancestor)
   * others ?

 * Set a cut over date

 * Run a conversion of the master repository at that date

 * Migrate in progress development branches

= Under discussion =

{{{
> But some script to mirror HEAD and STABLE branches into CVS while
> keeping the CVS structure of things would be nice in order to continue
> serving reasonable anoncvs read-only access. Not a requirement however.

I'd *prefer* to set an expectation about a switchover time and switch &
disable the CVS mirrors; because the higher fidelity of a VCS that does
renames etc makes correct mirroring into CVS really annoying.
}}}
