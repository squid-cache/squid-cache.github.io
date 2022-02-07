# CategoryToUpdate
= Blocking Content Based on MIME Types =

== Synopsis ==

A popular request is to block certain content types from being served to clients. Squid currently can not do "content inspection" to decide on the file type based on the contents, but it is able to block HTTP replies based on the servers' content MIME Type reply.

The MIME Type reply is generally set correctly so browsers are able to pass the reply to the correct module (image, text, html, flash, music, mpeg, etc.)

== Example: Blocking Flash Video ==

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

 {i} Note that the reply mime-type is "text/html" because the error page being returned is HTML rather than the original flash video.

=== Thanks ===

Thanks to AdrianChadd for this basic outline; please feel free to apply for a Wiki Editor account and update the page!

##please use [[MailTo(address AT domain DOT tld)]] for mail addresses; this will help hide them from spambots
----
CategoryKnowledgeBase
