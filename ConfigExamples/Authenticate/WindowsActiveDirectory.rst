#language en
#format wiki

= Configuring a Squid Server to authenticate off Active Directory =
By Adrian Chadd

[[Include(ConfigExamples, , from="^## warning begin", to="^## warning end")]]

[[TableOfContents]]

== Basic Concepts ==
In this example, a Squid installation will use the Samba ntlm_auth helper to authenticate against an Windows Active Directory. The server will be joined to the Active Directory domain and other services can use the ntlm_auth helper to authenticate users (but be out of the scope of this document.)
== Environment ==
 * Windows Server 2003 AD
 * Ubuntu Dapper installation
 * Squid-2.6
 * Kerberos 5
 * Samba + Winbind
 * NTP server running on AD controller
== Packages to install ==
    * samba (3)
    * ntp-server (Kerberos requires time-synchronised machines)
    * krb5-doc, krb5-config, krb5-user, libkerb53, libkadm55 (Kerberos related user libraries)
    * winbind 
== Files to modify ==

=== /etc/krb5.conf ===
{{{
[logging]
   default = FILE:/var/log/krb5libs.log
   kdc = FILE:/var/log/krb5kdc.log
   admin_server = FILE:/var/log/ksadmind.log

[libdefaults]
   default_realm = DOMAIN.COM.AU.
   dns_lookup_realm = false
   dns_lookup_kdc = false
   ticket_lifetime = 24h
   forwardable = yes
   default_tgs_enctypes = DES-CBC-CRC DES-CBC-MD5 RC4-HMAC
   default_tkt_enctypes = DES-CBC-CRC DES-CBC-MD5 RC4-HMAC
   preferred_enctypes = DES-CBC-CRC DES-CBC-MD5 RC4-HMAC 

[realms]
   DOMAIN.COM.AU = {
           kdc = ad-master.domain.com.au.:88
           admin_server = ad-master.domain.com.au.:749
           default_domain = domain.
   } 

[domain_realm]
   .domain. = DOMAIN.COM.AU.
   domain. = DOMAIN.COM.AU. 

[kdc]
   profile = /var/kerberos/krb5kdc/kdc.conf

[appdefaults]
   pam = {
           debug = false
           ticket_lifetime = 36000
           renew_lifetime = 36000
           forwardable = true
           krb4_convert = false
   }
}}}
=== /etc/samba.smb.conf ===
{{{
[global]
        netbios name = SERVERNAME
        workgroup = DOMAIN
        realm = DOMAIN.COM.AU
        server string = Domain Proxy Server
        encrypt passwords = yes
        security = ADS
        password server = ad-master.domain.com.au
        log level = 3
        log file = /var/log/samba/%m.log
        max log size = 50
        socket options = TCP_NODELAY SO_RCVBUF=8192 SO_SNDBUF=8192
        printcap name = /etc/printcap
        preferred master = No
        dns proxy = No
        ldap ssl = no
        idmap uid = 10000-20000
        idmap gid = 10000-20000
        winbind use default domain = yes
        cups options = raw
}}}

=== /var/kerberos/krb5kdc/kdc.conf ===
{{{
[kdcdfefaults]
        acl_file = /var/kerberos/krb5kdc/kadm5.acl
        dict_file = /usr/share/dict/words
        admin_keytab = /var/kerberos/krb5kdc/kadm5.keytab
        v4_mode = noreauth

[libdefaults]
        default_realm = DOMAIN.

[realms]
        DOMAIN. = {
                master_key_type = des-cbc-crc
                supported_enctypes = des3-hmac-sha1:normal arcfour-hmac:normal des-hmac-sha1:normal des-cbc-md5:normal des-cbc-crc:normal des-cbc-crc:v4 des-cbc-crc:afs3 
             }
}}}
=== /var/kerberos/krb5kdc/kadm5.acl ===
{{{
*/admin@EXAMPLE.COM     *
}}}

== Configure NTP time synchronisation ==

The server must time synchronise against the AD clock - so configure ntpd to sync against the same time source as the AD server is. You must do this step or random authentication failures will occur!

== Joining the server to the AD domain ==

Once the files have been initialised, join the server to the Active Directory by using an AD account with sufficient privilege:

{{{
# kinit <admin user>@<fulldomain>
}}}

eg

{{{
kinit chadda@DOMAIN.COM.AU.
}}}

You may need to do this a couple of times - it may take a while and fail; so try it once again.

Now, to do the actual join:

{{{
# net ads join -U <admin user>@<fulldomain>
}}}

eg

{{{
# net ads join -U chadda@DOMAIN.COM.AU.
}}}

This will also take some time and may need to be repeated. It should eventually tell you that the server successfully joined the domain.

Next, restart samba and winbind, ie
{{{
# /etc/init.d/samba restart
# /etc/init.d/winbind restart 
}}}
'wbinfo' can tell you whether winbind has successfully negotiated and joined the network:

    * `wbinfo -t` will check whether the trust exists
    * `wbinfo -u` will list the users in the domain 

== Fix Ownership ==

By default Squid will run as a non-root user; but the directory with the winbind socket (perhaps /var/run/winbindd_privileged/) is generally owned by root and only readable by people in the root group or user.

Don't try changing the ownership of the directory - it'll just revert at reboot. Instead you need to run Squid as the group root.

{{{
cache_effective_group root
}}}

== Configuring Squid to use the Samba 3 ntlm_auth program for authentication ==

Finally, configure Squid to talk to the NTLM authentication helper:

{{{
auth_param ntlm program /usr/bin/ntlm_auth --helper-protocol=squid-2.5-ntlmssp
auth_param ntlm children 10
#auth_param ntlm max_challenge_reuses 0
#auth_param ntlm max_challenge_lifetime 2 minutes
#auth_param ntlm use_ntlm_negotiate off
auth_param basic program /usr/bin/ntlm_auth --helper-protocol=squid-2.5-basic
auth_param basic children 5
auth_param basic realm Domain Proxy Server
auth_param basic credentialsttl 2 hours
auth_param basic casesensitive off
authenticate_cache_garbage_interval 10 seconds

# Credentials past their TTL are removed from memory
authenticate_ttl 0 seconds
}}}

Make sure you add the relevant ACL statements to force proxy authentication, eg:

{{{
acl lcl src 192.168.0.0/16
acl auth  proxy_auth REQUIRED

http_access allow lcl auth
http_access deny all
miss_access allow all
icp_access deny all
}}}
The ntlm authentication helper will start logging authentication attempts (success and failure) to the `cache.log` file.

----
CategoryConfigExample
