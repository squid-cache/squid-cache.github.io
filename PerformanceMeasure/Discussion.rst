##master-page:DiscussionTemplate
#format wiki
#language en

See [[../|Discussed Page]]

## Please begin your contribution with "----" and an anchor for C# (incrementing the number for each comment) and end it with "-- AlexRousskov <<DateTime(2009-07-02T10:06:34-0700)>>"
## this will help for references. Append to discussion at the bottom of the page.
## You can quote using
## {{{
## text
## }}}

----
<<Anchor(C1)>>
In my biased opinion, [[http://www.web-polygraph.org/|Web Polygraph]] should be used for lab performance work. It already covers your wish list pretty well, has many essential features that are not listed on your page yet, and can be enhanced to do more if needed. Polygraph has been designed to test caching proxies performance and comes with years of performance testing experience.

If you recall, I have been trying to find time to start running regular Squid performance tests and publish results for more than two years now. I gave up recently and hired somebody who should be able to do this for the Squid Project. I expect to post first results by August 2009.

I would not recommend using live data for the bulk of the performance testing work. To run meaningful series of tests, you almost always have to ''tune'' the workload to match the test purpose. Doing that with live data is sometimes technically possible, but is a lot more complex and does not buy you much in terms of realism. Real data also immediately causes personal and commercial privacy headaches. Parameterizing synthetic workloads with ISP-provided stats is a good idea though.

You should probably mention a misnamed [[KnowledgeBase/Benchmarks|Benchmarks]] page that collects live Squid performance anecdotes.

-- AlexRousskov <<DateTime(2009-07-02T10:06:34-0700)>>

### -------
### <<Anchor(C2)>>
### ...Your contribution here...
### -- AlexRousskov <<DateTime(2009-07-02T10:06:34-0700)>>
