# How daily snapshots files are generated

As of the 2023-11-02, this is the process to generate snapshot tarballs.

1. Jenkins jobs run at regular cadences, monitoring the repository, run a full build test.
   [`trunk-arm64-matrix`](https://build.squid-cache.org/job/trunk-arm64-matrix/) is used for the
   VCS ["master" branch](https://github.com/squid-cache/squid/tree/master/),
   while a version specific `N-matrix` (e.g. `6-matrix` or `5-matrix`) are used for the stable and old releases
1. if these jobs are successful, they will trigger the corresponding tarball creation job
   (e.g. [`website-tarballs-head`](https://build.squid-cache.org/job/website-tarballs-head/) for the `trunk_amd64_matrix`).
   The tarball jobs trust that if they are invoked, it's because the branch has a stable build and testing result.
   Jenkins administrators can, at any point, force the execution of these jobs.
1. 1. The code run there is [`make-snapshot.sh`](https://github.com/kinkie/support-tools/blob/master/squid-ci/make-snapshot.sh).
   The artifacts it generates are replicated to buildmaster and are accessible via https.
   e.g. [development version artifacts](https://build.squid-cache.org/job/website-tarballs-head/lastSuccessfulBuild/artifact/artifacts/).
1. 1. A cron job running [`mk-release-snapshots.sh`](https://github.com/squid-cache/ci/blob/main/release/mk-release-snapshots.sh) on master downloads these artifacts,
   unpacks them, and makes them available for access and download on the website
