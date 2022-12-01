# Squid on Windows

## Does Squid run on Windows ?

Squid can compile and run on Windows as a system service using the
[Cygwin](http://www.cygwin.com/) emulation environment, or can be
compiled in Windows native mode using the [MinGW](http://www.mingw.org/)
+ MSYS development environment. Windows NT 4 SP4 and later are
supported.

On Windows 2000 and later the service is configured to use the Windows
Service Recovery option restarting automatically after 60 seconds.

  - :information_source:
    The original development code name of the 2.5 project port was
    SquidNT, but after the 2.6.STABLE4 release, this project was
    complete. So when speaking about Squid on Windows, people should
    always refer to Squid, instead to the old SquidNT name.

### Known Limitations

  - Squid features not operational:
    
      - DISKD: still needs to be ported
    
      - Transparent Proxy: missing Windows non commercial interception
        driver
    
      - WCCP: these features have not been ported. Without transparent
        proxy support there is no need or use.
    
      - SMP support: Windows equivalent of UDS sockets has not been
        implemented

  - Some code sections can make blocking calls.

  - Some external helpers may not work.

  - File Descriptors number hard-limited to 2048 when building with
    MinGW.

  - Squid-3.x of all formal releases have major build issues.

## Pre-Built Binary Packages

Packages available for Squid on multiple environments.

### Squid-4

Maintainer: Rafael Akchurin, [Diladele B.V.](http://www.diladele.com/)

Bug Reporting: (about the installer only)
[](https://github.com/diladele/squid-windows/issues)

MSI installer packages for Windows are at:

  - 64-bit: [](http://squid.diladele.com/)

### Squid-3.3

Bug Reporting: see [](https://cygwin.com/problems.html)

Binary packages for the Cygwin environment on Windows are at:

  - 32-bit: [](https://cygwin.com/packages/x86/squid/)

  - 64-bit: [](https://cygwin.com/packages/x86_64/squid/)

# Installing Squid

## Service

Some new command line options were added for the Windows service
support:

  - **-n** switch to specify the Windows Service Name. Multiple Squid
    service instances are allowed. **Squid** is the default when the
    switch is not used. All service control operations use this switch
    to identify the destination instance being targeted.

  - **-i** switch to install the Windows service. It's possible to use
    **-f** switch at the same time to specify a different squid.conf
    file for the Squid Service that will be stored on the Windows
    Registry. To install the service, the syntax is:

<!-- end list -->

    squid -i [-f file] [-n service-name]

  - **-r** switch will uninstall the Windows service. Use the
    appropriate **-n** switch to determine which service instance is
    being removed. To uninstall the service, the syntax is:

<!-- end list -->

    squid -r [-n service-name]

  - **-k** switch is not new, but requires the use of **-n** to target
    the service instance. The syntax is:

<!-- end list -->

    squid -k command [-f file] [-n service-name]

## Command Line

To use the Squid original command line, the new **-O** switch must be
used **ONCE**, the syntax is:

    squid -O cmdline [-n service-name]

If multiple service command line options must be specified, use quote.
The **-n** switch is needed only when a non default service name is in
use.

  - :x:
    Don't use the "Start parameters" in the Windows 2000/XP/2003 Service
    applet. They are specific to Windows services functionality and
    Squid is not able to interpret and use them.

In the following example the command line of the "squidsvc" Squid
service is set to "-D -u 3130":

    squid -O "-u 3130" -n squidsvc

## Cache Manager CGI on Windows

On Windows, [cache
manager](/Features/CacheManager)
can be used with Microsoft IIS or Apache. Some specific configuration
could be needed:

  - IIS 6 (Windows 2003):
    
      - On IIS 6.0 all CGI extensions are denied by default for security
        reason, so the following configuration is needed:
        
          - Create a cgi-bin Directory
        
          - Define the cgi-bin IIS Virtual Directory with read and CGI
            execute IIS permissions, ASP scripts are not needed. This
            automatically defines a cgi-bin IIS web application
        
          - Copy cachemgr.cgi into cgi-bin directory and look to file
            permissions: the IIS system account and SYSTEM must be able
            to read and execute the file
        
          - In IIS manager go to Web Service extensions and add a new
            Web Service Extension called "Squid Cachemgr", add the
            cachemgr.cgi file and set the extension status to Allowed

  - Apache:
    
      - On Windows, cachemgr.cgi needs to create a temporary file, so
        Apache must be instructed to pass the TMP and TEMP Windows
        environment variables to CGI applications:

<!-- end list -->

    ScriptAlias /squid/cgi-bin/ "c:/squid/libexec/"
    <Location /squid/cgi-bin/cachemgr.cgi>
        PassEnv TMP TEMP
        Order allow,deny
        Allow from workstation.example.com
    </Location>

## Configuration Guides

  - [Windows
    Update](/SquidFaq/WindowsUpdate)

  - [Active Directory
    Authentication](/ConfigExamples/Authenticate/WindowsActiveDirectory)

  - [Kerberos
    Authentication](/ConfigExamples/Authenticate/Kerberos)

  - [NTLM
    Authentication](/ConfigExamples/Authenticate/Ntlm)
    ([with
    Groups](/ConfigExamples/Authenticate/NtlmWithGroups))

These and many other general manuals in the
[ConfigExamples](/ConfigExamples)
section.

## Registry DNS lookup

On Windows platforms, if no value is specified in the
[dns_nameservers](http://www.squid-cache.org/Doc/config/dns_nameservers)
option in squid.conf or in the /etc/resolv.conf file, the list of DNS
name servers are taken from the Windows registry, both static and
dynamic DHCP configurations are supported.

## Compatibility Notes

  - It's recommended to use '/' char in Squid paths instead of '\\'

  - Paths with spaces (like 'C:\\Programs Files\\Squid) are NOT
    supported by Squid

  - When using ACL like
    '[acl](http://www.squid-cache.org/Doc/config/acl) aclname acltype
    "file"' the file must be in DOS text format (CR+LF) and the full
    Windows path must be specified, for example:

<!-- end list -->

    acl blocklist dstdomain "c:/squid/etc/blocked1.txt"

  - The Windows equivalent of '/dev/null' is 'NUL'

  - Squid doesn't know how to run external helpers based on scripts,
    like .bat, .cmd, .vbs, .pl, etc. So in squid.conf the interpreter
    path must be always specified, for example:

<!-- end list -->

    url_rewrite_program c:/perl/bin/perl.exe c:/squid/libexec/redir.pl
    url_rewrite_program c:/winnt/system32/cmd.exe /C c:/squid/libexec/redir.cmd

  - When Squid runs in command line mode, the launching user account
    must have administrative privilege on the system

  - "Start parameters" in the Windows 2000/XP/2003 Service applet cannot
    be used

  - On Windows Vista and later, User Account Control (UAC) must be
    disabled before running service installation

# Compiling

  - These instructions apply to building **Squid-3.x**. Squid-2 package
    are available for download. See the

**New configure options:**

  - \--enable-win32-service

**Updated configure options:**

  - \--enable-default-hostsfile

**Unsupported configure options:**

  - \--with-large-files: No suitable build environment is available on
    both Cygwin and MinGW, but --enable-large-files works fine

## Compiling with Cygwin

  - **This section needs re-writing. Is has very little in compiling
    Squid and much about installation.**

In order to compile Squid, you need to have Cygwin fully installed.

The usage of the Cygwin environment is very similar to other Unix/Linux
environments, and -devel version of libraries must be installed.

|                                                                        |                                                                                                                                         |
| ---------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| :information_source: | Squid will by default, install into */usr/local/squid*. If you wish to install somewhere else, see the *--prefix* option for configure. |

Now, add a new Cygwin user - see the Cygwin user guide - and map it to
SYSTEM, or create a new NT user, and a matching Cygwin user and they
become the squid runas users.

Read the squid FAQ on permissions if you are using CYGWIN=ntsec.

When that has completed run:

    squid -z

If that succeeds, try:

    squid -N -D -d1

Squid should start. Check that there are no errors. If everything looks
good, try browsing through squid.

Now, configure *cygrunsrv* to run Squid as a service as the chosen
username. You may need to check permissions here.

## Compiling with MinGW

In order to compile squid using the MinGW environment, the packages
MSYS, MinGW and msysDTK must be installed. Some additional libraries and
tools must be downloaded separately:

  - OpenSSL: [Shining Light Productions Win32
    OpenSSL](http://www.slproweb.com/products/Win32OpenSSL.html)

  - libcrypt: [MinGW packages
    repository](http://sourceforge.net/projects/mingwrep/)

  - db-1.85: [TinyCOBOL download
    area](http://tiny-cobol.sourceforge.net/download.php)
    
      - :information_source:
        3.2+ releases require a newer 4.6 or later version of libdb

Before building Squid with SSL support, some operations are needed (in
the following example OpenSSL is installed in C:\\OpenSSL and MinGW in
C:\\MinGW):

  - Copy C:\\OpenSSL\\lib\\MinGW content to C:\\MinGW\\lib

  - Copy C:\\OpenSSL\\include\\openssl content to
    C:\\MinGW\\include\\openssl

  - Rename C:\\MinGW\\lib\\ssleay32.a to C:\\MinGW\\lib\\libssleay32.a

Unpack the source archive as usual and run configure.

The following are the recommended minimal options for Windows:

**Squid-3** : (requires
[Squid-3.5](/Releases/Squid-3.5)
or later, see porting efforts section below)

    --prefix=c:/squid
    --enable-default-hostsfile=none

Then run make and install as usual.

Squid will install into *c:\\squid*. If you wish to install somewhere
else, change the *--prefix* option for configure.

When that has completed run:

    squid -z

If that succeeds, try:

    squid -N -D -d1

  - squid should start. Check that there are no errors. If everything
    looks good, try browsing through squid.

Now, to run Squid as a Windows system service, run *squid -n*, this will
create a service named "Squid" with automatic startup. To start it run
*net start squid* from command line prompt or use the Services
Administrative Applet.

Always check the provided release notes for any version specific detail.

# Compiling with msys2

  - Download and install [msys2](https://www.msys2.org/)

  - download and install [Java
    JRE](https://www.oracle.com/java/technologies/javase-jre8-downloads.html)

  - download and install git

  - run:
    
      - `pacman -Syu`
    
      - `pacman -Su`
    
      - `pacman -S --needed base-devel mingw-w64-x86_64-toolchain`
    
      - `pacman -S git ed editrights cygrunsrv gcc libgnutls-devel`
    
      - enable windows' openssh optional feature
    
      - create jenins user and c:\\jenkins work dir

(work in progress)

:warning:
**End of edit conflict**

# Squid-3 porting efforts

Squid series 3 has major build issues on all Windows compiler systems.
Below is a summary of the known status for producing a useful Squid 3.x
for Windows. In a rough order of completeness as of the last page
update.

The TODO list for Windows has additional wishlist items that also need
to be sorted out:

  - Separate Windows AIOPS logics from Unix AIO logics. The two are
    currently mashed together where they should be in separate
    conditionally built library modules.

  - Windows OIO support. Alternative to Unix AIO and AIOPS disk I/O
    functionality.

  - Building an installer

## Cygwin

Cygwin has working builds and available packages sponsored by
[Diladele](http://www.diladele.com/).

## MinGW-w64

As of
[Squid-3.5](/Releases/Squid-3.5)
:

  - the default feature set builds without extra special ./configure
    options.

  - missing shared socket support available in Vista and later.
    Necessary for SMP workers.

[AmosJeffries](/AmosJeffries)
is cross-compiling with Mingw-w64 build environment on Debian, with
occasional native MinGW-w64 environment builds for confirmation of
changes. As this is spare-time work progress is slow.

  - **The cross-compiling:**

<!-- end list -->

    # Debian Packages Required:
    #
    # g++
    #       provides GCC base compiler. GCC 4.9.1 or later required.
    #
    # mingw-w64
    #       provides GCC cross-compiler. GCC 4.9.1 or later required.
    #
    # mingw-w64-tools
    #       provides pkg-config and other build-time tools used by autoconf
    #
    
    ./configure \
            --host=i686-w64-mingw32 \
            CXXFLAGS="-DWINVER=0x601 -D_WIN32_WINNT=0x601" \
            CFLAGS="-DWINVER=0x601 -D_WIN32_WINNT=0x601" \
            BUILDCXX="g++" \
            BUILDCXXFLAGS="-DFOO" \
            --enable-build-info="Windows (MinGW cross-build)"

  - This builds.

  - The squidclinet tool operates well, other helpers and tools are yet
    untested but expected to be fine.

  - The main Squid binary still lacks SMP support and will only operate
    with the **-N** command line option.
    
    **The native build:**

Requires the latest packages from
[](http://sourceforge.net/projects/mingw-w64/) with GCC 4.9 series
compiler.

    sh ./configure \
            CXXFLAGS="-DWINVER=0x601 -D_WIN32_WINNT=0x601" \
            CFLAGS="-DWINVER=0x601 -D_WIN32_WINNT=0x601" \
            --enable-build-info="Windows (MinGW-w64)"

## MinGW32

Sponsorship from iCelero produced a working
[Squid-3.2](/Releases/Squid-3.2)
and
[Squid-3.3](/Releases/Squid-3.3).
Unfortunately the product and sponsorship dropped before the final
stages of this work could be cleaned up for GPL release.

As of
[Squid-3.5](/Releases/Squid-3.5)
:

  - the default feature set builds without extra special ./configure
    options.

  - missing shared socket support available in Vista and later.
    Necessary for SMP workers.

<!-- end list -->

    ./configure \
            CXXFLAGS="-DWINVER=0x601 -D_WIN32_WINNT=0x601" \
            CFLAGS="-DWINVER=0x601 -D_WIN32_WINNT=0x601" \
            --enable-build-info="Windows (MinGW32)"

  - This builds for
    [Squid-3.5](/Releases/Squid-3.5)
    but not later code. A newer GCC version than supplied with
    [MingW32](/MingW32)
    is required.

  - The main Squid binary still lacks SMP support and will only operate
    with the **-N** command line option.

There also appears to be some work done by Joe Pelaez Jorge
([](https://code.launchpad.net/~joelpelaez/squid/win32)).

## Visual Studio

Almost no work on this environment has been done since
[Squid-2.7](/Releases/Squid-2.7).

Entirely new .sln, .sdf and .vcxproj build files need to be generated.
Ideally these would mirror the on-Windows style of convenience libraries
assembled to produce a number of different binaries. Experiments along
those lines have some nice results.

# Troubleshooting

[CategoryKnowledgeBase](/CategoryKnowledgeBase)
