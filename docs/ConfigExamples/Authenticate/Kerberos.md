---
categories: [ConfigExample]
---
# Configuring a Squid Server to authenticate against Kerberos

by *Markus Moeller*

> :warning: Need to extract linked images and embed them

## Outline

Two helpers are bundled with the Squid sources:
- `negotiate_kerberos_auth` for Squid running on Unix/Linux systems
- `mswin_negotiate_auth.exe` ffor Squid running on Windows systems

The following documentation applies to the helper Unix/Linux systems.
The Windows helper doesnot need any kind of configuration, it works just
out of the box.

## Pre-requisites for Active Directory integration

Install msktutil package from http://fuhm.net/software/msktutil/ or
https://code.google.com/p/msktutil/, or install [Samba](http://www.samba.org/)

## krb5.conf Configuration

> :warning: In IE the proxy must be specified as FQDN not as an IP-address
> :information_source: `rc4-hmac` should be listed as encryption type for windows 2003.

A minimal setup without DNS resolution of AD servers would be (MIT
Kerberos example):

```
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
```

## Create keytab

1. Create keytab for HTTP/fqdn with msktutil. (If used together with
    samba net join use another computer name than the hostname used by
    net join)

        kinit administrator@DOMAIN
        msktutil -c -b "CN=COMPUTERS" -s HTTP/<fqdn> -h <fqdn> -k /etc/squid/HTTP.keytab --computer-name squid-http --upn HTTP/<fqdn> --server <domain controller> --verbose

    or for Windows 2008 for AES support

        msktutil -c -b "CN=COMPUTERS" -s HTTP/<fqdn> -h <fqdn> -k /etc/squid/HTTP.keytab --computer-name squid-http --upn HTTP/<fqdn> --server <domain controller> --verbose --enctypes 28
```

> :warning: \<computer-name\> has Windows Netbios limitations of 15
    characters.
> :warning: `msktutil` requires the `cyrus-sasl-gssapi` ldap plugin to authenticate to
    AD ldap.
> :warning: because of a bug in `msktutil` 0.3.16 the \<computer-name\> must be
    lowercase

OR with Samba

1. Join host to domain with net ads join
1. Create keytab for HTTP/fqdn with net ads keytab

```
kinit administrator@DOMAIN

export KRB5_KTNAME=FILE:/etc/squid/HTTP.keytab

net ads keytab CREATE
net ads keytab ADD HTTP

unset KRB5_KTNAME
```

> :warning: Do not use this method if you run winbindd or other samba services
  as samba will reset the machine password every x days and thereby
  makes the keytab invalid !

OR with MIT/Heimdal `kdamin` tool

## Squid Configuration File

Paste the configuration file like this:
```
auth_param negotiate program /usr/sbin/squid_kerb_auth
auth_param negotiate children 10
auth_param negotiate keep_alive on
```
The basic auth ACL controls to make use of it are:
```
acl auth proxy_auth REQUIRED

http_access deny !auth
http_access allow auth
http_access deny all
```
Add the following to the squid startup script (Make sure the keytab is
readable by the squid process owner e.g. chgrp squid
/etc/squid/HTTP.keytab; chmod g+r /etc/squid/HTTP.keytab )
```
KRB5_KTNAME=/etc/squid/HTTP.keytab
export KRB5_KTNAME
```
Kerberos can keep a replay cache to detect the reuse of Kerberos tickets
(usually only possible in a 5 minute window) . If squid is under high
load with Negotiate(Kerberos) proxy authentication requests the replay
cache checks can create high CPU load. If the environment does not
require high security the replay cache check can be disabled for MIT
based Kerberos implementations by adding the following to the startup
script
```
KRB5RCACHETYPE=none
export KRB5RCACHETYPE
```
## Troubleshooting Tools

On Windows clients (e.g. IE or Firefox on XP, 2003, etc) use `kerbtray`
or `klist` from Microsoft resource kit to list and purge tickets.

`Wireshark` traffic on port 88 (Kerberos) to identify Kerberos errors.
(`KRB5KDC_ERR_PREAUTH_REQUIRED` is not an error, but an informational
message to the client)

## Further references

- A nice HOWTO is available at
  http://klaubert.wordpress.com/2008/01/09/squid-kerberos-authentication-and-ldap-authorization-in-active-directory/

## Step by Step Overview

1. User login to Desktop

- From Windows PC to Windows Active Directory as user \<userid\>
  selecting Netbios domainname DOMAIN
- From Unix PC using kinit or pam to Windows Active Directory as
  user \<userid@DOMAIN.COM\>
- From Windows PC to Unix Key Distribution Centre (KDC) as
  \<userid\> selecting Netbios domainname DOMAIN
- From Unix PC using kinit or pam to Unix Key Distribution Centre
  (KDC) as user <userid@DOMAIN.COM>
- Any of the above will create an AS Request/AS Reply exchange
  ![Squid-1.jpeg](/assets/images/squid-1.png)

1. User requests URL from Squid

- Send GET or PUT or any other request via Squid
- Squid (if setup correctly) replies with Proxy-Authenticate:
  Negotiate
  ![Squid-3.jpeg](/assets/images/squid-3.jpg)

1. Desktop attempts to get a Service ticket HTTP/\<squid-fqdn\> from
  KDC as user \< <userid@DOMAIN.COM> \>
  ![Squid-2.jpeg](/assets/images/squid-2.jpg)

1. Desktop sends request to Squid

- With Proxy-Authorization: Negotiate \<base64 encoded Kerberos
  token\> if previous step 3. was successful
- With Proxy-Authorization: Negotiate \<base64 encoded NTLM
  token\> if previous step 3. was not successful (not further
  discussed here. See NTLM documentation)
  ![Squid-9.jpeg](/assets/images/squid-9.jpg)

1. Squid verifies Kerberos ticket with help of keytab and replies after
    checking any additional access control settings
    The ticket contains the the user detail \< <userid@DOMAIN.COM> \>
    and squid can do authorisation decision based on it
    ![Squid-10.jpeg](/assets/images/squid-10.jpg)

1. Step 2., 4. and 5. continue until the Kerberos cache with the
    received AS and TGS replies expires after about 8 hours (This
    depends on your kdc settings and/or your kinit options) and step 1.
    and 3 need to be done again which is usually transparent on Windows
    but may require a new kinit on Unix.

If squid_kerb_ldap is used the following steps are happening

1. Squid "login" to Windows Active Directory or Unix kdc as user
    \<HTTP/\<fqdn-squid\>@DOMAIN.COM\>. This requires Active Directory
    to have an attribute userPrincipalname set to
    \<HTTP/\<fqdn-squid\>@DOMAIN.COM\> for the associated account. This
    is usaully done by using msktutil.

    ![Squid-4.jpeg](/assets/images/squid-4.jpg)

1. Squid determines ldap server from DNS by looking at SRV records

    ![Squid-7.jpeg](/assets/images/squid-7.jpg)

1. Squid connects to ldap server

    ![Squid-6.jpeg](/assets/images/squid-7.jpg)

1. If Kerberos authentication is supported by the ldap server Squid
    will request a service ticket \<ldap/\<ldap-server-fqdn\> as user
    \<HTTP/\<squid-fqdn\>@DOMAIN.COM\>

    ![Squid-5.jpeg](/assets/images/squid-5.jpg)

1. Squid sends LDAP search requests and receives replies using Kerberos
    authentication to the ldap server

    ![Squid-6.jpeg](/assets/images/squid-6.jpg)
