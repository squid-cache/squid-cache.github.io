---
categories: [ConfigExample]
---
# Configuring Squid for NTLM with Winbind Authentication on CentOS 5

*By Joseph L. Casale *


This Configuration Example illustrates a simplified method to setup
Squid on CentOS 5 (or any RHEL 5 flavor) using built in configuration
tools while enabling only the needed services for authentication to be
carried out by Winbind.

## Prerequisites

### Network Time Protocol (NTP)

In order for Kerberos to function, proper time synchronization between
your Active Directory PDC Emulator and this server must be maintained.

Check if the ntp client is installed:

    # rpm -qa ntp

If this query returns nothing, install it:

    # yum install ntp

Now edit **/etc/ntp.conf** and comment out any lines that begin with
**server** and create only one that points to your Active Directory PDC
Emulator.

Set the daemon to start automatically at boot and start it:

    # vi /etc/ntp.conf
    server pdce.example.local
    # chkconfig ntpd on
    # service ntpd start

### Samba and Winbind

The Samba configuration file **/etc/samba/smb.conf** and Squid
authentication helper **/usr/bin/ntlm_auth** are provided by the
samba-common package.

Check if the software is installed:

    # rpm -qa |egrep -i '(krb5-workstation|samba-common|authconfig)'
    authconfig-5.3.21-5.el5
    krb5-workstation-1.6.1-25.el5_2.1
    samba-common-3.0.28-1.el5_2.1

If not, install it with yum:

    # yum install authconfig krb5-workstation samba-common


## Configure Kerberos

To enable Active Directory Group and User enumeration by the helper, we
join the CentOS server to Active Directory. You can use authconfig to
configure Samba, Winbind and perform the join in one step.

- Replace ads.example.local with the fqdn of your Active Directory
    Server.
- Replace EXAMPLE with the netbios name of your domain.
- Replace EXAMPLE.LOCAL with the full name of your domain.


    # authconfig --enableshadow --enablemd5 --passalgo=md5 --krb5kdc=ads.example.local \
    --krb5realm=EXAMPLE.LOCAL --smbservers=ads.example.local --smbworkgroup=EXAMPLE \
    --enablewinbind --enablewinbindauth --smbsecurity=ads --smbrealm=EXAMPLE.LOCAL \
    --smbidmapuid="16777216-33554431" --smbidmapgid="16777216-33554431" --winbindseparator="+" \
    --winbindtemplateshell="/bin/false" --enablewinbindusedefaultdomain --disablewinbindoffline \
    --winbindjoin=Administrator --disablewins --disablecache --enablelocauthorize --updateall
    [/usr/bin/net join -w EXAMPLE -S ads.example.local -U Administrator]
    Administrator's password:
    Using short domain name -- EXAMPLE
    Joined 'SERVER' to realm 'EXAMPLE.LOCAL'
    
    Shutting down Winbind services:                            [FAILED]
    Starting Winbind services:                                 [  OK  ]

If Winbind wasn't running before this it can't shutdown, but authconfig
will start it and enable it to start at boot.

The default permissions for **/var/cache/samba/winbindd_privileged** in
RHEL/CentOS 5.4 were 750 root:squid (which worked by default) but are
now 750 root:wbpriv in 5.5 which doesn't allow the user Squid runs under
to access the socket. Make sure squid.conf does not have a
**cache_effective_group** defined and add wbpriv as a supplementary
group to the user Squid runs under:

    # usermod -a -G wbpriv squid

You can test Active Directory Group and User enumeration by viewing the
output of wbinfo:

    # wbinfo -{u|g}

If you are able to enumerate your Active Directory Groups and Users,
everything is working.

## Configuring Squid

I created an Active Directory Group to control who gets access to the
proxy. Check the man pages for
[ntlm_auth](http://www.samba.org/samba/docs/man/manpages-3/ntlm_auth.1.html)
for options.

Edit your **/etc/squid/squid.conf** to enable the helper and adjust
**our_networks** accordingly:

    auth_param ntlm program /usr/bin/ntlm_auth --helper-protocol=squid-2.5-ntlmssp --require-membership-of=EXAMPLE+ADGROUP
    auth_param ntlm children 5
    auth_param ntlm keep_alive on
    
    acl our_networks 192.168.0.0/24 192.168.1.0/24
    
    acl ntlm proxy_auth REQUIRED
    http_access allow our_networks ntlm

- This is not an inclusive set of parameters for Squid to function but
    is what is required for the authentication portion.

## Notes

- Current versions of Firefox are capable of ntlm authentication so
    you need not enable basic.
- You need not install the full Samba package, nor have smbd and nmbd
    running for authentication to take place.