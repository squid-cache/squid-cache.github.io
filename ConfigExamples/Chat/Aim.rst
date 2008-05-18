##master-page:CategoryTemplate
#format wiki
#language en
## This is a template for helping with new configuration examples. Remove this comment and add some descriptive text. A title is not necessary as the WikiPageName is already added here.
= Securing Instant Messengers =
<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==
Administrators often need to permit or block the use of IM (Instant Messengers) within Enterprises. While most use proprietary protocols and do not enter the Squid proxy at all, some have a port-80 failover mode, or may be explicitly configured to use a non-transparent proxy.

== MSN Messenger ==
MSN Messenger natively uses port 1863 and bypasses the Squid proxy. But when that has been locked down by the firewall admin it will failover to port 80 and enter Squid.

The ACL to identify and harness MSN traffic within squid is:

{{{
acl msnmime req_mime_type ^application/x-msn-messenger
acl msngw url_regex -i gateway.dll
}}}


== AOL Instant Messenger (AIM) ==
AIM natively uses TCP port 5190 and bypasses the Squid proxy.  When configured to use an explicit proxy, it will use CONNECT tunneling to go through squid.

The ACLs to identify and permit AIM traffic within squid are:

{{{
# Permit AOL Instant Messenger to connect to the OSCAR service
acl AIM_ports port 5190 443
acl AIM_domains dstdomain .oscar.aol.com .blue.aol.com
acl AIM_domains dstdomain .messaging.aol.com .aim.com
acl AIM_hosts dstdomain  login.oscar.aol.com login.glogin.messaging.aol.com
acl AIM_nets dst 64.12.0.0/255.255.0.0 205.188.0.0/255.255.0.0
acl AIM_methods method CONNECT
http_access allow AIM_methods AIM_ports AIM_nets
http_access allow AIM_methods AIM_ports AIM_hosts
http_access allow AIM_methods AIM_ports AIM_domains
always_direct allow AIM_hosts
always_direct allow AIM_nets
always_direct allow AIM_domains
}}}

----
 CategoryConfigExample
