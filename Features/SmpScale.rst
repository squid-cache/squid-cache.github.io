##master-page:CategoryTemplate
#format wiki
#language en

= Feature: SMP Scalability =

 * '''Goal''': Approach linear scale in non-disk throughput with the increase of the number of processors or cores.

 * '''Status''': Not started

 * '''ETA''': 10-18 months

 * '''Version''': Squid 3.2

 * '''Developer''':

 * '''More''':


SMP scalability can significantly reduce Squid costs and administration complexity in high-performance environments.

We need to isolate CPU-intensive Squid functionality into mostly independent logical threads, tasks, or jobs, so that each core or CPU can get its thread(s), spreading the overall load. The best architecture to implement this has not been decided yet.

The implementation speed will depend on funding available for this project.

----
CategoryFeature CategoryWish
