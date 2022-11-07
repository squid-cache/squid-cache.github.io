# Bypass Authentication for certain sites

Warning: Any example presented here is provided "as-is" with no support
or guarantee of suitability. If you have any further questions about
these examples please email the squid-users mailing list.

## Outline

A very common setup in forward proxy design calls for two different
access classes:

  - some destinations should be available to all users

  - all other destinations should require users to authenticate

Squid allows for this kind of setup, by simply setting your access-lists
in the right order.

## Squid Configuration File

First recommendation is to get acquainted with the basic notions of how
to configure squid to properly authenticate. Useful documentation can be
found at
[Features/Authentication](/Features/Authentication#),
and the manual pages for
[acl](http://www.squid-cache.org/Doc/config/acl#),
[auth\_param](http://www.squid-cache.org/Doc/config/auth_param#),
[http\_access](http://www.squid-cache.org/Doc/config/http_access#),
[http\_access2](http://www.squid-cache.org/Doc/config/http_access2#) and
[http\_reply\_access](http://www.squid-cache.org/Doc/config/http_reply_access#).

You may also want to
check[ConfigExamples/Authenticate/Kerberos](/ConfigExamples/Authenticate/Kerberos#),
[ConfigExamples/Authenticate/Ntlm](/ConfigExamples/Authenticate/Ntlm#)
for authentication-scheme-specific documentation.

Start by setting up Squid so that it authenticates all users to all
destinations, and once you are satisfied that it works to your liking,
you can act on the configuration file in a manner similar to this
example:

    # protect the cache manager, Safe_ports, SSL tunnels, then after the section marked as
    
    #
    # INSERT YOUR OWN RULE(S) HERE TO ALLOW ACCESS FROM YOUR CLIENTS
    #
    
    
    acl whitelist dstdomain .whitelist.com .goodsite.com .partnerssite.com
    acl http proto http
    acl port_80 port 80
    acl port_443 port 443
    acl CONNECT method CONNECT
    acl authenticated_users proxy_auth REQUIRED
    
    # rules allowing non-authenticated users
    http_access allow http port_80 whitelist
    http_access allow CONNECT port_443 whitelist
    
    # rules allowing authenticated users
    http_access allow http port_80 authenticated_users
    http_access allow CONNECT port_443 authenticated_users
    
    # catch-all rule
    http_access deny all

This snippet of configuration will allow http and https to the standard
service ports to any user which can successfully authenticate themselves
against your chosen authentication mechanisms.

The key is having all `http_access` rules that allow unauthenticated
users placed **before** those `http_access` rules which require
knowledge of the users' identity.

### a more complex example

The previous example can be extended to more complex scenarios. For
instance you may want to have two different user groups (let's call them
GroupA and GroupB) and three classes of sites: one class which must be
accessible to unauthenticated users, one which must be accessible to
users from GroupA and one which must be accessible to users from GroupB.
Notice that nothing prevents user groups or sites lists from
overlapping. Groups are kept in the squid configuration itself, using
auxiliary files.

This can be accomplished by using 6 configuration files:

*/etc/squid/groupa.txt*

    user1
    user2
    user3

*/etc/squid/groupb.txt*

    user1
    user4
    user5

*/etc/squid/sites.a.txt*

    .foo.example.com
    .bar.example.com

*/etc/squid/sites.b.txt*

    .foo.example.com
    .gazonk.example.com

*/etc/squid/sites.whitelist.txt*

    .public.example.com

*/etc/squid/squid.conf*

    # protect the cache manager, Safe_ports, SSL tunnels, then after the section marked as
    
    #
    # INSERT YOUR OWN RULE(S) HERE TO ALLOW ACCESS FROM YOUR CLIENTS
    #
    
    
    acl whitelist dstdomain "/etc/squid/sites.whitelist.txt"
    acl UsersGroupA proxy_auth "/etc/squid/groupa.txt"
    acl SitesGroupA dstdomain "/etc/squid/sites.a.txt"
    acl UsersGroupB proxy_auth "/etc/squid/groupb.txt"
    acl SitesGroupB dstdomain "/etc/squid/sites.b.txt"
    acl http proto http
    acl port_80 port 80
    acl port_443 port 443
    acl CONNECT method CONNECT
    acl authenticated_users proxy_auth REQUIRED
    
    # rules allowing non-authenticated users
    http_access allow http port_80 whitelist
    http_access allow CONNECT port_443 whitelist
    
    # rules allowing authenticated users
    http_access allow http port_80 SitesGroupA UsersGroupA
    http_access allow CONNECT port_443 SitesGroupA UsersGroupA
    http_access allow http port_80 SitesGroupB UsersGroupB
    http_access allow CONNECT port_443 SitesGroupB UsersGroupB
    
    # catch-all rule
    http_access deny all

This example configuration will allow any user access to whitelisted
sites without asking for identification, users in group A will be able
to access sites in list A, users in group B will be able to access sites
from group B and noone will be able to access anything else.

## Advanced configuration

The order of the http\_access clauses is important, as is important the
order of the acl's expressed in each http\_access clause: that's because
as soon as Squid has decided that a set of conditions is not met, it
will not evaluate the following ones. This can lead to very subtle
differences in behaviour.

Let's focus on a few lines from the second example (the ACL definitions
remain the same)

    http_access allow http port_80 whitelist
    http_access allow http port_80 SitesGroupA UsersGroupA
    http_access allow http port_80 SitesGroupB UsersGroupB
    # catch-all rule
    http_access deny all

and perform a small change:

    http_access allow http port_80 whitelist
    http_access allow http port_80 SitesGroupA UsersGroupA
    http_access allow http port_80 SitesGroupB UsersGroupB
    # catch-all rule
    http_access deny authenticated_users

The effect of this change is that access rights will remain the same:
groupA will get sitesA and groupB will get sitesB. The difference is
what happens when someone tries to access some site which is neither in
sitesA nor in sitesB: while with the former example they would get a
flat-out access denial, with this change they will be asked to provide a
password. They still get no access, but the way they are denied is
different.

Another possible change is:

    http_access allow http port_80 whitelist
    http_access allow UsersGroupA http port_80 SitesGroupA
    http_access allow UsersGroupB http port_80 SitesGroupB
    # catch-all rule
    http_access deny all

The behaviour changes again: users will need no authentication to access
whitelisted sites. As soon as they step outside whitelisted sites, they
will be asked for authentication (before they were only asked for it if
they tried to access a protected resource).
