##master-page:Features/FeatureTemplate
#format wiki
#language en
#faqlisted no

= Feature: Hot Configuration =

 * '''Goal''': To remove the many issues squid currently displays due to reconfigure via a full component shutdown/restart cycle.

 * '''Status''': underway;

 * '''ETA''': unknown

 * '''Version''': 

 * '''Developer''': AmosJeffries


= Details =

Squid currently performs reconfigure by way of a simulated shutdown, re-loading the config files, and restarting.

This causes many issues which are visible:
 * ports fully closed for a duration
 * memory leaks for SSL contexts, and other in-use objects
 * loss of information on in-transit requests
 * INVALID URL errors when protocol info disappears.
 * request denials when ACLs being checked disappear.

Related Bug reports:
 * Bug:219
 * Bug:513
 * Bug:537
 * Bug:1545
 * Bug:1946
 * Bug:2110
 * Bug:2460
 * Bug:2570
  . A workaround is in use for memory-only caches, but this keeps resurfacing. Lately rock type dirs with SMP diskers is causing it again.
  . We need to obsolete SquidConf:wccp2_rebuild_wait.
 * Bug:2626

== State up to Squid-3.1 ==

The plan begun during early 3.0 cycle was to re-work the existing squid.conf parser to pass the syntax parsing into each component which had better knowledge of the requirements.

The above plan halted for currently unknown reasons and was left incomplete. It appears to split the parsing down a bit too deeply into components for easy understanding. It also leads to code duplication as minor parsing functions (undocumented!) are missed by followup developers and re-implemented at the per-component level. This is not a good state and needs to be simplified in the redesign.

The old Squid-2 parser has a much clearer design, but suffers major issues with component inter-dependencies. So needs to be split at least partway down the track of the 3.0 design.

Also, neither of the current config parser designs can completely resolve the set of issues so a new design is needed to replace both. Integrating the simple option handling of the Squid-2 parser and the per-component split of the initial Squid-3 parser.


== New Design for Squid-3.1+ ==

The current work begun already in Squid-3.1 and building in with [[Features/SourceLayout]] takes the Squid-3.0 parser idea of modular component config (each sub-library has its own XX::Config object which holds only that components configuration settings.

But also leaves the legacy parser per-type parsing function. Which causes two layers to emerge:
 * the underlayer of legacy parser which handles file actions
 * the component layer of squid.conf option handlers

these are linked together at present by defining the legacy parser handlers interface as wrapper functions/macro to the XX::Config object methods.

The plan is to build on that modular design and create two master objects:

=== A XX::Config template or parent object ===

This object to provide virtual functions that register a handler for each squid.conf option the component can parse (both current, deprecated, and obsolete options).

The option handlers:
 * parse the squid.conf line for that option
 * produce clear and understandable error messages when a line is bad
 * produce clear warnings when an option is being deprecated
 * provide for migrating obsolete squid.conf options, a built-in [[Features/ConfigUpdater]]

It also must provide an API for the startup, shutdown, reload, and reconfigure processes. The reconfigure is in need of the most work.

As I see it the important part of reconfigure, is that a pre-reconfigure and post-reconfigure call is made to each component so it can perform any actions needed to prepare itself for parsing. And to cleanup/restart if needed after parsing.

Major components may need to process their parsing results into a shadow config during the reconfigure and perform a hot-swap that allows existing requests to continue with the old config details and new ones to use the updated config.

Some objects will need to be made ref-counted to prevent disappearance when an updated config is hot-swapped into place:
 * http_port definitions
 * SSL context settings
 * ACL lists
 * helper settings
 * auth settings
 * delay pools
 * store settings
 * (any others known please add)

The config object for each component needs to have a component enable/disable flag or setting. This will allow run-time enabling and disabling of components and additionally allow the shutdown/restart logics to be improved and extended with async paths.

=== A registry-style parser / component manager ===

A manager object to receive handler registrations and process the low-level file reads needed to process squid.conf.

May also control the core startup/shutdown/restart/reconfigure/reload actions currently done at global level by main.cc

== Results ==

When this is completed;
 * Components can be created semi-autonomously and 'dropped in' to the code base.
 * Each will manage its own set of squid.conf lines.
 * The startup procedure will take less than a second
 * reload will be a zero-downtime event
 * restart will be a zero-downtime event
 * shutdown will be a fast event
 * components such as auth and helpers will be reconfigurable


== Discussion ==
/!\ To answer, use the "Discussion" link in the main menu
<<Include(/Discussion)>>

----
CategoryFeature
