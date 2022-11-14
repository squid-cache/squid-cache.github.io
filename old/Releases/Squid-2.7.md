# Squid-2.7

|          |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| today    | Squid-2.x is **CONSIDERED DANGEROUS** as the security people say. Due to unfixed vulnerabilities **[CVE-2014-7141](http://www.squid-cache.org/Advisories/SQUID-2014_4.txt), [CVE-2014-7142](http://www.squid-cache.org/Advisories/SQUID-2014_4.txt), [CVE-2014-6270](http://www.squid-cache.org/Advisories/SQUID-2014_3.txt), [CVE-2012-5643](http://www.squid-cache.org/Advisories/SQUID-2012_1.txt), [CVE-2013-0189](http://www.squid-cache.org/Advisories/SQUID-2012_1.txt), [CVE-2009-0801](http://www.squid-cache.org/Advisories/SQUID-2011_1.txt)** and any other recently discovered issues. |
| Aug 2012 | the Squid-2.7 series became **OBSOLETE** with the release of [Squid-3.2](/Releases/Squid-3.2#) features                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| Aug 2011 | Henrik announced end of Squid-2.x support and **DEPRECATED** Squid-2.7                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |

This is the last Squid-2 "stable" release. No new features are planned
at this time for inclusion into Squid-2.7.

During 2006 and 2007
[AdrianChadd](/AdrianChadd#)
continued to develop the Squid-2 branch post-
[Squid-2.6](/Releases/Squid-2.6#)
to meet performance, scalability and functionality demands in
high-performance environments. Additional patches and features continued
to be provided by interested users as well.

Unfortunately most of them were not ported to
[Squid-3.0](/Releases/Squid-3.0#)
which compounded the problem begun with
[Squid-2.6](/Releases/Squid-2.6#).
These features developed specifically for high-performance needs were
found to be large enough to gather for an additional [Squid-2.7](#)
release in parallel with the maturing
[Squid-3.0](/Releases/Squid-3.0#).

(ported to 3.1)

  - Removal of the dummy "null" store type and useless default
    cache\_dir.

  - Include configuration file support

  - HTTP/1.1 compliant requests to servers

(ported to 3.2)

  - HTTP/1.1 compliant replies to clients

  - Modular logging work - including external logging daemon support,
    UDP logging support

(ported to Squid-3.4)

  - "store rewrite" stuff from Adrian Chadd - rewrite URLs when used for
    object storage and lookup; useful for caching sites with dynamic
    URLs with static content (eg Windows Updates, YouTube, Google Maps,
    etc) as well as some CDN-like uses.

(ported to Squid-3.5)

  - Fixing (or at least working around) [Bug
    \#7](https://bugs.squid-cache.org/show_bug.cgi?id=7#)

  - Further transparent interception improvements from Steven Wilton

Packages of squid 2.7 source code are available at
[](http://www.squid-cache.org/Versions/v2/2.7/)

# The Future

With two Squid releases now provided and supported. The core developers
gathered to discuss what alternatives could be taken other than further
splitting the code between two branches.

However
[AdrianChadd](/AdrianChadd#)
had [further
plans](/RoadMap/Squid2#)
for Squid-2 and
[Squid-3.0](/Releases/Squid-3.0#)
was clearly not meeting the needs of some major users. The goalposts had
shifted, as the saying goes. With a 5:1 split of developers working on
Squid-3 over Squid-2 the feature parity gap was closing, but not fast
enough to prevent confusion amongst the users.

The future aims of the project developers is to provide a single release
with all the features needed by each user group. The
[RoadMap/Squid3](/RoadMap/Squid3#)
page describes our future plans in more detail than are relevant here.

# Split Choice

As it stands, users will still need to make a choice between
[Squid-3.0](/Releases/Squid-3.0#)
and [Squid-2.7](#) when moving away from Squid-2.5 and
[Squid-2.6](/Releases/Squid-2.6#).
This decision needs to be made on the basis of their feature needs.

The only help we can provide for this is to point out that:

  - [Squid-3.0](/Releases/Squid-3.0#)
    has been largely sponsored by the Web-Filtering user community. With
    features aimed at adapting and altering content in transit.

  - [Squid-2.7](#) has been largely sponsored by high-performance user
    community. With features aimed at Caching extremely high traffic
    volumes in the order of Terabytes per day.
