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
== Pre-requisites ==
 1. Install kerberos client package
 1. Install msktutil package from http://dag.wieers.com/rpm/packages/msktutil/
 1. Create keytab for HTTP/fqdn with msktutil.

{{{
kinit administrator@DOMAIN

msktutil -c -b "CN=COMPUTERS" -s HTTP/<fqdn> -h <fqdn> -k /etc/squid/HTTP.keytab --computer-name squid-HTTP --upn HTTP/<fqdn> --server <domain controller> --verbose
}}}
 * /!\ beware the wrap! above 'mskutil' options are meant to be on one line.

== krb5.conf Configuration ==
 * /!\ In IE the proxy must be specified as FQDN not as an IP-address
 * {i} rc4-hmac should be listed as encryption type.

A minimal setup without DNS resolution of AD servers would be:

{{{
[libdefaults]
      default_realm = WIN2003R2.HOME
      dns_lookup_kdc = no
      dns_lookup_realm = no
      default_keytab_name = /etc/krb5.keytab
      default_tgs_enctypes = rc4-hmac des-cbc-crc des-cbc-md5
      default_tkt_enctypes = rc4-hmac des-cbc-crc des-cbc-md5
      permitted_enctypes = rc4-hmac des-cbc-crc des-cbc-md5
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
Add the following to the squid startup script

{{{
KRB5_KTNAME=/etc/squid/HTTP.keytab
export KRB5_KTNAME
}}}
Kerberos keeps a replay cache to detect the reuse of Kerberos tickets (usually only possible in a 5 minute window) . If squid is under high load with Negotiate(Kerberos) proxy authentication requests the replay cache checks can create high CPU load. If the environment does not require high security the replay cache check can be disabled for MIT based Kerberos implementations by adding the following to the startup script

{{{
KRB5RCACHETYPE=none
export KRB5RCACHETYPE
}}}
----
 . CategoryConfigExample
