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

 * '''Status''': ''Started''

## Remove this entry once the feature has been merged into trunk.
##  it will then be auto-listed in the RoadMap completed features for its Version
 * '''ETA''': 1 week

 * '''Version''': 3.2

 * '''Priority''': 4

 * '''Developer''': FrancescoChemolli

 * '''More''':  https://code.launchpad.net/~kinkie/squid/autoconf-refactor


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

AmosJeffries has investigated Pandora and found most of the tools very python and ruby centric. There are few macros provided we can use without some makeover to make them portable enough to use on the systems Squid builds on.

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

== Documentation for extra macros and available variables ==

=== Variables defined at the beginning of the process ===
 $squid_host_os :: a simplified version of {{{$host_os}}}, it only contains the operating system name, ''without'' the version number. In general, the most known values are: ''linux-gnu'', ''solaris'', ''mingw'', ''cygwin'', ''irix''
 $squid_host_os_version :: the version number extracted from {{{$host_os}}}. On MS-Windows it MAY be ''32'', but it should in general be ignored.

=== Extra available Macros ===
 SQUID_STATE_SAVE(state_name_prefix([,extra_vars_list]) :: checkpoints all relevant autoconf status variables (CFLAGS, LDFLAGS, etc.) in preparation of invasive checks. ''state_name_prefix'' must be suitable as a shell variable name. Extra variables to be saved may be specified, as a whitespace_separated variable names list.
 SQUID_STATE_COMMIT(state_name_prefix) :: commits the changes saved since the last call to SQUID_STATE_SAVE, and deletes the associated temporary storage variables.
 SQUID_STATE_ROLLBACK(state_name_prefix) :: reverts the autoconf state changes since the last call to SQUID_STATE_SAVE with the same prefix, and frees temporary storage. It is not necessary to specify the extra variables passed when saving state, they are retained automatically.
 SQUID_LOOK_FOR_MODULES(base_dir,var_name) :: fills in {{{$var_name}}} with the whitespace-separated list of the subdirs of base_dir containing modules.
 SQUID_CLEANUP_MODULES_LIST(var_name) :: removes duplicates from the modules list contained in {{{$var_name}}}. Modifies the variable in place.
 SQUID_CHECK_EXISTING_MODULES(base_dir,var_name) :: checks that all modules in the whitespace-separated list of modules {{{$var_name}}} are actually modules contained in the base directory {{{base_dir}}}. Aborts configuration in case of error. For each module, also sets the variable {{{$var_name_modulename}}} to 'yes'.
{{{
Example:
iomodules="disk net"
modules_basedir="$srcdir/src/io_mods"
SQUID_CHECK_EXISTING_MODULES($modules_basedir,[iomodules])

will:
1. check that $srcdir/src/io_mods/disk and $srcdir/src/io_mods/net
   exist and are directories, abort if they're not
2. set iomodules_disk and iomodules_net to "yes"
}}}
 SQUID_TOLOWER_VAR_CONTENTS(varname) :: lowercases $varname's contents
 SQUID_TOUPPER_VAR_CONTENTS(varname) :: uppercases $varname's contents
 SQUID_CC_CHECK_ARGUMENT(varname,flag) :: tests whether the compiler can handle the supplied flag. Sets {{{$varname}}} to either "yes" or "no"
 SQUID_CXX_CHECK_ARG_FHUGEOBJECTS :: checks that the c++ compiler can handle the -fhuge-objects flag
 SQUID_CC_GUESS_VARIANT :: checks what compiler the user is using. See the function definition for the list of detected compilers
 SQUID_CC_GUESS_OPTIONS :: guesses the options accepted by the compiler to activat certain behaviours; sets ''$squid_cv_cc_option_werror'', ''$squid_cv_cc_option_wall'', ''$squid_cv_cc_option_optimize'', ''$squid_cv_cc_arg_pipe'' (variable names are gcc-inspired)

== Other stuff to be fixed ==

 1. Trunk currently fails to build with linking errors if CFLAGS and CXXFLAGS are set as configure argument. The reason for this will have to be found and fixed.
 1. Helper modules require, in order to be built, that a helper-specific testlet be passed successfully. Those testlets are shell scripts which perform autoconf-like functions, but without the infrastructure. As a result, they lack flexibility and effectiveness in reporting the reasons for failure. They need to be reworked to be configure.in scripts to gain those advantages.


----
CategoryFeature
