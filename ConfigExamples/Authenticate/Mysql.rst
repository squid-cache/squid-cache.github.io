## page was renamed from ConfigExamples/SquidAndMysql
##master-page:CategoryTemplate
#format wiki
#language en

= Configuring a Squid Server to authenticate from MySQL database =
By Askar Ali Khan

<<Include(ConfigExamples, , from="^## warning begin", to="^## warning end")>>

<<TableOfContents>>

== Outline ==

In this example a squid installation will use MySQL to authenticate users before allowing them to surf the web. For security reasons users need to enter their username and password before they are allowed to surf the internet.

== Squid Installation ==

Install squid using your distro package management system or using source.

Make sure squid is compiled with '''--enable-basic-auth-helpers=DB''' option.

== Creating MySQL db/table to hold user credentials ==

{{{
mysql> create database squid;

mysql> grant select on squid.* to someuser@localhost identified by 'xxxx';

}}}

Create table 'passwd' in 'squid' db.

{{{

mysql> CREATE TABLE `passwd` (
  `user` varchar(32) NOT NULL default '',
  `password` varchar(35) NOT NULL default '',
  `enabled` tinyint(1) NOT NULL default '1',
  `fullname` varchar(60) default NULL,
  `comment` varchar(60) default NULL,
  PRIMARY KEY  (`user`)
);

}}}

Populate the table with some test data, eg

{{{

mysql> insert into passwd values('testuser','test',1,'Test User','for testing purpose');

}}}

== Squid Configuration File ==

Edit squid.conf so that authentication against MySQL db works

{{{

auth_param basic program /usr/local/squid/libexec/squid_db_auth --user someuser --password xxxx --plaintext --persist
auth_param basic children 5
auth_param basic realm Web-Proxy
auth_param basic credentialsttl 1 minute
auth_param basic casesensitive off


acl db-auth proxy_auth REQUIRED
http_access allow db-auth
http_access allow localhost
http_access deny all

}}}

== Testing the squid_db_auth helper ==

It good idea to test the squid_db_auth helper from command line to make sure it authenticating with mysql before trying from browser.

{{{

/usr/local/squid/libexec/squid_db_auth --user someuser --password xxxx --plaintext --persist

}}}

Type the user/password on the same line separated with space, on successful authentication it will give "OK" otherwise "ERR login failure"

----
CategoryConfigExample
