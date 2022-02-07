##master-page:SquidTemplate
#format wiki
#language en
#acl SquidWikiAdminGroup:read,write,delete,revert -All:read

[[TableOfContents]]

= Information for System Administrators =

Docker-based VMs have a specific document at ../DockerBuildFarm.

== j-freebsd-93 ==
It's a jail-based system, running on rs-freebsd-10.

The jail filesystem is in {{{/osversions/9.3}}}.
 . To start jenkins on it, run {{{/osversions/start-9.3-jenkins}}}.
 . To launch an interactive shell, run {{{/osversions/start-9.3}}}.
 . To stop it: run {{{jps}}} to obtain the jail ID, then {{{jail -r <jailid>}}}


----
Discuss this page using the "Discussion" link in the main menu

<<Include(/Discussion)>>
