#format wiki
#language en
#acl SquidWikiAdminGroup:read,write,delete,revert -All:read

= Master Node =
This page describes the setup of the '''master''' vm at Rackspace, meant to host the Project's main source code repository, web site master copy, mailing lists (''to be confirmed''). It should never be publicly referenced as such except by committers repository access.

== setup ==
 * dns name (temporay): master.make.squid-cache.org
 * Pieter, Amos and Kinkie have root (more to be added)
 * 3 filesystems (so far): / is a 40gb SSD, /home is a 20GB LVM-backed SSD (volume is /dev/fastdata/lv01); /srv is 100Gb (/dev/data/lv01)

=== Best Practices ===
 * alway use '''aptitude''' to install, upgrade, remove or purge packages.
  . apt-get does not retain sufficient records to auto-remove package dependencies if they get obsolete. This lack can be worked around by using '''deborphan''', but is cumbersome.

 * install hardening packages to provide early warning if programs containign known security vulnerabilities are installed.
 . see https://launchpad.net/ubuntu/+source/harden for what packages are available and do.
 . minimum install ({{{ aptitude install harden }}})

== services ==

=== bzr ===

 * packages: aptitude install bzr ssh apache2 rsync
 * repository root: /srv/bzr/squid3/
  . also has a symlink to make SSH and HTTP have access identical paths: {{{ ln -s /srv/bzr /bzr }}}

(to be confirmed if source maintenance performed here)
 * extra packages: aptitude install astyle perl

=== www hidden master ===

 * packages: aptitude install apache2 perl php5 php5-mysql bzr
  . NP: bzr is used by www generator scripts accessing http://bzr.squid-cache.org/

 * apache mod_rewrite: {{{ a2enmod rewrite }}}

 * dynamic site data:  /srv/www/master.squid-cache.org/public_html/

 * static site data: /srv/www/static.squid-cache.org/public_html/
  . TODO: read-only rsync access to static site data from mirrors

 1. Q: are we still going to use CVS for www version control?

=== DNS hidden master ===

 * packages: aptitude install bind9

 1. Q: are we still going to use CVS for dns zone version control?

=== mailman ===

 * packages: aptitude install mailman

=== wiki ===

{{{/srv/www/wiki.squid-cache.org}}}
Auxiliary cron jobs in {{{/etc/cron.daily}}} and logrotate in {{{/etc/logrotate.d}}}


----
Discuss this page using the "Discussion" link in the main menu

<<Include(/Discussion)>>
