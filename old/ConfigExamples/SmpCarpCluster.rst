##master-page:ConfigExampleTemplate
#format wiki
#language en


= CARP Cluster of SMP workers =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<Include(ConfigExamples, , from="^## smpwarning begin", to="^## smpwarning end")>>

<<TableOfContents>>

== Outline ==

[[Squid-3.2]] and newer offer support for SMP scaling on Multi-Core systems and much simpler configuration of multi-process systems. However the support is not yet complete for all components, notably the UFS cache storage systems. As such the old problem of object duplication in UFS/AUFS/diskd storage caches remains. That problem was partially solved in older versions by utilizing the CARP peer selection algorithm in a multi-teir multi-process design.

This configuration outlines how to utilize [[Squid-3.2]] SMP support to simplify the configuration of a Squid CARP cluster while retaining the CARP object de-duplication benefits. It is geared at '''expert system-administrators'''. Knowledge of forwarding loop control and SMP worker numbering will help with understanding this configuration.

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

While this setup is expected to increase the general throughput of a multicore system and simplify the CARP cluster maintenance, the benefits are anyways constrained as the frontend worker is still expected to be the bottleneck.

Should anyone put this in production, be encouraged to share the results to help others evaluate the effectiveness of the solution.

== Squid Configuration File ==

There are 3 configuration files to be used. You can click below each file on its filename to download it.

=== squid.conf ===
{{attachment:squid.conf}}

=== frontend.conf ===
{{attachment:frontend.conf}}

=== backend.conf ===
{{attachment:backend.conf}}


----
CategoryConfigExample
