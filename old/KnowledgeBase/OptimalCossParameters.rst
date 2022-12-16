##master-page:KnowledgeBaseTemplate
##Page-Creation-Date:[[Date(2007-05-04T22:27:22Z)]]
##Page-Original-Author:["kinkie"]
#format wiki
#language en

= Optimal COSS Parameters =

|| /!\ || This article is a '''STUB'''. It's written to encourage discussion on the topic, but it's not (yet) to be used as reference ||

'''Synopsis'''

[[Features/CyclicObjectStorageSystem|COSS]] or Cyclic Object Storage System is the fastest disk storage method available to Squid. The SquidFaq contains information about its configureable parameters, while here we want to focus on how to optimize those parameters for a typical proxying setup for maximum performance.

'''cache_dir number and parameters'''

Not more than one per physical disk. The aim of COSS is to be extremely fast, and to keep the OS - which is generally optimized for interactive tasks - from optimizing things the wrong way. Having multiple cache_dirs would increase the chance of disk head trashing, and thus lower performance.

If your disks are similar in performance, it's best to just let squid balance the load and use the same configuration parameters for all cache_dir's.

'''parameters'''

Use the cachemgr to fine-tune those parameters you can tweak.


----
CategoryKnowledgeBase CategoryStub
