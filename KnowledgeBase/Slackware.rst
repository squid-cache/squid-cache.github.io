##master-page:CategoryTemplate
##master-date:Unknown-Date
#format wiki
#language en

## This page is for the availability, contact and troubleshooting information
## relevant to a single operating system distribution on which Squid may be installed
##
## For consistency and wiki automatic inclusion certain headings and high level layout
## needs to be kept unchanged.
## Feel free to edit within each section as needed to make the content flow easily for beginners.
##


= Squid on Slackware =

<<TableOfContents>>

== Pre-Built Binary Packages ==

There are apparently no official Slackware distributed packages of Squid. Packages are instead built and supplied by volunteers from the slackware user community.

## Details briefly covering critical information for user contact and problem reporting...
##
##  '''Maintainer:''' Your Name goes here. Email too if you want direct contacts.
##  ''Bug Reporting:'''  link to bug reporting system interface (AND how-to if they need one).


## List of sections named per major release.
## Repeat the following with sub-section for each distributed release package.
## Named by version of Squid it packages.
## Numerically highest to lowest only those currently available in the distro.

## 4  = indents required for BinaryPackages page include
==== Squid-3.4 ====

'''Maintainer:''' David Somero

'''Source''': !SlackBuilds

 . http://slackbuilds.org/repository/14.1/network/squid/  (3.4.10 on SlackWare 14.1)

==== Squid-3.3 ====

Unofficial package provided by Helmut Hullen can be found in:
 . http://helmut.hullen.de/filebox/Linux/slackware/n/

==== Squid-3.1 ====

'''Maintainer:''' David Somero

'''Source''': !SlackBuilds

 . http://slackbuilds.org/repository/14.0/network/squid/  (3.1.20 on SlackWare 14.0)
 . http://slackbuilds.org/repository/13.37/network/squid/ (3.1.12 on Slackware 13.37)

## Exact sequence of command-line commands or GUI actions used to install this package on the distro.
##Install Procedure:
##{{{
##...
##}}}

==== Squid-3.x ====

'''Maintainer:''' David Somero

'''Bug Reporting:''' http://slackbuilds.org/howto/

 http://slackbuilds.org/result/?search=squid&sv=

## Exact sequence of command-line commands or GUI actions used to install this package on the distro.
##Install Procedure:
##{{{
##...
##}}}

== Compiling ==

## Describe the configure options and command line needed to build and install Squid

## Followed by any special patching needed.
## Please inform upstream so we can simplify this to a configure option and obsolete the patching

== Troubleshooting ==

## Series of errors that may be seen. Only if unique to this OS.
##  Cross-OS errors go in Features with the relevant feature.
## Followed by a description of what it means and the solution if known.

----
CategoryKnowledgeBase SquidFaq/BinaryPackages
