---
categories: Feature
---
# Schedule for Feature Removals

Certain features are no longer relevant as the code improves and are
planned for removal. Due to the possibility they are being used we list
them here along with the release version they are expected to disappear.
Warnings should also be present in the code where possible.

| Removed in version | Feature | Why |
| --- | --- | --- |
| **Deprecated in 6.0** | | |
| TBD | URN THTTP gateway | IETF deprecation and move to historic. |
| 6.0 | HPUX-specific build | Superseded by ./configure arguments. |
| 6.0 | AIX 6.1 support | Obsolete OS version. |
| 6.0 | TCP Lingering WAIT | Broken and unused for many years. |
| 6.0 | X-Cache and X-Cache-Lookup | Superseded by HTTP Cache-Status feature. |
| 6.0 | send-announce tool | Unused for many years. |
| 6.0 | ufsdump tool | Rarely used since [Squid-3.2](/Releases/Squid-3.2). Missing support for COSS and Rock caches. |
| | | |
| **Deprecated in 5.0** | | |
| TBD | BerkleyDB support | Superseded by TrivialDB which has better support by distributors. |
| 6.0 | GnuRegex library implementation | Only used by Windows toolchains which have not built for years. |
| | | |
| **Deprecated in 4.0** | | |
| 4.0 | ESI custom parser | Limited usability and repeated security issues. |
| | | |
| **Deprecated in 3.5** | | |
| TBD | [ssl_bump server-first](/Features/BumpSslServerFirst) | Obsolete and broken security. Superseded by [peek-n-splice](/Features/SslPeekAndSplice) |
| TBD | SSLv3 support | Obsolete and very broken security. But still widely used so no firm ETA. |
| 4.0 | SSLv2 support | RFC [6176](https://tools.ietf.org/rfc/rfc6176) compliance. |
| | | |
| **Deprecated in 3.4** | | |
| 3.5 | COSS storage type | Superseded by ROCK storage type |
| | | |
| **Deprecated in 3.3** | | |
| TBD | [ssl_bump client-first](/Features/SslBump) | Obsolete and very broken security. Superseded by [ssl_bump server-first](/Features/BumpSslServerFirst) |
| | | |
| **Deprecated in 3.2** | | |
| TBD | cachemgr_passwd | Security is better controlled by login [acl](http://www.squid-cache.org/Doc/config/acl) in the [http_access](http://www.squid-cache.org/Doc/config/http_access) configuration |
| TBD | cachemgr.cgi | Merger of report functionality into the main squid process obsoletes it as a stand-alone application. |
| 6.0 | UFS cache auto-upgrade | Unused since [Squid-3.2](/Releases/Squid-3.2). |
| | | |
| **Deprecated in 3.1** | | |
| TBD | error_directory files with named languages | Superseded by ISO-639 translations in [langpack](/Translations) |
| TBD | Netmask Support in ACL | CIDR or RFC-compliant netmasks are now required by 3.1. Netmask support full removal yet to be decided. |
| 3.5 | dnsserver and DNS external helper API | Internal DNS client now appears to satisfy all use-cases. |
| 3.2 | Multiple languages per error page. | Superseded by auto-negotiation in 3.1+ |
| 3.2 | TPROXYv2 Support | TPROXYv4 available from 3.1 and native Linux kernels |
| 3.1 | libcap 1.x | libcap-2.09+ is required for simpler code and proper API usage. |
| 3.1 | cache_dir null | Default for cache_dir has been changed to not using a disk cache. |
| | | |
| **Deprecated in Squid-3.0 or earlier** | | |
| 6.0 | recv-announce tool | Broken code since Squid-2.5. |
| 6.0 | cache_diff tool | Unused for some years. |
| 6.0 | CPU profiler | Broken feature. Superseded by external tools (eg oprofile). |
| 6.0 | leakfinder | Superseded by external tools (eg valgrind). |
| 6.0 | membanger tool | Has not built for many years. |
| 6.0 | pconn-banger tool | Has not built for many years. |
| 6.0 | tcp-banger2 tool | Has not built for many years. |
| 6.0 | tcp-banger3 tool | Has not built for many years. |
| 6.0 | tcp-banger.pl tool | Superseded by squidclient, wget, curl, and others. |
