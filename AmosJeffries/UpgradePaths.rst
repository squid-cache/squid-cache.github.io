#language en

= Upgrade Paths =

Squid installs a number of independent binaries and helpers. I've been trying to break the Squid2 vs Squid-3 portage problem down into components.

This page lists each helper and a BNF of its version upgrade paths. Assuming the latest release of each version is used.

|| KEY: || ||
|| A > D || means D version supercedes A. ||
|| A > ( B | C ) || means B and C have thing non-ported but both supersede A ||
|| A > ( B | C ) > D || means B and C have alternate features which are now merged into D. ||
|| X-( || portage needed to fix this path. ||
|| <:( || IIRC, double check ||
|| >:> || Perfect. ||

When this graph shows that ALL binaries including 'squid' have a path leading to the same D we have completed the feature portage.

|| '''Binary''' || '''Portage Pathway''' ||
||<|2> sbin/squid   || 2.5 > 3.0 > 3.1 || >:> ||
|| 2.5 > 2.6 > (2.7 | 3.1) || X-( so many features. performance tweaks ||
|| bin/squidclient  || 2.5 > (2.6 | 3.0) > 2.7 > 3.1 || >:>||
|| bin/cachemgr.cgi || 2.5 > (2.6 > 2.7 | 3.0 ) > 3.1 || <:( ||
|| libexec/pinger   || 2.5 > 2.6 > 2.7 > 3.0 > 3.1 || >:> /!\ strictly matches sbin/squid ||
|| libexec/squid_kerb_auth || 2.5 > 2.6 > (2.7|3.0) > 3.1 || >:> ||
|| errors/* || 2.5 > 2.6 > 2.7 > 3.0 > 3.1 || >:> ||
|| icons/* || 2.5 > 2.6 > 2.7 > 3.0 > 3.1 || >:> ||

|| libexec/diskd ||
|| libexec/unlinkd ||


./helpers:
Makefile.am
./helpers/basic_auth:
Makefile.am
./helpers/basic_auth/DB:
Makefile.am
./helpers/basic_auth/getpwnam:
Makefile.am
./helpers/basic_auth/LDAP:
Makefile.am
./helpers/basic_auth/MSNT:
Makefile.am
./helpers/basic_auth/mswin_sspi:
Makefile.am
./helpers/basic_auth/multi-domain-NTLM:
Makefile.am
./helpers/basic_auth/NCSA:
Makefile.am
./helpers/basic_auth/PAM:
Makefile.am
./helpers/basic_auth/POP3:
Makefile.am
./helpers/basic_auth/SASL:
Makefile.am
./helpers/basic_auth/SMB:
Makefile.am
./helpers/basic_auth/squid_radius_auth:
Makefile.am
./helpers/basic_auth/YP:
Makefile.am
./helpers/digest_auth:
Makefile.am
./helpers/digest_auth/eDirectory:
Makefile.am
./helpers/digest_auth/ldap:
Makefile.am
./helpers/digest_auth/password:
Makefile.am
./helpers/external_acl:
Makefile.am
./helpers/external_acl/ip_user:
Makefile.am
./helpers/external_acl/ldap_group:
Makefile.am
./helpers/external_acl/mswin_ad_group:
Makefile.am
./helpers/external_acl/mswin_lm_group:
Makefile.am
./helpers/external_acl/session:
Makefile.am
./helpers/external_acl/unix_group:
Makefile.am
./helpers/external_acl/wbinfo_group:
Makefile.am
./helpers/negotiate_auth:
Makefile.am
./helpers/negotiate_auth/mswin_sspi:
Makefile.am
./helpers/ntlm_auth:
Makefile.am
./helpers/ntlm_auth/fakeauth:
Makefile.am
./helpers/ntlm_auth/mswin_sspi:
Makefile.am
./helpers/ntlm_auth/no_check:
Makefile.am
./helpers/ntlm_auth/smb_lm:
Makefile.am
./helpers/ntlm_auth/smb_lm/smbval:
Makefile.am


Stuff still to check...

|| ./contrib/Makefile.am installed files ||
|| ./src/fs/Makefile.am installed files ||
|| ./src/auth/Makefile.am installed files ||
|| ./helper/*/*/Makefile.am installed files ||


./contrib:
        squid.options \
        config.site \
        squid.rc \
        rredir.c \
        rredir.pl \
        user-agents.pl \
        url-normalizer.pl \
        nextstep/Makefile \
        nextstep/Makefile.real \
        nextstep/README \
        nextstep/Squid.pkg.README \
        nextstep/info.in \
        nextstep/makepkg \
        nextstep/post_install \
        nextstep/pre_install



## TODO the rest. all the helpers...  fs module components. all the feature components.
