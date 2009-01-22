## page was renamed from ConfigExamples/SquidAndLDAP
## page was renamed from ConfigExamples/ConfigExamples/SquidAndLDAP
##master-page:CategoryTemplate
#format wiki
#language en

= Configuring a Squid Server to authenticate off OpenLDAP =
By Askar Ali Khan

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==
In this example a squid installation will use LDAP to authenticate users before allowing them to surf the web. For security reasons users need to enter their username and password before they are allowed to surf the internet.

== Usage ==

In this example we assume OpenLDAP has been configured to disallow anonymous search, one must bind before doing any searches. we will use squid_ldap_auth (Squid LDAP authentication helper) which allow squid to connect to a LDAP directory to validate the user name and password of Basic HTTP authentication. 

== Squid Configuration File ==

First edit squid.conf so that authentication against LDAP works

 /!\ The first config line below wraps, it is meant to be one long line.
{{{

auth_param basic program /usr/lib/squid/squid_ldap_auth -v 3 -b "dc=yourcompany,dc=com" -D uid=some-user,ou=People,dc=yourcompany,dc=com  -w password -f uid=%s ldap.yourcompany.com

auth_param basic children 5
auth_param basic realm Web-Proxy
auth_param basic credentialsttl 1 minute

acl ldap-auth proxy_auth REQUIRED

http_access allow ldap-auth
http_access allow localhost
http_access deny all

}}}

 || {i} || If you want to use the anonymous LDAP binding method then just don't specify the bind DN (-D option, and it's related -w option) ||

In case you are looking for a solution to authenticate Squid's users on an Ldap server through a SSL/TLS secure channel then pass -ZZ argument to squid_ldap_auth program. For more information see the squid_ldap_auth manual

 {i} Note: You should have generated your SSL certs and placed it under /etc/openldap/cacerts directory on squid server before using secure channel authentication. Remember that this only secures the traffic Squid<->LDAP Server, not browsers<->Squid. For SSL/TLS your squid_ldap_auth line will look like...

{{{
auth_param basic program /usr/lib/squid/squid_ldap_auth -v 3 -ZZ -b "dc=yourcompany,dc=com" -D uid=some-user,ou=People,dc=yourcompany,dc=com  -w password -f uid=%s ldap.yourcompany.com
}}}
----
CategoryConfigExample
