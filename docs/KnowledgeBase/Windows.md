---
categories: KnowledgeBase
---
# Squid on Windows

## Does Squid run on Windows ?

Squid can compile and run on Windows as a system service using the
[Cygwin](http://www.cygwin.com/) emulation environment, or can be
compiled in Windows native mode using the [MinGW + MSYS](http://www.mingw.org/)
development environment. All modern Windows versions are supported

> :information_source:
    The original development code name of the 2.5 project port was
    SquidNT, but after the 2.6.STABLE4 release, this project was
    complete. So when speaking about Squid on Windows, people should
    always refer to Squid, instead to the old SquidNT name.

## Known Limitations

### Unavailable features

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

## Pre-Built Binary Packages

Packages available for Squid on multiple environments.

### Squid-4

Maintainer: Rafael Akchurin, [Diladele B.V.](http://www.diladele.com/)

Bug Reporting: (about the installer only)
<https://github.com/diladele/squid-windows/issues>

MSI installer packages for Windows are at:

  - 64-bit: <http://squid.diladele.com/>

### Squid-3.3

Bug Reporting: see <https://cygwin.com/problems.html>

Binary packages for the Cygwin environment on Windows are at:

- 32-bit: <https://cygwin.com/packages/x86/squid/>
- 64-bit: <https://cygwin.com/packages/x86_64/squid/>

# Installing Squid

## Installing with Cygwin

The usage of the Cygwin environment is very similar to other Unix/Linux
environments, and -devel version of libraries must be installed.

> :information_source:
    Squid will by default, install into */usr/local/squid*.
    If you wish to install somewhere else, see
    the *--prefix* option for configure when building

Now, add a new Cygwin user (see the Cygwin user guide) and map it to
`SYSTEM`, or create a new NT user, and a matching Cygwin user and they
become the `squid` runas users.

Read the squid FAQ on permissions if you are using `CYGWIN=ntsec`.

Now, configure *cygrunsrv* to run Squid as a service as the chosen
username. You may need to check permissions here.

## Service

Command line options for the Windows service support:

- **-n** switch to specify the Windows Service Name. Multiple Squid
    service instances are allowed. **Squid** is the default when the
    switch is not used. All service control operations use this switch
    to identify the destination instance being targeted.
- **-i** switch to install the Windows service. It's possible to use
    **-f** switch at the same time to specify a different squid.conf
    file for the Squid Service that will be stored on the Windows
    Registry. To install the service, the syntax is:

        squid -i [-f file] [-n service-name]

- **-r** switch will uninstall the Windows service. Use the
    appropriate **-n** switch to determine which service instance is
    being removed. To uninstall the service, the syntax is:

        squid -r [-n service-name]

- **-k** switch is not new, but requires the use of **-n** to target
    the service instance. The syntax is:

        squid -k command [-f file] [-n service-name]

## Command Line

To use the Squid original command line, the new **-O** switch must be
used **ONCE**, the syntax is:

    squid -O cmdline [-n service-name]

If multiple service command line options must be specified, use quote.
The **-n** switch is needed only when a non default service name is in
use.

> :x:
    Do not use the "Start parameters" in the Windows 2000/XP/2003 Service
    applet. They are specific to Windows services functionality and
    Squid is not able to interpret and use them.

In the following example the command line of the "squidsvc" Squid
service is set to "-D -u 3130":

    squid -O "-u 3130" -n squidsvc

## Cache Manager CGI on Windows

On Windows, [cache manager](/Features/CacheManager)
can be used with Microsoft IIS or Apache. Some specific configuration
could be needed:

- **IIS 6** (Windows 2003):
    - On IIS 6.0 all CGI extensions are denied by default for security,
        so the following configuration is needed:
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

- **Apache**:
    On Windows, cachemgr.cgi needs to create a temporary file, so
    Apache must be instructed to pass the TMP and TEMP Windows
    environment variables to CGI applications:

        ScriptAlias /squid/cgi-bin/ "c:/squid/libexec/"
        <Location /squid/cgi-bin/cachemgr.cgi>
            PassEnv TMP TEMP
            Order allow,deny
            Allow from workstation.example.com
        </Location>

## Configuration Guides

- [Windows Update](/SquidFaq/WindowsUpdate)
- [Active Directory Authentication](/ConfigExamples/Authenticate/WindowsActiveDirectory)
- [Kerberos Authentication](/ConfigExamples/Authenticate/Kerberos)
- [NTLM Authentication](/ConfigExamples/Authenticate/Ntlm)
These and many other general manuals in the [ConfigExamples](/ConfigExamples)
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
    '[acl](http://www.squid-cache.org/Doc/config/acl) aclname acltype "file"'
    the file must be in DOS text format (CR+LF) and the full
    Windows path must be specified, for example:

        acl blocklist dstdomain "c:/squid/etc/blocked1.txt"

- The Windows equivalent of '/dev/null' is 'NUL'
- Squid doesn't know how to run external helpers based on scripts,
    like .bat, .cmd, .vbs, .pl, etc. So in squid.conf the interpreter
    path must be always specified, for example:

        url_rewrite_program c:/perl/bin/perl.exe c:/squid/libexec/redir.pl
        url_rewrite_program c:/winnt/system32/cmd.exe /C c:/squid/libexec/redir.cmd

- When Squid runs in command line mode, the launching user account
    must have administrative privilege on the system
- "Start parameters" in the Windows 2000/XP/2003 Service applet cannot
    be used
- On Windows Vista and later, User Account Control (UAC) must be
    disabled before running service installation

## Compiling

**configure options**

* --enable-win32-service
* --enable-default-hostsfile

**Unsupported configure options:**

* --with-large-files: No suitable build environment is available on
    both Cygwin and MinGW, but --enable-large-files works fine

## Compiling with Cygwin

In order to compile Squid, you need to have Cygwin fully installed.

The usage of the Cygwin environment is very similar to other Unix/Linux
environments, and -devel version of libraries must be installed.

## Compiling with MinGW

Requires the latest packages from <https://osdn.net/projects/mingw/> with GCC 8 or later compiler.

> :warning:
    This section needs re-writing. This environment has not successfully built since [Squid-3.4](Releases/Squid-3.4).

In order to compile squid using the MinGW environment, the packages
MSYS, MinGW and msysDTK must be installed. Some additional libraries and
tools must be downloaded separately:

- OpenSSL: [Shining Light Productions Win32 OpenSSL](http://www.slproweb.com/products/Win32OpenSSL.html)
- libcrypt: [MinGW packages repository](http://sourceforge.net/projects/mingwrep/)
- db-1.85: [TinyCOBOL download area](http://tiny-cobol.sourceforge.net/download.php)
    > :information_source:
        3.2+ releases require a newer 4.6 or later version of libdb

Before building Squid with SSL support, some operations are needed (in
the following example OpenSSL is installed in C:\\OpenSSL and MinGW in
C:\\MinGW):

- Copy C:\\OpenSSL\\lib\\MinGW content to C:\\MinGW\\lib
- Copy C:\\OpenSSL\\include\\openssl content to
    C:\\MinGW\\include\\openssl
- Rename C:\\MinGW\\lib\\ssleay32.a to C:\\MinGW\\lib\\libssleay32.a

Unpack the source archive as usual and run:

```bash
    ./configure \
        --enable-build-info="Windows (MinGW32)" \
        --prefix=c:/squid \
        --enable-default-hostsfile=none

    make check && make install
```

Squid will install into *c:\\squid*. If you wish to install somewhere
else, change the *--prefix* option for configure.

Now, to run Squid as a Windows system service, run *squid -n*, this will
create a service named "Squid" with automatic startup. To start it run
*net start squid* from command line prompt or use the Services
Administrative Applet.

Always check the provided release notes for any version specific detail.

## Compiling with msys2

> :x: to be completed


# Porting efforts

Squid series 3+ have major build issues on all Windows compiler systems.
Below is a summary of the known status for producing a useful Squid
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

Issues:
- missing shared socket support available in Vista and later.
    Necessary for SMP workers.
- The main Squid binary still lacks SMP support and will only operate
    with the **-N** command line option.

## Cygwin

Cygwin has working [Squid-4](Releases/Squid-4) builds and available packages sponsored by
[Diladele](http://www.diladele.com/).

## MinGW-w64

Currently the spare-time focus of porting efforts by the Squid developer team.
Latest cross-compilation results at <https://build.squid-cache.org/job/trunk-mingw-cross/>.
As this is spare-time work progress is slow.

**cross-compiling:**
```bash
    # Debian Packages Required:
    #
    # g++
    #       provides GCC base compiler. GCC 8 or later required.
    #
    # mingw-w64
    #       provides GCC cross-compiler. GCC 8 or later required.
    #
    # mingw-w64-tools
    #       provides pkg-config and other build-time tools used by autoconf
    #

    ./configure \
            --host=x86_64-w64-mingw32 \
            BUILDCXX="g++" \
            BUILDCXXFLAGS="-DFOO" \
            --enable-build-info="Windows (MinGW-w64 cross-build)"
```

**Native build:**

> :x:  No work on this environment has been done since [Squid-3.3](/Releases/Squid-3.3):

Requires the latest packages from <http://sourceforge.net/projects/mingw-w64/> with GCC 8 or later compiler.

```bash
    sh ./configure \
        --enable-build-info="Windows (MinGW-w64)"
```

## MinGW32

> :x:  Almost no work on this environment has been done since [Squid-3.5](/Releases/Squid-3.5):

There also appears to be some work done by Joe Pelaez Jorge
(<https://code.launchpad.net/~joelpelaez/squid/win32>).

## Visual Studio

> :x:  Almost no work on this environment has been done since [Squid-2.7](/Releases/Squid-2.7).

Entirely new .sln, .sdf and .vcxproj build files need to be generated.
Ideally these would mirror the on-Windows style of convenience libraries
assembled to produce a number of different binaries. Experiments along
those lines have some nice results.
