# Configuring a Squid Server to authenticate off LDAP

By Askar Ali Khan

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Outline

In this example a squid installation will use LDAP to authenticate users
before allowing them to surf the web. For security reasons users need to
enter their username and password before they are allowed to surf the
internet.

## Usage

In this example we assume OpenLDAP has been configured to disallow
anonymous search, one must bind before doing any searches. We will use
squid\_ldap\_auth (Squid LDAP authentication helper) which allow squid
to connect to a LDAP directory to validate the user name and password of
Basic HTTP authentication.

## Squid Configuration File

First edit squid.conf so that authentication against LDAP works

  - ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    The first config line below wraps, it is meant to be one long line.

<!-- end list -->

    auth_param basic program /usr/lib/squid/squid_ldap_auth -v 3 -b "dc=yourcompany,dc=com" -D uid=some-user,ou=People,dc=yourcompany,dc=com  -w password -f uid=%s ldap.yourcompany.com
    
    auth_param basic children 5
    auth_param basic realm Web-Proxy
    auth_param basic credentialsttl 1 minute
    
    acl ldap-auth proxy_auth REQUIRED
    
    http_access allow ldap-auth
    http_access allow localhost
    http_access deny all

  - 
    
    |                                                                        |                                                                                                                                  |
    | ---------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
    | ![{i}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-info.png) | If you want to use the anonymous LDAP binding method then just don't specify the bind DN (-D option, and it's related -w option) |
    

### SSL/TLS adjustments

In case you are looking for a solution to authenticate Squid's users on
an Ldap server through a SSL/TLS secure channel then pass -ZZ argument
to squid\_ldap\_auth program. For more information see the
squid\_ldap\_auth manual

  - ![{i}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-info.png)
    Note: You should have generated your SSL certs and placed it under
    /etc/openldap/cacerts directory on squid server before using secure
    channel authentication. Remember that this only secures the traffic
    Squid\<-\>LDAP Server, not browsers\<-\>Squid. For SSL/TLS your
    squid\_ldap\_auth line will look like...
    
    ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    The config line below wraps, it is meant to be one long line.

<!-- end list -->

    auth_param basic program /usr/lib/squid/squid_ldap_auth -v 3 -ZZ -b "dc=yourcompany,dc=com" -D uid=some-user,ou=People,dc=yourcompany,dc=com  -w password -f uid=%s ldap.yourcompany.com

### Windows 2003 Active Directory adjustments

Windows 2003 AD also supports LDAP authentication. Some adjustment to
the search filter is needed to map to the Microsoft way of naming
things...

  - ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    The config line below wraps, it is meant to be one long line.

<!-- end list -->

    auth_param basic program /usr/lib/squid/squid_ldap_auth -v 3 -b ou="something",ou=something,dc=svbmt,dc=net -D cn=LDAPUSER,ou="Generic User Accounts",ou=something",dc=svbmt,dc=net -w password -f sAMAccountName=%s -h ldap.yourcompany.com

[CategoryConfigExample](https://wiki.squid-cache.org/ConfigExamples/Authenticate/Ldap/CategoryConfigExample#)
