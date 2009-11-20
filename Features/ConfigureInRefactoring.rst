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
 1. available libraries
 1. available headers
 1. available types
 1. structures
 1. other stuff

RobertCollins suggests to also include making use of [[https://edge.launchpad.net/pandora-build|Pandora Build]], a set of cross-project and cross-system configuration resources.

----
CategoryFeature
