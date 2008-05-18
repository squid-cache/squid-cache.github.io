##master-page:CategoryTemplate
#format wiki
#language en

= Feature Comparison Map for Squid =

This pages hope to be authoritative. If you know of any errors or missing features please let us know.

== Table Key ==
|||| Key: ||
|| Y || Feature Available ||
|| - || Feature not available ||
|| X || Feature available as an experimental component ||
|| P || Patch available. ||
|||| ||
|| s2 || Available for STABLE release 2 ||
|| s2+ || Available for STABLE release 2 and later ||
|| Ps2-5 || Patch available for releases from 2 to 5 (inclusive) ||

== Feature Comparisons ==

|| '''Feature'''  || '''2.5''' || '''2.6''' || '''2.7''' || '''3.0''' || '''3-HEAD''' ||
|||||||||||| '''Accepted Input Protocols''' ||
|| HTTP 0.9       || Y   || Y   || Y   || Y   || Y   ||
|| HTTP 1.0       || Y   || Y   || Y   || Y   || Y   ||
|| HTTP 1.1       || -   || X   || Y   || X   || Y   ||
|| HTTPS          || -   || Y   || Y   || Y   || Y   ||
|| ICP (v2)       || -   || Y   || Y   || Y   || Y   ||
|| ICP (v3)       || -   || Y   || Y   || Y   || Y   ||
|||||||||||| '''URI Protocols handled''' ||
|| HTTP 1.0       || Y   || Y   || Y   || Y   || Y   ||
|| HTTP 1.1       || -   || -   || P   || -   || -   || see [[../Features/HTTP11]] ||
|| HTTPS          || Y   || Y   || Y   || Y   || Y   ||
|| FTP            || Y   || Y   || Y   || Y   || Y   ||
|| Gopher         || Y   || Y   || Y   || Y   || Y   ||
|| Whois          || Y   || Y   || Y   || Y   || Y   ||
|||||||||||| '''Other Protocols''' ||
|| HTCP           || Y   || Y   || Y   || Y   || Y   ||
|| ICP (v2)       || Y   || Y   || Y   || Y   || Y   ||
|| ICP (v3)       || -   || Y   || Y   || Y   || Y   ||
|| ICAP           || -   || -   || -   || X   || Y   || 2.6: Patch available has major bugs ||
|| IPv6           || -   || Ps13|| -   || -   || Y   ||
|| Wais           || Y   || Y   || Y   || Y   || Y   ||
|||||||||||| '''Storage Filesystems''' ||
|| AUFS           || -   || Y   || Y   || Y   || Y   ||
|| DiskD          || Y   || Y   || Y   || Y   || Y   ||
|| UFS            || Y   || Y   || Y   || Y   || Y   ||
|| COSS           || -   || Y   || Y   || X   || X   ||
