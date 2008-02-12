##master-page:CategoryTemplate
#format wiki
#language en

## This is a template for helping with new configuration examples. Remove this comment and add some descriptive text. A title is not necessary as the WikiPageName is already added here.

= Securing Instant Messengers =

[[Include(ConfigExamples, , from="^## warning begin", to="^## warning end")]]

[[TableOfContents]]

== Outline ==

Administrators often need to secure or block the use of IM (Instant Messengers) within Enterprises. While most use proprietary protocols and do not enter the Squid proxy at all. Some do have a port-80 failover mode which may need to be locked down.

== MSN Messenger ==

MSN Messenger natively uses port 1863 and bypasses the Squid proxy. But when that has been locked down by the firewall admin it will failover to port 80 and enter Squid.

The ACL to identify and harness MSN traffic within squid is:
{{{
acl msnmime req_mime_type ^application/x-msn-messenger
acl msngw url_regex -i gateway.dll
}}}

----
CategoryConfigExample
