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
