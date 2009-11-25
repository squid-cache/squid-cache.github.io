##master-page:Features/FeatureTemplate
#format wiki
#language en
##
## Change to 'yes' for a listing under Features in the Squid FAQ.
#faqlisted no

## This is a Feature documentation template. Remove this comment and replace  placeholder questions with the actual information about the feature.

= Feature: Refactor configure.in =

## Move this down into the details documentation when feature is complete.
 * '''Goal''': configure.in has grown in time into a big messy bundle, making it very hard to act on it in a sensible manner. It needs to be reduced to something sane again.

 * '''Status''': ''Not started''

## Remove this entry once the feature has been merged into trunk.
##  it will then be auto-listed in the RoadMap completed features for its Version
 * '''ETA''': 1 week

 * '''Version''': 3.2

 * '''Priority''': 4

 * '''Developer''': FrancescoChemolli

 * '''More''': 


= Details =

In order to more easily drive the push on code cleanliness and portability, it's also important that the infrastructure allowing to detect the build environment be clean and extendable. Sadly, the current configure.in is not.
It would be useful to refactor and comment it, dividing it in sections, with this tentative order (see [[http://www.gnu.org/software/autoconf/manual/autoconf.html#Autoconf-Input-Layout]]):

 1. auxiliary software available on the host system (including cc)
 1. system-dependent variations and parameters on said software
 1. configure arguments handling
 1. available libraries
 1. available headers
 1. available types
 1. structures
 1. other stuff

RobertCollins suggests to also include making use of [[https://edge.launchpad.net/pandora-build|Pandora Build]], a set of cross-project and cross-system configuration resources.

== Overview ==
In order to further modularize configure.in it would be useful to split some helper definition files out of configure.in itself, to an included set modular files.
Those file will be defined as {{{acinclude/*.m4}}}, and included from configure.in AFTER autoconf's initialization.

== Namespaces and naming conventions ==

Custom macros will have as their name structured as {{{SQUID_<COMPONENT>_<ACTION>_<OBJECTIVE>}}} where
 . COMPONENT is the target component to be checked (e.g. CC, CXX, OS ...)
 . ACTION can be one of: 
   1. CHECK
     :: test whether something is present or working. The expected result to be deposited in a variable is "yes" or "no
   1. GUESS
     :: try to determine a parameter or path. The expected result is a multiple-selection value, with "none" used as a "can't find/determine" output. The possible output values MUST be documented in the macro header.
 . OBJECTIVE is a variable string, detailing the purpose of the test

Variable names can fall in different categories:
 1. Test output variables: {{{$squid_[cv_]test_objective_in_lowercase}}}
 1. Variables holding configure options: {{{$squid_opt_optionname}}}
  :: they are multi-valued, containing "yes" (want, build fail if can't build), "no" (absolutely don't want) or "auto"(yes if available, detect)
  :: whatever the user-visible option (enable/disable), these variables should not be in the negative. default-handling is to be handled as part of the option processing.
 1. Variables to be substituted in Makefile.am's etc.: {{{ALL_UPPERCASE}}} (and try to avoid clashes ;) )



----
CategoryFeature
