For squid 3.1 I propose to migrate the development trunk and web code browsers to [http://bazaar-vcs.org/ Bazaar].

Bazaar is available in most O/S's these days: http://bazaar-vcs.org/Download.


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


The adhoc conversion I ran to see the repositories shape is here:
http://www.squid-cache.org/~robertc/bzr/cvsps/squid3/bzr/squid3/branches/HEAD/

you can make a local branch by doing 'bzr branch' e.g. 'bzr branch $URL
squid3'.

= TODO =

 * Install bzr and its additional components on the squid-cache.org server.
   Needs bzr, bzrtools, loggerhead installed. 1.0 or newer of bzr desired.

 * the snapshot scripts need a little update to use the right tools for checking out the source tree.
   Needs clarification about which/what/where these are.

 * the release scripts as well
   Needs clarification about which/what/where these are.

 * Write up recipes for how to do common tasks:
   * generate a patch for a commit
   * get a mirror of the development source to hack on
   * make a new branch to hack on
   * commit something which has been developed back to trunk
   * cherry pick something back to an older release using CVS
   * cherry pick something back to an older release using bzr.
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
