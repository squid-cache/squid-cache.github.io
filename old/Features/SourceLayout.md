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
- :one: [AlexRousskov](/AlexRousskov) doing now
- :two: [AmosJeffries](/AmosJeffries) doing now
- :three: [FrancescoChemolli](/FrancescoChemolli) doing now

<table>
<tbody>
<tr class="odd">
<td><p><strong>Unit</strong></p>
<p><strong>Tests</strong></p></td>
<td><p><strong>Stub</strong></p></td>
<td><p><strong>Namespace</strong></p></td>
<td><p><strong>forward.h</strong></p></td>
<td><p><strong>Polish</strong></p></td>
<td><p><strong>Group</strong></p></td>
<td><p><strong>Definition</strong></p></td>
<td><p><strong>Files and To-do</strong></p></td>
</tr>
<tr class="even">
<td>:neutral_face:</td>
<td><p>-</p></td>
<td><p>-</p></td>
<td><p>-</p></td>
<td>:neutral_face:</td>
<td><p><em>~/compat/</em></p></td>
<td><p>Portability primitives.</p>
<p>This is a full layer below everything, should be seamless with the OS API.</p></td>
<td><p>** migrate remaining pieces from squid.h and squid-old.h into compat</p></td>
</tr>
<tr class="odd">
<td>:frown:</td>
<td>:frown:</td>
<td>:frown:</td>
<td>:heavy_check_mark:</td>
<td>:neutral_face:</td>
<td><p><em>acl/</em></p></td>
<td><p>Access Controls</p></td>
<td><p>ACL* external_acl.*, Add Acl namespace and rename classes?</p></td>
</tr>
<tr class="even">
<td>:frown:</td>
<td>:frown:</td>
<td>:frown:</td>
<td>:heavy_check_mark:</td>
<td>:heavy_check_mark:</td>
<td><p><em>adaptation/</em></p></td>
<td><p>code common to eCAP and ICAP</p></td>
<td></td>
</tr>
<tr class="odd">
<td>:frown:</td>
<td>:frown:</td>
<td>:frown:</td>
<td>:frown:</td>
<td>:heavy_check_mark:</td>
<td><p><em>adaptation/ecap/</em></p></td>
<td><p>eCAP support</p></td>
<td></td>
</tr>
<tr class="even">
<td>:frown:</td>
<td>:frown:</td>
<td>:frown:</td>
<td>:frown:</td>
<td>:heavy_check_mark:</td>
<td><p><em>adaptation/icap/</em></p></td>
<td><p>ICAP support</p></td>
<td></td>
</tr>
<tr class="odd">
<td>:neutral_face:</td>
<td>:heavy_check_mark:</td>
<td>:heavy_check_mark:</td>
<td>:heavy_check_mark:</td>
<td>:heavy_check_mark:</td>
<td><p><em>anyp/</em></p></td>
<td><p>Protocol-independent protocol primitives</p></td>
<td><p>url* urn* ProtoPort*</p></td>
</tr>
<tr class="even">
<td>:neutral_face:</td>
<td>:heavy_check_mark:</td>
<td>:heavy_check_mark:</td>
<td>:heavy_check_mark:</td>
<td>:neutral_face:</td>
<td><p><em>auth/</em></p></td>
<td><p>Authentication schemes</p></td>
<td></td>
</tr>
<tr class="odd">
<td>:frown:</td>
<td>:heavy_check_mark:</td>
<td>:heavy_check_mark:</td>
<td>:frown:</td>
<td>:neutral_face:</td>
<td><p><em>auth/basic/</em></p></td>
<td><p>Basic Authentication</p></td>
<td></td>
</tr>
<tr class="even">
<td>:frown:</td>
<td>:heavy_check_mark:</td>
<td>:heavy_check_mark:</td>
<td>:frown:</td>
<td>:neutral_face:</td>
<td><p><em>auth/digest/</em></p></td>
<td><p>Digest Authentication</p></td>
<td></td>
</tr>
<tr class="odd">
<td>:frown:</td>
<td>:heavy_check_mark:</td>
<td>:heavy_check_mark:</td>
<td>:frown:</td>
<td>:neutral_face:</td>
<td><p><em>auth/negotiate/</em></p></td>
<td><p>Negotiate Authentication</p></td>
<td></td>
</tr>
<tr class="even">
<td>:frown:</td>
<td>:heavy_check_mark:</td>
<td>:heavy_check_mark:</td>
<td>:frown:</td>
<td>:neutral_face:</td>
<td><p><em>auth/ntlm/</em></p></td>
<td><p>NTLM Authentication</p></td>
<td></td>
</tr>
<tr class="odd">
<td>:neutral_face:</td>
<td>:frown:</td>
<td>:x:</td>
<td>:frown:</td>
<td>:neutral_face:</td>
<td><p><em>base/</em></p></td>
<td><p>Commonly used code without a better place to go.</p></td>
<td><p>Async*? wordlist.* dlink.* hash.*</p></td>
</tr>
<tr class="even">
<td>:frown:</td>
<td>:frown:</td>
<td>:frown:</td>
<td>:frown:</td>
<td>:frown:</td>
<td><p><em>clientdb/</em> :two:</p></td>
<td><p>Database of information about clients</p></td>
<td><p>PR <a href="https://github.com/squid-cache/squid/pull/954#">954</a> client_db.*</p></td>
</tr>
<tr class="odd">
<td>:frown:</td>
<td>:frown:</td>
<td>:frown:</td>
<td>:neutral_face:</td>
<td>:neutral_face:</td>
<td><p><em>clients/</em></p></td>
<td><p>Protocol clients and gateway components for connecting to upstream servers</p></td>
<td><p>ftp.*, http.*, gopher.*</p></td>
</tr>
<tr class="even">
<td>:frown:</td>
<td>:heavy_check_mark:</td>
<td>:heavy_check_mark:</td>
<td>:neutral_face:</td>
<td>:neutral_face:</td>
<td><p><em>comm/</em></p></td>
<td><p>I/O subsystem</p></td>
<td></td>
</tr>
<tr class="odd">
<td>:neutral_face:</td>
<td>:frown:</td>
<td>:frown:</td>
<td>:frown:</td>
<td>:frown:</td>
<td><p><em>cfg/</em> :two:</p></td>
<td><p>squid.conf parsing and management</p></td>
<td><p>PR <a href="https://github.com/squid-cache/squid/pull/928#">928</a>, cache_cf.* cf.* cf_* Parser.* <a href="/ConfigParser#">ConfigParser</a>.* <a href="/ConfigOption#">ConfigOption</a>.*</p></td>
</tr>
<tr class="even">
<td>:frown:</td>
<td>:frown:</td>
<td>:frown:</td>
<td>:frown:</td>
<td>:frown:</td>
<td><p><em>debug/</em></p></td>
<td><p>Debug core utilities</p></td>
<td></td>
</tr>
<tr class="odd">
<td>:neutral_face:</td>
<td>:heavy_check_mark:</td>
<td>:frown:</td>
<td>:frown:</td>
<td>:frown:</td>
<td><p><em>DiskIO</em></p></td>
<td><p>I/O primitives for filesystem access</p></td>
<td></td>
</tr>
<tr class="even">
<td>:neutral_face:</td>
<td>:frown:</td>
<td>:frown:</td>
<td>:heavy_check_mark:</td>
<td>:neutral_face:</td>
<td><p><em>dns/</em></p></td>
<td><p>DNS components (Internal, dnsserver, caches)</p></td>
<td><p>dns*, ipcache.* fqdncache.*</p></td>
</tr>
<tr class="odd">
<td>:frown:</td>
<td>:frown:</td>
<td>:frown:</td>
<td>:frown:</td>
<td>:neutral_face:</td>
<td><p><em>esi/</em></p></td>
<td><p>ESI support</p></td>
<td><p>ESI*, Add Esi namespace, rename classes</p></td>
</tr>
<tr class="even">
<td>:frown:</td>
<td>:heavy_check_mark:</td>
<td>:heavy_check_mark:</td>
<td>:frown:</td>
<td>:heavy_check_mark:</td>
<td><p><em>eui/</em></p></td>
<td><p>EUI-48 / MAC / ARP operations</p></td>
<td></td>
</tr>
<tr class="odd">
<td>:frown:</td>
<td>:heavy_check_mark:</td>
<td>:heavy_check_mark:</td>
<td>:frown:</td>
<td>:neutral_face:</td>
<td><p><em>format/</em></p></td>
<td><p>Custom formatting</p></td>
<td></td>
</tr>
<tr class="even">
<td>:neutral_face:</td>
<td>:frown:</td>
<td>:heavy_check_mark:</td>
<td>:frown:</td>
<td>:neutral_face:</td>
<td><p><em>fs/</em></p></td>
<td><p>file system-specific cache store support?</p></td>
<td><p>rename classes, add Makefiles for subdirs.</p></td>
</tr>
<tr class="odd">
<td>:frown:</td>
<td><p>-</p></td>
<td><p>-</p></td>
<td>:frown:</td>
<td><p>-</p></td>
<td><p><em>fs/aufs</em></p></td>
<td><p>AUFS cache_dir</p></td>
<td><p><a href="/FrancescoChemolli#">FrancescoChemolli</a>. Fs::Ufs namespace, renamed files. TODO: rename classes</p></td>
</tr>
<tr class="even">
<td>:frown:</td>
<td><p>-</p></td>
<td><p>-</p></td>
<td>:frown:</td>
<td><p>-</p></td>
<td><p><em>fs/diskd</em></p></td>
<td><p>DiskD cache_dir</p></td>
<td><p><a href="/FrancescoChemolli#">FrancescoChemolli</a>. Fs::Ufs namespace, renamed files. TODO: rename classes</p></td>
</tr>
<tr class="odd">
<td>:heavy_check_mark:</td>
<td>:frown:</td>
<td>:heavy_check_mark:</td>
<td>:frown:</td>
<td>:neutral_face:</td>
<td><p><em>fs/ufs</em></p></td>
<td><p>Ufs cache_dir</p></td>
<td><p>TODO: rename classes</p></td>
</tr>
<tr class="even">
<td>:heavy_check_mark:</td>
<td>:frown:</td>
<td>:heavy_check_mark:</td>
<td>:heavy_check_mark:</td>
<td>:neutral_face:</td>
<td><p><em>fs/rock</em></p></td>
<td><p>Rock cache_dir</p></td>
<td><p>TODO: rename classes</p></td>
</tr>
<tr class="odd">
<td>:frown:</td>
<td>:frown:</td>
<td>:heavy_check_mark:</td>
<td>:frown:</td>
<td>:neutral_face:</td>
<td><p><em>ftp/</em></p></td>
<td><p>FTP primitives shared by client, server, and ICAP sides</p></td>
<td></td>
</tr>
<tr class="even">
<td>:frown:</td>
<td>:frown:</td>
<td>:heavy_check_mark:</td>
<td>:heavy_check_mark:</td>
<td>:neutral_face:</td>
<td><p><em>helper/</em></p></td>
<td><p><a href="/Features/AddonHelpers#">Features/AddonHelpers</a> protocol primitives</p></td>
<td><p>migrate helper.*</p></td>
</tr>
<tr class="odd">
<td>:neutral_face:</td>
<td>:frown:</td>
<td>:heavy_check_mark:</td>
<td>:heavy_check_mark:</td>
<td>:neutral_face:</td>
<td><p><em>http/</em></p></td>
<td><p>HTTP primitives shared by client, server, and ICAP sides</p></td>
<td><p>Http*</p></td>
</tr>
<tr class="even">
<td>:neutral_face:</td>
<td>:frown:</td>
<td>:heavy_check_mark:</td>
<td>:heavy_check_mark:</td>
<td>:neutral_face:</td>
<td><p><em>http/one/</em></p></td>
<td><p>HTTP/1 primitives shared by client, server, and ICAP sides</p></td>
<td></td>
</tr>
<tr class="odd">
<td>:frown:</td>
<td>:frown:</td>
<td>:heavy_check_mark:</td>
<td>:frown:</td>
<td>:neutral_face:</td>
<td><p><em>http/two/</em></p></td>
<td><p>HTTP/2 primitives shared by client, server, and ICAP sides</p></td>
<td></td>
</tr>
<tr class="even">
<td>:neutral_face:</td>
<td>:heavy_check_mark:</td>
<td>:frown:</td>
<td>:frown:</td>
<td>:neutral_face:</td>
<td><p><em>icmp/</em></p></td>
<td><p>ICMP support and Network measurement</p></td>
<td><p>Icmp* net_db.*, C++ convert net_db*, Add Icmp namespace and rename classes</p></td>
</tr>
<tr class="odd">
<td>:frown:</td>
<td>:frown:</td>
<td>:frown:</td>
<td>:frown:</td>
<td>:neutral_face:</td>
<td><p><em>ident/</em></p></td>
<td><p>IDENT support</p></td>
<td><p>ident.* Make remote connection handling into an AsyncJob</p></td>
</tr>
<tr class="even">
<td>:neutral_face:</td>
<td>:heavy_check_mark:</td>
<td>:heavy_check_mark:</td>
<td>:heavy_check_mark:</td>
<td>:heavy_check_mark:</td>
<td><p><em>ip/</em></p></td>
<td><p>IP Protocol</p></td>
<td><p>Ip* Qos*</p></td>
</tr>
<tr class="odd">
<td>:frown:</td>
<td>:frown:</td>
<td>:frown:</td>
<td>:heavy_check_mark:</td>
<td>:neutral_face:</td>
<td><p><em>ipc/</em></p></td>
<td><p>inter-process communication</p></td>
<td><p>ipc.* ipc_win32.*, Move files, add Ipc namespace to them, and adjust global names</p></td>
</tr>
<tr class="even">
<td>:frown:</td>
<td>:heavy_check_mark:</td>
<td>:frown:</td>
<td>:frown:</td>
<td>:neutral_face:</td>
<td><p><em>log/</em></p></td>
<td><p>Logging components</p></td>
<td><p>namespace for Custom log formats and tokenizer. classify</p></td>
</tr>
<tr class="odd">
<td>:neutral_face:</td>
<td>:heavy_check_mark:</td>
<td>:heavy_check_mark:</td>
<td>:heavy_check_mark:</td>
<td>:neutral_face:</td>
<td><p><em>mem/</em></p></td>
<td><p>Basic Memory management</p></td>
<td><p>class renaming, documentation, unit tests</p></td>
</tr>
<tr class="even">
<td>:neutral_face:</td>
<td>:heavy_check_mark:</td>
<td>:frown:</td>
<td>:heavy_check_mark:</td>
<td>:neutral_face:</td>
<td><p><em>mgr/</em></p></td>
<td><p>Cache Manager</p></td>
<td><p>Move in <a href="/CacheManager#">CacheManager</a>.h, cache_manager.cc, and test cases</p></td>
</tr>
<tr class="odd">
<td>:neutral_face:</td>
<td>:frown:</td>
<td>:heavy_check_mark:</td>
<td>:frown:</td>
<td>:heavy_check_mark:</td>
<td><p><em>parser/</em></p></td>
<td><p>generic parsing primitives</p></td>
<td></td>
</tr>
<tr class="even">
<td>:frown:</td>
<td>:frown:</td>
<td>:heavy_check_mark:</td>
<td>:heavy_check_mark:</td>
<td>:frown:</td>
<td><p><em>proxyp/</em></p></td>
<td><p>PROXY protocol primitives</p></td>
<td></td>
</tr>
<tr class="odd">
<td>:frown:</td>
<td>:frown:</td>
<td>:frown:</td>
<td>:frown:</td>
<td>:frown:</td>
<td><p><em>redirect/</em></p></td>
<td><p>URL alteration (redirectors, URL-rewrite, URL maps)</p></td>
<td><p>redirect.* RedirectInternal.*</p></td>
</tr>
<tr class="even">
<td>:frown:</td>
<td>:frown:</td>
<td>:frown:</td>
<td>:frown:</td>
<td>:neutral_face:</td>
<td><p><em>repl/heap/</em></p></td>
<td><p>HEAP Replacement Policy algorithms</p></td>
<td></td>
</tr>
<tr class="odd">
<td>:frown:</td>
<td>:frown:</td>
<td>:frown:</td>
<td>:frown:</td>
<td>:neutral_face:</td>
<td><p><em>repl/lru/</em></p></td>
<td><p>Cache Replacement Policy algorithms</p></td>
<td></td>
</tr>
<tr class="even">
<td>:neutral_face:</td>
<td>:heavy_check_mark:</td>
<td>:frown:</td>
<td>:heavy_check_mark:</td>
<td>:heavy_check_mark:</td>
<td><p><em>sbuf/</em></p></td>
<td><p>SBuf (string buffer) components and related algorithms</p></td>
<td></td>
</tr>
<tr class="odd">
<td>:frown:</td>
<td>:heavy_check_mark:</td>
<td>:heavy_check_mark:</td>
<td>:heavy_check_mark:</td>
<td>:heavy_check_mark:</td>
<td><p><em>security/</em></p></td>
<td><p>Transport Layer Security components</p></td>
<td></td>
</tr>
<tr class="even">
<td>:frown:</td>
<td>:frown:</td>
<td>:frown:</td>
<td>:heavy_check_mark:</td>
<td>:neutral_face:</td>
<td><p><em>servers/</em></p></td>
<td><p>Listening Server components for receiving connections</p></td>
<td><p>client_side*</p></td>
</tr>
<tr class="odd">
<td>:frown:</td>
<td>:frown:</td>
<td>:frown:</td>
<td>:heavy_check_mark:</td>
<td>:neutral_face:</td>
<td><p><em>snmp/</em></p></td>
<td><p>SNMP components</p></td>
<td><p>snmp_*, move core and agent code. restructure for extensibility.</p></td>
</tr>
<tr class="even">
<td>:frown:</td>
<td>:heavy_check_mark:</td>
<td>:frown:</td>
<td>:frown:</td>
<td>:neutral_face:</td>
<td><p><em>ssl/</em></p></td>
<td><p>OpenSSL components</p></td>
<td><p>library is named libsslsquid.la and matchgin stub_lib*.cc</p></td>
</tr>
<tr class="odd">
<td>:frown:</td>
<td>:frown:</td>
<td>:frown:</td>
<td>:frown:</td>
<td>:frown:</td>
<td><p><em>shaping/</em> :two:</p></td>
<td><p>Traffic shaping and delay pools</p></td>
<td><p>PR <a href="https://github.com/squid-cache/squid/pull/928#">928</a>, *[Dd]elay.* *[Pp]ool*.*</p></td>
</tr>
<tr class="even">
<td>:neutral_face:</td>
<td>:frown:</td>
<td>:frown:</td>
<td>:heavy_check_mark:</td>
<td>:frown:</td>
<td><p><em>store/</em></p></td>
<td><p>generic (fs-agnostic) disk and memory cache support?</p></td>
<td><p>Store* store*</p></td>
</tr>
<tr class="odd">
<td>:frown:</td>
<td>:heavy_check_mark:</td>
<td>:heavy_check_mark:</td>
<td>:frown:</td>
<td>:frown:</td>
<td><p><em>time/</em></p></td>
<td><p>time and date handling tools</p></td>
<td><p>PR <a href="https://github.com/squid-cache/squid/pull/1001#">1001</a></p></td>
</tr>
</tbody>
</table>

## Bundled Add-On Source code

This section is used to edit and finalize the grouping of source files
important for users but not integral to build Squid. These sources are
generally contributed by third parties and vetted by the Squid
Developers for bundling.

|                                  |                                                                                                                   |
| -------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| **Directory Path**               | **Content Type**                                                                                                  |
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

<table>
<tbody>
<tr class="odd">
<td><p><strong>Problem</strong></p></td>
<td><p><strong>Proposed solution</strong></p></td>
</tr>
<tr class="even">
<td><p>Where to put OS-compatibility wrappers that are currently located in squid/lib and squid/include?</p></td>
<td><p><strong>squid/compat/</strong> but due to autoconf limitations the code must still be in <strong>.c</strong> files.</p></td>
</tr>
<tr class="odd">
<td><p>Where to put 3rd party libraries that are currently located in squid/lib and squid/include?</p></td>
<td><p><strong>squid/import/libFoo/</strong></p></td>
</tr>
<tr class="even">
<td><p>Can we remove Foo prefix from FOO/FooSomething.h file names? The prefix carries no additional information and is probably not required for modern compilers, especially in C++ world.</p></td>
<td><p><strong>Yes, Carefully</strong></p>
<p>File name should match the primary class declared or defined in that file. Directory name should match the (<em>lowercased</em>) namespace used by classes in that directory. We should move from PROTOFoo to PROTO::Foo classes.</p>
<p>Ensure that there is no squid/src/Foo.h or squid/include/Foo.h file before using a foo/Foo.h. Some systemic problems have been found cleaning filenames like this with compiler include methods.</p></td>
</tr>
<tr class="odd">
<td><p>Should client- and server- side files be separated?</p></td>
<td><p>yes</p></td>
</tr>
<tr class="even">
<td><p>Should directory names use just_small, CamelCase, or CAPS letters?</p></td>
<td><p>lower_case</p></td>
</tr>
<tr class="odd">
<td><p>Should class and file names use just_small, CamelCase, or CAPS letters?</p></td>
<td><p>CamelCaseHttpAcronymsIncluded</p></td>
</tr>
<tr class="even">
<td><p>Should we use squid/src/squid/ root for most sources to include header files as &lt;squid/group/file.h&gt;? This may be required for installed headers and 3rd party code using those headers. It is not clear whether Squid will have installed headers in the foreseeable future. The Feature/eCAP work will determine that.</p></td>
<td><p>no</p></td>
</tr>
<tr class="odd">
<td><p>Should we form a generic mini-cache object type to combine the shared portions of fqdncache, ipcache, idns queue, netdb, ident-cache, maybe others not yet found?</p></td>
<td><p>Probably, that will be a separate feature event though.</p></td>
</tr>
<tr class="even">
<td><p>What to do with all the mixed test* and stub_* files during this restructure?</p></td>
<td><p>Stub files placed next to the .cc file they can replace with an extension of .stub.cc and no file prefix.</p>
<p>test files go in test-suite directory.</p></td>
</tr>
<tr class="odd">
<td><p>What to do with third-party integration scripts and files?</p></td>
<td><p>Place in application-specific subdirectories off tools/</p></td>
</tr>
</tbody>
</table>

## Dependency Issues:

  - Cache manager **storeAppendPrintf** - just about every component
    uses this old function to dump it's stats to the cache manager
    output. It depends on StoreEntry which pulls in the entire store
    component tree. We need to make it use something something smaller.
    
      - An earlier attempt was made to use StoreEntryStream, but that
        still pulls in StoreEntry.
    
      - MemBuf is looking like a good all-purpose buffer we can have the
        components dump their text into. Which is then dumped into a
        StoreEntry by the cache manager. TODO: this probably should be
        switched to SBuf or SBufList now.
    
      - Current approach is to use Packable API:
        
          - the **Packable** type defines basic append() and appendf()
            semantics implemented by relevant classes (MemBuf,
            StoreEntry, TODO: SBuf).
        
          - the **PackableStream** type implements the C++ stream
            operators for any object implementing the Packable API.

  - **debugs()** macro handling still has a small circular dependency
    with libsquid, libbase files and file IO.

  - automake can generate library dependency links for us from
    foo_LDADD. But for historic reasons that no longer apply most of
    the makefiles are using foo_DEPENDENCIES which disables that
    functionality. We should remove the foo_DEPENDENCIES instead and
    move to foo_LDADD any objects not already there.

### Other:

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

[CategoryFeature](/CategoryFeature)
