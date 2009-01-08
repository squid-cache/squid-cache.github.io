##master-page:CategoryTemplate
#format wiki
#language en

= Feature: Source layout improvements =

 * '''Goal''': Ease code navigation. Reduce recompilation time. Fix distclean.
 * '''Status''': In progress
 * '''ETA''': November-December 2008
 * '''Version''': 3.1
 * '''Developer''': AlexRousskov and AmosJeffries
 * '''More''': [[http://www.mail-archive.com/squid-dev@squid-cache.org/msg07121.html|email07121]] [[http://www.mail-archive.com/squid-dev@squid-cache.org/msg07506.html|email07506]]

Historically, many Squid source files have been dumped into squid/src directory. That directory has accumulated more than 400 source files. This project will group closely related files and place groups in individual directories. The squid/src directory will contain pretty much nothing but Makefiles and subdirectories.

== Squid Source Code Layout ==

This section is used to edit and finalize the grouping of source files. The '''Group''' column contains src/ subdirectory names. The '''Files''' section lists current file names and assumes file extensions .h, .cc, and .cci are added to the corresponding file names and masks.

Key:
 * (./) Done.
 * {2} AmosJeffries doing now.
 * {3} AdrianChadd doing now.

||  || '''Group''' || '''Definition''' || '''Files''' ||
||  || ''acl/'' || Access Controls || ACL* external_acl.* ||
|| {2} || ''auth/'' || Authentication support || auth/* ||
|| {3} || ''core/'' || Core stuff which hasn't been further broken apart || ? ||
||  || ''comm/'' || I/O subsystem || Comm*, comm*  ||
||  || ''store/'' || generic (fs-agnostic) disk and memory cache support? || Store* store* ||
||  || ''http/'' || HTTP primitives shared by client, server, and ICAP sides || Http* ||
|| (./) || ''icmp/'' || ICMP support and Network measurement || Icmp* net_db.* ||
||  || ''ident/'' || Ident support || ident.* ||
||  || ''anyp/'' || Protocol-independent protocol primitives || url* urn* !ProtoPort* ||
||  || ''adaptation/'' || code common to eCAP and ICAP  || ICAP/ICAP* ||
||  || ''icap/'' || ICAP support || ICAP/ICAP* ||
||  || ''ecap/'' || eCAP support || - ||
||  || ''esi/'' || ESI support || ESI* ||
||  || ''dns/'' || DNS components (Internal, dnsserver, caches) || dns*, ipcache.* fqdncache.* ||
|| {3}  || ''debug/'' || Debug core utilities || debug.cc Debug.h ||
||  || ''mem/'' || Basic Memory management || mem* ||
||  || ''structures/'' || Basic pattern algorithm primitives || wordlist.* dlink.* hash.* ||
|| {2} || ''ip/'' || IP Protocol || IPAddress.* IPInterception.* Qos* ||

...
The following shuffling is linked to major code re-writes and will be held back to 3.2.

|| {2} || ''compat/'' || Portability primitives || include/os/* include/compat.h include/squid_* ||
|| {2} || ''redirect/'' || URL alteration (redirectors, URL-rewrite, URL maps) || redirect.* RedirectInternal.* ||

== Non-Squid Bundled Source code ==

This section is used to edit and finalize the grouping of source files important for users but not integral to build and run Squid. These sources are generally contributed by third parties and vetted by the Squid Developers for bundling.

|| '''Directory''' || || '''Content Type''' ||
||<-2> helpers/ || Helper applications which may be run by configuration. ||
|| || basic_auth/ || auth_param basic ||
|| || digest_auth/ || auth_param digest ||
|| || external_acl/ || external_acl_type ||
|| || negotiate_auth/ || auth_param negotiate ||
|| || ntlm_auth/ || auth_param ntlm ||
||<-2> modules/ || Extension modules which may be linked by configuration. ||
|| || ecap/ || eCAP ||
||<-2> tools/ || Administration tools ||


== Problems ==

If you know the solution or can improve the proposed one, please write to squid-dev mailing list.

|| '''Problem''' || '''Proposed solution''' ||
||Where to put OS-compatibilities wrappers that are currently located in squid/lib and squid/include?||squid/compat/lib squid/compat/include||
||Where to put 3rd party libraries that are currently located in squid/lib and squid/include?|| /squid/import/libFoo/||
||Can we remove Foo prefix from FOO/Foo''''''Something.h file names? The prefix carries no additional information and is probably not required for modern compilers, especially in C++ world.||File name should match the primary class declared or defined in that file. Directory name should match the namespace used by classes in that directory. We should move from PROTOFoo to PROTO::Foo classes. '''Some systemic problems have been found cleaning filenames like this with compiler include methods.'''||
||Should client- and server- side files be separated?||yes||
||Should directory names use just_small, !CamelCase, or CAPS letters? || lower_case ||
||Should class and file names use just_small, !CamelCase, or CAPS letters? || !CamelCaseHttpAcronymsIncluded ||
|| Should we use squid/src/squid/ root for most sources to include header files as <squid/group/file.h>? This may be required for installed headers and 3rd party code using those headers. It is not clear whether Squid will have installed headers in the foreseeable future. The Feature/eCAP work will determine that. || no ||
|| Should we form a generic mini-cache object type to combine the shared portions of fqdncache, ipcache, idns queue, netdb, ident-cache, maybe others not yet found? || Probably, that will be a separate feature event though. ||
|| What to do with all the mixed test* and stub_* files during this restructure? || AYJ: I'm sticking them in the same folder as the code, and prefixing with test* and stub* as needed. ||

----
CategoryFeature
