##master-page:CategoryTemplate
#format wiki
#language en

''by YuriVoinov''

= Viber Messenger =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

[[https://viber.com|Viber Messenger]] is end-to-end encryption messenger/VoIP/group chats/file transfers application. Using it may be prohibited by corporate security policy.

== Usage ==

Usually Viber works in most Squid's setups without any additional configuration. Blocking it, however, require some additional steps.
To block Viber, you require SSL Bump-aware squid, or, at least, [[https://wiki.squid-cache.org/Features/SslPeekAndSplice|peek-n-splice]] configuration.

== Squid Configuration File ==

Paste the configuration file like this:

{{{

# Block Viber
acl deny_viber ssl::server_name_regex .viber\.com
acl DiscoverSNIHost at_step SslBump1
ssl_bump peek DiscoverSNIHost
ssl_bump terminate deny_viber
ssl_bump splice all

}}}

then reconfigure Squid.

This is enough to make Viber fully unoperable (both desktop/mobile).

----
CategoryConfigExample
