## page was renamed from ConfigExamples/Authenticate
##master-page:CategoryTemplate
#format wiki
#language en

= Configuring Squid to authenticate against multiple services =

by ''Joseph Spadavecchia''

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==
We have a requirement to use different authentication mechanisms 
based on the subnet/ip-address of the client.

For example;
 A client from one subnet would authenticate against NTLM.
 While a client from another subnet would authenticate against an LDAP server.

To date this is normally done by running multiple instances of squid; 
but we have the requirement to do it with a single instance.  One way 
of achieving this would be to modify squid to pass the client's 
ip-address along with the authentication information.  However, I'd 
like to do it cleanly without modifying squid.

I created a custom authenticator that always returns "OK" and linked it 
to the external acl.

== Squid Configuration ==

{{{
auth_param basic program /usr/local/bin/my-auth.pl

external_acl_type myAclType %SRC %LOGIN %{Proxy-Authorization} /usr/local/bin/my-acl.pl

acl MyAcl external myAclType

http_access allow MyAcl
}}}

 * {i} myAclType's dependence on '''%LOGIN''' is required for triggering authentication and, thus, setting '''%{Proxy-Authorization}'''.


=== my-auth.pl ===
{{{
#!/usr/bin/perl -Wl

$|=1;

while (<>) {
        print "OK";
}
}}}

=== my-acl.pl ===
{{{
#!/usr/bin/perl -Wl

use URI::Escape;
use MIME::Base64;

$|=1;

while (<>) {
        ($ip,$user,$auth) = split();
        $auth = uri_unescape($auth);
        ($type,$authData) = split(/ /, $auth);
        $authString = decode_base64($authData);
        ($username,$password) = split(/:/, $authString);
       
        print my_awsome_auth($ip, $username, $password);
}
}}}


----
CategoryConfigExample
