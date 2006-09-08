#language en
## add some descriptive text. A title is not necessary as the WikiPageName is already added here.
## if you want to have a table of comments remove the heading hashes from the next line
## [[TableOfContents]]
== Current Goals for Squid-3.0 ==
We are aiming to have Squid-3.0 released as soon as it is possible. The project is currently trying to have the first stable release near the end of October.

 * Bring over a number of stable features from the Squid-2.6 branch - TPROXY, COSS, Pinned Connections
 * Concentrate on correctness and fixing bugs over performance or new features
 * Re-run Co-Advisor; fix anything obvious
 * Stable ICAP support
 * Stable ESI support
== Current Goals for Squid-3.1 ==
The main focus of Squid-3.1 will be performance and API restructuring. The main points to address will be:

 * Importing one or more content-encoding modules to test the suitability of the Squid-3 streams API and code - at least GZIP
 * Work on Comm/Disk layer optimising and restructuring where appropriate
 * Work on a replacement HTTP request/reply parser
 * Use the above work to document client streams and writing new protocol support; hopefully to entice more developers back into the project
Additionally, more work towards HTTP/1.1 compliance is needed. To this effect, some thought will need to be put into the following areas:

 * HTTP entity types
 * HTTP range requests
 * Storage Manager API and data flow
== Website Goals ==
 * Finish the work Duane has started with the website redesign/reorganisation
 * Start working on example configurations to explain how to configure and manage Squid in different environments
 * Work on more general web caching documents showing why its good - perhaps some "case studies" from those using Squid at the moment.
