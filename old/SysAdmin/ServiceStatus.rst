#format wiki
#language en
#acl SquidWikiAdminGroup:read,write,delete,revert -All:read

== health checks ==
 * we are using [[http://statuscake.com | StatusCake]] to do black-box availability testing of the main services. For now (July 2020) only FrancescoChemolli is notified; we'll add NOC once the reliability of the service is validated


----
/!\ most of what's below here is obsolete.
----

'''BUGS TO FIX:'''
 
 * bin/mk-static.sh copies CVS directories from dynamic to static site copies. (old bug) requires rsync cmd line voodoo to fix.

 * rsync run on west to mirror data, has permissions errors reading from master.
  * "rsync: change_dir "/" (in http-files) failed: Permission denied (13)"
 . seems to be permission on master to rsync user account.
 . works fully only if we set rsync daemon to group www-data, chown the files squidadm:www-data and set chmod 775 on all directories.

'''BUGS FIXED:'''

= Services TODO (by priority) =

 * mail{X} and mailing lists(./)
  . high priority (virtual) mailboxes: bugs@ (forwarded to list of same name), squid-bugs@ (forwarded to list of same name), info@
  . special lists with NO ARCHIVE: squid-bugs@ (list created, but?), noc@ (./) , cvs (list created, but empty)
  . high priority lists: squid-announce (./) , squid-users (./) , squid-dev (./)
  . lower priority: board/squid-board (./) , personal addresses (kinkie (./) , amos, hno, rousskov, pieter, duane, adri, robertc)
  . remove now-unused mailing lists: squid-core, squid-faq, squid-vendors (?)

 * FTP
  * install: aptitude install pure-ftpd
   . {X} have installed, but its requiring logins. need to configure anonymous-only access
  * user account: ftpuser ( --home /srv/ftp/ --disabled-login )
  * (./) data files: /srv/ftp/pub
  * (./) data file ownership: squidadm:www-data (same as with www service)
  * mirrors of ftp.squid-cache.org on: master, west (./) , east ( :/ ), eu
   . ftp://ftp.squid-cache.org/ running on east only, but updated data files not mirrored to it.

 * rsync (./)
  * user account: rsync (--home /nonexistent --no-create-home --shell /bin/false --disabled-login)
  * config file: /etc/defaults/rsync - set to enable rsync
  * config file: /etc/rsyncd.conf - configure all shares. services not yet configured are commented out
  * (./) mirror access for /srv/www/static.squid-cache.org/public_html/content ( /!\ see bugs above)
  * (./) mirror access for /src/ftp/pub/squid (ftp://ftp.squid-cache.org/pub/squid)
  * (./) mirror access for /src/ftp/pub/archive (ftp://ftp.squid-cache.org/pub/archive)
  * (./) mirror access for /src/rsync (snapshots and releases)

 * www
  * install: aptitude install libhttp-lite-perl
  * (./) dynamic / master.squid-cache.org running on master
  * (./) static.squid-cache.org running on master (as www.* and static.*)
  . mirrors of static.squid-cache.org on: master (./) , west (./) , east (outdated)
  . send mail notification of dynamic.* CVS commits to noc@

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


= Services Partial =

 * www
  . master.squid-cache.org working
  . static.squid-cache.org generator script running
  . not mirroring to east, so www content displayed varies between east/west/master requests.

= Services OKAY =

 * DNS (./)
  * running on: master (VM)
  * hidden master: bind9
   . config files: /srv/bind
   . version control: RCS
   . split internal (Rackspace) vs public internet views
  * public masters:
   . see bind/configs/named.conf.local and zones/squid-cache.org-public for lists.

 * mysql (./)
  . running on clouddb
  . user accounts: squidadm
  . credentials: /home/squidadm/.my.cnf for user command line login
  . credentials: /srv/www/master.squid-cache.org/public_html/cgi/dblink.inc for PHP page access.

 * BZR repository (./)
  * running on: master (as bzr.squid-cache.org)
  * SSH access
   . committers are group '''squid'''
  * HTTP access
  * rsync access

 * Bugzilla
  . runs on east

 * wiki
  . runs on eu

 * daily snapshot packaging
  . runs in build farm VM

= Services SUSPENDED =

These are mostly squidadm scripts not yet updated to run with in the new layout.

 * CVS repository mirror
 * mail archive generator
 * FTP data sync
 * mirror validation
 * source maintenance / coding guidelines enforcement

= Best practices for sysadmins =
(temporary accumulation spot, will be moved to own location when complete)
 * Server-specific services configurations are in /srv, referenced from system locations via bind mounts or symlinks
 * Directories containing changed configuration files must contain a directory named RCS; touched config files must be checked in when stable with {{{ci -l file ...}}}
 * all admins must belong to the group {{{sudo}}} and only use that mechanism to gain root
 * watch out for log rotation! When creating new log files, make sure to add a service-specific log rotation directive in /etc/logrotate.d
