# Performance Measurement Bundle

  - **Goal**: To provide a bundle of scripts and data which can generate
    and run a range of traffic throughput tests on Squid.

  - **Status**: Concept Design. Not started yet.

  - **ETA**: unknown.

  - **Developer**:
    [AmosJeffries](/AmosJeffries#)

# Details

  - ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    This is all a draft brain-dump for now. It has yet to be discussed
    and checked by anyone.

So just off the top of my head. What we need is:

  - a simulation of traffic ranging from a few hundred MB up to TB.

  - something to run this through Squid

  - something to measure the various things we gather benchmarks on

The simulation cannot be completely random. It needs to be fixed in
request/reply sizes and header complexity to give some realistic measure
of Squid with live traffic.

Some things can be randomized:

1.  Body data. We only require body data of specific sizes. This means
    we need to know real sizes when creating the benchmark set, but can
    generate new bodies randomly during benchmark suite setup. This
    saves a lot of transfer bandwidth and protects against
    privacy/copyright/security issues at the same time.

2.  Header URL lengths. We do need to keep URL length as realistic as
    possible. But by its nature we are going to be forced to make URLs
    into a format our benchmarking server can use to supply the proper
    reply. They can be padded UP with garbage info to whatever length is
    needed. This will purge any of the original tracking information and
    protects against privacy/copyright/security issues. Even though some
    URL will be larger than their original real version.

3.  Cookie etc. These can be replaced with somewhat random information.
    Only the header format needs to be kept parsable.

## The Dataset

For starters I'm thinking we need to use live data. This means we need
to locate an ISP able to provide at least one TB of sequential HTTP
requests+replies in full to be turned into a benchmarking dataset.

The data needs to be complete at point of capture, but our generation
process can perform the obfuscation methods mentioned above before its
published anywhere. If there are any privacy issues, the following can
most likely all be done before any information even leaves the ISP.

When processed the dataset should contain:

  - a script or file listing the client requests in order.

  - a script listing the reply objects and size. Headers would need to
    be packaged with the benchmark bundle, bodies can be generated on
    setup from this file.

  - a directory heirarchy of request and reply headers.

## Scripts

### Setup

One to setup the benchmark environment, generate dataset objects etc.
This should be pretty simple once the dataset and actual benchmarking
scripts are defined.

### Measurement

We have a lot of measures already:

  - req/sec

  - bytes/sec

  - total running time for various sizes of dataset

  - time from start to first server object

  - time to shutdown after dataset

  - various measures of per-object timing (variant on object size).

  - others??

Most of these are available already from Squid cachemgr reports. The
addition of a proposed benchmarking page will greatly enhance the
results accuracy. But legacy versions of Squid need to be accommodated
for comparison.

### Client / Server Emulators

Obviously a client process and server process. I'm kind of assuming
there is software already out there somewhere that can do this fast
enough to outperform Squid even after any improvements we make.

Suggestions please?

## Discussion

![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png) To
answer, use the "Discussion" link in the main menu

See [Discussed
Page](/PerformanceMeasure#)

In my biased opinion, [Web Polygraph](http://www.web-polygraph.org/)
should be used for lab performance work. It already covers your wish
list pretty well, has many essential features that are not listed on
your page yet, and can be enhanced to do more if needed. Polygraph has
been designed to test caching proxies performance and comes with years
of performance testing experience.

If you recall, I have been trying to find time to start running regular
Squid performance tests and publish results for more than two years now.
I gave up recently and hired somebody who should be able to do this for
the Squid Project. I expect to post first results by August 2009.

I would not recommend using live data for the bulk of the performance
testing work. To run meaningful series of tests, you almost always have
to *tune* the workload to match the test purpose. Doing that with live
data is sometimes technically possible, but is a lot more complex and
does not buy you much in terms of realism. Real data also immediately
causes personal and commercial privacy headaches. Parameterizing
synthetic workloads with ISP-provided stats is a good idea though.

You should probably mention a misnamed
[Benchmarks](/KnowledgeBase/Benchmarks#)
page that collects live Squid performance anecdotes.

\--
[AlexRousskov](/AlexRousskov#)

[CategoryFeature](/CategoryFeature#)
