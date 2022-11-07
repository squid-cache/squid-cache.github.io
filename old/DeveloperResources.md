# Contributing code

The best way to contribute code is to submit a high-quality [pull
request](https://github.com/squid-cache/squid/pulls) against the master
branch of the official
[repository](https://github.com/squid-cache/squid) on GitHub. To speed
up code review and improve your code acceptance chances, please adhere
to
[SquidCodingGuidelines](/SquidCodingGuidelines#)
and follow the
[MergeProcedure](/MergeProcedure#).

[ProgrammingGuide](/ProgrammingGuide#)
provides a broad overview of Squid architecture and details some of
Squid modules. It also discusses [manual page
writing](/ProgrammingGuide/ManualDocumentation#).

Auto-generated [code
documentation](http://www.squid-cache.org/Doc/code/) offers some
information on the Squid internals with links to the latest version of
the code.

Finding things to do:

  - [Bugzilla](http://bugs.squid-cache.org/) contains bugs and feature
    requests.

  - [RoadMap](/RoadMap#)
    lists the feature wishes and plans for future releases.

  - [RoadMap/Tasks](/RoadMap/Tasks#)
    itemizes general cleanup tasks that need to be done. These can be
    good introductory tasks.

  - [HTTP/1.1
    compliance](/Features/HTTP11#)
    violations need to be addressed.

  - `git grep XXX`

  - `git grep TODO`

  - Other developers are often able to provide projects for anyone just
    wanting to contribute.

# Discussing code

Most development discussions happen on the [developer mailing
list](http://www.squid-cache.org/Support/mailing-lists.html#squid-dev).
Please note that all messages must be sent in plain-text only (no HTML
email).

# Testing

We run constant integration testing with a
[BuildFarm](/BuildFarm#).

It is possible to rely on the images we use for it to test code changes
against different Linux distributions and compiler versions. We publish
these images to the [Docker
Hub](https://hub.docker.com/orgs/squidcache/repositories). They are
named ``squidcache/buildfarm-`uname -m`-<os name>``

Assuming you have access to a Docker environment, the easiest way to
test a local checkout on it is to run the command:

``OS=centos-7 docker run -ti --rm -v$PWD:$PWD -w$PWD -u1000
./test-builds.sh squidcache/buildfarm-`uname -m`-$OS --verbose
--use-config-cache --cleanup``

It may leave behind some files owned by UID 1000; sorry it can't be
avoided

## Detecting build errors early

It is always better to find bugs before submitting a PR for review.
Since Squid has such a large number of build permutations that can
interact to change build dependencies and outcomes the a
**test-builds.sh** script is provided in the repository to check that
your code contribution will at least compile successfully. This is the
same script which will be run by the CI system in a wider range of OS
systems to prevent regressions.

In a checkout of the Squid sources branch you are proposing to submit
for PR, run: \` ./bootstrap.sh && ./test-builds.sh \`

The default stdout display just lists the ERROR and FAIL messages
produced during build. Not all of these are problems (eg stats
indicating 0 failures), a series of logs with full build output are
provided as well. See the end of the log for overall build result if you
have any doubts about the success/failure status.

The command line option **--keep-going** is provided to allow as many
error as possible to be found on one script execution. It builds with
**make -k** and tries all build permutations instead of exiting on the
first compile failure.

The command line option **--verbose** is provided to allow full compile
output to stdout instead of only to logs. The logs are still produced.

Other options are available for specific build situations. See the
script for details or ask on squid-dev mailing list.

## Replication of CI BuildFarm failures

On any linux system with docker installed, to reproduce a build you can
check out squid sources on a fresh directory, then run:

\` OS\_VERSION=fedora-32 docker run -ti --rm -u jenkins -v $PWD:$PWD -w
$PWD squidcache/buildfarm:`uname -m`-$OS\_VERSION /bin/bash -l \`

  - ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    Replace OS\_VERSION with the OS version of the CI system node which
    is failing (eg, fedora-rawhide, debian-unstable)

This will drop you in the container, ready to try things out.

# Getting sources

There are several ways to get Squid sources. The method you select
determines whether the sources come bootstrapped or can be easily
updated as the official code changes.

## Raw sources via GitHub

The official Squid source code repository is on
[GitHub](https://github.com/squid-cache/squid). see
[GitHints](/GitHints#)
for common actions you may need to perform with the git VCS.

  - ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    When working from this repository the **bootstrap.sh** script is
    required to prepare ./configure and related magic. See
    [\#Required\_Build\_Tools](#Required_Build_Tools) for the required
    bootstrapping and building tools.

## Bootstrapped source tarballs via HTTP

The latest sources are available at address
[](http://www.squid-cache.org/Versions/) with a series of previous daily
snapshots of the code for testing regressions and other special
circumstances.

  - ![{i}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-info.png)
    The daily tarballs displayed are listed by date created and the
    repository revision ID included in that tarball. Gaps are expected
    in the list when there were no new revisions committed that day, or
    when the revision failed to compile on our tarball creation machine.
    
    ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    Daily tarballs contain the fully bootstrapped tool chain ready to
    build. But be aware that some changes may appear with incomplete or
    missing documentation.

As a more lightweight alternative you can use rsync to fetch the latest
tarball content.

## Bootstrapped sources via rsync

As a more lightweight alternative to the tarballs you can use rsync; the
latest sources are available at address
`rsync://squid-cache.org/source/<version>`

The rsync source mirrors the latest published sources tarball.

![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png) The
rsync sources contain the fully bootstrapped tool chain ready to build.
But be aware that some changes may appear with incomplete or missing
documentation.

To use this feature you may use

    $ rsync rsync://squid-cache.org/source
    (sample output)
    drwxr-xr-x         512 2011/03/20 19:14:28 .
    drwxr-xr-x        1024 2009/09/17 14:13:26 squid-2.6
    drwxr-xr-x        1024 2011/03/20 19:14:06 squid-2.7
    drwxr-xr-x        1024 2010/07/02 13:10:53 squid-2
    drwxr-xr-x        1024 2010/07/02 13:17:48 squid-3.0
    drwxr-xr-x        1024 2011/03/20 19:14:21 squid-3.1
    drwxr-xr-x        1024 2011/03/20 19:14:26 squid-3.2
    drwxr-xr-x        1024 2011/03/20 19:14:26 squid-3.3
    drwxr-xr-x        1024 2011/03/20 19:14:26 squid-3.4
    drwxr-xr-x        1024 2011/03/20 19:14:26 squid-3.5
    drwxr-xr-x        1024 2011/03/20 19:14:13 squid-4

After you've selected the version you wish to download you can:

    rsync -avz rsync://squid-cache.org/source/<version> .

# Required Build Tools

  - autoconf 2.64 or later

  - automake 1.10 or later

  - libtool 2.6 or later

  - libltdl-dev

  - awk

  - ed

  - [CppUnit](http://cppunit.sourceforge.net/cppunit-wiki) for unit
    testing.

Depending on what features you wish to develop there may be other
library and tool requirements.

Building tarballs for distribution requires these additional tools:

  - autoconf-archive

  - tar

  - gzip

  - bzip2

  - xz

  - perl

When working from the repository code the **bootstrap.sh** script is
required initially to run a number of autotools to prepare ./configure
and related magic. This needs repeating after any changes to the
Makefile.am or configure.ac scripts, including changes received from the
repository updates. Common bootstrap.sh problems are discussed in
[ProgrammingGuide/Bootstrap](/ProgrammingGuide/Bootstrap#).

# Miscellaneous

[ReleaseProcess](/ReleaseProcess#)
describes the process and criteria used by the Squid Developers when
making new Squid releases from the accepted changes.

[WhoWeAre](/WhoWeAre#)
explains who the people working on the Squid project are.

During the life of the Squid project, a number of
[papers](http://www.squid-cache.org/Devel/papers/) have been published.

Code Sprints are informal gatherings of Squid developers with a focus on
developing urgently needed features or fixing major bugs. You can find
links to related documents in
[MeetUps](/MeetUps#).
