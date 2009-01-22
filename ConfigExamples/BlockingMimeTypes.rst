## page was renamed from KnowledgeBase/BlockingMimeTypes
##master-page:KnowledgeBaseTemplate
##Page-Creation-Date:[[Date(2007-07-13T15:58:18Z)]]
##Page-Original-Author:AdrianChadd
#format wiki
#language en

= Blocking Content Based on MIME Types =

'''Synopsis'''

A popular request is to block certain content types from being served to clients. Squid currently can not do "content inspection" to decide on the file type based on the contents, but it is able to block HTTP replies based on the servers' content MIME Type reply.

The MIME Type reply is generally set correctly so browsers are able to pass the reply to the correct module (image, text, html, flash, music, mpeg, etc.)

'''Example: Blocking Flash Video'''

One popular example is to block flash video, used by sites such as Youtube.

The MIME type for such content is "video/flv". Creating an ACL to block this is easy.

First, create an ACL which matches the MIME type in question.

{{{ 
acl deny_rep_mime_flashvideo rep_mime_type video/flv
}}}

Then create a HTTP Reply ACL which denies any replies with that MIME type:

{{{
http_reply_access deny deny_rep_mime_flashvideo
}}}

This has been verified to block Youtube flash video content.

If the content is blocked the following similar line will be seen in access.log:

{{{
1184342357.997    542 192.168.1.129 TCP_DENIED_REPLY/403 2411 GET http://74.125.15.26/get_video?video_id=fzDmJpCt9dE - DIRECT/74.125.15.26 text/html
}}}

Note that the reply mime-type is "text/html" because the error page being returned is HTML rather than the original flash video.

The configuration: Squid-3.0PRE6 (and Squid-2.6.STABLE12); transparent interception using WCCPv2. This should also work when configured non-transparently as long as browsers are forced to use the proxy.

{{{
 http_port 127.0.0.1:3128 transparent
 http_port 192.168.1.9:3128
 icp_port 3130
 hierarchy_stoplist cgi-bin ?
 acl QUERY urlpath_regex cgi-bin \?
 cache deny QUERY
 cache_mem 64 MB
 cache_dir aufs /data/1/cache 4096 64 256
 refresh_pattern ^ftp:           1440    20%     10080
 refresh_pattern ^gopher:        1440    0%      1440
 refresh_pattern .               0       20%     4320
 acl all src 0.0.0.0/0.0.0.0
 acl manager proto cache_object
 acl localhost src 127.0.0.1/255.255.255.255
 acl to_localhost dst 127.0.0.0/8
 acl SSL_ports port 443
 acl Safe_ports port 80          # http
 acl Safe_ports port 21          # ftp
 acl Safe_ports port 443         # https
 acl Safe_ports port 70          # gopher
 acl Safe_ports port 210         # wais
 acl Safe_ports port 1025-65535  # unregistered ports
 acl Safe_ports port 280         # http-mgmt
 acl Safe_ports port 488         # gss-http
 acl Safe_ports port 591         # filemaker
 acl Safe_ports port 777         # multiling http
 acl CONNECT method CONNECT
 
 acl deny_rep_mime_type rep_mime_type video/flv
 http_reply_access deny deny_rep_mime_type

 http_access allow manager localhost
 http_access deny manager
 http_access deny !Safe_ports
 http_access deny CONNECT !SSL_ports
 acl our_networks src 192.168.0.0/16 127.0.0.1/32
 http_access allow our_networks
 http_access deny all
 http_reply_access allow all
 icp_access allow all
 buffered_logs off
 coredump_dir /home/adrian/work/squid/run3/var/cache
 wccp2_router 192.168.1.1
 wccp2_forwarding_method 1
 wccp2_return_method 1
 wccp2_service standard 0
 wccp2_rebuild_wait off
 debug_options ALL,1
 strip_query_terms off
 logfile_rotate 365
 # SNMP configuration
 snmp_port 3401
 acl snmppublic snmp_community public
 snmp_access allow snmppublic localhost
 snmp_access deny all
}}}





'''Thanks'''

Thanks to AdrianChadd for this basic outline; please feel free to apply for a Wiki Editor account and update the page!

##please use [[MailTo(address AT domain DOT tld)]] for mail addresses; this will help hide them from spambots
----
CategoryKnowledgeBase
