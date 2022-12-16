#format wiki
#language en
#acl SquidWikiAdminGroup:read,write,delete,revert -All:read

= WWW Mirror Servers Administration =

Each of the following sections / steps is dependent on the ones before having been completed and working.

== 1. Installation ==

The requirements installation and how-to register a mirror server are documented on the public MirrorGuidelines wiki page.

Sysadmin tasks begin with the registration request received by the project info@ contact address.


== 2. Manual Testing WWW mirrors ==

Squid www.* pages use an embeded script to prevent unregistered mirrors from duplicating our website content and making use of it themselves. This can make testing a little tricky.

The best way to test is with the '''squidclient''' tool which can forge the Host: header on requests.
{{{
  MIRROR_HOST = foo.example.com

  squidclient -h $MIRROR_HOST -j www.squid-cache.org -p 80 /
  squidclient -h $MIRROR_HOST -j www.squid-cache.org -p 80 /timestamp.txt
  squidclient -h $MIRROR_HOST -j www.squid-cache.org -p 80 /xyzzy/

}}}

When these tests start returning results the mirror MAY be working properly. However an eyeball test is difficult and easily fooled. Perform the SQL registration step and review the results of automated testing.


== 3. SQL Registration ==

=== MySQL ===
The Squid mysql database named '''mirrors''' contains tables of mirror server registrations. WWW mirrors are listed in the '''http''' table.
{{{
## fields may vary if this page is outdated

+------------+--------------+------+-----+---------+-------+
| Field      | Type         | Null | Key | Default | Extra |
+------------+--------------+------+-----+---------+-------+
| url        | varchar(100) | YES  |     | NULL    |       |
| country    | varchar(50)  | YES  |     | NULL    |       |
| continent  | char(2)      | YES  |     | NULL    |       |
| org        | varchar(100) | YES  |     | NULL    |       |
| hostname   | varchar(250) | YES  |     | NULL    |       |
| ip6        | tinyint(1)   | YES  |     | 0       |       |
| ip4        | tinyint(1)   | YES  |     | 1       |       |
| org_url    | varchar(50)  | YES  |     | NULL    |       |
| admin      | varchar(100) | YES  |     | NULL    |       |
| status     | varchar(50)  | YES  |     | NULL    |       |
| comments   | varchar(100) | YES  |     | NULL    |       |
| restricted | tinyint(1)   | YES  |     | NULL    |       |
| last_ok    | date         | YES  |     | NULL    |       |
+------------+--------------+------+-----+---------+-------+
}}}

 1. Supplied by the mirror admin:

  * '''country''' - Where the mirror is located geographically. Used in web page to inform users for selectino of nearby mirrors (we do not do GeoDNS automated selection).

  * '''org''' - The mirror sponsoring organisations official name. Used for crediting them sponsorhip.

  * '''org_url''' - The sponsoring organisations official URL. Used for referencing in credits.

  * '''hostname''' - The private FQDN for accessing this mirror directly. Used by CNAME *.squid-cache.org DNS and automated testing scripts.

  * '''admin''' - Name and contact email of the mirror administrator(s).
   - If not supplied explicitly assume the contact email the registration request came from.
   - /!\ '''IMPORTANT:''' field syntax appropriate for use in to email "To: " header.
   - May be a comma-separated list if they fit within the DB field.

  * '''restricted''' - 0/1 value indicating whether users face any access restrictions on this server. ie Country-specific users only.

 2. Determined by the Squid sysadmin:

  * '''continent''' - The mirrors web page is grouped by geographc region using this column. See existing entries.

  * '''ip6''' - 0/1 value indicating whether IPv6 supported by the mirror.

  * '''ip4''' - 0/1 value indicating whether IPv6 supported by the mirror.

  * '''url''' - The official URL {{{ scheme://*.squid-cache.org/ }}} segment for accessig this mirror. It will be used as the link on HTTP mirrors web page, and for script automated testing.

  * '''comments''' - Any comments 

 3. Determined automatically by the Squid master server scripts:

  * '''status''' - What HTTP status is being presented by the server. '''OK''' means working mirror. Otherwise details the error found by the automatics.

  * '''last_ok''' - How long since the server was last OK.
   - Used by the website generator to determine which mirrors are advertised.
   - Determines candidates for purging registrations after ~6 months of outage.


=== Scripts ===

Scripts for managing the WWW mirrors can be found in '''mirrors-db/http/'''.

The main script is '''mirrors-db/http/cron.sh''' which performs daily automated testing of the HTTP / WWW mirror servers registered in MySQL.

 * '''Makefile''' - Run the website HTML generator scripts
  . '''mk-http-mirrors-html.pl'''
  . '''mk-short-mirror-list.pl'''

 * '''add-mirror.sh''' - OUTDATED script to insert DB records for above.
  . Could still be used, but SQL table has changed.

 * '''check-mirror-status.pl''' - automated mirror tests.

 * '''cron.sh''' - automated daily HTTP mirror maintenance tasks.
  . Runs '''check-mirror-status.pl'''
  . Runs '''Makefile''' (make all install)
  . Outputs dump of DB records for any broken mirrors (cron email contact noc@ receives the report).

 * '''email-broken.pl''' - OUTDATED notification script for mirror admin.
  . Could still be used, but SQL table has changed, and mailing in Duanes name is not great.

 * '''fix-admins''' - OUTDATED? Seems to be old admin temporary script.
  . Might be useful to mine for mirror admin contacts of any are still relevant.

 * '''mk-http-mirrors-html.pl''' - OUTDATED? website HTML generator for (Mirrors/http-mirrors.html).
  . URL object seems to be recently updated
  . Authoritative mirrors list is the web page Download/http-mirrors.html built by PHP script.

 * '''mk-short-mirror-list.pl''' - OUTDATED? website HTML generator for (Mirrors/http-mirrors-short-list.html).
  . URL object seems to be recently updated but contains text not produced by this script.


== 4. DNS Registration ==

When the SQL registration is in place and the automated testing script above updates the DB record with '''OK'''. Note, the test script may be run manually to reach this step faster.

 * TODO: document the DNS record registration process for FQDN assigned and listed in DB as '''url''' field above.


= FTP Mirror Server Administration =

 TODO.

----
CategoryFeature
