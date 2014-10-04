#format wiki
#language en
#acl SquidWikiAdminGroup:read,write,delete,revert -All:read


'''BUGS TO FIX:'''

 * bin/mk-static.sh displays numerous permission errors when building static.squid-cache.org.
Example:
{{{
rsync: failed to set times on "/srv/www/static.squid-cache.org/public_html/content/Versions/v3/3.HEAD/changesets/squid-3-13555.patch.merged": Operation not permitted (1)
}}}
 * using CVS to commit west.squid-cache.org website changes to site version control fails due to cvs not being installed on west.


'''BUGS FIXED:'''

= Services TODO (by priority) =

 * mail{X} and mailing lists(./)
  . high priority (virtual) mailboxes: bugs@, info@
  . high priority lists: noc@ (./), squid-announce (./), squid-users (./), cvs (list created, but empty), squid-dev (./)
  . lower priority: board/squid-board (./), personal addresses (kinkie (./), amos, hno, rousskov, pieter, duane, adri, robertc)
  . remove now-unused mailing lists: squid-core, squid-faq, squid-vendors (?)

 * FTP
  . ftp://ftp.squid-cache.org

 * mysql
  . mysql down may cause database pages to generate with no content (ie mirror and sponsor lists)
  . see http://master.squid-cache.org/Download/http-mirrors.html

 * rsync
  . mirror access for static.squid-cache.org/public_html/
  . mirror access for ftp.squid-cache.org/pub/

 * www
  . check mirror of static.squid-cache.org/public_html/ to east works okay
  . implement same mirror to eu
  . send mail notification of commits to noc@

 * Authentication server
  . have a central authentication server or at least a pubkey distribution mechanism

 * mailing lists (less urgent issues)
  . port old ML archives over? What tool do we use for archives? Keep in mind occasional privacy requests
  . fix marc.info, mail-archive.org etc references

= Services Partial =

 * mail and mailing lists
  . noc@lists working. not everybody re-subscribed yet.

 * DNS
  . zone responding
  . zone file version control not working again yet. Updates frozen.

 * www
  . master.squid-cache.org working, update scripts running.
  . static.squid-cache.org generator script running
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
