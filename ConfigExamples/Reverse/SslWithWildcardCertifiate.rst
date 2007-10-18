##master-page:CategoryTemplate
#format wiki
#language en
## This is a template for helping with new configuration examples. Remove this comment and add some descriptive text. A title is not necessary as the WikiPageName is already added here.
= Configuring Squid as SSL Reverse Proxy With Wild Card Certificate to Support Multiple Web Site =
[[Include(ConfigExamples, , from="^## warning begin", to="^## warning end")]]

[[TableOfContents]]

== Outline ==
Squid can be configured to provide Reverse SSL Proxy Feature . This can talk to http or https websites hosted at the back of it . For this configuration I will be using Squid-2.6 STABLE 13 release .

== Setup ==
This Example Involves hosting 3 Websites Using Wildcard Certificate. The Wild Card Certificate will be Generated on the same server on which Squid will be installed also the same will be acting as a CA for Signing the Certificates .

For this Following information will be required

 * IP Address of the Squid Server ( Squid is installed at default location .i.e /usr/local/squid/ )
 * IP and the Hostname for all the 3 Servers
 * Openssl installed on the same server
== Squid Configuration ==
Please note that the https_port and cache_peer lines may wrap in your browser!

https_port 443 cert=/usr/newrprgate/CertAuth/testcert.cert key=/usr/newrprgate/CertAuth/testkey.pem defaultsite=[http://mywebsite.mydomain.com/ mywebsite.mydomain.com] vhost
cache_peer [http://10.112.62.20/ 10.112.62.20] parent 80 0 no-query originserver login=PASS name=[http://websitea.mydomain.com/ websiteA.mydomain.com]
 acl sites_server_1 dstdomain [http://websitea.mydomain.com/ websiteA.mydomain.com]
 cache_peer_access [http://websitea.mydomain.com/ websiteA.mydomain.com]
 allow sites_server_1
 cache_peer [http://10.112.143.112/ 10.112.143.112] parent 80 0 no-query originserver login=PASS name=[http://mywebsite.mydomain.com/ mywebsite.mydomain.com]
 acl sites_server_2 dstdomain [http://mywebsite.mydomain.com/ mywebsite.mydomain.com]
cache_peer_access [http://mywebsite.mydomain.com/ mywebsite.mydomain.com]
allow sites_server_2
 acl webserver dst [http://10.112.62.20/ 10.112.62.20] [http://10.112.143.112/ 10.112.143.112]
 http_access allow webserver
 http_access allow all
 miss_access allow webserver
 miss_access deny all
 http_access allow manager localhost
 http_access deny manager
 http_access deny all

== Squid Configuration File ==
Paste the configuration file like this:

{{{
acl all src 0.0.0.0/0.0.0.0
acl manager proto cache_object
acl localhost src 127.0.0.1/255.255.255.255
http_access deny all

}}}
----
CategoryConfigExample
