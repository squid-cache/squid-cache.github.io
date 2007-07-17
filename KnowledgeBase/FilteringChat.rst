##master-page:KnowledgeBaseTemplate
##Page-Creation-Date:[[Date(2007-07-17T03:50:05Z)]]
##Page-Original-Author:AdrianChadd
#format wiki
#language en

= Filtering Chat usage through Squid =

'''Synopsis'''

This is an article in progress. Please contact AdrianChadd if you'd like to contribute to this article.

Many Squid users are interested in filtering MSN, Yahoo, Google, Skype and similar protocols through the proxy server. Squid is a HTTP proxy and thus can only filter HTTP - so this relies on:

 * General desktops/workstations aren't able to directly connect to the internet; and
 * All their internet access is manually configured to use Squid as a HTTP proxy.

Assuming this holds true, you may be able to filter a number of chat related protocols. The best way to do this in your environment is to use a few chat programs, monitor your access logs and block sites appropriately.

This article is intended to be a guide to help Squid Administrators configure filters applicable to their environment. If you notice these instructions are incomplete or incorrect then please feel free to request editor privileges and update the information.

'''Example ACL set'''

One example ACL set, provided by Norman Noah, attempts to block a number of protocols. Please note this hasn't been verified by the article author (and thus he'd appreciate feedback!)

(Be careful; some ACL lines unfortunate wrap.)

{{{
# we have to allow ftp access using proxy since yahoo messenger can
# connect to ftp or telnet port without proxy.
ftp_user user@domain.com
ftp_list_width 64
ftp_passive on
acl ftp proto FTP

# yahoo messenger                                                                                         
acl ym dstdomain .messenger.yahoo.com .psq.yahoo.com .us.il.yimg.com .msg.yahoo.com .pager.yahoo.com                                                                           
acl ym dstdomain .rareedge.com .ytunnelpro.com .chat.yahoo.com .voice.yahoo.com                                                                                          
acl ym dstdomain .skype.com .imvu.com
acl ymregex url_regex yupdater.yim ymsgr myspaceim

#msn messenger                                                                                            
acl msn url_regex -i gateway.dll messenger.msn.com gateway.messenger.hotmail.com                                                                             
acl msn1 req_mime_type ^application/x-msn-messenger$

# (since ftp are using numeric ips so blocking skype throught numeric
# ips must be exact by ending with :443 )
#skype
acl numeric_IPs url_regex ^[0-9]+.[0-9]+.[0-9]+.[0-9]+:443
acl Skype_UA browser ^skype^

#aol
acl aol dst 64.12.200.89/32 205.188.153.121/32 205.188.179.233/32 64.12.161.153/32 64.12.161.185/32                                                                         

# Trillian
acl trillian dst 66.216.70.167/32

#Gizmoproject & voip                                                                                      
acl gizmo dstdomain .gizmoproject.com .talqer.com .gizmocall.com .fring.com .pidgin.im                                                                                    
acl gizmo dstdomain .icq.com

# streaming download
acl fails rep_mime_type ^.*mms.*
acl fails rep_mime_type ^.*ms-hdr.*
acl fails rep_mime_type ^.*x-fcs.*
acl fails rep_mime_type ^.*x-ms-asf.*
acl fails2 urlpath_regex dvrplayer mediastream mms://
acl fails2 urlpath_regex \.asf$ \.afx$ \.flv$

}}}

Then, the HTTP access section:

{{{
## allow ftp ip                                                                                           
http_access deny local ftp                                                                                
http_access allow ftp                                                                                     
http_reply_access allow ftp                                                                               
                                                                                                          
#chat program                                                                                             
http_access deny ym                                                                                       
http_reply_access deny ym                                                                                 
http_access deny ymregex                                                                                  
http_reply_access deny ymregex                                                                            
                                                                                                          
http_access deny msn                                                                                      
http_access deny msn1                                                                                     
http_reply_access deny msn                                                                                
http_reply_access deny msn1                                                                               
http_access deny aol                                                                                      
http_reply_access deny aol                                                                                
http_access deny trillian                                                                                 
http_reply_access deny trillian                                                                           
http_access deny gizmo                                                                                    
http_reply_access deny gizmo                                                                              
http_access deny numeric_IPS                                                                              
http_reply_access deny numeric_IPS                                                                        
http_access deny Skype_UA                                                                                 
                                                                                                          
#streaming files                                                                                          
http_access deny fails                                                                                    
http_reply_access deny fails                                                                              
http_access deny fails2                                                                                   
http_reply_access deny fails2                                                                             
}}}





'''Thanks'''

Thanks to [[Mailto(norman DOT noah AT gmail)]] for the initial set of example ACLs.

----
CategoryKnowledgeBase
