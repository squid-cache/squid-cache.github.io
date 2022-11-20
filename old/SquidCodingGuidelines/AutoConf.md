  - Back to
    [SquidCodingGuidelines](/SquidCodingGuidelines).

  - Back to
    [DeveloperResources](/DeveloperResources).

# Autoconf Syntax Guidelines

The current standard for both **--enable** and **--with** flags is:

  - **yes** means force-enable, fail the build if not possible.

  - **no** means force-disable,

  - **auto** means try to enable, disable if some required part is not
    available.

For **--with** flags, everything else is usually considered as a path to
be used. Though in some cases is a global constant.

For **--enable** flags, may contain a list of the components modular
pieces to be enabled. In which case:

  - being listed means force-enable

  - being omitted means force-disable

For further details on autoconf macros and conventions, also see
[Features/ConfigureInRefactoring](/Features/ConfigureInRefactoring)

## Component Macros in Autoconf

Squid uses autoconf defined macros to eliminate experimental or optional
components at build time.

  - name for variables passed to automake code should start with
    ENABLE\_

  - name for build/no-build variables passed to C++ code should start
    with USE\_

  - name for variables passed to either automake or C++ containing
    default values should start with DEFAULT\_
    
    ⚠️
    In the event of a clash or potential clash with system variables
    tack SQUID\_ after the above prefix. ie ENABLE\_SQUID\_ or
    USE\_SQUID\_

<!-- end list -->

    # For --enable-foo / --disable-foo
    
    AC_CONDITIONAL([ENABLE_FOO],[test "x${enable_foo:=yes}" = "xyes"])
    
    SQUID_DEFINE_BOOL(USE_FOO,${enable_foo:=no},[Whether to enable foo.])
    
    DEFAULT_FOO_MAGIC="magic"
    AC_SUBST(DEFAULT_FOO_MAGIC)
