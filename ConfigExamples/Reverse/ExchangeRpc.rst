##master-page:CategoryTemplate
#format wiki
#language en

## This is a template for helping with new configuration examples. Remove this comment and add some descriptive text. A title is not necessary as the WikiPageName is already added here.

= Configuring Squid to Accelerate/ACL RPC over HTTP =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

Squid can be used as an accelerator and ACL filter in front of an exchange server exporting mail via RPC over HTTP. The RPC_IN_DATA and RPC_OUT_DATA methods communicate with https://URL/rpc/rpcproxy.dll, for if there's need to limit the access..

== Squid Configuration File ==

{{{

# Define the required extension methods
extension_methods RPC_IN_DATA RPC_OUT_DATA

# Publish the RPCoHTTP service via SSL
https_port ip_of_squid:443 cert=/path/to/certificate defaultsite=rpcohttp.url.com

cache_peer ip_of_exchange_server parent 443 0 no-query originserver login=PASS ssl sslcert=/path/to/certificate name=the_exchange_server

acl EXCH dstdomain .rpcohttp.url.com

cache_peer_access the_exchange_server allow EXCH
cache_peer_access the_exchange_server deny all

# Lock down access to just the Exchange Server!
http_access allow EXCH
http_access deny all
miss_access allow EXCH
miss_access deny all

never_direct allow EXCH


}}}

== Thanks to ==

Thanks to Tuukka Laurikanien <t.laurikainen@ibermatica.com> for providing the information used in preparing this article.

----
CategoryConfigExample
