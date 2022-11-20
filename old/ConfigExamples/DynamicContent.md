# Caching Dynamic Content

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Outline

The obsolete default configuration of squid prevents the caching of
dynamic content (pages with ? in the URI), like so:

    hierarchy_stoplist cgi-bin ?
    acl QUERY urlpath_regex cgi-bin \?
    cache deny QUERY 

**NOTE:** That policy setting was created at a time when dynamic pages
rarely contained proper Cache-Controls, that has now changed. From the
release of Squid 2.7 and 3.1 the squid developers are advocating a
change to this caching policy. These changes will also work in 3.0 and
2.6 releases despite not being officially changed for their
squid.conf.default.

The changed policy is to remove the QUERY ACL and paired cache line. To
be replaced by the refresh\_patterns below:

    refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
    refresh_pattern .            0 20% 4320

## Additional

Some websites use query strings to obfuscate the file locations and
increase their traffic loading.

The popular website youtube.com is one example which is dynamic, using
query strings (?) to obfuscate the video locations but despite that has
large flash video files and images in relatively static locations.

There are other specific needs detailed in
[ConfigExamples/DynamicContent/YouTube](/ConfigExamples/DynamicContent/YouTube).

The same mechanisms may be employed for other less popular sites as long
as the site behavior and obfuscation pattern is understood.

[CategoryConfigExample](/CategoryConfigExample)
