#format wiki
#language en
#acl SquidWikiAdminGroup:read,write,delete,revert -All:read

= Eu Node =
This page describes the setup of the '''eu''' server

== setup ==
 * dns name: eu.squid-cache.org (IPv4 and IPv6)
 * kinkie, amosjeffries, hno, robertc, wessels, adrian, rousskov have root


== services ==

=== bzr mirror ===
User "bzr" has a cron-job mirroring via scp repository from west (to be updated when master will be migrated)


=== reverse-proxy ===
Single squid instance with tasks:
 * reverse-proxying www.squid-cache.org as ''www.eu.squid-cache.org''
 * reverse-proxying towards jenkins as ''build.squid-cache.org''
 * reverse-proxying towards other local services (health checks, etc)

=== build farm master node ===
[[http://build.squid-cache.org/]]

=== DNS slave ===
Present and ready, but not used


----
Discuss this page using the "Discussion" link in the main menu

<<Include(/Discussion)>>
