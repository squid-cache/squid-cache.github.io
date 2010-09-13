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

= Squid on Gentoo =

<<TableOfContents>>

== Pre-Built Binary Packages ==

## Details briefly covering critical information for user contact and problem reporting...
##
##  '''Maintainer:''' Your Name goes here. Email too if you want direct contacts.
##  ''Bug Reporting:'''  link to bug reporting system interface (AND how-to if they need one).


## List of sections named per major release.
## Repeat the following with sub-section for each distributed release package.
## Named by version of Squid it packages.
## Numerically highest to lowest only those currently available in the distro.

=== Squid-X.Y ===

'''Maintainer:''' Alin Năsta

Install Procedure (for the latest version in your selected portage tree):
{{{
 emerge squid
}}}

==== Squid-3.1 ====
Install Procedure:
{{{
 emerge =squid-3.1*
}}}
==== Squid-3.0 ====
Install Procedure:
{{{
 emerge =squid-3.0*
}}}
==== Squid-2.7 ====
Install Procedure:
{{{
 emerge =squid-2.7*
}}}
==== Version Notice ====
If you try and install a version not available in portage, such as 2.5, you will see the following notice:
{{{
emerge: there are no ebuilds to satisfy "=net-proxy/squid-2.5*".
}}}

== Compiling ==

## Describe the configure options and command line needed to build and install Squid

## Followed by any special patching needed.
## Please inform upstream so we can simplify this to a configure option and obsolete the patching

== Troubleshooting ==

## Series of errors that may be seen. Only if unique to this OS.
##  Cross-OS errors go in Features with the relevant feature.
## Followed by a description of what it means and the solution if known.

----
CategoryKnowledgeBase CategoryDistributionInfo
