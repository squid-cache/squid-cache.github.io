##master-page:KnowledgeBaseTemplate
#format wiki
#language en

= Squid on Windows =

<<TableOfContents>>

== Does Squid run on Windows ? ==

Starting from 2.6.STABLE4, Squid will ''compile and run'' on Windows NT and later incarnations with the [[http://www.cygwin.com/|Cygwin]] / [[http://www.mingw.org/|MinGW]] packages.


 {i} The original development code name of the 2.5 project port was SquidNT, but after the 2.6.STABLE4 release, this project was complete. So when speaking about Squid on Windows, people should always refer to Squid, instead to the old SquidNT name.   

== Pre-Built Binary Packages ==

GuidoSerassio of [[http://www.acmeconsulting.it/|Acme Consulting S.r.l.]] maintains the official [[http://squid.acmeconsulting.it/|native Windows port]] of Squid (built using the Microsoft toolchain) and is actively working on having the needed changes integrated into the standard Squid distribution. His effort is partially based on earlier Windows NT port by Romeo Anghelache.

 . '''Squid-2.6, Squid-2.7, Squid-3.0:''' Binaries for Windows NT/2000/XP/2003 are at http://squid.acmeconsulting.it/

== Compiling with Cygwin ==

In order to compile Squid, you need to have Cygwin fully installed.

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
