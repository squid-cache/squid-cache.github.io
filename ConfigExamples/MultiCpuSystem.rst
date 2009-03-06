##master-page:ConfigExampleTemplate
#format wiki
#language en


= MultiCpuSystem =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

Squid does not yet scale very well to Multi-CPU or Multi-Core systems. Some of its features do help, such as for example [[Features/DiskDaemon|DiskDaemon]], or [[Features/CyclicObjectStorageSystem|COSS]], or the ability to delegate parts of the request processing to external helpers such as [[SquidFaq/ProxyAuthentication|Authenticators]] or [[SquidFaq/RelatedSoftware|other auxiliary software]].
Still Squid remains to this day very bound to a single processing core model. There are plans to eventually make Squid able to effectively use multicore systems, but something may be done already, by using a fine-tuned MultipleInstances setup.

|| /!\ Notice || This setup has been designed with a recent version of squid in mind. It has been tested with Squid 3.1, but it should work with 3.0 and 2.7 as-is as well. 2.6 and earlier can be coaxed to work, but it will be harder to setup and maintain. ||

It is also geared at '''expert system-administrators'''. MultipleInstances is not easy to manage and run, and system integration depends on the specific details of the operating system distribution of choice.

The setup laid out in this [[ConfigExamples|configuration example]] aims at creating on a system multiple running squid processes:
 * a 'front-end' process which does
  * authentication
  * authorization
  * logging, delay pools etc.
  * in-memory hot-object caching
  * load-balancing of the backend processes
  * redirection etc.
 * a 'back-end' processes farm, whose each does
  * disk caching
  * do the network heavy lifting

While this setup is expected to increase the general throughput of a multicore system, the benefits are anyways constrained, as the frontend process is still expected to be the bottleneck.
Should anyone put this in production, he's encouraged to share the results to help others evaluate the effectiveness of the solution.

== Squid Configuration File ==

For a 2-backends system, there are 5 configuration files to be used.
You can click below each file on its filename to download it, no need to copy and paste. The .txt extension an artifact, please remove it.

=== acl ===
This file contains the ACL's that are common to all running instances. This allows to change cluster-wide parameters without needing to touch each instance's. Each instance will still have to be reconfigured individually.
{{attachment:common.acl.conf.txt}}

=== common backend parameters ===
Backends share most of the configuration, it makes sense to also join those
{{attachment:common.backend.conf.txt}}

=== frontend ===
{{attachment:frontend.conf.txt}}

=== backend 1 ===
{{attachment:backend-1.conf.txt}}

=== backend 2 ===
{{attachment:backend-2.conf.txt}}


----
CategoryConfigExample
