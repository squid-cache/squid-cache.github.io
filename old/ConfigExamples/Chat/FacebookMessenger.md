*by
[YuriVoinov](https://wiki.squid-cache.org/ConfigExamples/Chat/FacebookMessenger/YuriVoinov#)*

# Facebook Messenger

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Outline

[Facebook Messenger](https://messenger.com) is FB instant messaging
application. Using it may be prohibited by corporate security policy.

## Usage

Usually Facebook Messenger works in most Squid's setups without any
additional configuration. Blocking it, however, require some additional
steps. To block Facebook Messengert, you require SSL Bump-aware squid,
or, at least,
[peek-n-splice](https://wiki.squid-cache.org/Features/SslPeekAndSplice)
configuration.

## Squid Configuration File

`SSL Bump-aware setup`

Paste the configuration file like this:

    # Block Facebook messenger
    acl deny_fb_im dstdomain .messenger.com
    http_access deny deny_fb_im
    deny_info TCP_RESET deny_fb_im

`Peek-and-splice setup`

If you prefer not to put proxy certificate to clients, you can configure
your proxy like this:

    # Peek-n-splice rules
    acl facebook_messenger ssl::server_name .messenger.com
    acl DiscoverSNIHost at_step SslBump1
    
    ssl_bump peek DiscoverSNIHost
    ssl_bump terminate facebook_messenger
    ssl_bump splice all

then reconfigure Squid.

This is enough to make Facebook Messenger fully unoperable, also as
Web-version.

[CategoryConfigExample](https://wiki.squid-cache.org/ConfigExamples/Chat/FacebookMessenger/CategoryConfigExample#)
