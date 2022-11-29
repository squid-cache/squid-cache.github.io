# Feature: Refactor configure.in

  - **Goal**: configure.in has grown in time into a big messy bundle,
    making it very hard to act on it in a sensible manner. It needs to
    be reduced to something sane again.

  - **Status**: complete

  - **Version**: 3.2

  - **Developer**:
    [FrancescoChemolli](/FrancescoChemolli)

  - **More**:
    [](https://code.launchpad.net/~kinkie/squid/autoconf-refactor)

# Details

In order to more easily drive the push on code cleanliness and
portability, it's also important that the infrastructure allowing to
detect the build environment be clean and extensible. Sadly, the current
configure.in is not. It would be useful to refactor and comment it,
dividing it in sections, with this tentative order (see
[](http://www.gnu.org/software/autoconf/manual/autoconf.html#Autoconf-Input-Layout)):

1.  auxiliary software available on the host system (including cc)

2.  system-dependent variations and parameters on said software

3.  configure arguments handling

4.  available libraries

5.  available headers

6.  available types

7.  structures

8.  other stuff

[RobertCollins](/RobertCollins)
suggests to also include making use of [Pandora
Build](https://edge.launchpad.net/pandora-build), a set of cross-project
and cross-system configuration resources.

[AmosJeffries](/AmosJeffries)
has investigated Pandora and found most of the tools very python and
ruby centric. There are few macros provided we can use without some
makeover to make them portable enough to use on the systems Squid builds
on.

## Overview

In order to further modularize configure.in it would be useful to split
some helper definition files out of configure.in itself, to an included
set modular files. Those file will be defined as `acinclude/*.m4`, and
included from configure.in AFTER autoconf's initialization.

## Changes to configure process and parameters

Authentication was simplified, and now it is based on (hopefully
clearer) configure options:

  - \--disable-auth
    
      - global switch. Disables authentication support altogether

  - \--enable-auth-*scheme*
    
      - enables auth scheme *scheme* (all are enabled by default).
        Without arguments, will also build all helpers that can be built
        on the build-hosts. Otherwise a space-separated or
        comma-separated list of helpers can be supplied, or the special
        value `none` which means to enable the scheme but build no
        helpers. Force-enabling any auth-scheme when the global support
        is off will cause a configure-time error.

Interception proxying has been changed to auto-enabled-if-available for
those platforms which are known to work.

## Namespaces and naming conventions

Custom macros will have as their name structured as
`SQUID_<COMPONENT>_<ACTION>_<OBJECTIVE>` where

  - COMPONENT is the target component to be checked (e.g. CC, CXX, OS
    ...)

  - ACTION can be one of:
    
    1.  CHECK
    
    2.  GUESS

  - OBJECTIVE is a variable string, detailing the purpose of the test

Variable names can fall in different categories:

1.  Test output variables: `$squid_[cv_]test_objective_in_lowercase`

2.  Variables holding configure options: `$squid_opt_optionname`

3.  Variables to be substituted in Makefile.am's etc.: `ALL_UPPERCASE`
    (and try to avoid clashes
    ![;)](https://wiki.squid-cache.org/wiki/squidtheme/img/smile4.png) )

## Documentation for extra macros and available variables

### Variables defined at the beginning of the process

  - $squid_host_os  
    a simplified version of `$host_os`, it only contains the operating
    system name, *without* the version number. In general, the most
    known values are: *linux-gnu*, *solaris*, *mingw*, *cygwin*, *irix*

  - $squid_host_os_version  
    the version number extracted from `$host_os`. On MS-Windows it MAY
    be *32*, but it should in general be ignored.

### Extra available Macros

  - SQUID_STATE_SAVE(state_name_prefix(\[,extra_vars_list\])  
    checkpoints all relevant autoconf status variables (CFLAGS, LDFLAGS,
    etc.) in preparation of invasive checks. *state_name_prefix* must
    be suitable as a shell variable name. Extra variables to be saved
    may be specified, as a whitespace_separated variable names list.

  - SQUID_STATE_COMMIT(state_name_prefix)  
    commits the changes saved since the last call to SQUID_STATE_SAVE,
    and deletes the associated temporary storage variables.

  - SQUID_STATE_ROLLBACK(state_name_prefix)  
    reverts the autoconf state changes since the last call to
    SQUID_STATE_SAVE with the same prefix, and frees temporary
    storage. It is not necessary to specify the extra variables passed
    when saving state, they are retained automatically.

  - SQUID_LOOK_FOR_MODULES(base_dir,var_name)  
    fills in `$var_name` with the whitespace-separated list of the
    subdirs of base_dir containing modules.

  - SQUID_CLEANUP_MODULES_LIST(var_name)  
    removes duplicates from the modules list contained in `$var_name`.
    Modifies the variable in place.

  - SQUID_CHECK_EXISTING_MODULES(base_dir,var_name)  
    checks that all modules in the whitespace-separated list of modules
    `$var_name` are actually modules contained in the base directory
    `base_dir`. Aborts configuration in case of error. For each module,
    also sets the variable `$var_name_modulename` to 'yes'.

<!-- end list -->

    Example:
    iomodules="disk net"
    modules_basedir="$srcdir/src/io_mods"
    SQUID_CHECK_EXISTING_MODULES($modules_basedir,[iomodules])
    
    will:
    1. check that $srcdir/src/io_mods/disk and $srcdir/src/io_mods/net
       exist and are directories, abort if they're not
    2. set iomodules_disk and iomodules_net to "yes"

  - SQUID_TOLOWER_VAR_CONTENTS(varname)  
    lowercases $varname's contents

  - SQUID_TOUPPER_VAR_CONTENTS(varname)  
    uppercases $varname's contents

  - SQUID_CC_CHECK_ARGUMENT(varname,flag)  
    tests whether the compiler can handle the supplied flag. Sets
    `$varname` to either "yes" or "no"

  - SQUID_DEFINE_BOOL(define_name,$shell_variable,define_comment)  
    define a C(++) preprocessor macro `define_name` with comment
    `define_comment` using the expansion of `$shell_variable` to assign
    a value: it will be set to 0 if the variable expands to an empty
    string, 0 , false, or no; 1 if it expands to true, yes or 1; will
    abort in all other cases.

  - SQUID_YESNO($variable)  
    aborts unless the variable expansion is either "yes" or "no". It is
    mostly useful as an input validator for the AC_ARG_ENABLE and
    AC_ARG_WITH macros.

There more specific tests, checks and guesses performed by specific
macros; their definitions have been moved to the `acinclude/` directory
off the source tree root (and have to be explicitly included at the
beginning of configure.in). All of them are documented in purpose and
side effects; the source is the most comprehensive documentation for
them

## Other stuff to be improved

1.  Trunk currently fails to build with linking errors if CFLAGS and
    CXXFLAGS are set as configure argument. The reason for this will
    have to be found and fixed.

2.  Helper modules require, in order to be built, that a helper-specific
    testlet be passed successfully. Those testlets are shell scripts
    which perform autoconf-like functions, but without the
    infrastructure. As a result, they lack flexibility and effectiveness
    in reporting the reasons for failure. They should be reworked to be
    configure.in scripts to gain those advantages.

3.  AC_CONDITIONAL macors should use in a more uniform manner
    ENABLE_FOO

4.  the complication setting $ECAP_LIBS to ecap/libecap.la can be
    replaced by the automake "if USE_ECAP" conditional to build and
    link the ecap subdir library in src/adaptation/Makefile.am instead
    of configure.

5.  same for $ICAP_LIBS

6.  wrapping of the auth libraries build+link in the ENABLE_AUTH_\*

## Other random thoughts

On March 31st 2010, [Eric S. Raymond](http://www.catb.org/~esr/)
[ranted](http://esr.ibiblio.org/?p=1877) against autotools. This sparked
an interesting debate over cross-platform build tools. During the
discussion, some alternatives to autotools were mentioned:

  - [SCons](http://www.scons.org/) seemed to get the most positive
    comments

  - [gyp](http://code.google.com/p/gyp/)

  - [cmake](http://www.cmake.org/) is the most entrenched alternative

Squid's configure.in is very complex. Once refactored, it would be
interesting to see if any of the alternatives offers substantial
benefits, and possibly port over to it.

[CategoryFeature](/CategoryFeature)
