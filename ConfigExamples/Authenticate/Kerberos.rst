##master-page:CategoryTemplate
#format wiki
#language en

= Configuring a Squid Server to authenticate from Kerberos =

by ''Markus Moeller''

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

Squid-2.6 and later are capable of performing Kerberos authentication (for example with Windows Vista).

For Squid-3.1 and later the helper is bundled with the Squid sources. Earlier Squid require squid_kerb_auth from https://sourceforge.net/project/showfiles.php?group_id=196348

## == Usage ==

## Tell about some cases where this configuration would be good.

== Pre-requisites ==

 1. Install kerberos client package
 2. Install msktutil package from http://dag.wieers.com/rpm/packages/msktutil/
 3. Create keytab for HTTP/fqdn with msktutil.
{{{
kinit administrator@DOMAIN

msktutil -c -b "CN=COMPUTERS" -s HTTP/<fqdn> -h <fqdn> -k /etc/squid/HTTP.keytab --computer-name squid-HTTP --upn HTTP/<fqdn> --server <domain controller> --verbose
}}}
 * /!\ beware the wrap! above 'mskutil' options are meant to be on one line.


== krb5.conf Configuration ==

 Yet to be written.

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

----
CategoryConfigExample
