#format wiki
#language en
#acl SquidWikiAdminGroup:read,write,delete,revert -All:read

= Master Node =
This page describes the setup of the '''master''' vm at Rackspace, meant to host the Project's main source code repository, web site master copy, mailing lists (''to be confirmed''). It should never be publicly referenced as such except by committers repository access.

== setup ==
 * dns name (temporay): master.make.squid-cache.org
 * Pieter and Kinkie have root (more to be added)
 * 3 filesystems (so far): / is a 40gb SSD, /home is a 20GB LVM-backed SSD (volume is /dev/fastdata/lv01); /srv is 100Gb (/dev/data/lv01)


 * Best Practice: alway use '''aptitude''' to install, upgrade, remove or purge packages.
  . apt-get does not retain sufficient records to auto-remove package dependencies if they get obsolete. This lack can be worked around by using '''deborphan''', but is cumbersome.

== services ==

=== bzr ===

 * packages: aptitude install bzr ssh apache2 rsync
 * repository root: /srv/bzr.squid-cache.org/squid3/
  . also has a symlink to make SSH and HTTP have access identical paths: {{{ ln -s /srv/bzr /bzr }}}

(to be confirmed if source maintenance performed here)
 * extra packages: aptitude install astyle perl

=== www hidden master ===

 * packages: aptitude install apache2 mysql perl php5 php-mysql

 1. Q: are we still going to use CVS for www version control?

=== DNS hidden master ===

 * packages: aptitude install bind9

 1. Q: are we still going to use CVS for dns zone version control?

=== mailman ===

(to be confirmed if to be hosted here)

 * packages: aptitude install mailman


----
Discuss this page using the "Discussion" link in the main menu

<<Include(/Discussion)>>
