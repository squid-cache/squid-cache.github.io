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

## by Adam W. Dace.

Squid compiles on Mac OS X.  However, there are some steps required before following the general build instructions.

 * '''Install Xcode'''
  1. From Mac OS X, run the "!AppStore" application.
  2. Locate "Xcode", Apple's development environment.
  3. Install "Xcode".

 * '''Install Command-Line Tools'''
  1. Launch "Xcode".
  2. Open "Xcode | Preferences".
  3. Bring up the "Downloads" tab.
  4. Under "Components" click the "Install" button for "Command Line Tools".
  5. Quit Xcode.

 * '''Verify Command-Line Tools'''
  1. Launch "Terminal", usually located in the "Utilities" folder under "Applications".
  2. Run "gcc --version".  Manually verify this produces sane output.

From this point, the [[SquidFaq/CompilingSquid#How_do_I_compile_Squid.3F|general build instructions]] should be all you need.


 . /!\ It is worth noting this platform doesn't support EUI. The --enable-eui ./configure will cause build errors.


## Followed by any special patching needed.
## Please inform upstream so we can simplify this to a configure option and obsolete the patching

== Troubleshooting ==

## Series of errors that may be seen. Only if unique to this OS.
##  Cross-OS errors go in Features with the relevant feature.
## Followed by a description of what it means and the solution if known.

----
CategoryKnowledgeBase SquidFaq/BinaryPackages
