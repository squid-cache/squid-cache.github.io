---
categories: ConfigExample
---
# Yahoo\! Messenger

Warning: Any example presented here is provided "as-is" with no support
or guarantee of suitability. If you have any further questions about
these examples please email the squid-users mailing list.

## Squid Configuration File

Configuration file to Include:

    # Yahoo! Messenger
    acl ym dstdomain .messenger.yahoo.com .psq.yahoo.com
    acl ym dstdomain .us.il.yimg.com .msg.yahoo.com .pager.yahoo.com
    acl ym dstdomain .rareedge.com .ytunnelpro.com .chat.yahoo.com
    acl ym dstdomain .voice.yahoo.com
    
    acl ymregex url_regex yupdater.yim ymsgr myspaceim
    
    # Other protocols Yahoo!Messenger uses ??
    acl ym dstdomain .skype.com .imvu.com
    
    http_access deny ym
    http_access deny ymregex

[CategoryConfigExample](/CategoryConfigExample)
