#language en

= Guidelines for Mirroring the Squid Website and Sources =
<<TableOfContents>>

Please ensure all mirrors use '''rsync''' to replicate their content.

== Informing us about the mirror ==

Please send '''info at squid-cache.org''' an email informing us about your mirror if you are mirroring the FTP server or HTTP website. We will register it for automatic scanning and list it with our official download sources so long as it remains an accurate copy.

This email needs to include:
 * The URL you are providing for mirror
  . For FTP package mirrors the ftp:// URL and whether you provide an http:// alternative URL as well.
  . For HTTP package mirrors the http:// URL.
  . For website mirrors the FQDN for the mirror server or proxy
 * contact person and email
  . they will be notified of any problems with this server found by the automated testing.
  . optional: this same email address should also be subscribed to the [[http://lists.squid-cache.org/listinfo/squid-mirrors|squid-mirrors mailing list]].
 * country where the mirror is sited
 * name of organization to be credited with sponsorship
 * optional: a URL for the organization
 * optional: a note about the mirror or sponsor

Registered mirrors are tested for accuracy regularly. Mirrors are removed from the public listings immediately if any problems are detected, and re-added automatically a short period after the issue is resolved. If the issues remains after several months the mirror is automatically de-registered and scanning will cease at that time.

To terminate a mirror stop the updates and erase all public content from the Squid Project. Please also notify the above contact to get scanning stopped early.

== Mirrors for www.squid-cache.org ==

Both IPv4 and/or IPv6 mirrors are accepted.

HTTPS mirrors are not working yet, if you want to provide one please contact '''info at squid-cache.org''' to discuss it.

 * Mirrors updates should happen every 1-2 hours,
  * no more than once per hour please.
  * no less than once per day.

 * Mirrors must remove content not in the master rsync directory.

 * Mirrors must provide a publicly accessible server FQDN.

 * The mirror must accept requests for www.squid-cache.org.

The website pages and content can be fetched from here:
{{{
rsync -avz --delete-after master.squid-cache.org::http-files  /www/path
}}}

 . {i} We have deprecated the use of country-specific mirror domains. If you have previously been assigned a mirror domain such as www1.us.squid-cache.org. Please change that to hosting just the www.squid-cache.org domain and contact '''info at squid-cache.org''' about the change.

=== Squid reverse-proxies ===
Alternatively a Squid reverse-proxy can be supplied relaying requests to our master servers. Please indicate this in your contact email.

These mirrors are exempt from the update and removal timing requirements since they track changes. They are still scanned for correct operation.

The squid.conf snippet required is here:
{{{
http_port 80 accel vhost defaultsite=www.squid-cache.org

cache_peer master.squid-cache.org parent 80 0 originserver

acl squidcache dstdomain .squid-cache.org
http_access allow squidcache
cache_peer_access master.squid-cache.org allow squidcache
cache_peer_access master.squid-cache.org deny all
}}}

== Mirrors for ftp.squid-cache.org ==

Package archive is split into two sections. An archive containing the full history of package releases and a volatile area only containing the most current supported packages.

 * You may mirror either or both
 * If mirroring both please use the same base /path

 * Mirrors must be updated at minimum of daily
 * Mirrors must be updated at maximum of 3-hourly

Mirrors which are public but restricted (ie to a certain country) are still worth registering. Just indicate this nature in your contact email. They will need to permit access for the scanners on master.squid-cache.org to test the mirror.

=== Latest release bundles ===
{{{
rsync -avz --delete-after master.squid-cache.org::ftp-files  /path/squid
}}}

=== Package Archive ===
{{{
rsync -avz --delete-after master.squid-cache.org::archive  /path/archive
}}}


== Mirrors for the source code tree ==

=== Daily Snapshot ===
This code has passed simple quality checks to verify that trivial build problems are not going to occur. These are general build tests only. System-specific problems and runtime problems may still be found.

{{{
rsync -avz --delete-after master.squid-cache.org::source /source-path
}}}

Version specific code can be found in the numbered series sub-directories for their version.
For example:
{{{
rsync -avz --delete-after master.squid-cache.org::source/squid-5    /source-path
rsync -avz --delete-after master.squid-cache.org::source/squid-4    /source-path
rsync -avz --delete-after master.squid-cache.org::source/squid-3.5  /source-path
rsync -avz --delete-after master.squid-cache.org::source/squid-3.4  /source-path
rsync -avz --delete-after master.squid-cache.org::source/squid-3.3  /source-path
rsync -avz --delete-after master.squid-cache.org::source/squid-3.2  /source-path
rsync -avz --delete-after master.squid-cache.org::source/squid-3.1  /source-path
rsync -avz --delete-after master.squid-cache.org::source/squid-3.0  /source-path
rsync -avz --delete-after master.squid-cache.org::source/squid-2.7  /source-path
rsync -avz --delete-after master.squid-cache.org::source/squid-2.6  /source-path
}}}

=== Hourly Snapshot ===
This code is the hourly latest update of code submitted to each branch. This code is direct from the repository, build QA checks may not have been performed.

Structure of the source branches matches that of the daily snapshots.

{{{
rsync -avz --delete-after master.squid-cache.org::source-hourly  /source-path
}}}
