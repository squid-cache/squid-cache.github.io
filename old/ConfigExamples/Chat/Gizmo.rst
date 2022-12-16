# CategoryToUpdate
= Gizmo Project (Pidgeon IM, Fring, Taler, ICQ, IRC, AOL)  =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

## <<TableOfContents>>

Gizmo Project include software to connect to a wide range of messaging protocols and VoIP services.
This config does not include settings to block those IM which are not Gizmo Project provided services.

see Also:
 * [[../Aol|AOL]]
 * [[../Icq|ICQ]]
 * IRC

If you know of other IM services available through Gizmo software please inform us.

== Squid Configuration File ==

Configuration file to Include:

{{{
# Gizmo Project
acl gizmo dstdomain .gizmoproject.com

# Gizmo VoIP
acl gizmo dstdomain .talqer.com .gizmocall.com .fring.com

# Gizmo Chat
acl gizmo dstdomain .pidgin.im

http_access deny gizmo

}}}

----
CategoryConfigExample
