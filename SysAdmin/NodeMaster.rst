#format wiki
#language en
#acl SquidWikiAdminGroup:read,write,delete,revert -All:read

= Master Node =
This page describes the setup of the '''master''' vm at Rackspace, meant to host the Project's main source code repository, web site master copy, mailing lists (''to be confirmed''). It should never be publicly referenced as such except by committers repository access.

== setup ==
 - dns name (temporay): master.make.squid-cache.org
 - Pieter and Kinkie have root (more to be added)
 - 3 filesystems (so far): / is a 40gb SSD, /home is a 20GB LVM-backed SSD (volume is /dev/fastdata/lv01); /srv is 100Gb (/dev/data/lv01)



----
Discuss this page using the "Discussion" link in the main menu

<<Include(/Discussion)>>
