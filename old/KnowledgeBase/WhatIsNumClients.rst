##master-page:KnowledgeBaseTemplate
##Page-Creation-Date:[[Date(2008-03-19T13:54:12Z)]]
##Page-Original-Author:FrancescoChemolli
#format wiki
#language en

= What is the "Number of clients accessing cache"? =

In the [[SquidFaq/CacheManager|cache manager]]'s "general runtime information" page, Squid specifies the number of clients accesssing the cache; but WHAT it is is not really explained anywhere.

Technically speaking, it's the size of the clients database, where Squid records some informations about the clients haivng recently accessed its services.

''' So what is a "Client"? '''

Squid keeps in its client database information about IP addresses which have
 * performed more than 100 HTTP requests in the past 24 hours '''OR'''
 * performed more than 10 HTTP or ICP requests in the past 4 hours '''OR'''
 * performed more than one HTTP or ICP request in th epast 5 minutes

This logic is hard-coded in the Squid source and at this time can't be changed.

----
CategoryKnowledgeBase
