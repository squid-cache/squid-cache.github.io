#format wiki
#language en
#acl SquidWikiAdminGroup:read,write,delete,revert -All:read

= Web site content creation and accumulation =

Web site is assembled on master; creation process (in reverse order):
 * Mirrors (ideally) pull via rsync from the {{{http-files}}} rsync path.
 * Finished product is assembled in {{{/srv/www/static.squid-cache.org}}}
 * assembly is done via cron-jobs by the {{{squidadm}}} user; these are run by {{{bin/mk-static.sh}}} which:
   * assembles the site from the contents of {{{/srv/www/master.squid-cache.org}}} and {{{Doc/code/*}}} that comes in from the buildfarm node.
   * removes the old snapshots (/!\ seems not to be reliable)
   * rsyncs nondynamic files from /srv/www/master.squid-cache.org to /srv/www./static.squid-cache.org
   * runs php on the {{{*.dyn}}} files to turn them into HTML and rsyncs those to {{/srv/www/static.squid-cache.org

{{{
[08/11/14 15:11:36] Amos Jeffries: separate to that we have the mirror and URL checking scripts which scans the DB entries. The results of those scans affect the content results of some *.dyn scripts when they are next run through PHP by mk-static
[08/11/14 15:13:18] Amos Jeffries: separately we also have the changesets update script,
[08/11/14 15:13:24] Amos Jeffries: which for each version of Squid checks that the per-version patches are up to date and producing static *.html in /srv/www/master.*/Versions/v3/*/changesets/*.html
[08/11/14 15:13:28] Francesco Chemolli: I'm adapting this and adding to the wiki.
[08/11/14 15:14:18] Amos Jeffries: and one of them, (I think the snapshot script) updates also expands latest 3.HEAD snapshot to generate the langpack content.
[08/11/14 15:15:49] Amos Jeffries: we also have a script somewhere scanning the /srv/www/master.*/Versions/v3/* area for released tarballs and updating FTP server content. I'm not sure if its working properly after the recovery.
[08/11/14 15:17:34] Amos Jeffries: The original site used to be a bunch of index.pl and scripts generating static *.html content in-place and executed by squidadm explicitly. I have been trying to convert those to *.dyn scripts whenever possible so the mk-static scan does is in one sweeping update instead of lots of little sub-calls.
[08/11/14 15:17:56] Amos Jeffries: the changesets scripts are still leftover from that.
[08/11/14 15:21:50] Amos Jeffries: at the end of mk-static is where I put the chmod/chown calls earlier. It seemed to work on some things and not others depending on whether squidadm had access to change them  - since mk-static is run by squidadm.
[08/11/14 15:22:48] Francesco Chemolli: nod.
[08/11/14 15:23:03] Francesco Chemolli: which is ok, chowning things is definitely doable
[08/11/14 15:24:32] Amos Jeffries: oh, looking at k-static now I see CentOS6 is the node doing the snapshot building. we are going to have to update that CentOS6 can no longer build trunk after the ParserNG updates.
[08/11/14 15:25:13] Amos Jeffries: (I had to use C++11 initializer lists for the code reduction on unit-tests)
[08/11/14 15:27:42] Amos Jeffries: just updated the mk-static to do the master->static rsync copy last of all its actions. and to exclude CVS directories.
}}}
