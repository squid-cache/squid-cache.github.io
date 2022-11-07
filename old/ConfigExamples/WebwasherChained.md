# Configuring Squid and Webwasher in a proxy chain

By
[ChristophHaas](/ChristophHaas#)

## Outline

Squid is a brilliant caching proxy software. But it lacks a component
for content filtering. Often Squid administrators get ordered to prevent
downloading of virus-infected files or to filter out adult content.
There is software like Dansguardian or Squidguard that attempts to do
just that. But in a corporate environment this isn't sufficient at all.

Squid 3.x includes an ICAP client which at least allows you to connect
ICAP-capable content filters. But even with Squid 2.x you can connect
other proxies in a *proxy chain*. So this article deals with the
integration of the Webwasher proxy software (made by *Secure
Computing*).

![\<\!\>](https://wiki.squid-cache.org/wiki/squidtheme/img/attention.png)
DISCLAIMER: Webwasher is a relatively expensive piece of software. If
you want to save your kids at home from porn web sites this article is
not for you. The reason this article exists is that we use it at work.
It's not meant as an advertisement. This setup is a bit tough and you
should be familiar with the basics of Squid and LDAP.

## The example setup

What we do is authenticate our users against an LDAP database. As
different users need to be allowed different things on the internet
there are several LDAP groups that assign the users a certain profile.
Example: Nobody is allowed to use public webmail services but the group
of mail server administrators is given that permission so that they can
test their own server from the internet.

The setup described below works roughly like this:

  - Users point their browsers to the Squid proxy

  - When accessing the proxy the user gets asked for authentication (by
    verifying the credentials through LDAP)

  - Once the user is authenticated and let through according to ACLs the
    request is forwarded to the Webwasher

  - The Webwasher takes the authenticated username from Squid and
    assigns a *profile* (by looking up LDAP groups)

  - The transmitted content (request and response) are checked by the
    rules of the assigned profile and is either allowed or blocked

The big picture:

![bigpicture.png](https://wiki.squid-cache.org/ConfigExamples/WebwasherChained?action=AttachFile&do=get&target=bigpicture.png)

What the Webwasher does:

  - Virus scanning

  - URL blocking (huge database of URLs that allows you to block certain
    categories like web mail, porn or anonymous proxies)

  - Scanning of *active content* like Javascript, Java or ActiveX. It
    analyses what the Javascript or Java is actually doing and can block
    e.g. scripts that try to access the hard disk.

  - Checking of allowed content types (it does not just accept the
    content type that is sent by the browser but instead checks the
    actual content by so called *magic bytes* that are also used by the
    UNIX' **file** command)

  - Sanity checks: depth and size of archives, Microsoft Authenticode
    (most incorrectly signed scripts seem to come from Microsoft itself)

What the Webwasher currently does not:

  - The concept of *profiles* is very different from Squid's concept of
    ACLs. With ACLs and **http\_access** statements you run through
    those rules from top to bottom and the first matching entry
    determines whether the access is allowed or not. Profiles on the
    other hand define whether a certain filter is enabled or not. One
    *default* profile may disallow surfing to adult websites. But
    another profile might allow just that. The major drawback is that
    you cannot use inheritance with profiles. There is no way to say "I
    want the default profile but want to allow adult sites, too". You
    can just copy the default profile and change some settings. But if
    the default profile will be changed later no other profiles that are
    derived from the default profile will know about that change. So the
    longer you work with profiles the lesser you really know what each
    profile is doing.

## Squid configuration

The Squid proxy is mainly used for complex ACLs. Some users/client IPs
do not need to authenticate. Some URLs are blocked manually. Squid's
ACLs are perfect for that job.

### LDAP authentication and authorisation

First define how LDAP authentication will work:

    auth_param basic children 50
    auth_param basic realm Proxy
    auth_param basic credentialsttl 1 minute
    auth_param basic program /usr/lib/squid/ldap_auth -b o=ourcompany -h ldapserver -D cn=proxyauth,o=ourcompany -w secretpassword -f (&(objectclass=person)(cn=%s))

The interesting part is the call to **ldap\_auth**. These are the
meanings of the respective arguments:

|                                |                                                                                    |
| ------------------------------ | ---------------------------------------------------------------------------------- |
| o=ourcompany                   | the DN (distinguished name) the defines where your LDAP tree starts                |
| ldapserver                     | the DNS name or IP address of your LDAP server to query                            |
| cn=proxyauth,o=ourcompany      | the DN of the LDAP user that is used to verify the username and password of a user |
| secretpassword                 | the password that the above LDAP user needs to query the LDAP server               |
| (&(objectclass=person)(cn=%s)) | an LDAP expression limiting which kind of LDAP objects/users you are searching     |

If you want Squid to query the LDAP database to see whether a certain
user is part of a certain LDAP group you also need to define LDAP
lookups:

    external_acl_type ldapgroup ttl=60 concurrency=20 %LOGIN /usr/lib/squid/squid_ldap_group \
       -b o=ourcompany -f (&(objectclass=person)(cn=%v)(groupMembership=cn=%a,ou=groupcontainer,o=ourcompany)) \
       -D cn=proxyauth,o=ourcompany -w secretpassword -h ldapserver

Here the interesting part is
**(&(objectclass=person)(cn=%v)(groupMembership=cn=%a,ou=groupcontainer,o=ourcompany))**.
This LDAP expression queries for (1) all persons whose (2) name is
**%v** \[this is defined by your ACL later\] and you (3) look in groups
inside the **ou=groupcontainer,o=ourcompany** branch.

A minimal ACL/http\_access configuration that uses authentication will
look like this:

    acl ldap-auth proxy_auth REQUIRED
    http_access deny !ldap-auth
    http_access allow all

OPTIONAL:

You may want to create a special LDAP group with users that are allowed
to surf through the proxy. Perhaps you have an LDAP directory where all
your users are listed and you don't want to allow everybody internet
access. So you create an LDAP group **user\_can\_surf** and list all
privileged users there. Example configuration:

    acl ldap-auth proxy_auth REQUIRED
    http_access deny !ldap-auth
    acl ldapgroup-enabled external ldapgroup user_can_surf
    deny_info denied-ldapenabled ldapgroup-enabled
    http_access deny !ldapgroup-enabled
    http_access allow all

To tell the user why the access was denied you should consider using
**deny\_info** statements to define your own error pages. See your
squid.conf for details.

### Proxy chain

Now that Squid's job of authenticating the user is done and Squid
decided that the access is allowed you want to forward the request to
the Webwasher. This is done in a *proxy chain*. Set up a cache peer in
your squid.conf:

    cache_peer localhost parent 9090 0 no-query no-digest default login=*:foobar

You can run the Webwasher process on the same host as Squid itself.
That's why the peer host is *localhost* here. The additional options
**no-query** and **no-digest** tell Squid that the Webwasher does not
know about ICP queries and sibling relationships. But there is something
special here: **login=\*:foobar**. This option forwards the HTTP
**Proxy-Authorization** header to the parent proxy but replaces the
user's password by the string **foobar**. That way the Webwasher can
later use the name of the current Squid user to assign a certain
profile.

Also tell your Squid that you want all requests to be forwarded to the
Webwasher proxy without fetching the URL directly:

    never_direct allow all

If you have certain URLs that you want to be queried directly because
it's your intranet site or because Webwasher does something bad with the
web site you can always use **always\_direct allow ...** to send certain
types of queries directly from the Squid to the web server.

## Webwasher configuration

Since the configuration options in the web interface have moved between
version 5.x and 6.x I won't describe the exact path. If you don't know
where to find a certain option just use the search box on the top right.

First of all define your *profiles*. You will probably already have an
idea what different types of users you have and create a profile for
each.

### LDAP authorisation

Find the *Policy Management* option in the web interface. Next select
*Web Mapping*. Here you can define which profile a certain user gets
assigned. You can do that by

  - IP mapping: The profile gets assigned depending on the IP of the
    user's client PC. Set **forwarded\_for on** in the squid.conf to use
    this.

  - Username mapping: The name of the user as authenticated by Squid is
    taken into account.
    
      - Mapping method: Map from "Username" / Map via "LDAP lookup"
    
      - Extract user information from: Standard Request Header
        (Proxy-Authorization)
    
      - Mapping options: Do not verify password when using request
        headers (this is important to just map the username provided in
        Proxy-Authorization to a profile without checking the password
        again)
    
      - Current Rules: set mappings here. On the left select the profile
        to be assigned. And on the right put the name of an LDAP group
        that contains the users who should get this profile assigned.

Of course you need to have LDAP configured already. The setup depends on
your LDAP software of course. This is an example configuration:

  - User:
    
      - Attributes to extract: cn

  - Group object:
    
      - Attributes to extract: cn
    
      - Base DN to group objects: ou=proxygroups,o=ourcompany
    
      - Group member attribute name: uniqueMember
    
      - Object class for groups: groupOfNames

(To debug LDAP lookups ethereal/ethershark can be really useful.)

## Frequently Asked Questions

1.  Why do you use Squid at all? Seems like Webwasher can do all you
    want without Squid.
    
      - Squid is used for caching and because of its flexible ACLs. If
        you don't need that you can as well just use Webwasher and let
        that do the authentication.

<!-- end list -->

  - [CategoryConfigExample](/CategoryConfigExample#)
