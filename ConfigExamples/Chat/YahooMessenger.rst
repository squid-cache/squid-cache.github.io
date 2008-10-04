##master-page:CategoryTemplate
#format wiki
#language en

= Yahoo! Messenger =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

## <<TableOfContents>>

== Squid Configuration File ==

Configuration file to Include:

{{{

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

}}}

----
CategoryConfigExample
