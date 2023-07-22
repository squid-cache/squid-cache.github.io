---
categories: [Feature, WantedFeature]
---
# Feature: Source layout improvements

- **Goal**: Ease code navigation. Reduce recompilation time. Fix
  distclean. Fix dependency tree.
- **Status**: In progress
- **ETA**: Ongoing
- **Version**: 3.3
- **Developer**:
  [AlexRousskov](/AlexRousskov)
  and
  [AmosJeffries](/AmosJeffries)
- **More**:
    [email07121](http://www.mail-archive.com/squid-dev@squid-cache.org/msg07121.html)
    [email07506](http://www.mail-archive.com/squid-dev@squid-cache.org/msg07506.html)

Historically, many Squid source files have been dumped into squid/src
directory. That directory has accumulated more than 400 source files.
This project will group closely related files and place groups in
individual directories. The squid/src directory will contain pretty much
nothing but Makefiles and subdirectories.

## Squid Source Code Layout

This section is used to edit and finalize the grouping of source files.
The **Group** column contains src/ subdirectory names. The **Files**
section lists current file names and assumes file extensions .h, .cc,
and .cci are added to the corresponding file names and masks.

Key:
- (empty) - not even checked yet to see if this needs doing.
- :frown: in a sad state of affairs.
- :heavy_check_mark: Done.
- :neutral_face: Improved, but needs more work. Nobody is working on this now.
  See the To-do column for details.

| Unit Tests | Stub | Namespace | forward.h | Polish | Group | Definition | Files and To-do |
| ---------- | ---- | --------- | --------- | ------ | ----- | ---------- | --------------- |
| :neutral_face:     | -                  | -                  | -                  | :neutral_face:     | ~/compat/        | Portability primitives. This is a full layer below everything, should be seamless with the OS API. | ** migrate remaining pieces from squid.h and squid-old.h into compat              |
| :frowning:         | :frowning:         | :frowning:         | :heavy_check_mark: | :neutral_face:     | acl/             | Access Controls                                                                                    | ACL*external_acl.*, Add Acl namespace and rename classes?                        |
| :frowning:         | :frowning:         | :frowning:         | :heavy_check_mark: | :heavy_check_mark: | adaptation/      | code common to eCAP and ICAP                                                                       |
| :frowning:         | :frowning:         | :frowning:         | :frowning:         | :heavy_check_mark: | adaptation/ecap/ | eCAP support                                                                                       |
| :frowning:         | :frowning:         | :frowning:         | :frowning:         | :heavy_check_mark: | adaptation/icap/ | ICAP support                                                                                       |
| :neutral_face:     | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | anyp/            | Protocol-independent protocol primitives                                                           | url*urn* ProtoPort*                                                              |
| :neutral_face:     | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :neutral_face:     | auth/            | Authentication schemes                                                                             |
| :frowning:         | :heavy_check_mark: | :heavy_check_mark: | :frowning:         | :neutral_face:     | auth/basic/      | Basic Authentication                                                                               |
| :frowning:         | :heavy_check_mark: | :heavy_check_mark: | :frowning:         | :neutral_face:     | auth/digest/     | Digest Authentication                                                                              |
| :frowning:         | :heavy_check_mark: | :heavy_check_mark: | :frowning:         | :neutral_face:     | auth/negotiate/  | Negotiate Authentication                                                                           |
| :frowning:         | :heavy_check_mark: | :heavy_check_mark: | :frowning:         | :neutral_face:     | auth/ntlm/       | NTLM Authentication                                                                                |
| :neutral_face:     | :frowning:         | :x:                | :frowning:         | :neutral_face:     | base/            | Commonly used code without a better place to go.                                                   | Async*? wordlist.* dlink.*hash.*                                                 |
| :frowning:         | :frowning:         | :frowning:         | :frowning:         | :frowning:         | clientdb/   | Database of information about clients                                                              | PR 954 client_db.*                                                                |
| :frowning:         | :frowning:         | :frowning:         | :neutral_face:     | :neutral_face:     | clients/         | Protocol clients and gateway components for connecting to upstream servers                         | ftp.*, http.*, gopher.*                                                           |
| :frowning:         | :heavy_check_mark: | :heavy_check_mark: | :neutral_face:     | :neutral_face:     | comm/            | I/O subsystem                                                                                      |
| :neutral_face:     | :frowning:         | :frowning:         | :frowning:         | :frowning:         | cfg/        | squid.conf parsing and management                                                                  | PR 928, cache_cf.*cf.* cf_* Parser.* ConfigParser.* ConfigOption.*               |
| :frowning:         | :frowning:         | :frowning:         | :frowning:         | :frowning:         | debug/           | Debug core utilities                                                                               |
| :neutral_face:     | :heavy_check_mark: | :frowning:         | :frowning:         | :frowning:         | DiskIO           | I/O primitives for filesystem access                                                               |
| :neutral_face:     | :frowning:         | :frowning:         | :heavy_check_mark: | :neutral_face:     | dns/             | DNS components (Internal, dnsserver, caches)                                                       | dns*, ipcache.* fqdncache.*                                                       |
| :frowning:         | :frowning:         | :frowning:         | :frowning:         | :neutral_face:     | esi/             | ESI support                                                                                        | ESI*, Add Esi namespace, rename classes                                           |
| :frowning:         | :heavy_check_mark: | :heavy_check_mark: | :frowning:         | :heavy_check_mark: | eui/             | EUI-48 / MAC / ARP operations                                                                      |
| :frowning:         | :heavy_check_mark: | :heavy_check_mark: | :frowning:         | :neutral_face:     | format/          | Custom formatting                                                                                  |
| :neutral_face:     | :frowning:         | :heavy_check_mark: | :frowning:         | :neutral_face:     | fs/              | file system-specific cache store support?                                                          | rename classes, add Makefiles for subdirs.                                        |
| :frowning:         | -                  | -                  | :frowning:         | -                  | fs/aufs          | AUFS cache_dir                                                                                     | Fs::Ufs namespace, renamed files. TODO: rename classes         |
| :frowning:         | -                  | -                  | :frowning:         | -                  | fs/diskd         | DiskD cache_dir                                                                                    | FrancescoChemolli. Fs::Ufs namespace, renamed files. TODO: rename classes         |
| :heavy_check_mark: | :frowning:         | :heavy_check_mark: | :frowning:         | :neutral_face:     | fs/ufs           | Ufs cache_dir                                                                                      | TODO: rename classes                                                              |
| :heavy_check_mark: | :frowning:         | :heavy_check_mark: | :heavy_check_mark: | :neutral_face:     | fs/rock          | Rock cache_dir                                                                                     | TODO: rename classes                                                              |
| :frowning:         | :frowning:         | :heavy_check_mark: | :frowning:         | :neutral_face:     | ftp/             | FTP primitives shared by client, server, and ICAP sides                                            |
| :frowning:         | :frowning:         | :heavy_check_mark: | :heavy_check_mark: | :neutral_face:     | helper/          | Features/AddonHelpers protocol primitives                                                          | migrate helper.*                                                                  |
| :neutral_face:     | :frowning:         | :heavy_check_mark: | :heavy_check_mark: | :neutral_face:     | http/            | HTTP primitives shared by client, server, and ICAP sides                                           | Http*                                                                             |
| :neutral_face:     | :frowning:         | :heavy_check_mark: | :heavy_check_mark: | :neutral_face:     | http/one/        | HTTP/1 primitives shared by client, server, and ICAP sides                                         |
| :frowning:         | :frowning:         | :heavy_check_mark: | :frowning:         | :neutral_face:     | http/two/        | HTTP/2 primitives shared by client, server, and ICAP sides                                         |
| :neutral_face:     | :heavy_check_mark: | :frowning:         | :frowning:         | :neutral_face:     | icmp/            | ICMP support and Network measurement                                                               | Icmp*net_db.*, C++ convert net_db*, Add Icmp namespace and rename classes        |
| :frowning:         | :frowning:         | :frowning:         | :frowning:         | :neutral_face:     | ident/           | IDENT support                                                                                      | ident.* Make remote connection handling into an AsyncJob                          |
| :neutral_face:     | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | ip/              | IP Protocol                                                                                        | Ip*Qos*                                                                          |
| :frowning:         | :frowning:         | :frowning:         | :heavy_check_mark: | :neutral_face:     | ipc/             | inter-process communication                                                                        | ipc.*ipc_win32.*, Move files, add Ipc namespace to them, and adjust global names |
| :frowning:         | :heavy_check_mark: | :frowning:         | :frowning:         | :neutral_face:     | log/             | Logging components                                                                                 | namespace for Custom log formats and tokenizer. classify                          |
| :neutral_face:     | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :neutral_face:     | mem/             | Basic Memory management                                                                            | class renaming, documentation, unit tests                                         |
| :neutral_face:     | :heavy_check_mark: | :frowning:         | :heavy_check_mark: | :neutral_face:     | mgr/             | Cache Manager                                                                                      | Move in CacheManager.h, cache_manager.cc, and test cases                          |
| :neutral_face:     | :frowning:         | :heavy_check_mark: | :frowning:         | :heavy_check_mark: | parser/          | generic parsing primitives                                                                         |
| :frowning:         | :frowning:         | :heavy_check_mark: | :heavy_check_mark: | :frowning:         | proxyp/          | PROXY protocol primitives                                                                          |
| :frowning:         | :frowning:         | :frowning:         | :frowning:         | :frowning:         | redirect/        | URL alteration (redirectors, URL-rewrite, URL maps)                                                | redirect.*RedirectInternal.*                                                     |
| :frowning:         | :frowning:         | :frowning:         | :frowning:         | :neutral_face:     | repl/heap/       | HEAP Replacement Policy algorithms                                                                 |
| :frowning:         | :frowning:         | :frowning:         | :frowning:         | :neutral_face:     | repl/lru/        | Cache Replacement Policy algorithms                                                                |
| :neutral_face:     | :heavy_check_mark: | :frowning:         | :heavy_check_mark: | :heavy_check_mark: | sbuf/            | SBuf (string buffer) components and related algorithms                                             |
| :frowning:         | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | :heavy_check_mark: | security/        | Transport Layer Security components                                                                |
| :frowning:         | :frowning:         | :frowning:         | :heavy_check_mark: | :neutral_face:     | servers/         | Listening Server components for receiving connections                                              | client_side*                                                                      |
| :frowning:         | :frowning:         | :frowning:         | :heavy_check_mark: | :neutral_face:     | snmp/            | SNMP components                                                                                    | snmp_*, move core and agent code. restructure for extensibility.                  |
| :frowning:         | :heavy_check_mark: | :frowning:         | :frowning:         | :neutral_face:     | ssl/             | OpenSSL components                                                                                 | library is named libsslsquid.la and matchgin stub_lib*.cc                         |
| :frowning:         | :frowning:         | :frowning:         | :frowning:         | :frowning:         | shaping/    | Traffic shaping and delay pools                                                                    | PR 928, *[Dd]elay.* *[Pp]ool*.*                                                   |
| :neutral_face:     | :frowning:         | :frowning:         | :heavy_check_mark: | :frowning:         | store/           | generic (fs-agnostic) disk and memory cache support?                                               | Store*store*                                                                     |
| :frowning:         | :heavy_check_mark: | :heavy_check_mark: | :frowning:         | :frowning:         | time/            | time and date handling tools                                                                       | PR 1001                                                                           |


## Bundled Add-On Source code

This section is used to edit and finalize the grouping of source files
important for users but not integral to build Squid. These sources are
generally contributed by third parties and vetted by the Squid
Developers for bundling.

| **Directory Path**               | **Content Type**                                                                                                  |
| -------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| src/adaptation/ecap/modules/\*   | (PROPOSED) eCAP extension modules which may be linked by configuration.                                           |
| src/auth/basic/\*/               | [auth_param](http://www.squid-cache.org/Doc/config/auth_param) basic helpers                                    |
| src/auth/digest/\*/              | [auth_param](http://www.squid-cache.org/Doc/config/auth_param) digest helpers                                   |
| src/auth/negotiate/\*/           | [auth_param](http://www.squid-cache.org/Doc/config/auth_param) negotiate helpers                                |
| src/auth/ntlm/\*/                | [auth_param](http://www.squid-cache.org/Doc/config/auth_param) ntlm helpers                                     |
| src/acl/external/\*              | [external_acl_type](http://www.squid-cache.org/Doc/config/external_acl_type) helpers                           |
| src/fs/diskd/\*                  | [diskd_program](http://www.squid-cache.org/Doc/config/diskd_program) Disk I/O helpers                           |
| src/fs/unlink/\*                 | (PROPOSED) [unlinkd_program](http://www.squid-cache.org/Doc/config/unlinkd_program) helpers                     |
| src/http/url_rewriters/\*       | HTTP message URL re-writers ([url_rewrite_program](http://www.squid-cache.org/Doc/config/url_rewrite_program)) |
| src/icmp/\*                      | [pinger_program](http://www.squid-cache.org/Doc/config/pinger_program) helpers                                  |
| src/log/\*/                      | [logfile_daemon](http://www.squid-cache.org/Doc/config/logfile_daemon) helpers                                  |
| src/security/cert_validators/\* | [sslcrtvalidator_program](http://www.squid-cache.org/Doc/config/sslcrtvalidator_program) helpers                |
| src/security/cert_generators/\* | [sslcrtd_program](http://www.squid-cache.org/Doc/config/sslcrtd_program) helpers                                |
| src/security/cert_password/\*   | (PROPOSED) [sslpassword_program](http://www.squid-cache.org/Doc/config/sslpassword_program) helpers             |
| src/store/id_rewriters/\*       | Store-ID re-writers ([store_id_program](http://www.squid-cache.org/Doc/config/store_id_program))               |
| tools/                           | Administration tools                                                                                              |

## Problems

If you know the solution or can improve the proposed one, please write
to squid-dev mailing list.

| Problem | Proposed solution |
| ------- | ----------------- |
| Where to put OS-compatibility wrappers that are currently located in squid/lib and squid/include? | squid/compat/ but due to autoconf limitations the code must still be in .c files. |
| Where to put 3rd party libraries that are currently located in squid/lib and squid/include? | squid/import/libFoo/ |
| Can we remove Foo prefix from FOO/FooSomething.h file names? The prefix carries no additional information and is probably not required for modern compilers, especially in C++ world. | Yes, Carefully <br /> File name should match the primary class declared or defined in that file. Directory name should match the (lowercased) namespace used by classes in that directory. We should move from `PROTOFoo` to `PROTO::Foo` classes. <br /> Ensure that there is no squid/src/Foo.h or squid/include/Foo.h file before using a foo/Foo.h. Some systemic problems have been found cleaning filenames like this with compiler include methods. |
| Should client- and server- side files be separated? | yes |
| Should directory names use just_small, CamelCase, or CAPS letters? | lower_case |
| Should class and file names use just_small, CamelCase, or CAPS letters? | CamelCaseHttpAcronymsIncluded |
| Should we use squid/src/squid/ root for most sources to include header files as &lt;squid/group/file.h&gt;? This may be required for installed headers and 3rd party code using those headers. It is not clear whether Squid will have installed headers in the foreseeable future. The Feature/eCAP work will determine that. | no |
| Should we form a generic mini-cache object type to combine the shared portions of fqdncache, ipcache, idns queue, netdb, ident-cache, maybe others not yet found? | Probably, that will be a separate feature event though. |
| What to do with all the mixed test*and stub_* files during this restructure? | Stub files placed next to the .cc file they can replace with an extension of .stub.cc and no file prefix.
test files go in test-suite directory. |
| What to do with third-party integration scripts and files? | Place in application-specific subdirectories off tools/ |


## Dependency Issues:

- Cache manager **storeAppendPrintf** - just about every component
    uses this old function to dump it's stats to the cache manager
    output. It depends on StoreEntry which pulls in the entire store
    component tree. We need to make it use something something smaller
    - An earlier attempt was made to use StoreEntryStream, but that
        still pulls in StoreEntry
    - MemBuf is looking like a good all-purpose buffer we can have the
        components dump their text into. Which is then dumped into a
        StoreEntry by the cache manager. TODO: this probably should be
        switched to SBuf or SBufList now.
    - Current approach is to use Packable API:
        - the **Packable** type defines basic append() and appendf()
            semantics implemented by relevant classes (MemBuf,
            StoreEntry, TODO: SBuf).
        - the **PackableStream** type implements the C++ stream
            operators for any object implementing the Packable API
- **debugs()** macro handling still has a small circular dependency
    with libsquid, libbase files and file IO.
- automake can generate library dependency links for us from
    foo_LDADD. But for historic reasons that no longer apply most of
    the makefiles are using foo_DEPENDENCIES which disables that
    functionality. We should remove the foo_DEPENDENCIES instead and
    move to foo_LDADD any objects not already there.

### Other

**Explicit initialization vs self-initialization**

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

Current approach is to replace globals with a static function (typically
called GetFoo() or Foo::GetInstance() for the foo global) returning a
static local variable. The variable should either self-initialize or be
carefully initialized by the getter function.
