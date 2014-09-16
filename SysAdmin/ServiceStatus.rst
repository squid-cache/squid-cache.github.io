#format wiki
#language en
#acl SquidWikiAdminGroup:read,write,delete,revert -All:read


'''BUGS TO FIX:'''

 * bin/mk-static.sh displays numerous permission errors when building static.squid'cache.org.
Example:
{{{
rsync: failed to set times on "/srv/www/static.squid-cache.org/public_html/content/Versions/v3/3.HEAD/changesets/squid-3-13555.patch.merged": Operation not permitted (1)
}}}

 * using CVS to commit master.squid-cache.org website changes to site version control fails due to cvs not being installed.
Required:
{{{
 aptitude install cvs
}}}


= Services TODO =

 * mail and mailing lists

 * FTP
  . ftp://ftp.squid-cache.org

 * mysql

 * www
  . mirror static.squid-cache.org/public_html/ to east server (rsync)

 * rsync
  . mirror access for static.squid-cache.org/public_html/
  . mirror access for ftp.squid-cache.org/pub/
  . access to daily snapshot sources

= Services Partial =

 * DNS
  . zone responding
  . zone file version control not working again yet. Updates frozen.

 * www
  . master.squid-cache.org working, update scripts running.
  . static.squid-cache.org generator script running
  . not mirroring to east, so www content displayed varies between east/west requests.
  . mysql down may cause database pages to generate with no content (ie mirror and sponsor lists)

= Services OKAY =

 * BZR repository
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
 * rsync snapshot access
 * mirror validation
 * source maintenance / coding guidelines enforcement
