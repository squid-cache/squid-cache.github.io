Describe EliezerCroitoru/Drafts/SSLBUMP here.

In order to use sslbump in intercept or tproxy mode there are couple things that should be known and done.

On compilation of squid add the flags "--enable-ssl enable-ssl-crtd" to configure.

Create a selfs signed root CA certificate and create a der format public certificate for clients.

* note that for mobile devices there might be a need for another certificate format then der.

Since squid 3.4 there is an option wich called bump-server-first which instructs squid to first try to identify the certificate properties aginst the origin server.

The above is good to allow a much more effective bumping and certificate mimicing.

How to use ssl-bump with squid 3.4?
 
{{{
#!highlight bash
#!/usr/bin/env bash
set -x 
SQUIDCONF=/etc/squid/squid.conf
SSLCRTD=/usr/lib64/squid/ssl_crtd
SSLCRTDDB=/var/lib/ssl_db

echo "The global variables"
echo $SQUIDCONF
echo $SSLCRTD
echo $SSLCRTDDB

echo "creating directories"
mkdir -p /etc/squid/ssl_cert /var/lib

echo "about to create certificate..."
cd /etc/squid/ssl_cert
openssl req -new -newkey rsa:1024 -days 365 -subj "/C=IL/ST=Shomron/L=Karney Shomron/O=NgTech LTD/CN=ytgv.ngtech.co.il" \
	-nodes -x509 -keyout myCA.pem  -out myCA.pem 
echo "creating der x509 certificate format"
openssl x509 -in myCA.pem -outform DER -out myCA.der
echo "the next is the certificate for client in x509 format:"
cat myCA.pem

echo "initializing ssl_crtd_db"
$SSLCRTD -c -s $SSLCRTDDB

echo "changing ownership for ssl_db"
chown -R nobody $SSLCRTDDB

echo "adding settings into squid.conf"
grep "^sslcrtd_program" $SQUIDCONF
if [ "$?" -eq "1" ];then
echo "https_port 13128 intercept ssl-bump generate-host-certificates=on dynamic_cert_mem_cache_size=16MB  cert=/etc/squid/ssl_cert/myCA.pem
http_port 23128  ssl-bump generate-host-certificates=on dynamic_cert_mem_cache_size=16MB  cert=/etc/squid/ssl_cert/myCA.pem
sslcrtd_program $SSLCRTD -s $SSLCRTDDB -M 16MB
sslcrtd_children 10
ssl_bump server-first all
#sslproxy_cert_error allow all
#sslproxy_flags DONT_VERIFY_PEER" >> $SQUIDCONF
else
 echo "There is already sslcrtd settings"
fi

set +x
}}}


iptables rules for intercept https proxy
{{{
#!highlight bash
IPTABLES=/sbin/iptables
LAN_INT="eth1"
$IPTABLES -I PREROUTING 1 -i $LAN_INT -p tcp -m tcp --dport 443 -j REDIRECT --to-ports 13128
}}}


squid.conf example from 3.5.25
{{{
request_header_access Surrogate-Capability deny all

forwarded_for transparent
via off
dns_v4_first on
visible_hostname filter
strip_query_terms off
acl ms_v6test_doms dstdomain ipv6.msftncsi.com
deny_info 503:/etc/squid/503.html ms_v6test_doms

http_port 13128 ssl-bump \
  cert=/etc/squid/ssl_cert/myCA.pem \
  generate-host-certificates=on dynamic_cert_mem_cache_size=4MB
acl DiscoverSNIHost at_step SslBump1
acl NoSSLIntercept ssl::server_name_regex -i "/etc/squid/server-regex.nobump"

ssl_bump splice NoSSLIntercept

ssl_bump peek DiscoverSNIHost
#ssl_bump peek step1
ssl_bump bump all

sslcrtd_program /usr/lib64/squid/ssl_crtd -s /var/lib/ssl_db -M 4MB

sslcrtd_children 10

sslproxy_cert_error allow all
sslproxy_flags DONT_VERIFY_PEER

read_ahead_gap 64 MB
}}}
