##master-page:KnowledgeBaseTemplate
##Page-Creation-Date:[[Date(2007-07-13T15:58:18Z)]]
##Page-Original-Author:AdrianChadd
#format wiki
#language en

= Blocking Content Based on Mime Types =

'''Synopsis'''

A popular request is to block certain content types from being served to clients. Squid currently can not do "content inspection" to decide on the file type based on the contents, but it is able to block HTTP replies based on the servers' content Mime Type reply.

The Mime Type reply is generally set correctly so browsers are able to pass the reply to the correct module (image, text, html, flash, music, mpeg, etc.)

Please note that this will not correctly function for any SSL content as Squid does not see the unencrypted data.
 

'''Examples'''

''''Blocking Flash Video''''

The following configuration has been verified with Squid-2.6 and Squid-3.0.

First, create an ACL matching on flash video MIME replies:

acl deny_rep_mime_flashvideo rep_mime_type video/flv

Then create a HTTP Reply ACL which denies any replies with that MIME type:

http_reply_access deny deny_rep_mime_flashvideo

This has been verified to block Youtube flash video content.



'''Thanks'''

Thanks to AdrianChadd for this basic outline; please feel free to apply for a Wiki Editor account and update the page!

##please use [[MailTo(address AT domain DOT tld)]] for mail addresses; this will help hide them from spambots
----
CategoryKnowledgeBase
