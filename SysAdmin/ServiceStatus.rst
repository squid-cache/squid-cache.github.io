#format wiki
#language en
#acl SquidWikiAdminGroup:read,write,delete,revert -All:read


'''BUGS TO FIX:'''

 * /!\ AYJ: I think we are ready for DNS to point master.squid-cache.org at new/final master server.

 * on master bin/mk-static.sh displays permission errors accessing build farm nodes to pull resources. Permission to master needs allocating, west access can be revoked:
{{{
@ERROR: access denied to squiddox from lists.squid-cache.org (104.130.201.120)
rsync pull code Documentation from BuildFarm failed
@ERROR: access denied to snapshots-head from lists.squid-cache.org (104.130.201.120)
rsync pull 3.HEAD code snapshots from BuildFarm failed
@ERROR: access denied to snapshots-latest from lists.squid-cache.org (104.130.201.120)
rsync pull 3.4 code snapshots from BuildFarm failed
@ERROR: access denied to snapshots-old from lists.squid-cache.org (104.130.201.120)
rsync pull 3.3 code snapshots from BuildFarm failed
}}}

 * bin/mk-static.sh copies CVS directories from dynamic to static site copies. (old bug) requires rsync cmd line voodoo to fix.

 * ssh using squidadm account from master to west requires password.
 . Making it difficult to copy recovery data from west to master.
 . also breaks www generator on master which uses bzr+ssh://squidadm@bzr.squid-cache.org/ for repo access.

'''BUGS FIXED:'''

= Services TODO (by priority) =

 * mail{X} and mailing lists(./)
  . high priority (virtual) mailboxes: bugs@, info@
  . high priority lists: noc@ (./) , squid-announce (./) , squid-users (./) , cvs (list created, but empty), squid-dev (./)
  . lower priority: board/squid-board (./) , personal addresses (kinkie (./) , amos, hno, rousskov, pieter, duane, adri, robertc)
  . remove now-unused mailing lists: squid-core, squid-faq, squid-vendors (?)

 * FTP
  . ftp://ftp.squid-cache.org/ running on east only.
  . need master FTP configured
  . need east and west mirrors pulling from master

 * mysql
  . user accounts: squidadm
  . mysql down may cause database pages to generate with no content (ie mirror and sponsor lists)
  . see http://master.squid-cache.org/Download/http-mirrors.html
  . TODO: setup mysql-server on west, then sqldump the mirrors and web_pages databases for re-import to new mysl server.

 * rsync
  * config file: /etc/defaults/rsync - set to enable rsync
  * config file: /etc/rsyncd.conf - configure all shares. services not yet configured are commented out
  . (./) mirror access for /srv/www/static.squid-cache.org/public_html/content
  . mirror access for ftp://ftp.squid-cache.org/pub/

 * www
  . dynamic / master.squid-cache.org running on master (as http://master.make.squid-cache.org/)
  . static.squid-cache.org running on master (as www.* and static.*)
  . check mirror of static.squid-cache.org/public_html/ to east works okay
  . implement same mirror to eu
  . implement same mirror to west ??
  . send mail notification of dynamic.* commits to noc@

 * Authentication server
  . have a central authentication server or at least a pubkey distribution mechanism

 * mailing lists (less urgent issues)
  . port old ML archives over? What tool do we use for archives? Keep in mind occasional privacy requests
  . fix marc.info, mail-archive.org etc references

 * cvs
  . for use version controlling master.squid-cache.org content. Current errors:
{{{
cvs status: in directory .:
cvs status: ignoring CVS/Root because it specifies a non-existent repository /server/cvs-server/squid
cvs status: No CVSROOT specified!  Please use the `-d' option
cvs [status aborted]: or set the CVSROOT environment variable.
}}}

  . on west: using CVS to commit master.squid-cache.org website changes to site version control fails due to cvs not being installed.


= Services Partial =

 * DNS
  . zone responding
  . zone file version control not working again yet. Updates frozen.

 * www
  . master.squid-cache.org working (on west).
  . static.squid-cache.org generator script running (on master) requires mysql databases
  . not mirroring to east, so www content displayed varies between east/west requests.

= Services OKAY =

 * BZR repository (still running on west)
  . SSH access
  . HTTP access
  . mirrors updating

 * Bugzilla
  . runs on east

 * wiki
  . runs on eu

 * daily snapshot packaging
  . runs in build farm VM

= Services SUSPENDED =

These are mostly squidadm scripts not yet updated to run with in the new layout.

 * DNS zone updates
 * CVS repository mirror
 * mail archive generator
 * FTP and www data sync
 * rsync daily snapshot access
 * mirror validation
 * source maintenance / coding guidelines enforcement

= Best practices for sysadmins =
(temporary accumulation spot, will be moved to own location when complete)
 * Server-specific services configurations are in /srv, referenced from system locations via bind mounts or symlinks
 * Directories containing changed configuration files must contain a directory named RCS; touched config files must be checked in when stable with {{{ci -l file ...}}}
 * all admins must belong to the group {{{sudo}}} and only use that mechanism to gain root
 * watch out for log rotation! When creating new log files, make sure to add a service-specific log rotation directive in /etc/logrotate.d
