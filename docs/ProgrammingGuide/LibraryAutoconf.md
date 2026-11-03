---
---
# Autoconf Library Detection guideline

*This page is a work in progress. The autoconf template documented here
is still evolving and when stable will be turned into a macro.*

## Overview of Behaviour

Each library depended on by Squid should have an **AC_WITH()** macro
defined to permit user disabling, requirement, or replacement of the
library. Squid should be capable of quicky detecting the libraries
absence and

* When the user explicitly specifies `--with-foo` the libraries absence
is a fatal error.
* When the user specifies `--with-foo=PATH` the library shall be
detected at the specified path.
* When the user specifies `--without-foo` no tests for the library
will be performed, nor will it be used by Squid.
* When the library is absent API feature tests, hacks and workarounds
for the library should not be searched for. This reduces the time
./configure spends performing useless operations.

## Piece 1: AC_ARG_WITH()

Use this autoconf provided macro to setup path locations and with_\*
variables for the library.

```bash
    AC_ARG_WITH(foo,
      AS_HELP_STRING([--without-foo],
                     [Do not use Foo. Default: auto-detect]), [
    case "$with_foo" in
      yes|no)
        : # Nothing special to do here
        ;;
      *)
        if test ! -d "$withval" ; then
          AC_MSG_ERROR([--with-foo path does not point to a directory])
        fi
        LIBFOO_PATH="-L$with_foo/lib"
        CXXFLAGS="-I$with_foo/include $CXXFLAGS"
      esac
    ])
    AH_TEMPLATE(USE_FOO,[Foo support is available])
```

## Piece 2: Library need check
```bash
    if test "x$with_foo" != "xno"; then
      SQUID_STATE_SAVE(squid_foo_state)
      LIBS="$LIBS $LIBFOO_PATH"
```
**Piece \#3 and \#4 goes in here**

```bash
  SQUID_STATE_ROLLBACK(squid_foo_state)

  if test "x$with_foo" = "xyes" -a "x$LIBFOO_LIBS" = "x"; then
    AC_MSG_ERROR([Required Foo library not found])
  fi
  if test "x$LIBFOO_LIBS" != "x" ; then
    CXXFLAGS="$LIBFOO_CFLAGS $CXXFLAGS"
    FOOLIB="$LIBFOO_PATH $LIBFOO_LIBS"
    AC_DEFINE(USE_FOO,1,[Foo support is available])
    with_foo=yes
  else
    with_foo=no
  fi
fi
AC_MSG_NOTICE([Foo library support: ${with_foo:=auto} ${LIBFOO_PATH} ${LIBFOO_LIBS}])
AC_SUBST(FOOLIB)
```

- Note the absence of AC_CONDITIONAL to setup ENABLE_FOO. If a major
    feature requires library foo then it should base its determination
    on the setting in `$with_foo` only **after** these library tests
    have been performed and set $with_foo to one of yes/no.

## Piece 3: pkg-config and file detections

Prefer the use of pkg-config to locate library parameters. When provided
by the library author they are updated automatically if the build
parameters change, and can also do library version detection more
accurately.

The PKG_CHECK_MODULES macro creates the local variables
**LIBFOO_CFLAGS** and **LIBFOO_LIBS** necessary to build against the
library.

- Note that the users custom path (if any) is already provided in
    **CXXFLAGS** and **LIBS**.
- Note that any changes to the regular \*FLAGS or LIBS build variables
    will be reverted when this check state is rolled back. If necessary
    the backup detection logics should re-use the pkg-config variables
    so they can be setup only for binaries using this library.

An example of how to use PKG_CHECK_MODULES:

``` bash
  # auto-detect using pkg-config
  PKG_CHECK_MODULES([LIBFOO],[foo >= 1.0.0],,[

    ## something went wrong.
    ## try to find the package without pkg-config

    ## check that the library is actually new enough.
    ## by testing for a 1.0.0+ function which we use
    AC_CHECK_LIB(foo,foo_10_function,[LIBFOO_LIBS="-lfoo"])
  ])
```

## Piece 4: header detection

Check for the library header includes separately.

This is required as a side effect of the Squid requiremet for
HAVE_FOO_H wrapper definitions. The pkg-config tool does not check for
them automatically and it makes no sense to do them twice for both its
success and failure actions.

``` bash
  if test "x$LIBFOO_LIBS" != "x" ; then
    AC_CHECK_HEADERS(foo.h)
  fi
```

## Makefile.am

Each binary that uses library Foo should include `  $(FOOLIB)  ` in its
LDADD declaration **following** the libcompat.la entry and will be
linked when relevant.

> :information_source:
    for ease of maintenance these FOOLIB LDADD entries should be
    alphabetical.
