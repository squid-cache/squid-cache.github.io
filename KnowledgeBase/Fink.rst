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

= Squid on Fink =

<<TableOfContents>>

== Pre-Built Binary Packages ==

Packages available in binary or source for Squid on i86 64-bit, i86 32-bit and PowerPC architectures.

Package Information: http://pdb.finkproject.org/pdb/package.php/squid-unified

'''Maintainer:''' Benjamin Reed

##  '''Bug Reporting:'''  link to bug reporting system interface (AND how-to if they need one).


## 4  = indents required for BinaryPackages page include
==== Squid-3.1 ====

Package in source distribution.

Install Procedure:
{{{
apt-get install squid-unified
}}}

==== Squid-2.6 ====

Packaged in 10.5 binary distribution.

Install Procedure:
{{{
apt-get install squid-unified
}}}

==== Squid-2.5 ====

Packaged in 10.4 binary distribution.

Install Procedure:
{{{
apt-get install squid-unified
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
CategoryKnowledgeBase SquidFaq/BinaryPackages
