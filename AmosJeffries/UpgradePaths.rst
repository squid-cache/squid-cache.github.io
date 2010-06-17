## page was renamed from WikiSandBox/UpgradePaths
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

When this graph shows that ALL 2.x binaries including 'squid' have all their paths leading clearly to the 3.x we will have completed the feature portage.

|| '''Binary''' || '''Portage Pathway''' ||
||<|2> sbin/squid   || 2.5 > 3.0 > 3.1 > 3.2 || >:> ||
|| 2.5 > 2.6 > (2.7 | 3.1 > 3.2) || X-( some few features. performance tweaks ||
|| bin/squidclient  || 2.5 > (2.6 | 3.0) > 2.7 > 3.1 || >:> ||
|| bin/cachemgr.cgi || 2.5 > (2.6 > 2.7 | 3.0 ) > 3.1 || >:> ||
|| libexec/pinger   || 2.5 > 2.6 > 2.7 > 3.0 > 3.1 || >:> /!\ strictly matches sbin/squid ||
|| libexec/squid_kerb_auth || 2.5 > 2.6 > (2.7|3.0) > 3.1 || >:> ||
|| errors/* || 2.5 > 2.6 > 2.7 > 3.0 > 3.1 || >:> ||
|| icons/* || 2.5 > 2.6 > 2.7 > 3.0 > 3.1 || >:> ||

|| libexec/diskd   || 2.5 > 2.6 > 2.7 > 3.0 > 3.1 || >:> /!\ strictly matches sbin/squid ||
|| libexec/unlinkd || 2.5 > 2.6 > 2.7 > 3.0 > 3.1 || >:> /!\ strictly matches sbin/squid ||

|| helpers/basic_auth/DB || 2.5 > 2.6 > (2.7 | 3.1) > 3.2 || >:> ||
|| helpers/basic_auth/getpwnam || 2.5 > 2.6 > (2.7 | 3.1) > 3.2 || >:> ||
|| helpers/basic_auth/LDAP || 2.5 > 2.6 > (2.7 | 3.1) > 3.2 || <:( ||
|| helpers/basic_auth/MSNT || 2.5 > 2.6 > (2.7 | 3.1) > 3.2 || >:> ||
|| helpers/basic_auth/mswin_sspi || 2.5 > 2.6 > (2.7 | 3.1) > 3.2 || >:> ||
|| helpers/basic_auth/multi-domain-NTLM || 2.5 > 2.6 > (2.7 | 3.1) > 3.2 || >:> ||
|| helpers/basic_auth/NCSA || 2.5 > 2.6 > (2.7 | 3.1) > 3.2 || >:> ||
|| helpers/basic_auth/PAM || 2.5 > 2.6 > (2.7 | 3.1) > 3.2 || >:> ||
|| helpers/basic_auth/POP3 || 2.5 > 2.6 > (2.7 | 3.1) > 3.2 || >:> ||
|| helpers/basic_auth/SASL || 2.5 > 2.6 > (2.7 | 3.1) > 3.2 || >:> ||
|| helpers/basic_auth/SMB || 2.5 > 2.6 > (2.7 | 3.1) > 3.2 || >:> ||
|| helpers/basic_auth/squid_radius_auth || 2.5 > 2.6 > (2.7 | 3.1) > 3.2 || >:> ||
|| helpers/basic_auth/YP || 2.5 > 2.6 > (2.7 | 3.1) > 3.2 || >:> ||

|| helpers/digest_auth/eDirectory || 2.5 > 2.6 > (2.7 | 3.1) > 3.2 || <:( ||
|| helpers/digest_auth/ldap || 2.5 > 2.6 > (2.7 | 3.1) > 3.2 || <:( ||
|| helpers/digest_auth/password || 2.5 > 2.6 > (2.7 | 3.1) > 3.2 || >:> ||

|| helpers/external_acl/ip_user || 2.5 > 2.6 > (2.7 | 3.1) > 3.2 || >:> ||
|| helpers/external_acl/ldap_group || 2.5 > 2.6 > (2.7 | 3.1) > 3.2 || <:( ||
|| helpers/external_acl/mswin_ad_group || 2.5 > 2.6 > (2.7 | 3.1) > 3.2 || >:> ||
|| helpers/external_acl/mswin_lm_group || 2.5 > 2.6 > (2.7 | 3.1) > 3.2 || >:> ||
|| helpers/external_acl/session || 2.5 > 2.6 > (2.7 | 3.1) > 3.2 || >:> ||
|| helpers/external_acl/unix_group || 2.5 > 2.6 > (2.7 | 3.1) > 3.2 || >:> ||
|| helpers/external_acl/wbinfo_group || 2.5 > 2.6 > (2.7 | 3.1) > 3.2 || >:> ||

|| helpers/negotiate_auth/mswin_sspi || 2.5 > 2.6 > (2.7 | 3.1) > 3.2 || >:> ||

|| helpers/ntlm_auth/fakeauth || 2.5 > 2.6 > (2.7 | 3.1) > 3.2 || >:> ||
|| helpers/ntlm_auth/mswin_sspi || 2.5 > 2.6 > (2.7 | 3.1) > 3.2 || >:> ||
|| helpers/ntlm_auth/no_check || 2.5 > 2.6 > (2.7 | 3.1) > 3.2 || >:> ||
|| helpers/ntlm_auth/smb_lm || 2.5 > 2.6 > (2.7 | 3.1) > 3.2 || >:> ||
|| helpers/ntlm_auth/smb_lm/smbval || 2.5 > 2.6 > (2.7 | 3.1) > 3.2 || >:> ||

Stuff still to check...

|| ./contrib/Makefile.am installed files ||
|| ./src/fs/Makefile.am installed files ||
|| ./src/auth/Makefile.am installed files ||

./contrib:
        squid.options \
        config.site \
        squid.rc \
        rredir.c \
        rredir.pl \
        user-agents.pl \
        url-normalizer.pl \


## TODO the rest. all the helpers...  fs module components. all the feature components.
