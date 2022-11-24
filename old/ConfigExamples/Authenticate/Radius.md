---
categories: ConfigExample
---
# Configuring a Squid Server to authenticate from RADIUS

By Askar Ali Khan

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Outline

In this example a squid installation will use RADIUS
"squid\_radius\_auth" Squid RADIUS authentication helper to authenticate
users before allowing them to surf the web. For security reasons users
need to enter their username and password before they are allowed to
surf the internet.

## Squid Installation

Install squid using your distro package management system or using
source.

Make sure squid is compiled with
**--enable-basic-auth-helpers="squid\_radius\_auth"** option which is
only available in Squid-2.6.STABLE17 and later.

## Create radius configuration file

The configuration specifies how the helper connects to RADIUS. The file
contains a list of directives (one per line). Lines beginning with a \#
is ignored. The radius configuration file will contain...

    server radiusserver: specifies the name or address of the RADIUS server to connect to.
    
    secret somesecretstring: specifies the shared RADIUS secret.
    
    identifier nameofserver: specifies what the proxy should identify itsels as to the RADIUS server.  This directive is optional (optional)
    
    port portnumber: Specifies the port number or  service name where the helper should connect. (default to 1812)

Here is my radius config: /etc/radius\_config

    server 192.168.10.20
    secret someSecret

## Test the squid\_radius\_auth helper

Before making changes to squid.conf its better to test the helper from
command line.

    /usr/local/squid/libexec/squid_radius_auth -f /etc/radius_config

Or, if you are not using configuration file then ...

    /usr/local/squid/libexec/squid_radius_auth -h 192.168.10.20 -w someSecret

Type your radius username/password on the same line separated with
space, on successful authentication it will give "OK" otherwise "ERR
login failure"

## squid.conf Configuration

    auth_param basic program /usr/local/squid/libexec/squid_radius_auth -f /etc/radius_config
    auth_param basic children 5
    auth_param basic realm Web-Proxy
    auth_param basic credentialsttl 5 minute
    auth_param basic casesensitive off
    
    
    acl radius-auth proxy_auth REQUIRED
    http_access allow radius-auth
    http_access allow localhost
    http_access deny all

[CategoryConfigExample](/CategoryConfigExample)
