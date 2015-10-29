##master-page:SquidTemplate
#format wiki
#language en
#acl SquidWikiAdminGroup:read,write,delete,revert -All:read

[[TableOfContents]]

= Docker-based build farm setup =

== Host ==
The build farm itself runs on ''buildmaster.squid-cache.org''. You require a login there to perform any of the following.

All content is in /srv/jenkins, which is the home directory of the jenkins user. The only external hook is {{{/etc/rc.local}}}, to start jenkins up.

Jenkins runs as user {{{jenkins}}}; it connects to remote hosts using ssh (some have their own service calling in via jnlp), and starts up docker-based slaves on demand when there is a build to be done.

== Docker setup and conventions ==
Each slave is based on an image. The list of available images can be obtained (as root or jenkins) with the command {{{docker images}}}. The ones that are relevant for the farm are named with the convention {{{farm-<osname>-<osversion>}}}. Known-good recovery points are tagged with the date of the recovery point - the convention is thus {{{farm-<osname>-<osversion>:<yymmdd>}}}.

The {{{/home/jenkins}}} directory of each slave is meant to host the build environment for that slave, and is mapped from the host directory {{{/srv/jenkins/docker-images/<osname>-<osversion>}}}.

In {{{/srv/jenkins/docker-images}}} there are also a few utility commands to support managing containers.
 . {{{./interactive <containername>}}}
   run container "farm-<containername>" interactively. Its use-case is to manage the software installed in the container image.
 . {{{./slave <containername>}}}
   script meant to launch the jenkins slave with the appropriate command-line arguments

== Image management ==
In case software needs to be installed or upgraded, run:
{{{
cd ~/docker-images/
./interactive <containername>
}}}

This will launch a root shell in the context of the container. Perform updates as necessary.

Notice that changes will be applied only to the specific ''image'' this shell runs into, not the ''container'' it is running. In order to make the changes permanent, the following commands must be run after exiting the container:

{{{
docker commit <imgid> <containername>
docker rm i-farm-<containername>
}}}

The these commands are displayed when the {{{./interactive}}} script exits. The image id can also be obtained running {{{docker ps -a}}} (the variant {{{docker ps -l}}} outputs information on the last container that exited; it may be more convenient).

The changes will be picked up by slaves the next time they restart. The command to kill the running slave is also provided. Only use that if necessary.

----
Discuss this page using the "Discussion" link in the main menu

<<Include(/Discussion)>>
