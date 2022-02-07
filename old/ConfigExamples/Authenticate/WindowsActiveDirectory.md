# Configuring a Squid Server to authenticate off Active Directory

Original work By Adrian Chadd

Updated by James Robertson 19.01.2012

Updated by Christopher Schirner 11.11.2014

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Introduction

This wiki page covers setup of a Squid proxy which will seamlessly
integrate with Active Directory using Kerberos, NTLM and basic
authentication for clients not authenticated via Kerberos or NTLM.

  - ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    This configuration example appears to have been written for an
    Ubuntu installation and incompletely munged for someones idea of
    general use. File paths and account user/group names will depend on
    your operatig system.

If you are running Debian or would like more verbose instructions
including access groups [this
link](http://wiki.bitbinary.com/index.php/Active_Directory_Integrated_Squid_Proxy)
may be of interest.

## Example Environment

the following examples are utilised, you should update any configuration
examples with your clients domain, hostnames, IP's etc. where necessary.

  - Network
    
      - Domain= example.local
    
      - Subnet = 192.168.0.0/24

  - Proxy Server
    
      - OS = GNU/Linux
    
      - Squid 3.1
    
      - IP = 192.168.0.10
    
      - HOSTNAME = squidproxy.example.local
    
      - Kerberos computer name = SQUIDPROXY-K

  - Windows Server 1
    
      - IP = 192.168.0.1
    
      - HOSTNAME = dc1.example.local

  - Windows Server 2
    
      - IP = 192.168.0.2
    
      - HOSTNAME = dc2.example.local

## Prerequisites

Client Windows Computers need to have *Enable Integrated Windows
Authentication* ticked in *Internet Options ⇒ Advanced settings*.

## DNS Configuration

On the Windows DNS server add a new A record entry for the proxy
server's hostname and ensure a corresponding PTR (reverse DNS) entry is
also created and works. Check that the proxy is using the Windows DNS
Server for name resolution and update `/etc/resolv.conf` accordingly.

Edit the file according to your network.

    domain example.local
    search example.local
    nameserver 192.168.0.1
    nameserver 192.168.0.2

Ping a internal and external hostname to ensure DNS is operating.

    ping dc1.example.local -c 4 && ping google.com -c 4

Check you can reverse lookup the Windows Server and the local proxy ip
from the Windows DNS.

    dig -x 192.168.0.1

    dig -x 192.168.0.10

The **ANSWER SECTION** should contain the the DNS name of
`dc1.example.local` and `squidproxy.example.local`.

> **Important**
> 
> **Important:** If either lookup fails do not proceed until fixed or
> authentication may fail.

## NTP Configuration

Time needs to be syncronised with Windows Domain Controllers for
authentication, configure the proxy to obtain time from them and test to
ensure they are working as expected.

## Install and Configure Kerberos

Install Kerberos packages - on Debian these are `krb5-user libkrb53`

Edit the file `/etc/krb5.conf` replacing the variables with the your
domain and servers.

> **Important**
> 
> **Important:** If you only have 1 Domain Controller remove the
> additional `kdc` entry from the `[realms]` section, or add any
> additional DC's.
> 
> Depending on your Domain Controller's OS Version uncomment the
> relevant Windows 200X section and comment out the opposing section.

    [libdefaults]
        default_realm = EXAMPLE.LOCAL
        dns_lookup_kdc = no
        dns_lookup_realm = no
        ticket_lifetime = 24h
        default_keytab_name = /etc/squid3/PROXY.keytab
    
    ; for Windows 2003
        default_tgs_enctypes = rc4-hmac des-cbc-crc des-cbc-md5
        default_tkt_enctypes = rc4-hmac des-cbc-crc des-cbc-md5
        permitted_enctypes = rc4-hmac des-cbc-crc des-cbc-md5
    
    ; for Windows 2008 with AES
    ;    default_tgs_enctypes = aes256-cts-hmac-sha1-96 rc4-hmac des-cbc-crc des-cbc-md5
    ;    default_tkt_enctypes = aes256-cts-hmac-sha1-96 rc4-hmac des-cbc-crc des-cbc-md5
    ;    permitted_enctypes = aes256-cts-hmac-sha1-96 rc4-hmac des-cbc-crc des-cbc-md5
    
    [realms]
        EXAMPLE.LOCAL = {
            kdc = dc1.example.local
            kdc = dc2.example.local
            admin_server = dc1.example.local
            default_domain = example.local
        }
    
    [domain_realm]
        .example.local = EXAMPLE.LOCAL
        example.local = EXAMPLE.LOCAL

**Important notice:** One should use "Windows 2008 with AES" if
available. This is not just important for security reasons, but you
might also experience problems when using the DNS name of the squid
server instead of the IP address.

Example error messages regarding this issue may look like this:

    ERROR: Negotiate Authentication validating user. Error returned 'BH gss_accept_sec_context() failed: Unspecified GSS failure.  Minor code may provide more information.'

## Install Squid 3

We install squid 3 now as we need the squid3 directories available.
Squid configuration takes places after authentication is configured. On
Debian install the `squid3 ldap-utils` packages.

## Authentication

The Proxy uses 4 methods to authenticate clients, Negotiate/Kerberos,
Negotiate/NTLM, NTLM and basic authentication. Markus Moellers
negotiate\_wrapper is used for the 2 Negotiate methods.

### Kerberos

Kerberos utilises msktutil an Active Directory keytab manager (I presume
the name is abbreviated for "Microsoft Keytab Utility"). We need to
install some packages that msktutil requires. On Debian install
`libsasl2-modules-gssapi-mit libsasl2-modules`

Install msktutil - you can find msktutil here
"[](http://fuhm.net/software/msktutil/releases/)"

Initiate a kerberos session to the server with administrator permissions
to add objects to AD, update the username where necessary. msktutil will
use it to create our kerberos computer object in Active directory.

    kinit administrator

It should return without errors. You can see if you succesfully obtained
a ticket with:

    klist

Now we configure the proxy's kerberos computer account and service
principle by running msktutil (remember to update the values with
yours).

> **Important**
> 
> **Important:** There are 2 important caveats in regard to the
> msktutils --computer-name argument.
> 
> `-computer-name` cannot be longer than 15 characters due to netbios
> name limitations. See this link and this link for further information.
> 
> `-computer-name` must be different from the proxy's hostname so
> computer account password updates for NTLM and Kerberos do not
> conflict, see this
> [link](http://www.squid-cache.org/mail-archive/squid-users/201112/0461.html)
> for further information. This guide uses -k appended to the hostname.

Execute the msktutil command as follows:

    msktutil -c -b "CN=COMPUTERS" -s HTTP/squidproxy.example.local -k /etc/squid3/PROXY.keytab \
    --computer-name SQUIDPROXY-K --upn HTTP/squidproxy.example.local --server dc1.example.local --verbose

> **Important**
> 
> **Important:** If you are using a Server 2008 domain then add
> `--enctypes 28` at the end of the command

Pay attention to the output of the command to ensure success, because we
are using --verbose output you should review it carefully.

Set the permissions on the keytab so squid can read it.

    chgrp proxy /etc/squid3/PROXY.keytab
    chmod g+r /etc/squid3/PROXY.keytab

Destroy the administrator credentials used to create the account.

    kdestroy

On the Windows Server reset the Computer Account in AD by right clicking
on the SQUIDPROXY-K Computer object and select "Reset Account", then run
msktutil as follows to ensure the keytab is updated as expected and that
the keytab is being sourced by msktutil from `/etc/krb5.conf` correctly.
This is not completely necessary but is useful to ensure msktutil works
as expected. Then run the following:

    msktutil --auto-update --verbose --computer-name squidproxy-k

> **Note**
> 
> **Note:** Even though the account was added in capital letters, the
> `--auto-update` in msktutil requires the `--computer-name` to be lower
> case.

If the keytab is not found try adding `-k /etc/squid3/PROXY.keytab` to
the command to see if it works and then troubleshoot until resolved or
users will not be able to authenticate with Squid.

Add the following to cron so it can automatically updates the computer
account in active directory when it expires (typically 30 days). Pipe it
through logger so I can see any errors in syslog if necessary. As stated
msktutil uses the default `/etc/krb5.conf` file for its paramaters so be
aware of that if you decide to make any changes in it.

    00 4  *   *   *     msktutil --auto-update --verbose --computer-name squidproxy-k | logger -t msktutil

Edit squid3's init script to export the `KRB5_KTNAME` variable so squid
knows where to find the kerberos keytab.

On Debian the simplest way to do that is as follows:

Add the following configuration to `/etc/default/squid3`

    KRB5_KTNAME=/etc/squid3/PROXY.keytab
    export KRB5_KTNAME

### NTLM

Install Samba and Winbind. On Debian install `samba winbind
samba-common-bin`

Stop the samba and winbind daemons and edit `/etc/samba/smb.conf`

    workgroup = EXAMPLE
    security = ads
    realm = EXAMPLE.LOCAL
    
    winbind uid = 10000-20000
    winbind gid = 10000-20000
    winbind use default domain = yes
    winbind enum users = yes
    winbind enum groups = yes

Now join the proxy to the domain.

    net ads join -U Administrator

Start samba and winbind and test acces to the domain.

    wbinfo -t

This command should output something like this:

    checking the trust secret for domain EXAMPLE via RPC calls succeeded

    wbinfo -a EXAMPLE\\testuser%'password'

Output should be similar to this.

    plaintext password authentication succeeded
    challenge/response password authentication succeeded

Set Permissions so the proxy user account can read
`/var/run/samba/winbindd_privileged`.

    gpasswd -a proxy winbindd_priv

  - ![{X}](https://wiki.squid-cache.org/wiki/squidtheme/img/icon-error.png)
    on Debian an Ubuntu systems there may also be a
    */var/lib/samba/winbindd\_privileged* directory created by the
    winbind and ntlm\_auth tools with root ownership. The group of that
    folder needs to be changed to match the
    /var/run/samba/winbindd\_privileged location.

append the following to cron to regularly change the computer account
password - Wiki note: Need to research if Samba does this automatically.

    05  4  *   *   *     net rpc changetrustpw -d 1 | logger -t changetrustpw

### Basic

In order to use basic authentication by way of LDAP we need to create an
account with which to access Active Directory.

In Active Directory create a user called "Squid Proxy" with the logon
name <squid@example.local>.

Ensure the following is true when creating the account.

  - User must change password at next logon Unticked

  - User cannot change password Ticked

  - Password never expires Ticked

  - Account is disabled Unticked

Create a password file used by squid for ldap access and secure the file
permissions (substitute the word "squidpass" below with your password).

    echo 'squidpass' > /etc/squid3/ldappass.txt
    chmod o-r /etc/squid3/ldappass.txt
    chgrp proxy /etc/squid3/ldappass.txt

## Install negotiate\_wrapper

Firstly we need to install negotiate\_wrapper. Install the necessary
build tools on Debian intall `build-essential linux-headers-$(uname -r)`
Then compile and install.

    cd /usr/local/src/
    wget "http://downloads.sourceforge.net/project/squidkerbauth/negotiate_wrapper/negotiate_wrapper-1.0.1/negotiate_wrapper-1.0.1.tar.gz"
    tar -xvzf negotiate_wrapper-1.0.1.tar.gz
    cd negotiate_wrapper-1.0.1/
    ./configure
    make
    make install

## squid.conf

Then setup squid and it's associated config files.

Add the following to your `squid.conf`.

Study and update the following text carefully, replacing the example
content with your networks configuration - if you get something wrong
your proxy will not work.

    ### /etc/squid3/squid.conf Configuration File ####
    
    ### negotiate kerberos and ntlm authentication
    auth_param negotiate program /usr/local/bin/negotiate_wrapper -d --ntlm /usr/bin/ntlm_auth --diagnostics --helper-protocol=squid-2.5-ntlmssp --domain=EXAMPLE --kerberos /usr/local/bin/squid_kerb_auth -d -s GSS_C_NO_NAME
    auth_param negotiate children 10
    auth_param negotiate keep_alive off
    
    ### pure ntlm authentication
    auth_param ntlm program /usr/bin/ntlm_auth --diagnostics --helper-protocol=squid-2.5-ntlmssp --domain=EXAMPLE
    auth_param ntlm children 10
    auth_param ntlm keep_alive off
    
    ### provide basic authentication via ldap for clients not authenticated via kerberos/ntlm
    auth_param basic program /usr/local/bin/squid_ldap_auth -R -b "dc=example,dc=local" -D squid@example.local -W /etc/squid3/ldappass.txt -f sAMAccountName=%s -h dc1.example.local
    auth_param basic children 10
    auth_param basic realm Internet Proxy
    auth_param basic credentialsttl 1 minute
    
    ### acl for proxy auth and ldap authorizations
    acl auth proxy_auth REQUIRED
    
    ### enforce authentication
    http_access deny !auth
    http_access allow auth
    http_access deny all

## Additional reads

  - [](http://wiki.bitbinary.com/index.php/Active_Directory_Integrated_Squid_Proxy)
    (by Eliezer Croitoru)
