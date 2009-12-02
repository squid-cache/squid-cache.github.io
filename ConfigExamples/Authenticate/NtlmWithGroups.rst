##master-page:CategoryTemplate
#format wiki
#language en

= Configure Squid for NTLM with Group-Based Access controls =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

To perform group-based access controls you need to already have NTLM authentication configured and working on a per-user basis.

Details on how to do that are covered in:
 * [[ConfigExamples/Authenticate/Ntlm]]
 * [[ConfigExamples/Authenticate/WindowsActiveDirectory]]

== Squid Configuration File ==

Create and ACL for checking the group access:
{{{
external_acl_type testForNTGroup %LOGIN /usr/local/squid/libexec/wbinfo_group.pl

acl inGroupX external testForNTGroup someGroupNameX
}}}

and to use the ACL as you would any other authentication ACL
{{{
http_access allow inGroupX
}}}


----
CategoryConfigExample
