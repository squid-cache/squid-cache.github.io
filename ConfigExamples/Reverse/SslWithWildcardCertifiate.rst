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
== OpenSSL Configuration for CA and Certificate Generation ==
Download and install the openssl software: If you are on RH linux, just check if this software is installed using '''rpm -qi openssl''' . Please find the openssl.cnf file in which some changes were made for '''dir = /usr/newrprgate/CertAuth , private_key = $dir/private/cakey.pem''' , '''default_keyfile = /usr/newrprgate/CertAuth/private/cakey.pem '''rest of the config is used as default .

{{{
HOME                    = .
RANDFILE                = $ENV::HOME/.rnd
oid_section             = new_oids
[ new_oids ]
[ ca ]
default_ca      = CA_default            # The default ca section
[ CA_default ]
dir             = /usr/newrprgate/CertAuth              # Where everything is kept
certs           = $dir/certs            # Where the issued certs are kept
crl_dir         = $dir/crl              # Where the issued crl are kept
database        = $dir/index.txt        # database index file.
new_certs_dir   = $dir/certs            # default place for new certs.
certificate     = $dir/cacert.pem       # The CA certificate
serial          = $dir/serial           # The current serial number
crl             = $dir/crl.pem          # The current CRL
private_key     = $dir/private/cakey.pem # The private key
RANDFILE        = $dir/private/.rand    # private random number file
x509_extensions = usr_cert              # The extentions to add to the cert
name_opt        = ca_default            # Subject Name options
cert_opt        = ca_default            # Certificate field options
default_days    = 365                   # how long to certify for
default_crl_days= 30                    # how long before next CRL
default_md      = md5                   # which md to use.
preserve        = no                    # keep passed DN ordering
policy          = policy_match
[ policy_match ]
countryName             = match
stateOrProvinceName     = match
organizationName        = match
organizationalUnitName  = optional
commonName              = supplied
emailAddress            = optional
[ policy_anything ]
countryName             = optional
stateOrProvinceName     = optional
localityName            = optional
organizationName        = optional
organizationalUnitName  = optional
commonName              = supplied
emailAddress            = optional
[ req ]
default_bits            = 1024
default_keyfile         = /usr/newrprgate/CertAuth/private/cakey.pem
distinguished_name      = req_distinguished_name
attributes              = req_attributes
x509_extensions = v3_ca # The extentions to add to the self signed cert
string_mask = nombstr
[ req_distinguished_name ]
countryName                     = Country Name (2 letter code)
countryName_default             = GB
countryName_min                 = 2
countryName_max                 = 2
stateOrProvinceName             = State or Province Name (full name)
stateOrProvinceName_default     = Berkshire
localityName                    = Locality Name (eg, city)
localityName_default            = Newbury
0.organizationName              = Organization Name (eg, company)
0.organizationName_default      = My Company Ltd
organizationalUnitName          = Organizational Unit Name (eg, section)
commonName                      = Common Name (eg, your name or your server\'s hostname)
commonName_max                  = 64
emailAddress                    = Email Address
emailAddress_max                = 64
[ req_attributes ]
challengePassword               = A challenge password
challengePassword_min           = 4
challengePassword_max           = 20
unstructuredName                = An optional company name
[ usr_cert ]
basicConstraints=CA:FALSE
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer:always
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
[ v3_ca ]
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid:always,issuer:always
basicConstraints = CA:true
[ crl_ext ]
authorityKeyIdentifier=keyid:always,issuer:always
}}}
== Please proceed as Follow to Generate OpenSSL Certificate ==
{{{
[root@rprgate ~]# cd /usr
[root@rprgate ~]# mkdir newprpgate; cd newrprgate
[root@rprgate ~]# mkdir CertAuth; cd CertAuth
[root@rprgate ~]# mkdir certs; mkdir private
[root@rprgate ~]# chmod 700 private
[root@rprgate ~]# echo '01' > serial
[root@rprgate ~]# touch index.txt
}}}
{{{
[root@rprgate ~]#openssl req -x509 -newkey rsa -out cacert.pem -outform PEM -days 1000}}}
{{{
Generating a 2048 bit RSA private key
..........................................................................................+++
................................................................................................................+++
writing new private key to '/etc/CertAuth/private/cakey.pem'
Enter PEM pass phrase:
Verifying - Enter PEM pass phrase:}}}
{{{
Users generating a certificate request: Now we have a certificate authority. But some user who wants to get his certificate signed from us, has to generate a certificate request. here are the list of commands that i will follow... Two files are created testkey.pem and testreq.pem }}}
{{{
testkey.pem ==> private key generated for the user (protected by the pass phrase.. usually I will not provide a passphrase as i need to use this for automatic creation without user intervention. To do this, I have to provide the -nodes option on the command line.)
testreq.pem ==> request to be sent to the CA for being accepted.

}}}
{{{
[root@rprgate ~]#openssl req -newkey rsa:1024 -keyout testkey.pem -keyform PEM -out testreq.pem -outform PEM -nodes}}}
{{{
Generating a 1024 bit RSA private key .........................++++++ .++++++ writing new private key to 'testkey.pem'

You are about to be asked to enter information that will be incorporated into your certificate request. What you are about to enter is what is called a Distinguished Name or a DN. There are quite a few fields but you can leave some blank For some fields there will be a default value, If you enter '.', the field will be left blank. }}}
{{{
Country Name (2 letter code) [GB]:IN
State or Province Name (full name) [Berkshire]:UP
Locality Name (eg, city) [Newbury]:Noida
Organization Name (eg, company) [My Company Ltd]:Pie Dreams
Organizational Unit Name (eg, section) []:Pie Solutions
Common Name (eg, your name or your server's hostname) []:*.mydomain.com
Email Address []:sudhirkumargupta@gmail.com
Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:i am a good boy
An optional company name []: PRESS ENTER
}}}
{{{
Issuing the certificate: The CA should verify that the certifiacte comes from the right person and issue it using the following command. It is recommended that u use the "-notext" and "-out testcert.cert" option. This will not print any output to stdout.. and make a copy of the certificate in the file testcert.cert in the current directory.. This way you will not have to search the certs/ directory for the new certifcate.
}}}
{{{
[root@rprgate ~]#openssl ca -in testreq.pem -notext -out testcert.cert}}}
{{{
Using configuration from /etc/CertAuth/openssl.cnf
Enter pass phrase for /etc/CertAuth/private/cakey.pem:secretcode
Check that the request matches the signature
Signature ok
The Subject's Distinguished Name is as follows
countryName           :PRINTABLE:'IN'
stateOrProvinceName   :PRINTABLE:'UP'
localityName          :PRINTABLE:'Noida'
organizationName      :PRINTABLE:'Pie Dreams'
organizationalUnitName:PRINTABLE:'Pie Solutions'
commonName            :PRINTABLE:'mydomain.com'
emailAddress          :IA5STRING:'sudhirkumargupta@gmail.com'
Certificate is to be certified until Oct 18 22:54:31 2007 GMT (365 days)
Sign the certificate? [y/n]:y
1 out of 1 certificate requests certified, commit? [y/n]y
Write out database with 1 new entries
Data Base Updated}}}
== Squid Configuration File ==
Please note that the https_port and cache_peer lines may wrap in your browser!

{{{
https_port 443 cert=/usr/newrprgate/CertAuth/testcert.cert key=/usr/newrprgate/CertAuth/testkey.pem
defaultsite=mywebsite.mydomain.com vhost
cache_peer 10.112.62.20 parent 80 0 no-query originserver login=PASS
name=websiteA.mydomain.com
acl sites_server_1 dstdomain websiteA.mydomain.com
cache_peer_access websiteA.mydomain.com allow sites_server_1
cache_peer 10.112.143.112 parent 80 0 no-query originserver login=PASS
name=mywebsite.mydomain.com
acl sites_server_2 dstdomain mywebsite.mydomain.com
cache_peer_access mywebsite.mydomain.com allow sites_server_2
cache_peer 10.112.90.20 parent 443 0 no-query originserver ssl sslflags=DONT_VERIFY_PEER name=websiteB.mydomain.com
acl sites_server_3 dstdomain websiteB.mydomain.com
cache_peer_access websiteB.mydomain.com allow sites_server_3
acl webserver dst 10.112.62.20 10.112.143.112 10.112.90.20
http_access allow webserver
http_access allow all
miss_access allow webserver
miss_access deny all
http_access allow manager localhost
http_access deny manager
http_access deny all
}}}
CategoryConfigExample
