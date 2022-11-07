# Squid Build Farm

The Squid project aims to ensure compatibility with a big number of
OSes. Aim of the Build Farm effort is to ensure that at least some
testing is done on all platforms we can, and we rely on a number of
Docker containers and virtual machines running on hosts kindly donated
by volunteers and by [DigitalOcean](http://www.digitalocean.com/).

[FrancescoChemolli](/FrancescoChemolli#) is leading this effort.

Project sysadmins can find documentation on the Docker farm at
[BuildFarm/DockerBuildFarm](/BuildFarm/DockerBuildFarm#).
The images used to test our supported builds are available on the
[Docker Hub](https://hub.docker.com/repository/docker/squidcache/buildfarm), and
are built from instructions at [GitHub](https://github.com/kinkie/dockerfiles);
feel free to use them for your own builds.

**Volunteer Help Sought:**

|                |                   |
| -------------- | ----------------- |
| MacOS          | Volunteers sought |
| Windows Cygwin | Needed            |

Donations of disk space and CPU time are welcome and encouraged.

The actual testing will be coordinated by
[Jenkins](http://jenkins-ci.org/) at [Our instance](http://build.squid-cache.org/)
