---
categories: ReviewMe
published: false
---
# Using the digest LDAP authentication helper

**Synopsis**

A lot of people storing their password in an LDAP base don't feel
comfortable when using the basic mechanism because it sends the
passwords in clear text to Squid (a base64 encoded string), and
sometimes ends up by using NTLM to talk to a CIFS server. The purpose of
this document is to show how to configure an authentication helper in
Squid using the digest mechanism and storing the passwords (or in that
case, the digests) in LDAP.

**Environment and what is expected that you have or already know**

The environment used in the test was composed by two Debian Sarge
servers, one playing a role of an internet gateway (running Squid 2.5.9)
and the other hosting the LDAP base (running OpenLDAP) and being the PDC
of the Samba domain. Doesn't matter much how or where your services are
running, but is expected from who are reading this:

  - Already working Squid, Samba and LDAP servers.

  - Already configured Idealx's smbldap-tools to manipulate the accounts
    (it relies on this to sync).

  - Some knowledge on how LDAP works and stores its information.

**The way it was done**

To manipulate the attributes in LDAP was used the tools from the package
ldap-utils (those beginning with ldap\* and used to manipulate the base
when running, pretty standard). Theres n ways to do that, feeding the
base with LDIF files, using administration tools with a web interface,
these will not be shown here. LDAP can be populated in various different
forms, so, it is expected that yours can be a little different than mine
(the structure used by Idealx's smbldap-populate script, and the way
Debian sets up an administrator account was used here).

It was used an attribute called "l" (defined in core.schema) to hold the
digest, its not exactly made for this, but I couldn't though in anything
more appropriate, but anyway, it is not a problem. You will see
sometimes a host called "fileserver" being used (it is because my Squid
and LDAP + Samba aren't in the same host). The DN of my LDAP
administrator is "cn=admin,dc=minharede,dc=lan" with a password
"temppass", it is the account that can do anything inside the base.

**How the digest is calculated and what is expected to be in the base**

The base needs to hold an attribute containing a pair, realm and H(A1)
separated by a separator like realm:H(A1) inside a distiguished name
representing an user name. Where H(A1) is the digested value of
username:realm:password.

**Installing and testing the helper**

**1.**Get the [Squid sources](http://www.squid-cache.org/Versions/),
compile the digest_ldap_auth helper and put it together with the
others squid helpers.

Here I will not discuss much on how to compile Squid or solve dependency
problems.

    ./configure --enable-auth-digest=LDAP
    make
    cp ./helpers/digest_auth/LDAP/digest_ldap_auth /usr/lib/squid
    ../

Put it where YOUR distro holds the helpers (or wherever you want).

**2.** Create a hash in one account to make a test. Run it from the
shell.

    REALM="Squid proxy-caching web server" HASH=`echo -n "usuario1:$REALM:password" | md5sum | cut -f1 -d' '` ldapmodify -x -D "cn=admin,dc=minharede,dc=lan" -w "temppass" << EOF
    dn: uid=usuario1,ou=Users,dc=minharede,dc=lan
    l: $REALM:$HASH
    EOF

**3.**Test the helper from the command line.

    echo '"usuario1":"Squid proxy-caching web server"' | /usr/lib/squid/digest_ldap_auth -b "ou=Users,dc=minharede,dc=lan" -u "uid" -A "l" -D "cn=admin,dc=minharede,dc=lan" -w "temppass" -e -v 3 -h fileserver -d
    Connected OK
    searchbase 'uid=usuario1, ou=Users,dc=minharede,dc=lan'
    password: 6f9e1772bc8ed55bfe157071e169bf19
    6f9e1772bc8ed55bfe157071e169bf19

**4.** Create a "Simple Security Object" in LDAP.

It will be used to bind and read the digests. When using digest, users
do not authenticate in the base, so granting access only for them is
pointless, and you will not want anyone looking at the digests of your
entire base.

    PASS=`slappasswd -s "digestpass"` ldapadd -x -D "cn=admin,dc=minharede,dc=lan" -w "temppass" << EOF
    dn: uid=digestreader,dc=minharede,dc=lan
    objectClass: top
    objectClass: account
    objectClass: simpleSecurityObject
    uid: digestreader
    userPassword: $PASS
    EOF

**5.** Protect the digest attribute to be readed and/or writed only by
who should do it.

Change your slapd.conf:

    access to attrs=l
            by dn="cn=admin,dc=minharede,dc=lan" write
            by dn="uid=digestreader,dc=minharede,dc=lan" read
            by anonymous auth
            by self write
            by * none

Restart your OpenLDAP.

**6.** Put the password of the object in a file and protect it.

    echo "digestpass" > /etc/digestreader_cred
    chown proxy:proxy /etc/digestreader_cred
    chmod 440 /etc/digestreader_cred

In Debian, Squid runs as the user proxy and so helpers are executed as
the user proxy.

**7.** Test the helper again using the object created to bind to the
base and the file with the password.

    echo '"usuario1":"Squid proxy-caching web server"' | /usr/lib/squid/digest_ldap_auth -b "ou=Users,dc=minharede,dc=lan" -u "uid" -A "l" -D "uid=digestreader,dc=minharede,dc=lan" -W "/etc/digestreader_cred" -e -v 3 -h fileserver -d
    Connected OK
    searchbase 'uid=usuario1, ou=Users,dc=minharede,dc=lan'
    password: 6f9e1772bc8ed55bfe157071e169bf19
    6f9e1772bc8ed55bfe157071e169bf19

**8.** Configure Squid to use the LDAP digest helper.

In squid.conf:

    ...
    auth_param digest program /usr/lib/squid/digest_ldap_auth -b "ou=Users,dc=minharede,dc=lan" -u "uid" -A "l" -D "uid=digestreader,dc=minharede,dc=lan" -W "/etc/digestreader_cred" -e -v 3 -h fileserver
    auth_param digest children 5
    auth_param digest realm Squid proxy-caching web server
    ...

The debug flag "-d" is not used here, we are not debugging anymore.

**Digest synchronization**

**1.** Change the smbldap-passwd script from idealx.

    ...
    ################ CHANGE THIS CODE ################
    # use Digest::MD5 qw(md5);
    use Digest::MD5 qw(md5 md5_hex md5_base64);
    ######### END OF THE CODE TO BE CHANGED ##########
    ...
    # Update 'userPassword' field
    my $modify = $ldap_master->modify ( "$dn", changes => [
                                               replace => [userPassword => "$hash_password"]
                                               ]
                                      );
    $modify->code && warn "Unable to change password : ", $modify->error ;
    ################ INSERT THIS CODE ################
    my $realm = "Squid proxy-caching web server";
    # Creates the digest.
    my $HA1digest = md5_hex("$user:$realm:$pass");
    my $realmdigest = "$realm:$HA1digest";
    # Add the attribute, if it already exists it will be overwritten.
    $modify = $ldap_master->modify ( "$dn",
          changes => [
             replace => [l => $realmdigest]
          ]
    );
    $modify->code && warn "Unable to create the H(A1) hash : ", $modify->error ;
    ######### END OF THE CODE TO BE INSERTED #########
    # take down session
    $ldap_master->unbind;
    exit 0;
    ...

You can do something a little more elaborated than this, like read the
realm from the config file, create a flag to make the sync, etc. The
code can be a little different from version to version, but the point is
that its just a perl script and is very easy to put a little more code
to create another attribute with a digest.

**2.**Use the "passwd program" option in samba to make use of the
changed script.

In smb.conf:

    # ldap passwd sync = Yes
    unix password sync = Yes
    passwd program = /usr/sbin/smbldap-passwd -u %u
    passwd chat = "Changing password for*\nNew password*" %n\n "*Retype new password*" %n\n

**Result**

At that point your Windows clients can change their passwords from
inside Windows and Linux clients can change their passwords using
smbldap-passwd. All passwords and digests will remain in sync.****

  - [CategoryKnowledgeBase](/CategoryKnowledgeBase)
