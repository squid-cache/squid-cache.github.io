##master-page:CategoryTemplate
#format wiki
#language en
= Configuring a Squid Server to authenticate from Kerberos =
by ''Markus Moeller''

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==
Squid-2.6 and later are capable of performing Kerberos authentication (for example with Windows Vista).

For Squid-2.7 and later two helpers are bundled with the Squid sources:

 * '''squid_kerb_auth''' for Unix/Linux systems
 * '''mswin_negotiate_auth.exe''' for Windows systems

Earlier Squid require squid_kerb_auth from https://sourceforge.net/project/showfiles.php?group_id=196348

The following documentation applies to squid_kerb_auth on Unix/Linux systems, on Windows mswin_negotiate_auth.exe doesn't need any kind of configuration, it works just out of the box.

## == Usage ==
## Tell about some cases where this configuration would be good.
== Pre-requisites for Active Directory integration ==
Install msktutil package from http://fuhm.net/software/msktutil/.

 . or

Install Samba

== krb5.conf Configuration ==
 * /!\ In IE the proxy must be specified as FQDN not as an IP-address
 * {i} rc4-hmac should be listed as encryption type for windows 2003.

A minimal setup without DNS resolution of AD servers would be (MIT Kerberos example):

{{{
[libdefaults]
      default_realm = WIN2003R2.HOME
      dns_lookup_kdc = no
      dns_lookup_realm = no
      default_keytab_name = /etc/krb5.keytab
; for Windows 2003
      default_tgs_enctypes = rc4-hmac des-cbc-crc des-cbc-md5
      default_tkt_enctypes = rc4-hmac des-cbc-crc des-cbc-md5
      permitted_enctypes = rc4-hmac des-cbc-crc des-cbc-md5

; for Windows 2008 with AES
;      default_tgs_enctypes = aes256-cts-hmac-sha1-96 rc4-hmac des-cbc-crc des-cbc-md5
;      default_tkt_enctypes = aes256-cts-hmac-sha1-96 rc4-hmac des-cbc-crc des-cbc-md5
;      permitted_enctypes = aes256-cts-hmac-sha1-96 rc4-hmac des-cbc-crc des-cbc-md5
;
; for MIT/Heimdal kdc no need to restrict encryption type

[realms]
      WIN2003R2.HOME = {
              kdc = w2k3r2.win2003r2.home
              admin_server = w2k3r2.win2003r2.home
      }

[domain_realm]
      .linux.home = WIN2003R2.HOME
      .win2003r2.home = WIN2003R2.HOME
      win2003r2.home = WIN2003R2.HOME

[logging]
  kdc = FILE:/var/log/kdc.log
  admin_server = FILE:/var/log/kadmin.log
  default = FILE:/var/log/krb5lib.log
}}}
== Create keytab ==
 1. Create keytab for HTTP/fqdn with msktutil. (If used together with samba net join use another computer name than the hostname used by net join)

{{{
kinit administrator@DOMAIN

msktutil -c -b "CN=COMPUTERS" -s HTTP/<fqdn> -h <fqdn> -k /etc/squid/HTTP.keytab --computer-name squid-http --upn HTTP/<fqdn> --server <domain controller> --verbose

or for Windows 2008 for AES support

msktutil -c -b "CN=COMPUTERS" -s HTTP/<fqdn> -h <fqdn> -k /etc/squid/HTTP.keytab --computer-name squid-http --upn HTTP/<fqdn> --server <domain controller> --verbose --enctypes 28
}}}
 * /!\ beware the wrap! above 'mskutil' options are meant to be on one line.
 * /!\ beware the <computer-name> has Windows Netbios limitations of 15 characters.
 * /!\ msktutil requires cyrus-sasl-gssapi ldap plugin to authenticate to AD ldap.
 * /!\ because of a bug in msktutil 0.3.16 the <computer-name> must be lowercase

OR with Samba

 1. Join host to domain with net ads join
 1. Create keytab for HTTP/fqdn with net ads keytab

{{{
kinit administrator@DOMAIN

export KRB5_KTNAME=FILE:/etc/squid/HTTP.keytab

net ads keytab CREATE
net ads keytab ADD HTTP

unset KRB5_KTNAME
}}}
 * /!\ Do not use this method if you run winbindd or other samba services as samba will reset the machine password every x days and thereby makes the keytab invalid !!

OR with MIT/Heimdal kdamin tool

== Squid Configuration File ==
Paste the configuration file like this:

{{{
auth_param negotiate program /usr/sbin/squid_kerb_auth
auth_param negotiate children 10
auth_param negotiate keep_alive on
}}}
The basic auth ACL controls to make use of it are:

{{{
acl auth proxy_auth REQUIRED

http_access deny !auth
http_access allow auth
http_access deny all
}}}
Add the following to the squid startup script (Make sure the keytab is readable by the squid process owner e.g. chgrp squid /etc/squid/HTTP.keytab; chmod g+r /etc/squid/HTTP.keytab )

{{{
KRB5_KTNAME=/etc/squid/HTTP.keytab
export KRB5_KTNAME
}}}
Kerberos can keep a replay cache to detect the reuse of Kerberos tickets (usually only possible in a 5 minute window) . If squid is under high load with Negotiate(Kerberos) proxy authentication requests the replay cache checks can create high CPU load. If the environment does not require high security the replay cache check can be disabled for MIT based Kerberos implementations by adding the following to the startup script

{{{
KRB5RCACHETYPE=none
export KRB5RCACHETYPE
}}}
== Troubleshooting Tools ==
On Windows clients (e.g. IE or Firefox on XP, 2003, etc) use __kerbtray__ or __klist__ from Microsoft resource kit to list and purge tickets.

__Wireshark__ traffic on port 88 (Kerberos) to identify Kerberos errors. (KRB5KDC_ERR_PREAUTH_REQUIRED is not an error, but an informational message to the client)

== Further references ==
 * A nice HOWTO is available at http://klaubert.wordpress.com/2008/01/09/squid-kerberos-authentication-and-ldap-authorization-in-active-directory/

== Step by Step Overview ==
 * Login to Desktop which will create an AS Request/AS Reply exchange
  * Windows PC to Windows Active Directory as user <userid> selecting Netbios domainname DOMAIN
  * Unix PC using kinit or pam to Windows Active Directory as user < userid@DOMAIN.COM >
  * Windows PC to Unix Key Distribution Centre (KDC) as <userid> selecting Netbios domainname DOMAIN
  * Unix PC using kinit or pam to Unix Key Distribution Centre (KDC) as user < userid@DOMAIN.COM >
 {{attachment:Squid-1.jpeg}}

 * Request a URL from squid
  * Send GET or PUT or any other request via Squid
  * Squid (if setup correctly) replies with Proxy-Authenticate: Negotiate

         {{attachment:Squid-3.jpeg}}

 * Desktop attempts to get a Service ticket HTTP/<squid-fqdn> from KDC as user userid@DOMAIN.COM <<BR>>

----

CategoryConfigExample
