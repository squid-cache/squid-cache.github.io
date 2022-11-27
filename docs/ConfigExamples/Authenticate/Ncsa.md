---
categories: ConfigExample
---
# Authenticate with a NCSA httpd-style passwords file

In this example a squid installation will use a NCSA-style passwords file to
authenticate users

## The password file

To create a new password file:
```
htpasswd -c -nbm /etc/squid/passwords username password
```

To add users:
```
htpasswd -nbm /etc/squid/passwords username password
```

To delete users:
```
htpasswd -D -nbm /etc/squid/passwords username password
```
> ℹ️ The `-m` option specifies MD5 encryption which is the default for
    htpasswd

Squid helpers support DES, MD5 and SHA encryption of the passwords file.
Bcrypt requires additional support in the crypto libraries Squid is
built with so may or may not work.

## Squid Configuration File

In squid.conf:
```
auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwords
auth_param basic children 5
auth_param basic credentialsttl 1 minute
```

The basic auth ACL controls to make use of it are:
```
acl auth proxy_auth REQUIRED

http_access deny !auth
http_access allow auth
http_access deny all
```
