##master-page:KnowledgeBaseTemplate
#format wiki
#language en

= Squid on Windows =

<<TableOfContents>>

== Does Squid run on Windows ? ==

Squid can compile and run on Windows as a system service using the [[http://www.cygwin.com/|Cygwin]] emulation environment, or can be compiled in Windows native mode using the [[http://www.mingw.org/|MinGW]] + MSYS development environment. Windows NT 4 SP4 and later are supported.

On Windows 2000 and later the service is configured to use the Windows Service Recovery option restarting automatically after 60 seconds.

 {i} The original development code name of the 2.5 project port was SquidNT, but after the 2.6.STABLE4 release, this project was complete. So when speaking about Squid on Windows, people should always refer to Squid, instead to the old SquidNT name.   

== Pre-Built Binary Packages ==

GuidoSerassio of [[http://www.acmeconsulting.it/|Acme Consulting S.r.l.]] maintains the official [[http://squid.acmeconsulting.it/|native Windows port]] of Squid (built using the Microsoft toolchain) and is actively working on having the needed changes integrated into the standard Squid distribution. His effort is partially based on earlier Windows NT port by Romeo Anghelache.

 . '''Squid-2.6, Squid-2.7, Squid-3.0:''' Binaries for Windows NT/2000/XP/2003 are at http://squid.acmeconsulting.it/

== Installing Squid ==

=== Service ===
Some new command line options were added for the Windows service support:

 * '''-n''' switch to specify the Windows Service Name. Multiple Squid service instances are allowed. "Squid" is the default when the switch is not used. All service control operations use this switch to identify the destination instance being targeted.

 * '''-i''' switch to install the Windows service. It's possible to use -f switch at the same time to specify a different squid.conf file for the Squid Service that will be stored on the Windows Registry. To install the service, the syntax is:
{{{
squid -i [-f file] [-n service-name]
}}}

 * '''-r''' switch will uninstall the Windows service. Use the appropriate -n switch to determine which service instance is being removed. To uninstall the service, the syntax is:
{{{
squid -r [-n service-name]
}}}

 * '''-k''' switch is not new, but requires the use of '''-n''' to target the service instance. The syntax is:
{{{
squid -k command [-f file] [-n service-name]
}}}

=== Command Line ===
To use the Squid original command line, the new '''-O''' switch must be used '''ONCE''', the syntax is:
{{{
squid -O cmdline [-n service-name]
}}}

If multiple service command line options must be specified, use quote. The '''-n''' switch is needed only when a non default service name is in use.

Don't use the "Start parameters" in the Windows 2000/XP/2003 Service applet: they are specific to Windows services functionality and Squid is not able to interpret and use them.

In the following example the command line of the "squidsvc" Squid service is set to "-D -u 3130":

squid -O "-u 3130" -n squidsvc


3.7 Using cache manager on Windows:

On Windows, cache manager ('''[[http://www.squid-cache.org/Versions/v3/3.HEAD/manuals/cachemgr.cgi|cachemgr.cgi]]''') can be used with Microsoft IIS or Apache.
Some specific configuration could be needed:

 * IIS 6 (Windows 2003):
  * On IIS 6.0 all CGI extensions are denied by default for security reason, so the following configuration is needed:
   * Create a cgi-bin Directory
   * Define the cgi-bin IIS Virtual Directory with read and CGI execute IIS permissions, ASP scripts are not needed. This automatically defines a cgi-bin IIS web application
   * Copy cachemgr.cgi into cgi-bin directory and look to file permissions: the IIS system account and SYSTEM must be able to read and execute the file
   * In IIS manager go to Web Service extensions and add a new Web Service Extension called "Squid Cachemgr", add the cachemgr.cgi file and set the extension status to Allowed
 * Apache:
  * On Windows, cachemgr.cgi needs to create a temporary file, so Apache must be instructed to pass the TMP and TEMP Windows environment variables to CGI applications:
{{{
ScriptAlias /squid/cgi-bin/ "c:/squid/libexec/"
<Location /squid/cgi-bin/cachemgr.cgi>
    PassEnv TMP TEMP
    Order allow,deny
    Allow from workstation.example.com
</Location>
}}}

== PSAPI.DLL (Process Status Helper) Considerations ==

The process status helper functions make it easier for you to obtain information about processes and device drivers running on Microsoft® Windows NT®/Windows® 2000. These functions are available in PSAPI.DLL, which is distributed in the Microsoft® Platform Software Development Kit (SDK). The same information is generally available through the performance data in the registry, but it is more difficult to get to it. PSAPI.DLL is freely redistributable.

PSAPI.DLL is available only on Windows NT, 2000, XP and 2003. The implementation in Squid is aware of this, and try to use it only on the right platform.

On Windows NT PSAPI.DLL can be found as component of many applications, if you need it, you can find it on Windows NT Resource KIT. If you have problem, it can be downloaded from here: http://download.microsoft.com/download/platformsdk/Redist/4.0.1371.1/NT4/EN-US/psinst.EXE

On Windows 2000 and later it is available installing the Windows Support Tools, located on the Support\Tools folder of the installation Windows CD-ROM.

== Registry DNS lookup ==

On Windows platforms, if no value is specified in the SquidConf:dns_nameservers option in squid.conf or in the /etc/resolv.conf file, the list of DNS name servers are taken from the Windows registry, both static and dynamic DHCP configurations are supported.

== Compatibility Notes ==

 * It's recommended to use '/' char in Squid paths instead of '\'
 * Paths with spaces (like 'C:\Programs Files\Squid) are NOT supported by Squid
 * When using ACL like 'SquidConf:acl aclname acltype "file"' the file must be in DOS text format (CR+LF) and the full Windows path must be specified, for example:
{{{
acl blocklist dstdomain "c:/squid/etc/blocked1.txt"
}}}

 * The Windows equivalent of '/dev/null' is 'NUL'
 * Squid doesn't know how to run external helpers based on scripts, like .bat, .cmd, .vbs, .pl, etc. So in squid.conf the interpreter path must be always specified, for example:
{{{
url_rewrite_program c:/perl/bin/perl.exe c:/squid/libexec/redir.pl
url_rewrite_program c:/winnt/system32/cmd.exe /C c:/squid/libexec/redir.cmd
}}}

 * When Squid runs in command line mode, the launching user account must have administrative privilege on the system
 * "Start parameters" in the Windows 2000/XP/2003 Service applet cannot be used
 * On Windows Vista and later, User Account Control (UAC) must be disabled before running service installation

=== Known Limitations ===

 * Squid features not operational:
  * DISKD: still needs to be ported
  * Transparent Proxy: missing Windows non commercial interception driver

 * Some code sections can make blocking calls.
 * Some external helpers may not work.
 * File Descriptors number hard-limited to 2048 when building with MinGW.

== Building Squid on Windows ==

When running configure, --disable-wccp and --disable-wccpv2 options should always specified to avoid compile errors.

'''New configure options:'''
 * --enable-win32-service

'''Updated configure options:'''
 * --enable-arp-acl
 * --enable-default-hostsfile

'''Unsupported configure options:'''
 * --enable-coss-aio-ops: On Windows Posix AIO is not available
 * --with-large-files: No suitable build environment is available on both Cygwin and MinGW, but --enable-large-files works fine

== Compiling with Cygwin ==

In order to compile Squid, you need to have Cygwin fully installed.

The usage of the Cygwin environment is very similar to other Unix/Linux environments, and -devel version of libraries must be installed.

 /!\ WCCP is not available on Windows so the following configure options are needed to disable them:
{{{
  --disable-wccp
  --disable-wccpv2
}}}

|| {i} ||Squid will by default, install into ''/usr/local/squid''. If you wish to install somewhere else, see the ''--prefix'' option for configure.||

Now, add a new Cygwin user - see the Cygwin user guide - and map it to SYSTEM, or create a new NT user, and a matching Cygwin user and they become the squid runas users.

Read the squid FAQ on permissions if you are using CYGWIN=ntsec.

After run ''squid -z''. If that succeeds, try ''squid -N -D -d1'', squid should start. Check that there are no errors. If everything looks good, try browsing through squid.

Now, configure ''cygrunsrv'' to run Squid as a service as the chosen username. You may need to check permissions here.

== Compiling with MinGW ==

In order to compile squid using the MinGW environment, the packages MSYS, MinGW and msysDTK must be installed. Some additional libraries and tools must be downloaded separately:

 * OpenSSL: [[http://www.slproweb.com/products/Win32OpenSSL.html|Shining Light Productions Win32 OpenSSL]]
 * libcrypt: [[http://sourceforge.net/projects/mingwrep/|MinGW packages repository]]
 * db-1.85: [[http://tiny-cobol.sourceforge.net/download.php|TinyCOBOL download area]]
 * uudecode: [[http://unxutils.sourceforge.net/|Native Win32 ports of some GNU utilities]]

 {i} 3.0+ releases do not require uudecode.

Before building Squid with SSL support, some operations are needed (in the following example OpenSSL is installed in C:\OpenSSL and MinGW in C:\MinGW):
 * Copy C:\OpenSSL\lib\MinGW content to C:\MinGW\lib
 * Copy C:\OpenSSL\include\openssl content to C:\MinGW\include\openssl
 * Rename C:\MinGW\lib\ssleay32.a to C:\MinGW\lib\libssleay32.a

Unpack the source archive as usual and run configure.

The following are the recommended minimal options for Windows:
{{{
--prefix=c:/squid
--disable-wccp
--disable-wccpv2
--enable-win32-service
--enable-default-hostsfile=none
}}}

Then run make and install as usual.

Squid will install into ''c:\squid''. If you wish to install somewhere else, change the ''--prefix'' option for configure.

After run ''squid -z''. If that succeeds, try ''squid -N -D -d1'', squid should start. Check that there are no errors. If everything looks good, try browsing through squid.

Now, to run Squid as a Windows system service, run ''squid -n'', this will create a service named "Squid" with automatic startup. To start it run ''net start squid'' from command line prompt or use the Services Administrative Applet.

Always check the provided release notes for any version specific detail.


== Configuration Guides ==

 * [[SquidFaq/WindowsUpdate|Windows Update]]
 * [[ConfigExamples/Authenticate/WindowsActiveDirectory|Active Directory Authentication]]
 * [[ConfigExamples/Authenticate/Kerberos|Kerberos Authentication]]
 * [[ConfigExamples/Authenticate/Ntlm|NTLM Authentication]] ([[ConfigExamples/Authenticate/NtlmWithGroups| with Groups]])

These and many other general manuals in the ConfigExamples section.

----
CategoryKnowledgeBase
