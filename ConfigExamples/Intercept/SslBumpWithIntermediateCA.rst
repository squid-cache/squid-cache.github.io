##master-page:CategoryTemplate
#format wiki
#language en

= SSL-Bump using an intermedtate CA =

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

 ''by Jok Thuauand Yuri Voinov''

<<TableOfContents>>

== Outline ==

You can use an intermediate CA on the proxy for SSL-Bump.

== Usage ==

In case if the intermediate certificate CA2 being compromised, you can simply revoke the intermediate CA2 with primary CA1 and sign new intermediate CA2 without disturb your clients.

== CA certificate preparation ==

 1. Create a '''root CA1''' with CRL URL encoded in CA1. This CRL URL needs to be reachable by your clients.

 2. Use the CA1 to sign an intermediate CA2, which will be used on the proxy for signing mimicked certificates.

 3. install primary CA1 public key onto clients.

 4. prepare a public keys file which contains concatenated intermediate CA2 followed by root CA1 in PEM format.
   . For example in the config below we call this ''rootCA12.pem''.

Now Squid can send the intermediate CA2 public key with root CA1 to client and does not need to install intermediate CA2 to clients.

== Squid Configuration File ==

Paste the configuration file like this:

{{{
http_port 3128 ssl-bump generate-host-certificates=on dynamic_cert_mem_cache_size=4MB \
   cert=/etc/squid/rootCA2.crt \
   key=/etc/squid/rootCA2.key \
   cafile=/etc/squid/rootCA12.pem
}}}

----
CategoryConfigExample
