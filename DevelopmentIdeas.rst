#language en
Ideas for possible new developments should be posted here, along with discussions on pros and cons

[[TableOfContents]]

= Linux-only I/O optimizations =
Linux 2.6.17 (but the concepts were refined and interfaces altered in 2.6.18+) implemented a few new system calls for zero-copy I/O operations involving pipes: splice, tee and vmsplice

 * ''splice'' copies an user-specified amount data from a pipe into another pipe
 * ''tee'' is like splice but doesn't consume data from the input, and can be thus invoked multiple times on the same pipe
 * ''vmsplice'' copies data from an user-specified memory region into a pipe
Those '''''might''''' be useful in different cases: respectively disk cache hit, cacheable miss and (probably) error pages. We need to verify that the semantics are right, and what kind of compromises are required to implement them

''' '''

'''Resources''':

 * http://lwn.net/Articles/178199/
 * http://lwn.net/Articles/179492/
 * http://lwn.net/Articles/181169/
'''Discussion '''

----
= Request Flow reorganization =
(from the old Faq-O-Matic)

The request flow should be as clean as possible 
 1. The proxy request flow should be just that. Separate cache from the request flow. 
 1. No double or triple copying of data. Make use of reference counted data buffers to pass data as-is from reader to writer, including to/from cache. 
 1. As few special cases as possible. Beware of "huge" requests, or joined requests with a "huge" distance between two users. 

Due to requirement 'c', I think we should drop the idea of joined requests where there is more than one client. Better if we simply support storage of partial objects, and then ignores the whole issue.

[:Henrik Nordström]
'''Discussion'''
