##master-page:SquidTemplate
#format wiki
#language en

## This page documents the requirements for distributing third-party modules as part of Squid

<<TableOfContents>>

= Third Party Modules in Squid =

Squid offers many different interfaces and API for extension, and has for quite some time. The number and power of these interfaces has grown in time, as has their usefulness.
Finding those plugins may be a hard task for the interested users; the purpose of this page is to help extension modules' authors make their work known to users.

|| /!\ || The Squid Development Team cannot in any way offer any warranty, or take any responsibility, on any third-party code. We did not write it, and we cannot support nor maintain it. ||

== Self-distributed modules ==

Authors who wish to self-distribute their add-on modules can publish a feature-like page pointing to their work in the [[#modules|Third-party modules registry]].

It is possible - and in fact encouraged - to use the Squid Wiki infrastructure to document extension modules.
It is also possible to use this wiki to distribute those modules as [[HelpOnActions/AttachFile|Wiki Attachments]]

To be given write-access to the wiki please follow the instructions in FrontPage.

=== Using LaunchPad ===

[[https://launchpad.net/|LaunchPad]] is a service maintained by Canonical to host and help Free/Open Source Software projects by offering services related to code development, such as code repositories, bug tracking databases, documentation repositories etc. It is very well integrated with [[BzrInstructions|Bazaar]], the code repository tool used by the Squid project.

It is possible to also use Launchpad to maintain a link to the squid project for self-distributed modules: the easiest way is to use a Launchpad Blueprint, mentioning "squid" as a dependency for a project. That will automatically link third-party projects to the [[https://blueprints.launchpad.net/squid|Squid Blueprints]] page.

== Bundled modules ==

The Squid Team is also open to requests from third-parties to bundle extension modules with the Squid releases.
We are currently developing a set of guidelines to help ease the distribution integration. Until they are finalized, we ask interested parties to them for tracking and apply with the project MergeProcedure.


<<Anchor(modules)>>
= Modules Registry =

Here's an auto-generated list of available third-party modules.
<<FullSearch(title:ThirdPartyModules/)>>

== Register a new third-party module ==

Choose a good WikiName for it and enter it here:
<<NewPage(ThirdPartyModuleTemplate, Create, ThirdPartyModules)>>


----
Discuss this page using the "Discussion" link in the main menu

<<Include(/Discussion)>>
