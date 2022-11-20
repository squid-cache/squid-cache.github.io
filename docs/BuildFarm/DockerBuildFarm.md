# Docker-based build farm setup

## Host

The build farm itself runs on *buildmaster.squid-cache.org*. You need a
login there to perform any of the following.

All content is in /srv/jenkins, which is the home directory of the
jenkins user. The only external hook is `/etc/rc.local`, to start
jenkins up.

Jenkins runs as user `jenkins`; it connects to remote hosts using ssh
(some have their own service calling in via jnlp), and starts up
docker-based slaves on demand when there is a build to be done.

## Docker setup and conventions

Each slave is based on an image. The list of available images can be
obtained (as root or jenkins) with the command `docker images`. The ones
that are relevant for the farm are named with the convention
`farm-<osname>-<osversion>`. Known-good recovery points are tagged with
the date of the recovery point - the convention is thus
`farm-<osname>-<osversion>:<yymmdd>`.

The `/home/jenkins` directory of each slave is meant to host the build
environment for that slave, and is mapped from the host directory
`/srv/jenkins/docker-images/<osname>-<osversion>`.

In `/srv/jenkins/docker-images` there are also a few utility commands to
support managing containers.

  - `./interactive <containername>`
    
      - run container "farm-\<containername\>" interactively. Its
        use-case is to manage the software installed in the container
        image.

  - `./slave <containername>`
    
      - script meant to launch the jenkins slave with the appropriate
        command-line arguments

## Image management

Images are built from dockerfiles in
jenkins@buildmaster:\~/docker-images/dockerfiles (it's a local git
repository). In order to update an image, edit the relevant dockerfile,
then in the top directory,

    $ make <image name> [<image name> ...]

To clean older versions if images:

    $ make clean

## Host installation

The host needed to run the images can be installed using this commands
list (assuming a debian host)

    apt -y update && apt -y upgrade && apt -y install openjdk-11-jre-headless docker.io
    useradd -m -u 1000 -G docker jenkins
    
    (optional)
    docker pull --all-tags squidcache/buildfarm

## Autoscale on-demand builds

These run on buildmaster, here's how the concepts fit together: - builds
need to be tied to a node labelled "docker-build-host". This label is
provided by the
[DigitalOcean](/DigitalOcean)
plugin, which instantiates a new cloud VM on demand, and tears it down
when not used. The cloud initialiser installs what is needed to run a
slave. If it is a matrix build, there needs to be a "slaves" matrix axis
with a single label to enforce this, or jobs will be run everywhere -
The build command is:

  - `` docker run --rm -u jenkins -v `pwd`:`pwd` -w `pwd`
    squidcache/buildfarm:${OS} /bin/bash -l ./test-builds.sh --verbose
    ${tests}  `` where OS is either a matrix axis or an OS label.

\- the docker images to be used are hosted on the docker hub, as labels
of squidcache/buildfarm - in order to build and push these images, go to
jenkins@buildmaster:\~/docker-images/dockerfiles, and `make all push`
