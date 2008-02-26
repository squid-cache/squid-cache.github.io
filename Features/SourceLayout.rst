##master-page:CategoryTemplate
#format wiki
#language en

= Feature: Source layout improvements =

 * '''Goal''': Ease development. Support installable Squid headers and libraries. Fix distclean.

 * '''Status''': In progress
 * '''ETA''': 2008/06/15/C
 * '''Version''': 3.2?
 * '''Developer''': TBD
 * '''More''': [http://www.mail-archive.com/squid-dev@squid-cache.org/msg07121.html email07121]

Historically, many Squid source files have been dumped into squid/src directory. That directory has occumulated more than 400 source files. This project will group closely related files and place groups in individual directories. The squid/src directory will contain pretty much nothing but Makefiles and subdirectories.

== Layout ==

This section is used to edit and finalize the grouping of source files. The '''Group''' column contains src/ subdirectory names. The '''Files''' section lists current file names and assumes file extensions .h, .cc, and .cci are added to the corresponding file names and masks.

|| '''Group''' || '''Definition''' || '''Files''' ||
|| ''comm/'' || I/O subsystem || Comm*, comm*  ||
|| ''store/'' || generic (fs-agnostic) disk and memory cache support? || Store* store* ||
|| ''HTTP/'' || HTTP primitives shared by client, server, and ICAP sides || Http* ||
|| ''ICAP/'' || ICAP support || ICAP/ICAP* ||
|| ''ESI/'' || ESI support || ESI* ||
|| ''ICMP/'' || ICMP support || ICMP* ||
|| ''AnyP/'' || Protocol-independent protocol primitives || url* urn* ProtoPort* ||
...

== Problems ==

If you know the solution or can improve the proposed one, please write to squid-dev mailing list.

|| '''Problem''' || '''Proposed solution''' ||
||Where to put OS-compatibilities wrappers that are currently located in squid/lib and squid/include?||squid/compat/lib squid/compat/include||
||Where to put 3rd party libraries that are currently located in squid/lib and squid/include?|| /squid/import/libFoo/||
||Can we remove Foo prefix from FOO/!FooSomething.h file names? The prefix carries no additional information and is probably not required for modern compilers, especially in C++ world.||File name should match the primary class declared or defined in that file. Directory name should match the namespace used by classes in that directory. We should move from PROTOFoo to PROTO::Foo classes.||
||Should client- and server- side files be separated?||yes||
||Should directory names use just_small, !CamelCase, or CAPS letters? Does Windows portability require lowercase letters? || ? ||
|| Should we use squid/src/squid/ root for most sources to include header files as <squid/group/file.h>? This may be required for installed headers and 3rd party code using those headers. It is not clear whether Squid will have installed headers in the foreseeable future. The Feature/eCAP work will determine that. || ? ||

----
CategoryFeature
