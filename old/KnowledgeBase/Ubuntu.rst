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


= Squid on Ubuntu =

<<TableOfContents>>

== Pre-Built Binary Packages ==

Packages available for Squid on multiple architectures.

 . '''Maintainer:''' Luigi Gangitano

==== Squid-4 ====
Bug Reports: https://bugs.launchpad.net/ubuntu/+source/squid

 . {i} Ubuntu 18.10 (Cosmic) or newer.

Install Procedure:

{{{
 aptitude install squid
}}}

==== Squid-3.5 ====
Bug Reports: https://bugs.launchpad.net/ubuntu/+source/squid

 . {i} Ubuntu 18.04 (Bionic) or older.

Install Procedure:

{{{
 aptitude install squid
}}}


## same as Debian for now (but no patches mentioned)
<<Include(KnowledgeBase/Debian,"(see Debian)",3,from="^== Compiling ==$", to="^## end basic compile")>>


## Describe the configure options and command line needed to build and install Squid

## Followed by any special patching needed.
## Please inform upstream so we can simplify this to a configure option and obsolete the patching


=== Compile on A basic Ubuntu Server ===
@Eliezer

Squid can be built on a basic Ubuntu basic Server and it seems like an enterprise OS to me.
The only dependencies are "build-essential" and "libltdl-dev" for squid to run as a forward proxy.
{{{
sudo apt-get install build-essential libltdl-dev
}}}
For more then just forward proxy like ssl-bump or tproxy We need a bit more testing.

Latest squid 3.3.8 builds and runs on ubuntu server 13.04.

== Troubleshooting ==

## Series of errors that may be seen. Only if unique to this OS.
##  Cross-OS errors go in Features with the relevant feature.
## Followed by a description of what it means and the solution if known.

----
CategoryKnowledgeBase SquidFaq/BinaryPackages
