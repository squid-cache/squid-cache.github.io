##master-page:CategoryTemplate
#format wiki
#language en

= Skype Access Controls =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

## <<TableOfContents>>

== Squid Configuration File ==

Configuration file to include.

 /!\ Since FTP uses numeric IPs the Skype ACL must be exact including the port.

=== Blocking ===
{{{
# Skype

acl numeric_IPs dstdom_regex ^(([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)|(\[([0-9af]+)?:([0-9af:]+)?:([0-9af]+)?\])):443
acl Skype_UA browser ^skype

http_access deny numeric_IPS
http_access deny Skype_UA

}}}

 /!\ Recent releases of Skype have been evading the above restriction by not sending their User-Agent headers and using domain names. The following can be used to catch those installs, but be aware it will likely also catch other agents.
{{{
acl validUserAgent browser \S+
http_access deny !validUserAgent
}}}

=== Permitting ===

 /!\ This needs to be done before any restrictive CONNECT http_access controls.

{{{
acl numeric_IPs dstdom_regex ^(([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)|(\[([0-9af]+)?:([0-9af:]+)?:([0-9af]+)?\])):443
acl Skype_UA browser ^skype

http_access allow CONNECT localnet numeric_IPS Skype_UA
}}}

 {i} Note that Skype prefers the '''port 443''' which is by default enabled in Squid anyway so this configuration is only needed when you block HTTPS access through the proxy.

If you limit HTTPS access to known sites only, then permitting Skype will break that policy.

----
CategoryConfigExample
