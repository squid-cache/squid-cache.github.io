## page was renamed from ConfigExamples/Intercept/CiscoIOSv11Wccp
##master-page:CategoryTemplate
#format wiki
#language en

## This is a template for helping with new configuration examples. Remove this comment and add some descriptive text. A title is not necessary as the WikiPageName is already added here.

= Configure Cisco IOS 11.x router for WCCP Interception =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

## == Outline ==

## start feature include
== Cisco IOS 11.x router ==

For very old versions of IOS you will need this config:

{{{
conf t
wccp enable
!
interface [Interface carrying Outgoing Traffic]x/x
!
ip wccp web-cache redirect
!
CTRL Z
copy running-config startup-config
}}}
## end feature include

----
CategoryConfigExample
