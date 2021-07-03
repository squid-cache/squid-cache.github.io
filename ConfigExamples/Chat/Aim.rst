# CategoryToUpdate
= AOL Instant Messenger (AIM) =
<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

## <<TableOfContents>>

== Details ==
AIM natively uses TCP port 5190 and bypasses the Squid proxy.  When configured to use an explicit proxy, it will use CONNECT tunneling to go through squid.

== Squid Configuration File ==

{{{

# Permit AOL Instant Messenger to connect to the OSCAR service
acl AIM_ports port 5190 443

acl AIM_domains dstdomain .oscar.aol.com .blue.aol.com
acl AIM_domains dstdomain .messaging.aol.com .aim.com

acl AIM_nets dst 64.12.0.0/16 205.188.0.0/16

http_access allow CONNECT AIM_ports AIM_nets
http_access allow CONNECT AIM_ports AIM_domains

}}}

----
 CategoryConfigExample
