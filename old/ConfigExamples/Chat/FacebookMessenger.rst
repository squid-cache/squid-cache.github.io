# CategoryToUpdate
''by YuriVoinov''

= Facebook Messenger =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==
[[https://messenger.com|Facebook Messenger]] is FB instant messaging application. Using it may be prohibited by corporate security policy.

== Usage ==


Usually Facebook Messenger works in most Squid's setups without any additional configuration. Blocking it, however, require some additional steps.
To block Facebook Messengert, you require SSL Bump-aware squid, or, at least, [[https://wiki.squid-cache.org/Features/SslPeekAndSplice|peek-n-splice]] configuration.

== Squid Configuration File ==

```SSL Bump-aware setup```

Paste the configuration file like this:

{{{

# Block Facebook messenger
acl deny_fb_im dstdomain .messenger.com
http_access deny deny_fb_im
deny_info TCP_RESET deny_fb_im

}}}

```Peek-and-splice setup```

If you prefer not to put proxy certificate to clients, you can configure your proxy like this:

{{{

# Peek-n-splice rules
acl facebook_messenger ssl::server_name .messenger.com
acl DiscoverSNIHost at_step SslBump1

ssl_bump peek DiscoverSNIHost
ssl_bump terminate facebook_messenger
ssl_bump splice all

}}}

then reconfigure Squid.

This is enough to make Facebook Messenger fully unoperable, also as Web-version.

----
CategoryConfigExample
