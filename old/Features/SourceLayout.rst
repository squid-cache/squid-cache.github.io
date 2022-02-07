##master-page:CategoryTemplate
#format wiki
#language en
= Feature: Source layout improvements =
 * '''Goal''': Ease code navigation. Reduce recompilation time. Fix distclean. Fix dependency tree.
 * '''Status''': In progress
 * '''ETA''': Ongoing
 * '''Version''': 3.3
 * '''Developer''': AlexRousskov and AmosJeffries
 * '''More''': [[http://www.mail-archive.com/squid-dev@squid-cache.org/msg07121.html|email07121]] [[http://www.mail-archive.com/squid-dev@squid-cache.org/msg07506.html|email07506]]

Historically, many Squid source files have been dumped into squid/src directory. That directory has accumulated more than 400 source files. This project will group closely related files and place groups in individual directories. The squid/src directory will contain pretty much nothing but Makefiles and subdirectories.

== Squid Source Code Layout ==
This section is used to edit and finalize the grouping of source files. The '''Group''' column contains src/ subdirectory names. The '''Files''' section lists current file names and assumes file extensions .h, .cc, and .cci are added to the corresponding file names and masks.

Key:

 * (empty) - not even checked yet to see if this needs doing.
 * <:( in a sad state of affairs.
 * (./) Done.
 * :\ Improved, but needs more work. Nobody is working on this now. See the To-do column for details.
 * {1} AlexRousskov doing now.
 * {2} AmosJeffries doing now.
 * {3} FrancescoChemolli doing now.

## * {3} you? doing now.
||'''Unit''' <<BR>> '''Tests''' ||'''Stub''' ||'''Namespace''' ||'''forward.h''' ||'''Polish''' ||'''Group''' ||'''Definition''' ||'''Files and To-do''' ||
|| :\ ||- ||- || - || :\ ||''~/compat/'' ||Portability primitives. <<BR>> This is a full layer below everything, should be seamless with the OS API. ||** migrate remaining pieces from squid.h and squid-old.h into compat ||
|| <:( || <:( || <:( || (./) || :\ ||''acl/'' ||Access Controls ||ACL* external_acl.*, Add Acl namespace and rename classes? ||
|| <:( || <:( || <:( || (./) || (./) ||''adaptation/'' ||code common to eCAP and ICAP ||
|| <:( || <:( || <:( || <:( || (./) ||''adaptation/ecap/'' ||eCAP support ||
|| <:( || <:( || <:( || <:( || (./) ||''adaptation/icap/'' ||ICAP support ||
|| :\ || (./) || (./) || (./) || (./) ||''anyp/'' ||Protocol-independent protocol primitives ||url* urn* !ProtoPort* ||
|| :\ || (./) || (./) || (./)  || :\ ||''auth/'' ||Authentication schemes || ||
|| <:( || (./) || (./) || <:( || :\ ||''auth/basic/'' || Basic Authentication || ||
|| <:( || (./) || (./) || <:( || :\ ||''auth/digest/'' || Digest Authentication || ||
|| <:( || (./) || (./) || <:( || :\ ||''auth/negotiate/'' || Negotiate Authentication || ||
|| <:( || (./) || (./) || <:( || :\ ||''auth/ntlm/'' || NTLM Authentication || ||
|| :\ || <:( || {X} || <:( || :\ ||''base/'' ||Commonly used code without a better place to go. ||Async*?  wordlist.* dlink.* hash.* ||
|| <:( || <:( || <:( || <:( || <:( ||''clientdb/'' {2} || Database of information about clients || PR SquidPr:954 client_db.* ||
|| <:( || <:( || <:( || :\ || :\ ||''clients/'' ||Protocol clients and gateway components for connecting to upstream servers ||ftp.*, http.*, gopher.* ||
|| <:( || (./) || (./) || :\ || :\ ||''comm/'' ||I/O subsystem ||
|| :\ || <:( || <:( || <:( || <:( ||''cfg/'' {2} ||squid.conf parsing and management || PR SquidPr:928, cache_cf.* cf.* cf_* Parser.* ConfigParser.* ConfigOption.* ||
|| <:( || <:( || <:( || <:( || <:( ||''debug/'' ||Debug core utilities ||debug.cc Debug.h ||
|| :\ || (./) || <:( || <:( || <:( || ''DiskIO'' || I/O primitives for filesystem access || ||
|| :\ || <:( || <:( || (./) || :\ ||''dns/'' ||DNS components (Internal, dnsserver, caches) ||dns*, ipcache.* fqdncache.* ||
|| <:( || <:( || <:( || <:( || :\ ||''esi/'' ||ESI support ||ESI*, Add Esi namespace, rename classes ||
|| <:( || (./) || (./) || <:( || (./) ||''eui/'' ||EUI-48 / MAC / ARP operations ||
|| <:( || (./) || (./) || <:( || :\ ||''format/'' ||Custom formatting ||
|| :\ || <:( || (./) || <:( || :\ ||''fs/'' ||file system-specific cache store support? || rename classes, add Makefiles for subdirs. ||
|| <:( || - || - || <:( || - ||''fs/aufs'' ||AUFS cache_dir ||FrancescoChemolli. Fs::Ufs namespace, renamed files. TODO: rename classes ||
|| <:( || - || - || <:( || - ||''fs/diskd'' ||DiskD cache_dir ||FrancescoChemolli. Fs::Ufs namespace, renamed files. TODO: rename classes ||
|| (./) || <:( || (./) || <:( || :\ ||''fs/ufs'' ||Ufs cache_dir || TODO: rename classes ||
|| (./) || <:( || (./) || (./) || :\ ||''fs/rock'' ||Rock cache_dir || TODO: rename classes ||
|| <:( || <:( || (./) || <:( || :\ ||''ftp/'' ||FTP primitives shared by client, server, and ICAP sides || ||
|| <:( || <:( || (./) || (./) || :\ ||''helper/'' || [[Features/AddonHelpers]] protocol primitives || migrate helper.* ||
|| :\ || <:( || (./) || (./) || :\ ||''http/'' || HTTP primitives shared by client, server, and ICAP sides ||Http* ||
|| :\ || <:( || (./) || (./) || :\ ||''http/one/'' || HTTP/1 primitives shared by client, server, and ICAP sides || ||
|| <:( || <:( || (./) || <:( || :\ ||''http/two/'' || HTTP/2 primitives shared by client, server, and ICAP sides || ||
|| :\ || (./) || <:( || <:( || :\ ||''icmp/'' ||ICMP support and Network measurement ||Icmp* net_db.*, C++ convert net_db*, Add Icmp namespace and rename classes ||
|| <:( || <:( || <:( || <:( || :\ ||''ident/'' ||IDENT support ||ident.* Make remote connection handling into an !AsyncJob ||
|| :\ || (./) || (./) || (./) || (./) ||''ip/'' ||IP Protocol ||Ip* Qos* ||
|| <:( || <:( || <:( || (./) || :\ ||''ipc/'' ||inter-process communication ||ipc.* ipc_win32.*, Move files, add Ipc namespace to them, and adjust global names ||
|| <:( || (./) || <:( || <:( || :\ ||''log/'' ||Logging components ||namespace for Custom log formats and tokenizer. classify ||
|| :\ || (./) || (./) || (./) || :\ ||''mem/'' ||Basic Memory management || class renaming, documentation, unit tests ||
|| :\ || (./) || <:( || (./) || :\ ||''mgr/'' ||Cache Manager ||Move in CacheManager.h, cache_manager.cc, and test cases ||
|| :\ || <:( || (./) || <:( || (./) || ''parser/'' || generic parsing primitives || ||
|| <:( || <:( || (./) || (./) || <:( || ''proxyp/'' || PROXY protocol primitives || ||
|| <:( || <:( || <:( || <:( || <:( ||''redirect/'' ||URL alteration (redirectors, URL-rewrite, URL maps) ||redirect.* !RedirectInternal.* ||
|| <:( || <:( || <:( || <:( || :\ ||''repl/heap/'' ||HEAP Replacement Policy algorithms ||
|| <:( || <:( || <:( || <:( || :\ ||''repl/lru/'' ||Cache Replacement Policy algorithms ||
|| :\ || (./) || <:( || (./) || (./) ||''sbuf/'' || SBuf (string buffer) components and related algorithms ||
|| <:( || (./) || (./) || (./) || (./) ||''security/'' || Transport Layer Security components ||
|| <:( || <:( || <:( || (./) || :\ ||''servers/'' ||Listening Server components for receiving connections ||client_side* ||
|| <:( || <:( || <:( || (./) || :\ ||''snmp/'' ||SNMP components ||snmp_*, move core and agent code. restructure for extensibility. ||
|| <:( || (./) || <:( || <:( || :\ ||''ssl/'' || OpenSSL components || library is named libsslsquid.la and matchgin stub_lib*.cc ||
|| <:( || <:( || <:( || <:( || <:( ||''shaping/'' {2} ||Traffic shaping and delay pools || PR SquidPr:928,  *[Dd]elay.* *[Pp]ool*.* ||
|| :\ || <:( || <:( || (./) || <:( ||''store/'' ||generic (fs-agnostic) disk and memory cache support? ||Store* store* ||
|| <:( || <:( || <:( || <:( || <:( ||''time/'' ||time and date handling tools ||time.* squidTime.* ||


== Bundled Add-On Source code ==
This section is used to edit and finalize the grouping of source files important for users but not integral to build Squid. These sources are generally contributed by third parties and vetted by the Squid Developers for bundling.

||'''Directory Path''' ||'''Content Type''' ||
|| src/adaptation/ecap/modules/* || (PROPOSED) eCAP extension modules which may be linked by configuration.||
|| src/auth/basic/*/ || SquidConf:auth_param basic helpers ||
|| src/auth/digest/*/ || SquidConf:auth_param digest helpers ||
|| src/auth/negotiate/*/ || SquidConf:auth_param negotiate helpers ||
|| src/auth/ntlm/*/ || SquidConf:auth_param ntlm helpers ||
|| src/acl/external/* || SquidConf:external_acl_type helpers ||
|| src/fs/diskd/* || SquidConf:diskd_program Disk I/O helpers ||
|| src/fs/unlink/* || (PROPOSED) SquidConf:unlinkd_program helpers ||
|| src/http/url_rewriters/* || HTTP message URL re-writers (SquidConf:url_rewrite_program) ||
|| src/icmp/* || SquidConf:pinger_program helpers ||
|| src/log/*/ || SquidConf:logfile_daemon helpers ||
|| src/security/cert_validators/* || SquidConf:sslcrtvalidator_program helpers ||
|| src/security/cert_generators/* || SquidConf:sslcrtd_program helpers ||
|| src/security/cert_password/* || (PROPOSED) SquidConf:sslpassword_program helpers ||
|| src/store/id_rewriters/* || Store-ID re-writers (SquidConf:store_id_program) ||
|| tools/ ||Administration tools ||


== Problems ==
If you know the solution or can improve the proposed one, please write to squid-dev mailing list.
||'''Problem''' ||'''Proposed solution''' ||
||Where to put OS-compatibility wrappers that are currently located in squid/lib and squid/include? ||'''squid/compat/''' but due to autoconf limitations the code must still be in '''.c''' files. ||
||Where to put 3rd party libraries that are currently located in squid/lib and squid/include? ||'''squid/import/libFoo/''' ||
||Can we remove Foo prefix from FOO/FooSomething.h file names? The prefix carries no additional information and is probably not required for modern compilers, especially in C++ world. ||'''Yes, Carefully''' <<BR>> File name should match the primary class declared or defined in that file. Directory name should match the (''lowercased'') namespace used by classes in that directory. We should move from PROTOFoo to PROTO::Foo classes. <<BR>> <<BR>> Ensure that there is no squid/src/Foo.h or squid/include/Foo.h file before using a foo/Foo.h. Some systemic problems have been found cleaning filenames like this with compiler include methods. ||
||Should client- and server- side files be separated? ||yes ||
||Should directory names use just_small, !CamelCase, or CAPS letters? ||lower_case ||
||Should class and file names use just_small, !CamelCase, or CAPS letters? ||!CamelCaseHttpAcronymsIncluded ||
||Should we use squid/src/squid/ root for most sources to include header files as <squid/group/file.h>? This may be required for installed headers and 3rd party code using those headers. It is not clear whether Squid will have installed headers in the foreseeable future. The Feature/eCAP work will determine that. ||no ||
||Should we form a generic mini-cache object type to combine the shared portions of fqdncache, ipcache, idns queue, netdb, ident-cache, maybe others not yet found? ||Probably, that will be a separate feature event though. ||
||What to do with all the mixed test* and stub_* files during this restructure? ||Stub files placed next to the .cc file they can replace with an extension of .stub.cc and no file prefix.<<BR>> test files go in test-suite directory. ||
|| What to do with third-party integration scripts and files? || Place in application-specific subdirectories off tools/ ||



== Dependency Issues: ==
 * Cache manager '''storeAppendPrintf''' - just about every component uses this old function to dump it's stats to the cache manager output. It depends on !StoreEntry which pulls in the entire store component tree.  We need to make it use something something smaller.
  * An earlier attempt was made to use !StoreEntryStream, but that still pulls in !StoreEntry.
  * !MemBuf is looking like a good all-purpose buffer we can have the components dump their text into. Which is then dumped into a !StoreEntry by the cache manager. TODO: this probably should be switched to SBuf or SBufList now.
  * Current approach is to use Packable API:
    * the '''Packable''' type defines basic append() and appendf() semantics implemented by relevant classes (!MemBuf, !StoreEntry, TODO: SBuf).
    * the '''!PackableStream''' type implements the C++ stream operators for any object implementing the Packable API.

 * '''debugs()''' macro handling still has a small circular dependency with libsquid, libbase files and file IO.

 * automake can generate library dependency links for us from foo_LDADD. But for historic reasons that no longer apply most of the makefiles are using foo_DEPENDENCIES which disables that functionality. We should remove the foo_DEPENDENCIES instead and move to foo_LDADD any objects not already there.

=== Other: ===
'''Explicit initialization vs self-initialization'''

{{{
The more I think on this the more I am of the opinion that using
self-registering static/global objects as method of initialization &
registration is generally a mistake. Better if each such class have a
method for initialization, with initialization order explicitly coded in
the main program. Also makes transition to runtime loaded modules easier
and less intrusive as each module can assume the modules it registers
into has been properly initialized already which means it can do a full
initialization.

Regards
Henrik
}}}

Current approach is to replace globals with a static function (typically called !GetFoo() or Foo::!GetInstance() for the foo global) returning a static local variable. The variable should either self-initialize or be carefully initialized by the getter function.

----
CategoryFeature
