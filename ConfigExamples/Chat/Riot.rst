##master-page:CategoryTemplate
#format wiki
#language en

''by YuriVoinov''

= Riot Messenger =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

[[https://riot.im|Riot Instant Messenger]] is open-source end-to-end encryption messenger/VoIP/group chats/file transfers application. Using it may be prohibited by corporate security policy.

== Usage ==

Usually Riot works in most Squid's setups without any additional configuration. Blocking it, however, require some additional steps.
To block Riot, you require SSL Bump-aware squid, or, at least, [[https://wiki.squid-cache.org/Features/SslPeekAndSplice|peek-n-splice]] configuration.

== Squid Configuration File ==

```SSL Bump-aware setup```

Paste the configuration file like this:

{{{

# Block Riot.im
acl riot dstdomain .riot.im .matrix.org
http_access deny riot
deny_info TCP_RESET riot

}}}

```Peek-and-splice setup```

If you prefer not to put proxy certificate to clients, you can configure your proxy like this:

{{{

# Peek-n-splice rules
acl DiscoverSNIHost at_step SslBump1
# Splice specified servers
acl TerminateThis ssl::server_name_regex .riot\.im .martix\.org
ssl_bump peek DiscoverSNIHost
ssl_bump terminate TerminateThis
ssl_bump splice all

}}}

then reconfigure Squid.

This is enough to make Riot fully unoperable with default server(s).

----
CategoryConfigExample
