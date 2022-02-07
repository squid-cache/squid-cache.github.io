# Project: Dockerised build and packaging

  - **Goal**: Convert my VM's based build and packaging farm into
    dockerised one.

  - **Status**: Skeleton completed .

  - **Developer**:
    [EliezerCroitoru](https://wiki.squid-cache.org/BuildFarm/DockerPackaging/EliezerCroitoru#)

  - **Sponsored by**:
    [EliezerCroitoru](https://wiki.squid-cache.org/BuildFarm/DockerPackaging/EliezerCroitoru#)
    - [NgTech](http://www1.ngtech.co.il/)

# Details

I have been building and packaging Squid-Cahce for
CentOS/Oracle/AWS/Suse and couple other distributions. Since
[RedHat](https://wiki.squid-cache.org/BuildFarm/DockerPackaging/RedHat#)
and other distributions made it possible to build and pack software in
their "Software Collections" There is no real need for me to build Squid
every time a release is out.

Since my web service is being abused by many on the Internet I decided
to "Offload" the build service to others.

I have created a repository which contains docker build nodes for
x86\_64(Only) that might work on other platforms.

[](https://github.com/elico/squid-docker-build-nodes)

This build system has been tested a lot but due to the migration from
VM's to Docker it requires re-evaluation.

I am planning to stop my build nodes and my repository hosting services
in the next couple month to a year. For now there is a QOS system on my
service and for instructions on how to access these try:
[](http://gogs.ngtech.co.il:9001/NgTech-LTD/ngtech-connect)

If you are interested in funding these, contact me on my mobile or
email.
