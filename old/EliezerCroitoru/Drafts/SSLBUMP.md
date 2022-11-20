Describe EliezerCroitoru/Drafts/SSLBUMP here.

In order to use sslbump in intercept or tproxy mode there are couple
things that should be known and done.

On compilation of squid add the flags "--enable-ssl enable-ssl-crtd" to
configure.

Create a self signed root CA certificate and create a der format public
certificate for clients.

\* note that for mobile devices there might be a need for another
certificate format then der.

Since squid 3.4 there is an option which called bump-server-first which
instructs squid to first try to identify the certificate properties
against the origin server.

The above is good to allow a much more effective bumping and certificate
mimicking.

How to use ssl-bump with squid 4.1?

``` highlight
#!/usr/bin/env bash

set -x

DOMAIN="ngtech.co.il"
COUNTRYCODE="IL"
STATE="Shomron"
REGION="Center"
ORGINZATION="NgTech LTD"
CERTUUID=`uuidgen | awk 'BEGIN { FS="-"}; {print $1}'`
SUBJECDETAILS=`echo -n "/C=$COUNTRYCODE/ST=$STATE/L=$REGION/O=$ORGINAZATION/CN=px$CERTUUID.$DOMAIN"`


SQUIDCONF=/etc/squid/squid.conf
SSLCRTD=/usr/lib64/squid/security_file_certgen
SSLCRTDDB=/var/lib/ssl_db

echo "The global variables"
echo $SQUIDCONF
echo $SSLCRTD
echo $SSLCRTDDB

echo "creating directories"
mkdir -p /etc/squid/ssl_cert /var/lib

echo "about to create certificate..."
cd /etc/squid/ssl_cert
#openssl req -new -newkey rsa:1024 -days 365 -subj "/C=IL/ST=Shomron/L=Karney Shomron/O=NgTech LTD/CN=ytgv.ngtech.co.il" \
#        -nodes -x509 -keyout myCA.pem  -out myCA.pem

openssl req -new -newkey rsa:2048 -sha256 -days 365 -nodes -x509 -subj "$SUBJECDETAILS" \
    -extensions v3_ca -keyout myCA.pem  -out myCA.pem
echo "creating der x509 certificate format"
openssl x509 -in myCA.pem -outform DER -out myCA.der
echo "the next is the certificate for client in x509 format:"
cat myCA.pem

echo "initializing ssl_crtd_db"
$SSLCRTD -c -s $SSLCRTDDB -M 16MB

echo "changing ownership for ssl_db"
chown -R nobody $SSLCRTDDB

echo "adding settings into squid.conf"
touch "/etc/squid/server-regex.nobump"
grep "^sslcrtd_program" $SQUIDCONF
if [ "$?" -eq "1" ];then
echo "

http_port 13129 intercept
https_port 13128 intercept ssl-bump generate-host-certificates=on dynamic_cert_mem_cache_size=16MB  cert=/etc/squid/ssl_cert/myCA.pem

http_port 23128 ssl-bump generate-host-certificates=on dynamic_cert_mem_cache_size=16MB  cert=/etc/squid/ssl_cert/myCA.pem

sslcrtd_program $SSLCRTD -s $SSLCRTDDB -M 16MB
sslcrtd_children 10

acl DiscoverSNIHost at_step SslBump1
acl NoSSLIntercept ssl::server_name_regex -i "/etc/squid/server-regex.nobump"

ssl_bump splice NoSSLIntercept

ssl_bump peek DiscoverSNIHost
#ssl_bump peek step1
ssl_bump bump all" >> $SQUIDCONF
else
 echo "There is already sslcrtd settings"
fi

chown squid.squid -R $SSLCRTDDB
set +x
```

How to use ssl-bump with squid 3.4?

``` highlight
#!/usr/bin/env bash 

set -x

DOMAIN="ngtech.co.il"
COUNTRYCODE="IL"
STATE="Shomron"
REGION="Center"
ORGINZATION="NgTech LTD"
CERTUUID=`uuidgen | awk 'BEGIN { FS="-"}; {print $1}'`
SUBJECDETAILS=`echo -n "/C=$COUNTRYCODE/ST=$STATE/L=$REGION/O=$ORGINAZATION/CN=px$CERTUUID.$DOMAIN"`

 
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
#openssl req -new -newkey rsa:1024 -days 365 -subj "/C=IL/ST=Shomron/L=Karney Shomron/O=NgTech LTD/CN=ytgv.ngtech.co.il" \
#        -nodes -x509 -keyout myCA.pem  -out myCA.pem
                
openssl req -new -newkey rsa:2048 -sha256 -days 365 -nodes -x509 -subj "$SUBJECDETAILS" \
    -extensions v3_ca -keyout myCA.pem  -out myCA.pem 
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

chown squid.squid -R $SSLCRTDDB
set +x
```

A nice script I wrote for initialization of
[RedWood](/RedWood)
proxy SSL-BUMP feature.

Couple things can be taken from the next script to enhance the above one
like the addition of a UUID to the CA certificate.

``` highlight
#!/usr/bin/env bash 

DOMAIN="ngtech.co.il"
COUNTRYCODE="IL"
STATE="Shomron"
REGION="Center"
ORGINZATION="NgTech LTD"
CERTUUID=`uuidgen | awk 'BEGIN { FS="-"}; {print $1}'`
SUBJECDETAILS=`echo -n "/C=$COUNTRYCODE/ST=$STATE/L=$REGION/O=$ORGINAZATION/CN=px$CERTUUID.$DOMAIN"`
source /etc/sysconfig/redwood
echo $SUBJECDETAILS
if [ -d "/etc/redwood/ssl-cert" ];then
  echo "Abort since /etc/redwood/ssl-cert exists"
  exit 1
else
  mkdir -p /etc/redwood/ssl-cert
  openssl req -new -newkey rsa:2048 -sha256 -days 365 -nodes -x509 -subj "$SUBJECDETAILS" \
    -extensions v3_ca -keyout /etc/redwood/ssl-cert/myCAkey.pem -out /etc/redwood/ssl-cert/myCAcert.pem
fi

egrep "^(tls-cert\ |tls-key\ )" /etc/redwood/redwood.conf 
if [ "$?" -eq "1" ];then
  echo "" >> /etc/redwood/redwood.conf
  echo "# ssl-bump tls key and certificate" >> /etc/redwood/redwood.conf
  echo "tls-cert /etc/redwood/ssl-cert/myCAcert.pem" >> /etc/redwood/redwood.conf
  echo "tls-key /etc/redwood/ssl-cert/myCAkey.pem" >> /etc/redwood/redwood.conf
  cat /etc/redwood/sslbump-defaultbypass-acls.conf /etc/redwood/acls.conf > /tmp/$CERTUUID-acls.conf
  cp /etc/redwood/acls.conf /etc/redwood/acls.conf.backup
  cp /tmp/$CERTUUID-acls.conf /etc/redwood/acls.conf
  systemctl restart redwood
else
  echo "some sslbump settings are already in-place"
fi

if [ -e  "/etc/redwood/ssl-cert/myCAcert.pem" ];then
        cp -v /etc/redwood/ssl-cert/myCAcert.pem /var/redwood/static/
        echo "/etc/redwood/ssl-cert/myCAcert.pem was copied to /var/redwood/static/"
        openssl x509 -outform der -in /etc/redwood/ssl-cert/myCAcert.pem -out /var/redwood/static/myCAcert.der
        echo "/etc/redwood/ssl-cert/myCAcert.pem was converted to der and now at => /var/redwood/static/myCAcert.der"
fi
```

iptables rules for intercept https proxy

``` highlight
IPTABLES=/sbin/iptables
LAN_INT="eth1"
$IPTABLES -I PREROUTING 1 -i $LAN_INT -p tcp -m tcp --dport 443 -j REDIRECT --to-ports 13128
```

squid.conf example from 3.5.25

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
