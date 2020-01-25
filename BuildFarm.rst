##master-page:SquidTemplate
#format wiki
#language en
= Squid Build Farm =
The Squid project supports a big number of OSes (SquidFaq/AboutSquid has the short list), but it lacks the resources to test all of them, relying on user feedback instead. Aim of the Build Farm effort is to have a greater number of OS platforms directly available for unit-testing and development. The backbone of the build farm is a number of Docker containers running on hosts kindly donated by [[http://www.digitalocean.com/|DigitalOcean]].

FrancescoChemolli is leading this effort.

Project sysadmins can find documentation at /SystemAdministration and on the Docker farm at /DockerBuildFarm. An /AutoScale build farm is in the works. The images used to test our supported builds are available on the [[https://hub.docker.com/repository/docker/squidcache/buildfarm|Docker Hub]] .



'''Volunteer Help Sought:'''

|| 32-bit systems running Linux flavors || Volunteers sought ||
||[[http://www.opensource.apple.com/projects/darwin/6.0/release.html|Darwin]] and/or MacOS X ||Volunteers sought ||
||[[http://www.microsoft.com/windows/default.aspx|MS Windows]] Cygwin ||Needed ||
||AIX ||Volunteers sought, PPC hardware sought ||

Donations of disk space and CPU time on non-x86 systems are welcome and encouraged.

The actual testing will be coordinated by [[http://jenkins-ci.org/|Jenkins]]. [[http://build.squid-cache.org/|Our instance]]

----
 . Discuss this page using the "Discussion" link in the main menu

<<Include(/Discussion)>>
