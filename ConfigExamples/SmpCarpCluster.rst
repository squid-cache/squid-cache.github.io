##master-page:ConfigExampleTemplate
#format wiki
#language en


= MultiCpuSystem =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

Squid-3.1 and older do not scale very well to Multi-CPU or Multi-Core systems. Some of its features do help, such as for example [[Features/DiskDaemon|DiskDaemon]], or [[Features/CyclicObjectStorageSystem|COSS]], or the ability to delegate parts of the request processing to external helpers such as [[SquidFaq/ProxyAuthentication|Authenticators]] or [[SquidFaq/RelatedSoftware|other auxiliary software]].
Still Squid remains to this day very bound to a single processing core model. There are plans to eventually make Squid able to effectively use multicore systems, but something may be done already, by using a fine-tuned MultipleInstances setup.

It is also geared at '''expert system-administrators'''. MultipleInstances is not easy to manage and run, and system integration depends on the specific details of the operating system distribution of choice.

The setup laid out in this [[ConfigExamples|configuration example]] aims at creating on a system running squid with SMP workers:
 * a 'front-end' worker which does
  * authentication
  * authorization
  * logging, delay pools etc.
  * in-memory hot-object caching
  * load-balancing of the backend processes
  * redirection etc.
 * a 'back-end' worker farm, whose each does
  * disk caching
  * do the network heavy lifting

While this setup is expected to increase the general throughput of a multicore system, the benefits are anyways constrained, as the frontend worker is still expected to be the bottleneck.
Should anyone put this in production, he's encouraged to share the results to help others evaluate the effectiveness of the solution.

== Squid Configuration File ==

For a 2-backends system, there are 5 configuration files to be used.
You can click below each file on its filename to download it, no need to copy and paste. The .txt extension an artifact, please remove it.

=== acl ===
This file contains the ACL's that are common to all running instances.
{{attachment:common.acl.conf.txt}}

=== common backend parameters ===
Backends share most of the configuration, it makes sense to also join those
{{attachment:common.backend.conf.txt}}

=== squid.conf ===

=== frontend ===
{{attachment:frontend.conf.txt}}

=== backend ===
{{attachment:backend.conf.txt}}


----
CategoryConfigExample
