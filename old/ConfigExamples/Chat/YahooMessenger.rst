# CategoryToUpdate
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


## Original config had a comment about needing global FTP access
## for Yahoo!Messenger blocking to work...

## But that seems illogical.

##{{{
## we have to allow ftp access using proxy since yahoo messenger can
## connect to ftp or telnet port without proxy.
##ftp_user user@domain.com
##ftp_list_width 64
##ftp_passive on
##acl ftp proto FTP
##}}}

##Then, the HTTP access section:

##{{{
## allow ftp ip
##http_access deny local ftp
##http_access allow ftp
##http_reply_access allow ftp
##}}}

----
CategoryConfigExample
